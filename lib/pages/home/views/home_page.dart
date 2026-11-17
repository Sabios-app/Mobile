import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/greeting_section.dart';
import '../widgets/next_session_card.dart';
import '../widgets/action_plan_section.dart';
import '../widgets/recommended_mentor_card.dart';
import '../widgets/mentor_booking_sheet.dart';
import '../widgets/notifications_popover.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const HomePage({
    super.key,
    this.onNavigateToTab,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const _userName = 'Marina Costa';
  static const _userAvatar = 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?crop=faces&fit=crop&w=200&h=200&q=85';
  static const _session = UpcomingSession(
    title: 'Fluxo de caixa sem complicação',
    mentorName: 'Helena Martins',
    mentorRole: 'Finanças & Gestão',
    mentorImage: 'https://images.unsplash.com/photo-1758691737605-69a0e78bd193?crop=faces&fit=crop&w=200&h=200&q=85',
    time: '15h',
    duration: '60 min',
    dateBadge: 'Hoje',
  );
  static const _carlos = Mentor(
    id: 'carlos',
    name: 'Carlos Almeida',
    role: 'Vendas & Estratégia',
    image: 'https://images.unsplash.com/photo-1750853752220-0facda334bd7?crop=faces&fit=crop&w=200&h=200&q=85',
    rating: '4,8',
    sessions: '96 sessões',
    price: r'R$ 160',
    available: 'Amanhã, às 10h',
    tags: ['Vendas', 'Planejamento'],
    bio: 'Liderou times comerciais por mais de 28 anos no varejo e atacado.',
  );

  List<TaskItem> _tasks = const [
    TaskItem(id: '1', title: 'Revisar despesas fixas', dueDate: 'Até sexta-feira', isCompleted: true),
    TaskItem(id: '2', title: 'Separar contas pessoais', dueDate: 'Até 18 de junho'),
    TaskItem(id: '3', title: 'Projetar caixa para 90 dias', dueDate: 'Até 21 de junho'),
  ];
  bool _notificationsOpen = false;
  final List<NotificationItem> _notifications = const [
    NotificationItem(id: 'n1', title: 'Sessão confirmada', message: 'Helena confirmou sua sessão de hoje, às 15h.', time: 'Há 10 min'),
    NotificationItem(id: 'n2', title: 'Nova mensagem de Carlos', message: 'Vamos retomar aquele plano de vendas?', time: 'Ontem'),
  ];

  int get _progressPercentage {
    if (_tasks.isEmpty) return 0;
    final completed = _tasks.where((t) => t.isCompleted).length;
    return ((completed / _tasks.length) * 100).round();
  }

  void _toggleTask(String id) {
    setState(() {
      _tasks = _tasks.map((t) => t.id == id ? t.copyWith(isCompleted: !t.isCompleted) : t).toList();
    });
  }

  void _toggleNotifications() => setState(() => _notificationsOpen = !_notificationsOpen);
  void _closeNotifications() => setState(() => _notificationsOpen = false);

  void _onEnterRoom() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.videocam_rounded, color: AppColors.accentGold),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Conectando à sala virtual com Helena Martins...',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryTeal,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeHeader(
        onNotificationsTap: _toggleNotifications,
        hasUnreadNotifications: _notifications.any((n) => n.isUnread),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GreetingSection(
                  userName: _userName,
                  userAvatarUrl: _userAvatar,
                  onAvatarTap: () => widget.onNavigateToTab?.call(4),
                ),
                NextSessionCard(
                  session: _session,
                  onEnterRoom: _onEnterRoom,
                ),
                const SizedBox(height: 28),
                ActionPlanSection(
                  tasks: _tasks,
                  progressPercentage: _progressPercentage,
                  onToggleTask: _toggleTask,
                  onSeeAll: () => widget.onNavigateToTab?.call(2),
                ),
                const SizedBox(height: 28),
                RecommendedMentorCard(
                  mentor: _carlos,
                  onSelectMentor: () => MentorBookingSheet.show(context, _carlos),
                  onExplore: () => widget.onNavigateToTab?.call(1),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
          if (_notificationsOpen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: NotificationsPopover(
                notifications: _notifications,
                onClose: _closeNotifications,
              ),
            ),
        ],
      ),
    );
  }
}
