import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/brand_logo.dart';
import '../../../core/widgets/network_avatar.dart';

class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final conversations = [
      _Conversation(
        name: 'Helena Martins',
        text: 'Recebi seu relatório. Está ótimo!',
        time: '10:42',
        imageUrl: 'https://images.unsplash.com/photo-1758691737605-69a0e78bd193?crop=faces&fit=crop&w=200&h=200&q=85',
        isUnread: true,
      ),
      _Conversation(
        name: 'Carlos Almeida',
        text: 'Vamos retomar aquele plano de vendas?',
        time: 'Ontem',
        imageUrl: 'https://images.unsplash.com/photo-1750853752220-0facda334bd7?crop=faces&fit=crop&w=200&h=200&q=85',
        isUnread: true,
      ),
      _Conversation(
        name: 'Suporte Sábios',
        text: 'Como foi sua última sessão?',
        time: 'Seg',
        imageUrl: null,
        isUnread: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            const Text('2 NOVAS MENSAGENS', style: AppTextStyles.eyebrow),
            const SizedBox(height: 6),
            const Text('Conversas', style: AppTextStyles.heading1),
            const SizedBox(height: 18),


            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.borderLight),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: const Row(
                children: [
                  Icon(Icons.search_rounded, color: AppColors.textPlaceholder),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar conversa',
                        hintStyle: TextStyle(color: AppColors.textPlaceholder, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),


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
                  itemCount: conversations.length,
                  separatorBuilder: (ctx, idx) => const Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) {
                    final item = conversations[index];
                    return InkWell(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Abrindo chat com ${item.name}...'),
                            backgroundColor: AppColors.primaryTeal,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        child: Row(
                          children: [
                            if (item.imageUrl != null)
                              NetworkAvatar(
                                imageUrl: item.imageUrl!,
                                name: item.name,
                                size: 52,
                                borderRadius: 999,
                              )
                            else
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryTeal,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CustomPaint(
                                    painter: SabiosSymbolPainter(color: AppColors.accentGold),
                                  ),
                                ),
                              ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        item.time,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.text,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: item.isUnread ? FontWeight.w600 : FontWeight.normal,
                                      color: item.isUnread ? AppColors.textPrimary : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (item.isUnread) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 10,
                                height: 10,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentOchre,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Conversation {
  final String name;
  final String text;
  final String time;
  final String? imageUrl;
  final bool isUnread;

  _Conversation({
    required this.name,
    required this.text,
    required this.time,
    required this.imageUrl,
    required this.isUnread,
  });
}
