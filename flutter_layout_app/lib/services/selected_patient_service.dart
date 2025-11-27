import 'package:flutter_layout_app/models/patient_model.dart';

class SelectedPatientService {
  // Singleton: só existe uma instância
  static final SelectedPatientService _instance =
      SelectedPatientService._internal();

  /// Paciente atualmente selecionado
  Patient? selected;

  /// Para saber se já selecionou automaticamente o primeiro da lista
  bool hasAutoSelected = false;

  factory SelectedPatientService() {
    return _instance;
  }

  SelectedPatientService._internal();

  /// Define um paciente como selecionado
  void select(Patient patient) {
    selected = patient;
  }

  /// Limpa seleção
  void clear() {
    selected = null;
    hasAutoSelected = false;
  }
}
