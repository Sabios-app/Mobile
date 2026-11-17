import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/brand_logo.dart';

class HomeHeader extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onNotificationsTap;
  final bool hasUnreadNotifications;

  const HomeHeader({
    super.key,
    required this.onNotificationsTap,
    this.hasUnreadNotifications = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(68);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.95),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const BrandLogo(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: Colors.white,
                shape: const CircleBorder(
                  side: BorderSide(color: AppColors.borderLight, width: 1),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onNotificationsTap,
                  child: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.notifications_outlined,
                      color: AppColors.textPrimary,
                      size: 22,
                    ),
                  ),
                ),
              ),
              if (hasUnreadNotifications)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.notificationDot,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
