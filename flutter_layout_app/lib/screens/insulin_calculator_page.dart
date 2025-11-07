import 'package:flutter/material.dart';

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

  // simulação de paciente selecionado
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

  void calculateCorrectionDose() {
    final glycemia = double.tryParse(glycemiaController.text);
    if (glycemia == null) return;

    final targetMid = (patient['targetMin'] + patient['targetMax']) / 2;
    final dose = ((glycemia - targetMid) / patient['correctionFactor']).clamp(0, double.infinity);

    String rec = '';
    if (glycemia < 70) {
      rec = '⚠️ Hipoglicemia detectada. Administrar 15g de carboidratos de ação rápida. '
            'Não administrar insulina. Reavaliar em 15 minutos.';
    } else if (glycemia < patient['targetMin']) {
      rec = 'Glicemia abaixo do alvo. Reduzir dose basal ou ajustar meta. '
            'Sem necessidade de correção agora.';
    } else if (glycemia <= patient['targetMax']) {
      rec = '✅ Dentro do alvo terapêutico. Manter esquema atual.';
    } else if (glycemia <= 180) {
      rec = 'Glicemia levemente elevada. Dose sugerida: ${dose.round()} UI. Reavaliar em 2-4h.';
    } else if (glycemia <= 250) {
      rec = 'Hiperglicemia moderada. Dose sugerida: ${dose.round()} UI. Reavaliar em 2-4h.';
    } else {
      rec = '🚨 Hiperglicemia importante. Dose sugerida: ${dose.round()} UI. '
            'Investigar causas (infecção, estresse, adesão). Reavaliar em 2h.';
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
      body: Padding(
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
    );
  }

  Widget _buildPatientInfo() {
    return Card(
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Paciente Selecionado', style: TextStyle(fontSize: 14, color: Colors.black54)),
            Text(patient['name'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.indigo)),
            const SizedBox(height: 4),
            Text('${patient['age']} anos • ${patient['weight']} kg', style: const TextStyle(color: Colors.grey)),
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
            const Text('Dose de Correção', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Calcule a dose de insulina com base na glicemia atual.'),
            const SizedBox(height: 16),

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
              decoration: const InputDecoration(labelText: 'Momento'),
              items: const [
                DropdownMenuItem(value: 'fasting', child: Text('Jejum')),
                DropdownMenuItem(value: 'preprandial', child: Text('Pré-prandial')),
                DropdownMenuItem(value: 'postprandial', child: Text('Pós-prandial')),
                DropdownMenuItem(value: 'bedtime', child: Text('Antes de dormir')),
              ],
            ),

            const SizedBox(height: 16),
            Text('Meta Glicêmica: ${patient['targetMin']} - ${patient['targetMax']} mg/dL'),
            Text('Fator de Correção: ${patient['correctionFactor']} mg/dL/UI'),

            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: calculateCorrectionDose,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular Dose'),
                  ),
                ),
              ],
            ),

            if (calculatedDose != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _alertColor(),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dose Calculada: ${calculatedDose!.round()} UI',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(recommendation, style: const TextStyle(fontSize: 13)),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _alertColor() {
    final g = double.tryParse(glycemiaController.text) ?? 0;
    if (g < 70) return Colors.red.shade50;
    if (g > 180) return Colors.yellow.shade50;
    return Colors.green.shade50;
  }

  Widget _buildInsulinSchemeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Esquema Atual', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Tipo de Esquema:'),
                Chip(label: Text(patient['insulinType'] == 'basal-bolus' ? 'Basal-Bolus' : 'Outro')),
              ],
            ),
            const SizedBox(height: 8),
            if (patient['insulinType'] == 'basal-bolus') ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dose Basal:'),
                  Text('${patient['basalDose'] ?? calculateBasalDose()} UI/dia'),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Insulina NPH ou análogo de longa ação.'),
            ],
            const SizedBox(height: 12),
            const Text(
              '💡 Ajustes de dose: aumentar ou reduzir 10-20% se glicemia persistir fora do alvo.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Protocolo SBD 2025', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Meta glicêmica: 100–140 mg/dL (pré-prandial)'),
            Text('• Hipoglicemia: tratar se < 70 mg/dL'),
            Text('• Monitorização: capilar a cada 6h'),
            Text('• Fator de correção: 1800/dose total diária (regular) ou 1500/dose total (ultrarrápida)'),
          ],
        ),
      ),
    );
  }
}
