import 'package:cloud_firestore/cloud_firestore.dart';

class Patient {
  final String id;
  final String name;
  final int age;
  final String diagnosis;
  final String insulinType;
  final double weight;
  final int targetMin;
  final int targetMax;
  final int? lastGlycemia;
  final DateTime? lastUpdate;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.diagnosis,
    required this.insulinType,
    required this.weight,
    required this.targetMin,
    required this.targetMax,
    this.lastGlycemia,
    this.lastUpdate,
  });

  factory Patient.fromMap(String id, Map<String, dynamic> data) {
    return Patient(
      id: id,
      name: data['name'] ?? '',
      age: data['age'] ?? 0,
      diagnosis: data['diagnosis'] ?? '',
      insulinType: data['insulinType'] ?? '',
      weight: (data['weight'] ?? 0).toDouble(),
      targetMin: data['target']?['min'] ?? 0,
      targetMax: data['target']?['max'] ?? 0,
      lastGlycemia: data['lastGlycemia'],
      lastUpdate: data['lastUpdate'] != null
          ? (data['lastUpdate'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'diagnosis': diagnosis,
      'insulinType': insulinType,
      'weight': weight,
      'target': {
        'min': targetMin,
        'max': targetMax,
      },
      'lastGlycemia': lastGlycemia,
      'lastUpdate': lastUpdate != null
          ? Timestamp.fromDate(lastUpdate!)
          : null,
    };
  }
}
