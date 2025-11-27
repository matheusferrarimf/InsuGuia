import 'package:flutter/material.dart';
import 'package:flutter_layout_app/models/patient_model.dart';
import 'package:flutter_layout_app/screens/patients/patient_list_page.dart';
import '../insulin_calculator_page.dart';
import '../guidelines_page.dart';
import '../../utils/no_animation_route.dart';

class PatientDetailsPage extends StatefulWidget {
  final Patient patient;

  const PatientDetailsPage({super.key, required this.patient});

  @override
  State<PatientDetailsPage> createState() => _PatientDetailsPageState();
}

class _PatientDetailsPageState extends State<PatientDetailsPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.patient;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------
            // MENU SUPERIOR
            // -------------------------------------
            _topMenu(context),

            const SizedBox(height: 20),

            // -------------------------
            // CABEÇALHO DO PACIENTE
            // -------------------------
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),
                    const Text(
                      "Detalhes completos e histórico do paciente",
                      style: TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoColumn("Idade", "${p.age} anos"),
                        _infoColumn("Peso", "${p.weight} kg"),
                        _infoColumn(
                          "Última Glicemia",
                          p.lastGlycemia != null
                              ? "${p.lastGlycemia} mg/dL"
                              : "--",
                          highlight: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // -------------------------------------
            // TABS INTERNAS
            // -------------------------------------
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: const [
                  Tab(text: "Controle Glicêmico"),
                  Tab(text: "Insulinoterapia"),
                  Tab(text: "Dados Clínicos"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 400,
              child: TabBarView(
                controller: tabController,
                children: [
                  _glycemiaTab(),
                  _placeholder("Insulinoterapia"),
                  _placeholder("Dados Clínicos"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: _metricCard("Média 24h", "150 mg/dL")),
                const SizedBox(width: 12),
                Expanded(
                    child: _metricCard("Tempo no Alvo", "60%",
                        color: Colors.green)),
                const SizedBox(width: 12),
                Expanded(
                    child: _metricCard("Eventos Hipoglicemia", "0",
                        color: Colors.red)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // MENU SUPERIOR — EXATAMENTE COMO NO PRINT
  // =====================================================================

  Widget _topMenu(BuildContext context) {
    final selected = 2; // Detalhes

    final items = [
      "Pacientes",
      "Calculadora",
      "Detalhes",
      "Diretrizes",
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = index == selected;

          return GestureDetector(
            onTap: () => _navigateTo(index),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: isSelected
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        )
                      ],
                    )
                  : null,
              child: Text(
                items[index],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.blue : Colors.black87,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ------------------- MENU SUPERIOR (sem animação) --------------------
  void _navigateTo(int index) {
    if (index == 2) return; // já está na tela

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: PatientListPage()),
      );
    }

    if (index == 1) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: const InsulinCalculatorPage()),
      );
    }

    if (index == 3) {
      Navigator.pushReplacement(
        context,
        NoAnimationRoute(page: const GuidelinesPage()),
      );
    }
  }

  // =====================================================================
  // COMPONENTES AUXILIARES
  // =====================================================================

  Widget _infoColumn(String label, String value,
      {bool highlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Container(
          padding: highlight ? const EdgeInsets.all(6) : null,
          decoration: highlight
              ? BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(6),
                )
              : null,
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight:
                  highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.red : Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _glycemiaTab() {
    return const Center(
      child: Text("📊 Gráfico será adicionado aqui"),
    );
  }

  Widget _placeholder(String text) {
    return Center(
      child: Text("Conteúdo de $text ainda não implementado"),
    );
  }

  Widget _metricCard(String title, String value, {Color? color}) {
    return Card(
      elevation: 2,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                color: color ?? Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
