import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';
import '../../../services/auth_service.dart';
import '../../../services/user_service.dart';
import '../../../models/user_model.dart';

class ProfilePage extends StatefulWidget {
  final VoidCallback? onLogout;

  const ProfilePage({super.key, this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await UserService.getMe();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      _ProfileOption(
        icon: Icons.business_center_outlined,
        title: 'Dados profissionais',
        subtitle: _user?.isCounselor == true ? 'Conselheiro Especialista' : 'Café Aurora',
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

    final name = _user?.name.isNotEmpty == true ? _user!.name : 'Marina Costa';
    final roleTitle = _user?.isCounselor == true ? 'CONTA DE CONSELHEIRO' : 'CONTA DE CLIENTE';
    final email = _user?.email.isNotEmpty == true ? _user!.email : 'marina@cafeaurora.com.br';
    final avatar = _user?.avatarUrl ?? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=faces&fit=crop&w=200&h=200&q=85';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadUser,
          color: AppColors.primaryTeal,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              Text(roleTitle, style: AppTextStyles.eyebrow),
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
                    NetworkAvatar(
                      imageUrl: avatar,
                      name: name,
                      size: 72,
                      borderRadius: 20,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontFamily: AppTextStyles.serifFamily,
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 13,
                              color: AppColors.textWhite70,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              _user?.role ?? 'CLIENTE',
                              style: const TextStyle(
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
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${item.title} em breve!'),
                              backgroundColor: AppColors.primaryTeal,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
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
                                  color: AppColors.surfaceWarmGray,
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
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, color: AppColors.textPlaceholder),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              OutlinedButton.icon(
                onPressed: () async {
                  await AuthService.logout();
                  UserService.clearUser();
                  widget.onLogout?.call();
                },
                icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                label: const Text(
                  'Sair da conta',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.redAccent, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileOption {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}
