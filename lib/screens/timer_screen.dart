import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ussaa/services/notification_service.dart';
import 'package:flutter/services.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  int _workTime = 25 * 60;
  int _remainingTime = 25 * 60;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    NotificationService.initializeNotification();
    _hideSystemUI();

  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _startTimer() {
    if (_isPaused) {
      _timer?.cancel();
      setState(() {
        _isPaused = false;
      });
    } else {
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
            _updateNotification();
          } else {
            _timer!.cancel();
            _showNotification();
          }
        });
      });
      setState(() {
        _isPaused = true;
      });
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _remainingTime = _workTime;
      _isPaused = false;
    });
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = _workTime;
      _timer?.cancel();
      _isPaused = false;
    });
  }

  void _showNotification() {
    NotificationService.showNotification(
      title: 'Timer Finished',
      body: 'Your timer has ended.',
    );
  }

  void _updateNotification() {
    NotificationService.showTimerNotification(
      title: 'Timer Running',
      body: 'Remaining time: ${_formatTime(_remainingTime)}',
      remainingTime: _formatTime(_remainingTime),
    );
  }

  String _formatTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _setWorkTime(int hours, int minutes, int seconds) {
    setState(() {
      _workTime = hours * 3600 + minutes * 60 + seconds;
      _remainingTime = _workTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          bool isLandscape = orientation == Orientation.landscape;
          if (isLandscape) {
            print('Landscape mode');
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: orientation == Orientation.portrait
                  ? _buildPortraitLayout()
                  : _buildLandscapeLayout(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimerDisplay(),
        const SizedBox(height: 20),
        _buildTimeAdjuster('Work Time', _workTime, _setWorkTime),
        const SizedBox(height: 20),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildLandscapeLayout() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimerDisplay(),
              const SizedBox(height: 20),
              _buildActionButtons(),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTimeAdjuster('Work Time', _workTime, _setWorkTime),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimerDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        _formatTime(_remainingTime),
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildTimeAdjuster(String label, int initialValue, Function(int, int, int) onChanged) {
    final hours = initialValue ~/ 3600;
    final minutes = (initialValue % 3600) ~/ 60;
    final seconds = initialValue % 60;

    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _buildNumberPicker('H', hours, 23, (value) {
                onChanged(value, minutes, seconds);
              })),
              Expanded(child: _buildNumberPicker('M', minutes, 59, (value) {
                onChanged(hours, value, seconds);
              })),
              Expanded(child: _buildNumberPicker('S', seconds, 59, (value) {
                onChanged(hours, minutes, value);
              })),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPicker(String label, int initialValue, int maxValue, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        SizedBox(
          height: 100,
          width: 50,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            onSelectedItemChanged: (index) {
              if (index < 0) {
                onChanged(maxValue);
              } else if (index > maxValue) {
                onChanged(0);
              } else {
                onChanged(index);
              }
            },
            controller: FixedExtentScrollController(initialItem: initialValue),
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                int displayIndex = index % (maxValue + 1);
                return Center(
                  child: Text(
                    displayIndex.toString().padLeft(2, '0'),
                    style: const TextStyle(fontSize: 24),
                  ),
                );
              },
              childCount: maxValue + 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _resetTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text('Retry', style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: _startTimer,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(_isPaused ? 'Pause' : 'Start', style: const TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
