import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../theme.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const PatientCard({
    super.key,
    required this.patient,
    this.onTap,
    this.onDelete,
  });

  Color getRiskColor() {
    final g = patient.lastGlycemia;

    if (g == null) return AppColors.border;
    if (g < patient.targetMin) return AppColors.mediumRisk;
    if (g > patient.targetMax) return AppColors.highRisk;
    return AppColors.normalRisk;
  }

  String getRiskLabel() {
    final g = patient.lastGlycemia;
    if (g == null) return "Sem dados";

    if (g < patient.targetMin) return "Baixa";
    if (g > patient.targetMax) return "Alta";
    return "Normal";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.border,
              child: const Icon(Icons.person, size: 32, color: AppColors.textLight),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient.diagnosis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  patient.lastGlycemia?.toString() ?? "--",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: getRiskColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    getRiskLabel(),
                    style: TextStyle(
                      fontSize: 12,
                      color: getRiskColor(),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(width: 8),

            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.textLight),
              onPressed: onDelete,
            )
          ],
        ),
      ),
    );
  }
}
