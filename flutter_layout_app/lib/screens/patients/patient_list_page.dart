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

  //     NAVEGAÇÃO DO MENU
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
                // Seleciona automaticamente o primeiro se não tiver nenhum selecionado
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

  // Cards
  Widget _buildPatientCard(Patient p, {required bool isDesktop}) {
  final bool isSelected = selectedService.selected?.id == p.id;

  return GestureDetector(
    onTap: () {
      setState(() {
        selectedService.selected = p;
      });
    },
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.blueAccent : Colors.transparent,
          width: isSelected ? 2 : 0,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // -------------------------
              // Linha superior -> Nome + Lixeira
              // -------------------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOME + IDADE + PESO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${p.age} anos • ${p.weight} kg",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Text(
                          p.diagnosis,
                          style: const TextStyle(fontSize: 15),
                        ),

                        const SizedBox(height: 8),

                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            p.insulinType,
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //   ÍCONE DE LIXEIRA
                  InkWell(
                    onTap: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Excluir paciente"),
                          content: Text(
                              "Tem certeza que deseja excluir ${p.name}?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text("Cancelar"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                "Excluir",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await service.deletePatient(p.id);

                        if (selectedService.selected?.id == p.id) {
                          selectedService.selected = null;
                        }

                        if (mounted) setState(() {});
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.delete_outline,
                          color: Colors.grey, size: 22),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // -------------------------
              // BOTÃO VER DETALHES
              // -------------------------
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      NoAnimationRoute(page: PatientDetailsPage(patient: p)),
                    );
                  },
                  icon: const Icon(Icons.show_chart),
                  label: const Text(
                    "Ver Detalhes",
                    style: TextStyle(fontSize: 16),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    foregroundColor: Colors.black87,
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
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