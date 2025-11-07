import 'package:flutter/material.dart';
//sofy: adicionou, o ultimo n funciona
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_layout_app/screens/insulin_calculator_page.dart';
import 'package:flutter_layout_app/screens/patient_details_page.dart';
import 'package:flutter_layout_app/screens/patient_list_page.dart';
import '../firebase_options/firebase_options.dart';
import 'package:flutter/material.dart';
import 'screens/guidelines_page.dart';

void main() {
  runApp(const InsuGuiaApp());
}

class InsuGuiaApp extends StatelessWidget {
  const InsuGuiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InsuGuia Mobile',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(), // substitui depois se tiver tela inicial
        '/guidelines': (context) => const GuidelinesPage(),
        '/patientDetails': (context) => const PatientDetailsPage(patientName: 'João Silva'),
        '/insulinCalculator': (context) => const InsulinCalculatorPage(),
        '/patientList': (context) => const PatientListPage(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('InsuGuia Mobile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/guidelines'),
              child: const Text('Ver Diretrizes SBD 2025'),
            ),
            const SizedBox(height: 16), // espaçamento entre os botões
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/insulinCalculator'),
              child: const Text('Abrir Calculadora de Insulina'),
            ),
            const SizedBox(height: 16), // espaçamento entre os botões
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/patientDetails'),
              child: const Text('Ver Detalhes do Paciente'),
            ),
            const SizedBox(height: 16), // espaçamento entre os botões
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/patientList'),
              child: const Text('Ver Lista de Paciente'),
            )
          ],
        ),
      ),
    );
  }
}
