import 'package:flutter/material.dart';
import 'patients/patient_list_page.dart';
import 'guidelines_page.dart';
import 'patients/patient_details_page.dart';

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

  // Paciente simulado — depois você troca por um real
  final Map<String, dynamic> patient = {
    'name': 'João Silva',
    'age': 55,
    'weight': 80.0,
    'targetMin': 100,
    'targetMax': 140,
    'correctionFactor': 50,
    'insulinType': 'basal-bolus',
    'basalDose': 18,
  };

  // -------------------------------
  // MENU UNIVERSAL
  // -------------------------------
  Widget _buildTopMenu(BuildContext context, {required int selectedIndex}) {
    final items = ["Pacientes", "Calculadora", "Detalhes", "Diretrizes"];

    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (i) {
          final isSelected = i == selectedIndex;
          final isDisabled = i == 2; // "Detalhes" desligado nesta página

          return GestureDetector(
            onTap: isDisabled
                ? null
                : () {
                    if (i == 0) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => PatientListPage()));
                    } else if (i == 3) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const GuidelinesPage()));
                    }
                  },
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

  // -------------------------------------------------------------------

  void calculateCorrectionDose() {
    final glycemia = double.tryParse(glycemiaController.text);
    if (glycemia == null) return;

    final targetMid = (patient['targetMin'] + patient['targetMax']) / 2;
    final dose = ((glycemia - targetMid) / patient['correctionFactor'])
        .clamp(0, double.infinity);

    String rec = '';
    if (glycemia < 70) {
      rec = '⚠️ Hipoglicemia detectada. Administrar 15g de carboidratos...';
    } else if (glycemia < patient['targetMin']) {
      rec = 'Glicemia abaixo do alvo.';
    } else if (glycemia <= patient['targetMax']) {
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

  int calculateBasalDose() {
    return (patient['weight'] * 0.25).round();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculadora de Insulina')),
      body: Column(
        children: [
          _buildTopMenu(context, selectedIndex: 1),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildPatientInfo(),
                  const SizedBox(height: 16),
                  _buildCalculatorCard(),
                  const SizedBox(height: 16),
                  _buildInsulinSchemeCard(),
                  const SizedBox(height: 16),
                  _buildProtocolCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------- UI CARDS -------------------------------

  Widget _buildPatientInfo() {
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paciente Selecionado',
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text(patient['name'],
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo)),
            const SizedBox(height: 4),
            Text('${patient['age']} anos • ${patient['weight']} kg',
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculatorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Dose de Correção',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: glycemiaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Glicemia Atual (mg/dL)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: mealType,
              onChanged: (v) => setState(() => mealType = v!),
              items: const [
                DropdownMenuItem(value: 'fasting', child: Text('Jejum')),
                DropdownMenuItem(value: 'preprandial', child: Text('Pré-prandial')),
                DropdownMenuItem(value: 'postprandial', child: Text('Pós-prandial')),
                DropdownMenuItem(value: 'bedtime', child: Text('Antes de dormir')),
              ],
              decoration: const InputDecoration(labelText: 'Momento'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: calculateCorrectionDose,
              icon: const Icon(Icons.calculate),
              label: const Text('Calcular Dose'),
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
                        'Dose Calculada: ${calculatedDose!.round()} UI',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Esquema Atual',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tipo de Esquema:'),
                Chip(
                    label: Text(
                        patient['insulinType'] == 'basal-bolus'
                            ? 'Basal-Bolus'
                            : 'Outro')),
              ],
            ),
            const SizedBox(height: 8),
            Text('Dose Basal: ${patient['basalDose']} UI/dia'),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard() {
    return Card(
      child: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Protocolo SBD 2025',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('• Meta: 100–140 mg/dL'),
            Text('• Hipoglicemia: tratar se < 70 mg/dL'),
          ],
        ),
      ),
    );
  }
}
