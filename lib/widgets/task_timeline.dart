import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:ussaa/models/task_model.dart';

class TaskTimeline extends StatefulWidget {
  const TaskTimeline({super.key, required this.taskList});
  final List<Task> taskList;

  @override
  State<TaskTimeline> createState() => _TaskTimelineState();
}

class _TaskTimelineState extends State<TaskTimeline> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.taskList.map((task) {
        return SizedBox(
          height: 75,
          child: TimelineTile(
            isFirst: widget.taskList.indexOf(task) == 0,
            isLast: widget.taskList.indexOf(task) == widget.taskList.length - 1,
            alignment: TimelineAlign.manual,
            lineXY: 0.3,
            startChild: Center(
              child: Text('${task.dueDate.hour}:${task.dueDate.minute}'),
            ),
            beforeLineStyle: LineStyle(
              color: task.isDone ? Colors.purple : Colors.purple.shade100,
            ),
            indicatorStyle: IndicatorStyle(
              width: 25,
              color: Colors.purple.shade900,
              iconStyle: IconStyle(
                color: task.isDone ? Colors.white : Colors.purple.shade100,
                iconData: task.isDone ? Icons.done : Icons.close,
              ),
            ),
            endChild: Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                color: task.isDone ? Colors.purple : Colors.purple.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(task.title, style: const TextStyle(color: Colors.white),),
            ),
          ),
        );
      }).toList(),
    );
  }
}
