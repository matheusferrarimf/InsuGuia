import 'package:flutter/material.dart';
import 'patients/patient_list_page.dart';
import 'insulin_calculator_page.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({super.key});

  // -------------------------------
  //          MENU UNIVERSAL
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
          final isDisabled = i == 2; // detalhes desabilitado aqui

          return GestureDetector(
            onTap: isDisabled
                ? null
                : () {
                    if (i == 0) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => PatientListPage()));
                    } else if (i == 1) {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (_) => const InsulinCalculatorPage()));
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

  //---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diretrizes SBD 2025')),
      body: Column(
        children: [
          _buildTopMenu(context, selectedIndex: 3),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: const [
                        Icon(Icons.description, color: Colors.indigo),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Protocolo de Insulinoterapia para Pacientes Não Críticos',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _section('Metas Glicêmicas', [
                  'Glicemia pré-prandial: 100–140 mg/dL',
                  'Glicemia aleatória: <180 mg/dL',
                ]),
                _section('Esquemas de Insulinoterapia', [
                  'Basal-Bolus: preferencial',
                  'Insulina Regular ou ultrarrápida antes das refeições',
                ]),
                _section('Monitorização', [
                  '4x ao dia mínimo',
                  'Método: glicemia capilar',
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (var item in items) Text('• $item'),
          ],
        ),
      ),
    );
  }
}
