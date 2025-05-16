import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/department.dart';

final departmentsProvider = Provider<List<Department>>((ref) => [
      Department(
        id: 'finance',
        name: 'Finance',
        icon: Icons.attach_money,
        color: Colors.green,
      ),
      Department(
        id: 'law',
        name: 'Law',
        icon: Icons.gavel,
        color: Colors.blueGrey,
      ),
      Department(
        id: 'it',
        name: 'IT',
        icon: Icons.computer,
        color: Colors.indigo,
      ),
      Department(
        id: 'medical',
        name: 'Medical',
        icon: Icons.healing,
        color: Colors.redAccent,
      ),
    ]);
