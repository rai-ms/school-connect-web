import 'package:flutter/material.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../../../../../core/utils/app_global.dart';
import 'class_item.dart';

class ClassData {
  final String time;
  final String subject;
  final String room;
  final bool isLab;

  const ClassData({
    required this.time,
    required this.subject,
    required this.room,
    required this.isLab,
  });
}

class UpcomingClasses extends StatelessWidget {
  const UpcomingClasses({super.key});

  @override
  Widget build(BuildContext context) {
    final classes = [
      ClassData(
        time: '10:00 AM\n11:30 AM',
        subject: L?.mathematics ?? 'Mathematics',
        room: L?.room.call('101') ?? 'Room 101',
        isLab: false,
      ),
      ClassData(
        time: '12:00 PM\n1:30 PM',
        subject: L?.physics ?? 'Physics',
        room: L?.lab.call('202') ?? 'Lab 202',
        isLab: true,
      ),
      ClassData(
        time: '2:00 PM\n3:30 PM',
        subject: L?.computerScience ?? 'Computer Science',
        room: L?.lab.call('301') ?? 'Lab 301',
        isLab: true,
      ),
    ];

    return GlassyBackground(
      child: Column(
        children: [
          ...classes.asMap().entries.map((entry) => ClassItem(
            time: entry.value.time,
            subject: entry.value.subject,
            room: entry.value.room,
            isLast: entry.key == classes.length - 1,
            onNotificationPressed: () {
              // TODO: Handle notification
            },
          )),
        ],
      ),
    );
  }
}
