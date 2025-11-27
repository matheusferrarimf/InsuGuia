import 'package:flutter/material.dart';
import 'package:flutter_layout_app/models/patient_model.dart';
import 'package:flutter_layout_app/screens/patients/patient_details_page.dart';
import 'package:flutter_layout_app/services/patient_service.dart';

import '../insulin_calculator_page.dart';
import '../guidelines_page.dart';
import '../../utils/no_animation_route.dart';

class PatientListPage extends StatelessWidget {
  final PatientService service = PatientService();

  PatientListPage({super.key});

  // -----------------------------
  //     NAVEGAÇÃO DO MENU
  // -----------------------------
  void _navigate(BuildContext context, int index) {
    if (index == 0) return; // já estamos na lista
    if (index == 2) return; // detalhes sem paciente é proibido

    final pages = [
      null,
      const InsulinCalculatorPage(),
      null,
      const GuidelinesPage(),
    ];

    if (pages[index] != null) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: pages[index]!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pacientes"),
      ),

      body: Column(
        children: [
          // -----------------------------
          //          MENU SUPERIOR
          // -----------------------------
          _buildTopMenu(context, selectedIndex: 0),

          // -----------------------------
          //      LISTA DE PACIENTES
          // -----------------------------
          Expanded(
            child: StreamBuilder<List<Patient>>(
              stream: service.getPatients(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final patients = snapshot.data!;

                if (patients.isEmpty) {
                  return const Center(
                    child: Text(
                      "Nenhum paciente cadastrado.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  itemBuilder: (context, i) {
                    final p = patients[i];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text("Idade: ${p.age}"),
                            Text("Peso: ${p.weight} kg"),
                            Text("Diagnóstico: ${p.diagnosis}"),
                            Text("Insulina: ${p.insulinType}"),

                            const SizedBox(height: 12),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  p.lastGlycemia != null
                                      ? "Última Glicemia: ${p.lastGlycemia} mg/dL"
                                      : "Última Glicemia: --",
                                  style: TextStyle(
                                    color: p.lastGlycemia != null &&
                                            p.lastGlycemia! > p.targetMax
                                        ? Colors.red
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      NoAnimationRoute(
                                        page: PatientDetailsPage(patient: p),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text("Detalhes"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------
  //           MENU SUPERIOR (WIDGET)
  // ----------------------------------------
  Widget _buildTopMenu(BuildContext context, {required int selectedIndex}) {
    final items = [
      "Pacientes",
      "Calculadora",
      "Detalhes",
      "Diretrizes",
    ];

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isSelected = i == selectedIndex;
          final isDisabled = i == 2; // desabilita "Detalhes"

          return GestureDetector(
            onTap: isDisabled
                ? null
                : () => _navigate(context, i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  color: isDisabled ? Colors.grey : Colors.black,
                  fontWeight:
                      isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
