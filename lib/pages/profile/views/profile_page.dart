import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _ProfileOption(
        icon: Icons.business_center_outlined,
        title: 'Dados profissionais',
        subtitle: 'Café Aurora',
      ),
      _ProfileOption(
        icon: Icons.favorite_border_rounded,
        title: 'Especialistas favoritos',
        subtitle: '3 salvos',
      ),
      _ProfileOption(
        icon: Icons.receipt_long_outlined,
        title: 'Pagamentos e recibos',
        subtitle: 'Ver histórico',
      ),
      _ProfileOption(
        icon: Icons.settings_outlined,
        title: 'Preferências',
        subtitle: 'Notificações e acesso',
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const Text('CONTA DE CLIENTE', style: AppTextStyles.eyebrow),
            const SizedBox(height: 6),
            const Text('Seu perfil', style: AppTextStyles.heading1),
            const SizedBox(height: 18),


            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const NetworkAvatar(
                    imageUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=faces&fit=crop&w=200&h=200&q=85',
                    name: 'Marina Costa',
                    size: 72,
                    borderRadius: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Marina Costa',
                          style: TextStyle(
                            fontFamily: AppTextStyles.serifFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Café Aurora',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textWhite70,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: const Text(
                            'Perfil 80% completo',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accentGoldLight,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),


            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: menuItems.length,
                  separatorBuilder: (ctx, idx) => const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final item = menuItems[index];
                    return InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${item.title} em breve!'),
                            backgroundColor: AppColors.primaryTeal,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceSage,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              alignment: Alignment.center,
                              child: Icon(item.icon, color: AppColors.primaryTeal, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.subtitle,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14,
                              color: AppColors.textPlaceholder,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 28),

            const Center(
              child: Text(
                'Sábios versão 1.0 • Feito para ser simples',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileOption {
  final IconData icon;
  final String title;
  final String subtitle;

  _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
