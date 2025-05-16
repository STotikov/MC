import 'package:flutter/material.dart';
import '../models/department.dart';

class DepartmentItem extends StatelessWidget {
  final Department department;
  final int studentCount;

  const DepartmentItem({super.key, required this.department, required this.studentCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [department.color.withOpacity(0.7), department.color]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(department.icon, size: 40),
            const SizedBox(height: 10),
            Text(department.name, style: Theme.of(context).textTheme.titleMedium),
            Text('$studentCount students'),
          ],
        ),
      ),
    );
  }
}