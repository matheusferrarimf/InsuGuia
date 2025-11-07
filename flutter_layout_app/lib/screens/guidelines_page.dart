import 'package:flutter/material.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diretrizes SBD 2025'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.description, color: Colors.indigo),
                      SizedBox(width: 8),
                      Text(
                        'Protocolo de Insulinoterapia para Pacientes Não Críticos',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Este protocolo é baseado nas diretrizes da Sociedade Brasileira de Diabetes (2025) '
                    'e destina-se exclusivamente a pacientes não críticos internados em enfermarias.',
                    style: TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          _buildSectionTitle('Tópicos das Diretrizes'),

          _buildAccordion(
            title: '1. Metas Glicêmicas',
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Para a maioria dos pacientes não críticos hospitalizados:'),
                const SizedBox(height: 4),
                const Text('• Glicemia pré-prandial: 100–140 mg/dL'),
                const Text('• Glicemia aleatória: <180 mg/dL'),
                const SizedBox(height: 8),
                const Text(
                  'Metas mais liberais podem ser consideradas em:',
                  style: TextStyle(fontSize: 13),
                ),
                const Text(
                  '• Pacientes com múltiplas comorbidades\n'
                  '• Idosos com risco de hipoglicemia\n'
                  '• Cuidados paliativos\n'
                  '• Hipoglicemia assintomática',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

          _buildAccordion(
            title: '2. Esquemas de Insulinoterapia',
            content: const Text(
              'Esquema Basal-Bolus (Preferencial):\n'
              '- Insulina Basal: NPH 2x/dia ou análogo de longa ação 1x/dia\n'
              '- Insulina Prandial: Regular ou ultrarrápida antes das refeições\n'
              '- Insulina de Correção conforme protocolo\n\n'
              'Esquema Apenas Correção:\n'
              '- Não recomendado como esquema único\n'
              '- Pode ser usado temporariamente em hiperglicemia leve\n'
              '- Controle inadequado em 70% dos casos',
              style: TextStyle(fontSize: 14),
            ),
          ),

          _buildAccordion(
            title: '3. Cálculo da Dose de Correção',
            content: const Text(
              'Fator de Correção (FC):\n'
              '- Regular: FC = 1800 / Dose Total Diária\n'
              '- Ultrarrápida: FC = 1500 / Dose Total Diária\n\n'
              'Dose = (Glicemia Atual - Meta) / FC\n'
              'Exemplo: Dose ≈ 2 UI',
              style: TextStyle(fontSize: 14),
            ),
          ),

          _buildAccordion(
            title: '4. Monitorização Glicêmica',
            content: const Text(
              '• Mínimo 4x/dia: antes das refeições e ao deitar\n'
              '• Adicionar medidas se sintomas de hipo/hiperglicemia\n'
              '• Método: glicemia capilar (padrão-ouro), sensor contínuo quando disponível',
              style: TextStyle(fontSize: 14),
            ),
          ),

          _buildAccordion(
            title: '5. Manejo da Hipoglicemia',
            content: const Text(
              'Definição: Glicemia <70 mg/dL (grave <54 mg/dL)\n\n'
              'Tratamento:\n'
              '- Consciente: 15g carboidrato simples, reavaliar em 15min\n'
              '- Inconsciente: Glicose 50% EV 20–40ml ou Glucagon 1mg IM/SC\n\n'
              'Prevenção: reduzir dose em 10–20%, revisar metas e causas.',
              style: TextStyle(fontSize: 14),
            ),
          ),

          _buildAccordion(
            title: '6. Ajustes de Dose',
            content: const Text(
              '• Ajustar se glicemia fora do alvo por 2–3 dias\n'
              '• Alterar 10–20% da dose correspondente\n'
              '• Reavaliar após 2–3 dias',
              style: TextStyle(fontSize: 14),
            ),
          ),

          _buildAccordion(
            title: '7. Situações Especiais',
            content: const Text(
              'Paciente em jejum: manter 80% da dose basal\n'
              'Uso de corticoides: aumentar 20–50%, foco no período tarde/noite\n'
              'Alta hospitalar: ajustar esquema ambulatorial e agendar acompanhamento.',
              style: TextStyle(fontSize: 14),
            ),
          ),

          const SizedBox(height: 16),

          _buildSectionTitle('Referências'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '1. Sociedade Brasileira de Diabetes. Diretrizes 2024–2025.\n'
              '2. ADA. Standards of Medical Care in Diabetes – 2024.\n'
              '3. Umpierrez GE, et al. Management of Hyperglycemia in Hospitalized Patients. J Clin Endocrinol Metab, 2012.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccordion({required String title, required Widget content}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [content],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}
