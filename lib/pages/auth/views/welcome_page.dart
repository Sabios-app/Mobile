import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/brand_logo.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onRegister;
  final VoidCallback onLogin;
  final VoidCallback? onSkipToApp;

  const WelcomePage({
    super.key,
    required this.onRegister,
    required this.onLogin,
    this.onSkipToApp,
  });

  static const String welcomeImageUrl =
      'https://images.unsplash.com/photo-1678282931256-370578a0d036?crop=entropy&cs=tinysrgb&fit=crop&w=900&h=1100&q=85';

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.primaryTeal,
      body: Column(
        children: [

          Expanded(
            flex: 5,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  welcomeImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.primaryTealLight,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.people_outline_rounded,
                      size: 80,
                      color: AppColors.accentGold,
                    ),
                  ),
                ),

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryTeal.withValues(alpha: 0.15),
                        Colors.transparent,
                        AppColors.primaryTeal,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.45, 1.0],
                    ),
                  ),
                ),

                Positioned(
                  top: topPadding + 16,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(999),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const BrandLogo(
                      emblemSize: 32,
                      fontSize: 20,
                    ),
                  ),
                ),

                Positioned(
                  top: topPadding + 16,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTeal.withValues(alpha: 0.85),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Mentoria de verdade',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),


          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 28,
                bottom: bottomPadding + 24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryTeal,
                borderRadius: BorderRadius.vertical(top: Radius.circular(38)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 3.5,
                          backgroundColor: AppColors.accentGoldLight,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'EXPERIÊNCIA QUE TRANSFORMA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                            color: AppColors.accentGoldLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),


                  RichText(
                    text: const TextSpan(
                      text: 'Quem já viveu,\n',
                      style: TextStyle(
                        fontFamily: AppTextStyles.serifFamily,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        height: 1.1,
                        letterSpacing: -0.8,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(
                          text: 'sabe o caminho.',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: AppColors.accentGoldLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),


                  const Text(
                    'Converse com profissionais experientes e tome decisões melhores para o seu negócio.',
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textWhite70,
                    ),
                  ),
                  const SizedBox(height: 26),


                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGoldButton,
                        foregroundColor: AppColors.primaryTeal,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Começar agora',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),


                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: onLogin,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        'Já tenho uma conta',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),


                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          size: 15,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Conselheiros verificados pela Sábios',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
