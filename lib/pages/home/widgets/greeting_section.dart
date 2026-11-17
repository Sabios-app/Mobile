import 'package:flutter/material.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';

class GreetingSection extends StatelessWidget {
  final String userName;
  final String userAvatarUrl;
  final VoidCallback? onAvatarTap;

  const GreetingSection({
    super.key,
    required this.userName,
    required this.userAvatarUrl,
    this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Bom dia, ${userName.split(' ').first}',
                  style: AppTextStyles.greeting,
                ),
                const SizedBox(height: 4),
                const Text(
                  'Vamos avançar?',
                  style: AppTextStyles.heading1,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAvatarTap,
            child: NetworkAvatar(
              imageUrl: userAvatarUrl,
              name: userName,
              size: 48,
              hasBorder: true,
            ),
          ),
        ],
      ),
    );
  }
}
