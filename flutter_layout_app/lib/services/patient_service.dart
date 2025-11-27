import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_layout_app/models/patient_model.dart';

class PatientService {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('patients');

  Future<void> addPatient(Patient p) async {
    await _collection.doc(p.id).set(p.toMap());
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
}
