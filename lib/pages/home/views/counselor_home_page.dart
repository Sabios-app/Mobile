import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/home_header.dart';
import '../widgets/notifications_popover.dart';
import '../widgets/conselheiro/conselheiro_header.dart';
import '../widgets/conselheiro/conselheiro_metrics.dart';
import '../widgets/conselheiro/conselheiro_next_session_card.dart';
import '../widgets/conselheiro/conselheiro_pending_requests.dart';
import '../../../services/user_service.dart';
import '../../../services/mentoring_service.dart';
import '../../../services/action_plan_service.dart';
import '../../../services/app_notification_service.dart';
import '../../../models/mentoring_model.dart';
import '../../../models/user_model.dart';

class CounselorHomePage extends StatefulWidget {
  final ValueChanged<int>? onNavigateToTab;

  const CounselorHomePage({super.key, this.onNavigateToTab});

  @override
  State<CounselorHomePage> createState() => _CounselorHomePageState();
}

class _CounselorHomePageState extends State<CounselorHomePage> {
  UserModel? _user;
  bool _isAvailable = true;
  MentoringModel? _nextSession;
  List<MentoringModel> _pendingRequests = [];
  int _unreadNotifications = 0;
  List<NotificationItem> _notifications = [];
  bool _notificationsOpen = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final user = await UserService.getMe();
      final mentorings = await MentoringService.getMyMentorings();
      final unread = await AppNotificationService.getUnreadCount();
      final notifs = await AppNotificationService.getNotifications(size: 5);

      if (!mounted) return;
      setState(() {
        _user = user;
        _unreadNotifications = unread;
        if (notifs.isNotEmpty) {
          _notifications = notifs.map((n) {
            return NotificationItem(
              id: n.id,
              title: n.title,
              message: n.message,
              time: 'Hoje',
              isUnread: !n.read,
            );
          }).toList();
        }

        _pendingRequests =
            mentorings.where((m) => m.status.toUpperCase() == 'REQUESTED').toList();
        final confirmed =
        mentorings.where((m) => m.status.toUpperCase() == 'CONFIRMED').toList();
        if (confirmed.isNotEmpty) {
          _nextSession = confirmed.first;
        } else if (mentorings.isNotEmpty) {
          _nextSession = mentorings.first;
        } else {
          _nextSession = null;
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _pendingRequests = [];
        _nextSession = null;
      });
    }
  }

  void _onEnterRoom() {
    if (_nextSession == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Conectando à videoconferência com o cliente...'),
        backgroundColor: AppColors.primaryTeal,
      ),
    );
  }

  void _showAssignTaskDialog() {
    if (_nextSession == null) return;
    final taskController = TextEditingController();
    final deadlineController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Atribuir Tarefa para ${_nextSession!.client?.name ?? "Cliente"}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: taskController,
                decoration: InputDecoration(
                  labelText: 'Título da ação prática combinada na mentoria',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: deadlineController,
                decoration: InputDecoration(
                  labelText: 'Prazo sugerido (ex: Até a próxima sessão)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () async {
                    final title = taskController.text.trim();
                    if (title.isEmpty) return;
                    Navigator.pop(ctx);
                    await ActionPlanService.createActionPlan(
                      title: title,
                      deadline: deadlineController.text.trim().isNotEmpty
                          ? deadlineController.text.trim()
                          : null,
                      mentoringId: _nextSession!.id,
                      conselheiroNome: _user?.name,
                    );
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Tarefa adicionada com sucesso ao plano do cliente!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Salvar Tarefa no Plano',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleAccept(String id) async {
    await MentoringService.acceptMentoring(id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Mentoria confirmada e adicionada à sua agenda!'),
        backgroundColor: Colors.green,
      ),
    );
    _loadData();
  }

  void _handleDecline(String id) {
    setState(() {
      _pendingRequests.removeWhere((r) => r.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Solicitação recusada.'),
        backgroundColor: AppColors.textSecondary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = _user?.name.isNotEmpty == true ? _user!.name : 'Helena Martins';
    final avatar = _user?.avatarUrl ??
        'https://images.unsplash.com/photo-1758691737605-69a0e78bd193?crop=faces&fit=crop&w=200&h=200&q=85';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: HomeHeader(
        onNotificationsTap: () => setState(() => _notificationsOpen = !_notificationsOpen),
        hasUnreadNotifications: _unreadNotifications > 0,
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _loadData,
            color: AppColors.primaryTeal,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CounselorHeader(
                    name: name,
                    title: 'Finanças & Gestão • Aracaju, SE',
                    avatarUrl: avatar,
                    isAvailable: _isAvailable,
                    onToggleAvailability: (val) => setState(() => _isAvailable = val),
                    onManageAgenda: () => widget.onNavigateToTab?.call(2),
                  ),
                  const SizedBox(height: 20),
                  const CounselorMetrics(),
                  const SizedBox(height: 24),
                  CounselorNextSessionCard(
                    session: _nextSession,
                    onEnterRoom: _onEnterRoom,
                    onAssignTask: _showAssignTaskDialog,
                  ),
                  const SizedBox(height: 24),
                  CounselorPendingRequests(
                    pendingRequests: _pendingRequests,
                    onAccept: _handleAccept,
                    onDecline: _handleDecline,
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          if (_notificationsOpen)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: NotificationsPopover(
                notifications: _notifications,
                onClose: () => setState(() => _notificationsOpen = false),
              ),
            ),
        ],
      ),
    );
  }
}