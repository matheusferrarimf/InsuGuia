import 'package:flutter/material.dart';

class Patient {
  final String id;
  final String name;
  final int age;
  final double weight;
  final String diagnosis;
  final String insulinType;
  final Map<String, double> target;
  final double? lastGlycemia;
  final String? lastUpdate;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.diagnosis,
    required this.insulinType,
    required this.target,
    this.lastGlycemia,
    this.lastUpdate,
  });
}

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final List<Patient> patients = [];
  Patient? selectedPatient;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController diagnosisController = TextEditingController();

  String insulinType = 'correction-only';

  void _addPatient() {
    final newPatient = Patient(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameController.text,
      age: int.parse(ageController.text),
      weight: double.parse(weightController.text),
      diagnosis: diagnosisController.text,
      insulinType: insulinType,
      target: {'min': 100, 'max': 140},
    );

    setState(() {
      patients.add(newPatient);
    });

    nameController.clear();
    ageController.clear();
    weightController.clear();
    diagnosisController.clear();
  }

  void _deletePatient(String id) {
    setState(() {
      patients.removeWhere((p) => p.id == id);
    });
  }

  Color _getGlycemiaColor(double value) {
    if (value < 70) return Colors.red;
    if (value <= 140) return Colors.green;
    if (value <= 180) return Colors.amber;
    return Colors.redAccent;
  }

  String _getInsulinTypeLabel(String type) {
    switch (type) {
      case 'basal-bolus':
        return 'Basal-Bolus';
      case 'correction-only':
        return 'Correção';
      case 'premixed':
        return 'Pré-misturada';
      default:
        return type;
    }
  }

  void _showAddPatientDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Adicionar Novo Paciente'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nome Completo'),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Idade'),
              ),
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
              ),
              TextField(
                controller: diagnosisController,
                decoration: const InputDecoration(labelText: 'Diagnóstico'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: insulinType,
                decoration: const InputDecoration(labelText: 'Esquema de Insulina'),
                items: const [
                  DropdownMenuItem(value: 'correction-only', child: Text('Apenas Correção')),
                  DropdownMenuItem(value: 'basal-bolus', child: Text('Basal-Bolus')),
                  DropdownMenuItem(value: 'premixed', child: Text('Pré-misturada')),
                ],
                onChanged: (value) {
                  setState(() => insulinType = value!);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _addPatient();
              Navigator.pop(context);
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pacientes Ativos')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPatientDialog,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: patients.isEmpty
            ? const Center(
                child: Text(
                  'Nenhum paciente cadastrado.\nToque no botão + para adicionar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  childAspectRatio: 2.4,
                ),
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  final isSelected = selectedPatient?.id == patient.id;
                  final glycemia = patient.lastGlycemia;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPatient = patient;
                      });
                    },
                    child: Card(
                      color: isSelected ? Colors.indigo.shade50 : null,
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    patient.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () => _deletePatient(patient.id),
                                ),
                              ],
                            ),
                            Text('${patient.age} anos • ${patient.weight} kg'),
                            const SizedBox(height: 6),
                            Text(patient.diagnosis, style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Chip(
                                  label: Text(_getInsulinTypeLabel(patient.insulinType)),
                                ),
                                if (glycemia != null) ...[
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text('${glycemia.toStringAsFixed(0)} mg/dL'),
                                    backgroundColor: _getGlycemiaColor(glycemia),
                                    labelStyle: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ],
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/patientDetails', arguments: patient);
                                },
                                icon: const Icon(Icons.trending_up, size: 16),
                                label: const Text('Ver Detalhes'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
