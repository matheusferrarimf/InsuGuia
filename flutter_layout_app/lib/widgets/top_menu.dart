import 'package:flutter/material.dart';
import '../utils/no_animation_route.dart';
import '../screens/patients/patient_list_page.dart';
import '../screens/insulin_calculator_page.dart';
import '../screens/guidelines_page.dart';

Widget buildTopMenu(BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12),
    color: Colors.blueGrey[50],
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              NoAnimationRoute(page: PatientListPage()),
            );
          },
          child: const Text("Pacientes"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              NoAnimationRoute(page: const InsulinCalculatorPage()),
            );
          },
          child: const Text("Calculadora"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              NoAnimationRoute(page: const GuidelinesPage()),
            );
          },
          child: const Text("Diretrizes"),
        ),
      ],
    ),
  );
}
