import 'package:flutter/material.dart';
import 'package:flutter_layout_app/models/patient_model.dart';
import 'package:flutter_layout_app/screens/patients/patient_add_page.dart';
import 'package:flutter_layout_app/screens/patients/patient_details_page.dart';
import 'package:flutter_layout_app/services/patient_service.dart';
import 'package:flutter_layout_app/services/selected_patient_service.dart';

import '../insulin_calculator_page.dart';
import '../guidelines_page.dart';
import '../../utils/no_animation_route.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final PatientService service = PatientService();

  final SelectedPatientService selectedService = SelectedPatientService();

  // -----------------------------
  //     NAVEGAÇÃO DO MENU
  // -----------------------------
  void _navigate(BuildContext context, int index) {
    if (index == 0) return; // Já estamos na lista

    // detalhes
    if (index == 2) {
      if (selectedService.selected == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selecione um paciente primeiro.")),
        );
        return;
      }

      Navigator.push(
        context,
        NoAnimationRoute(
          page: PatientDetailsPage(patient: selectedService.selected!),
        ),
      );
      return;
    }

    final pages = [
      null,
      const InsulinCalculatorPage(),
      null,
      const GuidelinesPage(),
    ];

    if (pages[index] != null) {
      Navigator.push(
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
          _buildTopMenu(context, selectedIndex: 0),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Novo Paciente"),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const AddPatientDialog(),
                    );
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Patient>>(
              stream: service.getPatients(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(
                      child: Text("Erro ao carregar pacientes."));
                }

                final patients = snapshot.data!;

                if (patients.isEmpty) {
                  selectedService.selected = null;
                  return const Center(
                    child: Text(
                      "Nenhum paciente cadastrado.",
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                // Seleciona automaticamente o primeiro se nenhum está selecionado
                if (selectedService.selected == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      setState(() {
                        selectedService.selected = patients.first;
                      });
                    }
                  });
                }

                final bool isDesktop = MediaQuery.of(context).size.width > 800;

                if (!isDesktop) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: patients.length,
                    itemBuilder: (context, i) {
                      return _buildPatientCard(patients[i], isDesktop: false);
                    },
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: patients.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.4,
                  ),
                  itemBuilder: (context, i) {
                    return _buildPatientCard(patients[i], isDesktop: true);
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
  //       CARD DO PACIENTE (selecionável)
  // ----------------------------------------
  Widget _buildPatientCard(Patient p, {required bool isDesktop}) {
    final bool isSelected = selectedService.selected?.id == p.id;

    final double cardHeight = isDesktop ? double.infinity : 130;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedService.selected = p;
        });
      },
      child: Container(
        height: cardHeight == double.infinity ? null : cardHeight,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.blueAccent : Colors.transparent,
            width: isSelected ? 2 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Card(
          elevation: 3,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor:
                            isSelected ? Colors.blueAccent : Colors.grey.shade300,
                        child: Text(
                          _initials(p.name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              p.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("Idade: ${p.age}"),
                                const SizedBox(width: 10),
                                Text("Peso: ${p.weight} kg"),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Diagnóstico: ${p.diagnosis}",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: p.lastGlycemia == null
                                  ? Colors.grey
                                  : p.lastGlycemia! > p.targetMax
                                      ? Colors.red.shade400
                                      : Colors.green.shade400,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p.lastGlycemia?.toString() ?? "--",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Botão inferior ocupando toda a largura
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      NoAnimationRoute(page: PatientDetailsPage(patient: p)),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("Ver detalhes"),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(12),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return "";
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  // ----------------------------------------
  //           MENU SUPERIOR (WIDGET)
  // ----------------------------------------
  Widget _buildTopMenu(BuildContext context, {required int selectedIndex}) {
    final items = ["Pacientes", "Calculadora", "Detalhes", "Diretrizes"];

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isSelected = i == selectedIndex;

          return GestureDetector(
            onTap: () => _navigate(context, i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
