import 'package:flutter/material.dart';
import 'package:flutter_layout_app/models/patient_model.dart';
import 'package:flutter_layout_app/screens/patients/patient_list_page.dart';
import '../insulin_calculator_page.dart';
import '../guidelines_page.dart';
import '../../utils/no_animation_route.dart';

class PatientDetailsPage extends StatelessWidget {
  final Patient patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(patient.name),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topMenu(context),

            const SizedBox(height: 20),

            // -------------------------------
            // CARD PRINCIPAL DO PACIENTE
            // -------------------------------
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "Informações do paciente",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoColumn("Idade", "${patient.age} anos"),
                        _infoColumn("Peso", "${patient.weight} kg"),
                        _infoColumn(
                          "Última Glicemia",
                          patient.lastGlycemia != null
                              ? "${patient.lastGlycemia} mg/dL"
                              : "--",
                          highlight: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------
  //            TOP MENU
  // -------------------------------------
  Widget _topMenu(BuildContext context) {
    final selected = 2; // Detalhes

    final items = [
      "Pacientes",
      "Calculadora",
      "Detalhes",
      "Diretrizes",
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == selected;

          return GestureDetector(
            onTap: () => _navigateTo(context, index),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    )
                  : null,
              child: Text(
                items[index],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // -------------------------------------
  //      NAVEGAÇÃO DO MENU
  // -------------------------------------
  void _navigateTo(BuildContext context, int index) {
    if (index == 2) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: PatientListPage()),
      );
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: const InsulinCalculatorPage()),
      );
    }

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: const GuidelinesPage()),
      );
    }
  }

  // -------------------------------------
  //    WIDGET DE INFORMAÇÃO DO CARD
  // -------------------------------------
  Widget _infoColumn(String label, String value, {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: highlight ? const EdgeInsets.all(6) : null,
          decoration: highlight
              ? BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(6),
                )
              : null,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.red : Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
