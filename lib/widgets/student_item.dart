import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentItem extends StatelessWidget {
  final Student student;

  const StudentItem({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: student.gender == Gender.female ? const Color.fromARGB(255, 248, 33, 108) : const Color.fromARGB(255, 0, 139, 253),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        title: Text('${student.firstName} ${student.lastName}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(departmentIcons[student.department]),
            const SizedBox(width: 8),
            Text('${student.grade}'),
          ],
        ),
      ),
    );
  }
}