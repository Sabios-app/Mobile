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
<<<<<<< Updated upstream
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
=======
  UserModel? _user = UserService.currentUser;
  List<TaskItem> _tasks = [];
  int _unreadNotificationsCount = 0;
  List<NotificationItem> _notifications = [];
  bool _notificationsOpen = false;

  Mentor? _recommendedMentor;

  UpcomingSession _session = const UpcomingSession(
    title: 'Fluxo de caixa sem complicação',
    mentorName: 'Especialista',
    mentorRole: 'Finanças & Gestão',
    mentorImage: '',
    time: '15h',
    duration: '60 min',
    dateBadge: 'Hoje',
  );

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    final user = await UserService.getMe();
    if (!mounted) return;
    if (user != null) {
      setState(() => _user = user);
    }

    if (!(user?.isCounselor ?? false)) {
      _loadTasks();
    }

    _loadNotifications();
    _loadNextMentoring();
    _loadRecommendedMentor();
  }

  Future<void> _loadTasks() async {
    try {
      final plans = await ActionPlanService.getActionPlans();
      if (!mounted) return;
      if (plans.isNotEmpty) {
        setState(() {
          _tasks = plans.map((p) {
            final due = p.dueDate ?? p.deadline ?? 'Sem prazo definido';
            return TaskItem(
              id: p.id,
              title: p.title,
              dueDate: due,
              isCompleted: p.completed,
            );
          }).toList();
        });
      } else {
        setState(() => _tasks = []);
      }
    } catch (_) {}
  }

  Future<void> _loadNotifications() async {
    final unread = await AppNotificationService.getUnreadCount();
    final notifs = await AppNotificationService.getNotifications(size: 5);
    if (!mounted) return;
    setState(() {
      _unreadNotificationsCount = unread;
      if (notifs.isNotEmpty) {
        _notifications = notifs.map((n) {
          final diff = n.createdAt != null
              ? DateTime.now().difference(n.createdAt!)
              : Duration.zero;
          String timeStr = 'Hoje';
          if (diff.inMinutes < 60) {
            timeStr = 'Há ${diff.inMinutes} min';
          } else if (diff.inHours < 24) {
            timeStr = 'Há ${diff.inHours}h';
          } else {
            timeStr = 'Há ${diff.inDays} dias';
          }

          return NotificationItem(
            id: n.id,
            title: n.title,
            message: n.message,
            time: timeStr,
            isUnread: !n.read,
          );
        }).toList();
      }
    });
  }

  Future<void> _loadNextMentoring() async {
    final mentorings = await MentoringService.getMyMentorings();
    if (!mounted || mentorings.isEmpty) return;

    final next = mentorings.firstWhere(
          (m) => m.isConfirmed && (m.scheduledAt == null || m.scheduledAt!.isAfter(DateTime.now().subtract(const Duration(hours: 1)))),
      orElse: () => mentorings.first,
    );

    setState(() {
      final hour = next.scheduledAt != null ? '${next.scheduledAt!.hour}h' : '15h';
      _session = UpcomingSession(
        title: next.title,
        mentorName: next.specialist?.user.name ?? 'Especialista',
        mentorRole: next.specialist?.specialty ?? 'Finanças & Gestão',
        mentorImage: next.specialist?.user.avatarUrl ?? '',
        time: hour,
        duration: '60 min',
        dateBadge: 'Hoje',
      );
    });
  }

  Future<void> _loadRecommendedMentor() async {
    final specialists = await SpecialistService.getSpecialists(size: 1);
    if (!mounted || specialists.isEmpty) return;

    final s = specialists.first;
    setState(() {
      _recommendedMentor = Mentor(
        id: s.id,
        name: s.user.name.isNotEmpty ? s.user.name : 'Carlos Almeida',
        role: s.specialty.isNotEmpty ? s.specialty : s.title,
        image: (s.user.avatarUrl != null && s.user.avatarUrl!.isNotEmpty)
            ? s.user.avatarUrl!
            : 'https://images.unsplash.com/photo-1750853752220-0facda334bd7?crop=faces&fit=crop&w=200&h=200&q=85',
        rating: s.rating > 0 ? s.rating.toStringAsFixed(1).replaceAll('.', ',') : '4,8',
        sessions: '96 sessões',
        price: 'R\$ ${s.hourlyRate.toInt()}',
        available: 'Disponível',
        tags: [s.specialty, 'Consultoria'],
        bio: s.bio,
      );
    });
  }
>>>>>>> Stashed changes

  int get _progressPercentage {
    if (_tasks.isEmpty) return 0;
    final completed = _tasks.where((t) => t.isCompleted).length;
    return ((completed / _tasks.length) * 100).round();
  }

<<<<<<< Updated upstream
  void _toggleTask(String id) {
=======
  Future<void> _toggleTask(String id) async {
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
    final displayName = _user?.name.isNotEmpty == true ? _user!.name : '';
    final displayAvatar = _user?.avatarUrl ?? '';

>>>>>>> Stashed changes
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeHeader(
        onNotificationsTap: _toggleNotifications,
        hasUnreadNotifications: _notifications.any((n) => n.isUnread),
      ),
      body: Stack(
        children: [
<<<<<<< Updated upstream
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
=======
          RefreshIndicator(
            onRefresh: _loadInitialData,
            color: AppColors.primaryTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GreetingSection(
                    userName: displayName,
                    userAvatarUrl: displayAvatar,
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
                    onSeeAll: _showCreateTaskDialog,
                  ),
                  if (_recommendedMentor != null) ...[
                    const SizedBox(height: 28),
                    RecommendedMentorCard(
                      mentor: _recommendedMentor!,
                      onSelectMentor: () => MentorBookingSheet.show(context, _recommendedMentor!),
                      onExplore: () => widget.onNavigateToTab?.call(1),
                    ),
                  ],
                  const SizedBox(height: 40),
                ],
              ),
>>>>>>> Stashed changes
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