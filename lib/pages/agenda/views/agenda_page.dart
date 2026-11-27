import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';
import '../../../services/mentoring_service.dart';
import '../../../services/agenda_service.dart';
import '../../../services/user_service.dart';
import '../../../models/mentoring_model.dart';

class AgendaPage extends StatefulWidget {
  final VoidCallback? onScheduleNew;

  const AgendaPage({super.key, this.onScheduleNew});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  int _selectedDay = DateTime.now().day;
  bool _isLoading = true;
  List<MentoringModel> _mentorings = [];
  List<SpecialistAvailability> _myAvailabilities = [];
  bool _isCounselor = false;

  final List<String> _weekDays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
  late final List<int> _days;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _days = List.generate(7, (i) => today.subtract(Duration(days: today.weekday % 7)).add(Duration(days: i)).day);
    _selectedDay = today.day;
    _loadAgendaData();
  }

  Future<void> _loadAgendaData() async {
    setState(() => _isLoading = true);
    final user = await UserService.getMe();
    _isCounselor = user?.isCounselor ?? false;

    if (_isCounselor) {
      _myAvailabilities = await AgendaService.getMyAgenda();
    }
    _mentorings = await MentoringService.getMyMentorings();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _showAddAvailabilityDialog() {
    String selectedDay = 'MONDAY';
    final startController = TextEditingController(text: '09:00');
    final endController = TextEditingController(text: '12:00');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
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
                  const Text(
                    'Adicionar Horário Disponível',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: selectedDay,
                    decoration: InputDecoration(
                      labelText: 'Dia da semana',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'MONDAY', child: Text('Segunda-feira')),
                      DropdownMenuItem(value: 'TUESDAY', child: Text('Terça-feira')),
                      DropdownMenuItem(value: 'WEDNESDAY', child: Text('Quarta-feira')),
                      DropdownMenuItem(value: 'THURSDAY', child: Text('Quinta-feira')),
                      DropdownMenuItem(value: 'FRIDAY', child: Text('Sexta-feira')),
                      DropdownMenuItem(value: 'SATURDAY', child: Text('Sábado')),
                      DropdownMenuItem(value: 'SUNDAY', child: Text('Domingo')),
                    ],
                    onChanged: (val) {
                      if (val != null) setSheetState(() => selectedDay = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: startController,
                          decoration: InputDecoration(
                            labelText: 'Início (ex: 09:00)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: endController,
                          decoration: InputDecoration(
                            labelText: 'Fim (ex: 12:00)',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryTeal,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await AgendaService.addAvailability(
                          dayOfWeek: selectedDay,
                          startTime: startController.text.trim(),
                          endTime: endController.text.trim(),
                        );
                        _loadAgendaData();
                      },
                      child: const Text(
                        'Salvar Disponibilidade',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadAgendaData,
          color: AppColors.primaryTeal,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const Text('AGENDA & SESSÕES', style: AppTextStyles.eyebrow),
              const SizedBox(height: 6),
              Text(
                _isCounselor ? 'Sua disponibilidade' : 'Suas mentorias',
                style: AppTextStyles.heading1,
              ),
              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _weekDays.map((day) {
                        return SizedBox(
                          width: 38,
                          child: Text(
                            day,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPlaceholder,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _days.map((day) {
                        final isSelected = day == _selectedDay;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedDay = day),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 38,
                            height: 44,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryTeal : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              '$day',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
                )
              else if (_isCounselor) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('HORÁRIOS CADASTRADOS', style: AppTextStyles.eyebrow),
                    IconButton(
                      icon: const Icon(Icons.add_circle, color: AppColors.primaryTeal),
                      onPressed: _showAddAvailabilityDialog,
                    ),
                  ],
                ),
                if (_myAvailabilities.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Center(
                      child: Text(
                        'Nenhum horário cadastrado. Toque no + para adicionar disponibilidade.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ),
                  )
                else
                  ..._myAvailabilities.map((av) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.borderLight),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                av.dayOfWeek,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Text(
                                '${av.startTime} às ${av.endTime}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () async {
                              await AgendaService.deleteAvailability(av.id);
                              _loadAgendaData();
                            },
                          ),
                        ],
                      ),
                    );
                  }),
              ] else ...[
                const Text('MENTORIAS AGENDADAS', style: AppTextStyles.eyebrow),
                const SizedBox(height: 12),
                if (_mentorings.isNotEmpty)
                  ..._mentorings.map((m) {
                    final mentorName = m.specialist?.user.name ?? 'Especialista';
                    final avatar = m.specialist?.user.avatarUrl ?? '';
                    final hourStr = m.scheduledAt != null ? '${m.scheduledAt!.hour}:00' : 'A definir';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              NetworkAvatar(
                                imageUrl: avatar,
                                name: mentorName,
                                size: 56,
                                borderRadius: 16,
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$hourStr • ${m.status}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.accentGoldLight,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      m.title,
                                      style: const TextStyle(
                                        fontFamily: AppTextStyles.serifFamily,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      mentorName,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.textWhite60,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Conectando à sala com $mentorName...'),
                                    backgroundColor: AppColors.primaryTeal,
                                  ),
                                );
                              },
                              icon: const Icon(Icons.videocam_rounded, size: 20),
                              label: const Text('Entrar na sala', style: TextStyle(fontWeight: FontWeight.w800)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accentGoldButton,
                                foregroundColor: AppColors.primaryTeal,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  })
                else
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: const Center(
                      child: Text(
                        'Nenhuma mentoria agendada para este período.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                      ),
                    ),
                  ),
              ],
              const SizedBox(height: 20),

              OutlinedButton(
                onPressed: widget.onScheduleNew,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryTeal,
                  side: const BorderSide(color: AppColors.primaryTeal, width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Agendar nova sessão', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
