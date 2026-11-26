import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/network_avatar.dart';
import '../../../../models/mentoring_model.dart';

class CounselorNextSessionCard extends StatelessWidget {
  final MentoringModel? session;
  final VoidCallback onEnterRoom;
  final VoidCallback onAssignTask;

  const CounselorNextSessionCard({
    super.key,
    required this.session,
    required this.onEnterRoom,
    required this.onAssignTask,
  });

  @override
  Widget build(BuildContext context) {
    if (session == null) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: const Center(
          child: Text(
            'Nenhuma mentoria confirmada no momento.\nAguardando novas solicitações de clientes.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ),
      );
    }

    final clientName = session!.client?.name.isNotEmpty == true ? session!.client!.name : 'Cliente Mentorado';
    final avatar = session!.client?.avatarUrl ?? '';
    final timeStr = session!.scheduledAt != null
        ? '${session!.scheduledAt!.day}/${session!.scheduledAt!.month} às ${session!.scheduledAt!.hour}:00'
        : 'Hoje às 14:00';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryTeal,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryTeal.withValues(alpha: 0.22),
            blurRadius: 36,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.access_time_rounded, size: 14, color: AppColors.accentGoldLight),
                        SizedBox(width: 4),
                        Text(
                          'PRÓXIMA MENTORIA AGENDADA',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentGoldLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      session!.status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  NetworkAvatar(
                    imageUrl: avatar,
                    name: clientName,
                    size: 58,
                    borderRadius: 18,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          clientName,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.serifFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          session!.title,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.textWhite70,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '📅 $timeStr',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGoldLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (session!.doubts != null && session!.doubts!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    'Dúvida do cliente: "${session!.doubts}"',
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: AppColors.textWhite70,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGoldButton,
                        foregroundColor: AppColors.primaryTeal,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: onEnterRoom,
                      icon: const Icon(Icons.videocam_rounded, size: 20),
                      label: const Text(
                        'Entrar na sala',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: onAssignTask,
                    icon: const Icon(Icons.add_task_rounded, size: 20),
                    tooltip: 'Atribuir tarefa ao cliente',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
