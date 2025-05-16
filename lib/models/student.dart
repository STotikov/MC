import 'package:flutter/material.dart';

enum DepartmentType { finance, law, it, medical }

final departmentIcons = {
  DepartmentType.finance: Icons.attach_money,
  DepartmentType.law: Icons.gavel,
  DepartmentType.it: Icons.computer,
  DepartmentType.medical: Icons.healing,
};

enum Gender { male, female }

class Student {
  final String id;
  final String firstName;
  final String lastName;
  final DepartmentType department;
  final int grade;
  final Gender gender;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.department,
    required this.grade,
    required this.gender,
  });

  Student copyWith({
    String? id,
    String? firstName,
    String? lastName,
    DepartmentType? department,
    int? grade,
    Gender? gender,
  }) {
    return Student(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      department: department ?? this.department,
      grade: grade ?? this.grade,
      gender: gender ?? this.gender,
    );
  }
}
