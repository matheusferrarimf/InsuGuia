import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_layout_app/models/patient_model.dart';

class PatientService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('patients');

  Future<void> addPatient(Patient p) async {
    final doc = _collection.doc(); // cria ID automático

    final newPatient = Patient(
      id: doc.id,
      name: p.name,
      age: p.age,
      diagnosis: p.diagnosis,
      insulinType: p.insulinType,
      weight: p.weight,
      targetMin: p.targetMin,
      targetMax: p.targetMax,
      lastGlycemia: p.lastGlycemia,
      lastUpdate: p.lastUpdate,
    );

    await doc.set(newPatient.toMap());
  }

  Future<void> deletePatient(String id) async {
    await _collection.doc(id).delete();
  }

  Stream<List<Patient>> getPatients() {
    return _collection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Patient.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
  
  Future<void> updateGlycemia({
    required String id,
    required int glycemia,
  }) async {
    await _collection.doc(id).update({
      'lastGlycemia': glycemia,
      'lastUpdate': Timestamp.now(),
    });
  }

}