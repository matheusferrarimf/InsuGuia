import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // para o gráfico

class PatientDetailsPage extends StatefulWidget {
  final String patientName;
  const PatientDetailsPage({super.key, required this.patientName});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage> {
  bool isEditing = false;

  // simulação de dados
  int age = 55;
  double weight = 80.0;
  int lastGlycemia = 145;

  List<Map<String, dynamic>> glycemiaHistory = [
    {'time': '00:00', 'value': 120},
    {'time': '06:00', 'value': 145},
    {'time': '12:00', 'value': 186},
    {'time': '18:00', 'value': 158},
    {'time': '22:00', 'value': 142},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.patientName),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.check : Icons.edit),
            onPressed: () => setState(() => isEditing = !isEditing),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHeaderCard(),
          const SizedBox(height: 16),
          _buildGlycemiaChart(),
          const SizedBox(height: 16),
          _buildInsulinCard(),
          const SizedBox(height: 16),
          _buildClinicalCard(),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dados do Paciente', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _infoRow('Idade', '$age anos'),
            _infoRow('Peso', '${weight.toStringAsFixed(1)} kg'),
            _infoRow('Última glicemia', '$lastGlycemia mg/dL'),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildGlycemiaChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Histórico de Glicemia', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            AspectRatio(
              aspectRatio: 1.6,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 30),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < glycemiaHistory.length) {
                            return Text(glycemiaHistory[index]['time']);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: glycemiaHistory
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value['value'].toDouble()))
                          .toList(),
                      isCurved: true,
                      color: Colors.indigo,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
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

  Widget _buildInsulinCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Esquema de Insulinoterapia', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Tipo: Basal-Bolus'),
            Text('Dose Basal: 18 UI/dia'),
            Text('Fator de Correção: 45 mg/dL/UI'),
            Text('Meta Glicêmica: 100–140 mg/dL'),
          ],
        ),
      ),
    );
  }

  Widget _buildClinicalCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Informações Clínicas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Paciente não crítico em enfermaria'),
            Text('• Dieta hospitalar regular para diabéticos'),
            Text('• Monitorização capilar 4x/dia'),
            Text('• Sem sinais de infecção ativa'),
          ],
        ),
      ),
    );
  }
}
