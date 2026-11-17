import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/brand_logo.dart';

class RoleChoicePage extends StatelessWidget {
  final ValueChanged<String> onChooseRole;
  final VoidCallback onLogin;
  final VoidCallback onBack;

  const RoleChoicePage({
    super.key,
    required this.onChooseRole,
    required this.onLogin,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: Colors.white,
                  shape: const CircleBorder(
                    side: BorderSide(color: AppColors.borderLight),
                  ),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onBack,
                    child: Container(
                      width: 44,
                      height: 44,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.textPrimary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const BrandLogo(emblemSize: 36, fontSize: 22),
                const SizedBox(width: 44),
              ],
            ),
            const SizedBox(height: 28),


            const Center(
              child: Column(
                children: [
                  Text('CRIE SUA CONTA GRATUITAMENTE', style: AppTextStyles.eyebrow),
                  SizedBox(height: 8),
                  Text(
                    'Como você quer usar a Sábios?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppTextStyles.serifFamily,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Escolha seu perfil para prepararmos uma experiência feita para seus objetivos.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),


            _buildRoleCard(
              icon: Icons.business_center_rounded,
              iconBgColor: AppColors.surfaceSage,
              iconColor: AppColors.primaryTeal,
              title: 'Quero ser cliente',
              description: 'Preciso de orientação para tomar melhores decisões e fazer meu negócio crescer.',
              actionLabel: 'Encontrar um conselheiro',
              onTap: () => onChooseRole('client'),
            ),
            const SizedBox(height: 16),


            _buildRoleCard(
              icon: Icons.star_rounded,
              iconBgColor: AppColors.surfaceSand,
              iconColor: AppColors.accentAmber,
              title: 'Quero ser conselheiro',
              description: 'Quero compartilhar minha experiência, gerar impacto e ter uma renda extra.',
              actionLabel: 'Compartilhar experiência',
              onTap: () => onChooseRole('advisor'),
            ),
            const SizedBox(height: 24),


            Center(
              child: GestureDetector(
                onTap: onLogin,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Já possui uma conta? ',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                      children: [
                        TextSpan(
                          text: 'Entrar agora',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.accentAmberDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryTeal.withValues(alpha: 0.05),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppTextStyles.serifFamily,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    actionLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.accentAmberDark,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    size: 16,
                    color: AppColors.accentAmberDark,
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
