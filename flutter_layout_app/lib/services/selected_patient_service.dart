import 'package:flutter_layout_app/models/patient_model.dart';

class SelectedPatientService {

  static final SelectedPatientService _instance =
      SelectedPatientService._internal();

  Patient? selected;

  bool hasAutoSelected = false;

  factory SelectedPatientService() {
    return _instance;
  }

  SelectedPatientService._internal();

  void select(Patient patient) {
    selected = patient;
  }

  void clear() {
    selected = null;
    hasAutoSelected = false;
  }
}
