import 'package:flutter/material.dart';
import 'package:flutter_layout_app/models/patient_model.dart';

import 'patients/patient_list_page.dart';
import 'guidelines_page.dart';
import '../utils/no_animation_route.dart';

import 'package:flutter_layout_app/services/patient_service.dart';
import 'package:flutter_layout_app/services/selected_patient_service.dart';

final patientService = PatientService();
final selectedService = SelectedPatientService();

class InsulinCalculatorPage extends StatefulWidget {
  const InsulinCalculatorPage({super.key});

  @override
  State<InsulinCalculatorPage> createState() => _InsulinCalculatorPageState();
}

class _InsulinCalculatorPageState extends State<InsulinCalculatorPage> {
  final TextEditingController glycemiaController = TextEditingController();
  String mealType = 'preprandial';
  double? calculatedDose;
  String recommendation = '';

  Patient? get patient => SelectedPatientService().selected;

  void calculateCorrectionDose() {
    if (patient == null) return;
    final glycemia = double.tryParse(glycemiaController.text);
    if (glycemia == null) return;
    final targetMid = ((patient!.targetMin + patient!.targetMax) / 2);
    final dose = ((glycemia - targetMid) / 50).clamp(0, 40); // soldado 40, provavelmente varia de paciente pra paciente
    String rec = '';
    if (glycemia < 70) {
      rec = '⚠️ Hipoglicemia detectada. Administrar 15g de carboidratos...';
    } else if (glycemia < patient!.targetMin) {
      rec = 'Glicemia abaixo do alvo.';
    } else if (glycemia <= patient!.targetMax) {
      rec = 'Dentro do alvo.';
    } else if (glycemia <= 180) {
      rec = 'Dose sugerida: ${dose.round()} UI.';
    } else if (glycemia <= 250) {
      rec = 'Hiperglicemia moderada. Dose: ${dose.round()} UI.';
    } else {
      rec = '🚨 Hiperglicemia importante. Dose: ${dose.round()} UI.';
    }
    setState(() {
      calculatedDose = dose.toDouble();
      recommendation = rec;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    return Scaffold(
      appBar: AppBar(title: const Text("Calculadora de Insulina")),
      body: Column(
        children: [
          _buildTopMenu(context, selectedIndex: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildLeftColumn()),
                        const SizedBox(width: 16),
                        Expanded(flex: 1, child: _buildRightColumn()),
                      ],
                    )
                  : ListView(
                      children: [
                        _buildLeftColumn(),
                        const SizedBox(height: 16),
                        _buildRightColumn(),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildPatientInfoCard(),
        const SizedBox(height: 16),
        _buildCalculatorCard(),
      ],
    );
  }

  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildInsulinSchemeCard(),
        const SizedBox(height: 16),
        _buildProtocolCard(),
      ],
    );
  }

  Widget _buildTopMenu(BuildContext context, {required int selectedIndex}) {
    final items = ["Pacientes", "Calculadora", "Detalhes", "Diretrizes"];

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          return GestureDetector(
            onTap: () {
              if (i == 0) {
                Navigator.pushReplacement(
                  context,
                  NoAnimationRoute(page: const PatientListPage()),
                );
              } else if (i == 3) {
                Navigator.pushReplacement(
                  context,
                  NoAnimationRoute(page: const GuidelinesPage()),
                );
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: i == selectedIndex
                    ? Colors.white
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                items[i],
                style: TextStyle(
                  fontWeight:
                      i == selectedIndex ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPatientInfoCard() {
    if (patient == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text("Nenhum paciente selecionado."),
        ),
      );
    }

    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Paciente Selecionado",
                style: TextStyle(color: Colors.black54)),
            Text(
              patient!.name,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo),
            ),
            const SizedBox(height: 4),
            Text(
              "${patient!.age} anos • ${patient!.weight} kg",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Dose de Correção",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: glycemiaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Glicemia Atual (mg/dL)",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: mealType,
              decoration: const InputDecoration(
                labelText: "Momento",
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                    value: "preprandial", child: Text("Pré-prandial")),
                DropdownMenuItem(
                    value: "postprandial", child: Text("Pós-prandial")),
                DropdownMenuItem(value: "fasting", child: Text("Jejum")),
                DropdownMenuItem(
                    value: "bedtime", child: Text("Antes de dormir")),
              ],
              onChanged: (v) => setState(() => mealType = v!),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: calculateCorrectionDose,
                    icon: const Icon(Icons.calculate),
                    label: const Text("Calcular Dose"),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("Salvar"),
                  onPressed: saveGlycemiaToDatabase,
                ),
              ],
            ),

            if (calculatedDose != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dose Calculada: ${calculatedDose!.round()} UI",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(recommendation),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInsulinSchemeCard() {
    if (patient == null) return Container();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Esquema Atual",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Tipo de Esquema:"),
                Chip(label: Text(patient!.insulinType)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("Protocolo SBD 2025",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("• Meta glicêmica: 100–140 mg/dL"),
            Text("• Tratar hipoglicemia se < 70 mg/dL"),
            Text("• Monitorizar capilar a cada 6h"),
          ],
        ),
      ),
    );
  }

  void saveGlycemiaToDatabase() async {
    final patient = selectedService.selected;
    if (patient == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nenhum paciente selecionado!")),
      );
      return;
    }
    final gly = int.tryParse(glycemiaController.text);
    if (gly == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Digite uma glicemia válida!")),
      );
      return;
    }
    await patientService.updateGlycemia(
      id: patient.id,
      glycemia: gly,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Glicemia salva com sucesso.")),
    );
  }
}