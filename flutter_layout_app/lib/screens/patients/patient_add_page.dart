import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_layout_app/models/patient_model.dart';
import 'package:flutter_layout_app/services/patient_service.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_layout_app/models/patient_model.dart';
// import 'package:flutter_layout_app/services/patient_service.dart';

class AddPatientDialog extends StatefulWidget {
  const AddPatientDialog({super.key});

  @override
  State<AddPatientDialog> createState() => _AddPatientDialogState();
}

class _AddPatientDialogState extends State<AddPatientDialog> {
  // Variáveis sem controllers
  String name = "";
  String diagnosis = "";
  String insulinType = "Apenas Correção";
  int? age;
  double? weight;

  final PatientService _service = PatientService();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Adicionar Paciente"),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //-----------------------------------------------------
            // Nome completo
            //-----------------------------------------------------
            const Text("Nome Completo"),
            const SizedBox(height: 6),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite o nome",
              ),
              onChanged: (v) => name = v,
            ),
            const SizedBox(height: 16),

            //-----------------------------------------------------
            // Idade + Peso na mesma linha
            //-----------------------------------------------------
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Idade"),
                      const SizedBox(height: 6),
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Ex: 32",
                        ),
                        onChanged: (v) {
                          age = int.tryParse(v);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Peso (kg)"),
                      const SizedBox(height: 6),
                      TextField(
                        keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Ex: 72.5",
                        ),
                        onChanged: (v) {
                          weight = double.tryParse(v.replaceAll(",", "."));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            //-----------------------------------------------------
            // Diagnóstico
            //-----------------------------------------------------
            const Text("Diagnóstico"),
            const SizedBox(height: 6),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Ex: DM1, DM2, etc",
              ),
              onChanged: (v) => diagnosis = v,
            ),
            const SizedBox(height: 16),

            //-----------------------------------------------------
            // Insulin Type
            //-----------------------------------------------------
            const Text("Esquema de Insulina"),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              value: insulinType,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: const [
                DropdownMenuItem(
                    value: "Apenas Correção", child: Text("Apenas Correção")),
                DropdownMenuItem(
                    value: "Basal-Bolus", child: Text("Basal-Bolus")),
                DropdownMenuItem(
                    value: "Pré-misturada", child: Text("Pré-misturada")),
              ],
              onChanged: (v) => insulinType = v!,
            ),
          ],
        ),
      ),

      //-----------------------------------------------------
      // Botões
      //-----------------------------------------------------
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        FilledButton(
          onPressed: () async {
            if (name.isEmpty || age == null || weight == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Preencha os campos obrigatórios")),
              );
              return;
            }

            final id =
                FirebaseFirestore.instance.collection("patients").doc().id;

            final patient = Patient(
              id: id,
              name: name,
              age: age!,
              diagnosis: diagnosis,
              insulinType: insulinType,
              weight: weight!,
              targetMin: 0,
              targetMax: 0,
            );

            await _service.addPatient(patient);

            if (!mounted) return;
            Navigator.pop(context);
          },
          child: const Text("Salvar"),
        ),
      ],
    );
  }
}
