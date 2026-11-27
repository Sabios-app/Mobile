import 'package:flutter/material.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';

class Mentor {
  final String id;
  final String name;
  final String role;
  final String image;
  final String rating;
  final String sessions;
  final String price;
  final String available;
  final List<String> tags;
  final String bio;

  const Mentor({
    required this.id,
    required this.name,
    required this.role,
    required this.image,
    required this.rating,
    required this.sessions,
    required this.price,
    required this.available,
    required this.tags,
    this.bio = '',
  });
}

class MentorBookingSheet extends StatefulWidget {
  final Mentor mentor;
  final VoidCallback onClose;

  const MentorBookingSheet({
    super.key,
    required this.mentor,
    required this.onClose,
  });

  static void show(BuildContext context, Mentor mentor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MentorBookingSheet(
        mentor: mentor,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  State<MentorBookingSheet> createState() => _MentorBookingSheetState();
}

class _MentorBookingSheetState extends State<MentorBookingSheet> {
  final _titleController = TextEditingController(text: 'Sessão de mentoria');
  final _doubtsController = TextEditingController();

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 10, minute: 0);

  List<DateTime> _availableSlots = [];
  bool _loadingSlots = true;
  bool _confirmed = false;
<<<<<<< Updated upstream
=======
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFreeSlots();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _doubtsController.dispose();
    super.dispose();
  }

  String _formatIsoDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }



  Set<String> get _availableDayKeys {
    return _availableSlots.map((dt) => _formatIsoDate(dt)).toSet();
  }

  List<TimeOfDay> get _slotsForSelectedDate {
    final times = _availableSlots
        .where(
          (dt) =>
      dt.year == _selectedDate.year &&
          dt.month == _selectedDate.month &&
          dt.day == _selectedDate.day,
    )
        .map((dt) => TimeOfDay(hour: dt.hour, minute: dt.minute))
        .toList();

    final unique = <String, TimeOfDay>{};
    for (final t in times) {
      unique['${t.hour}:${t.minute}'] = t;
    }
    return unique.values.toList();
  }

  DateTime get _scheduledDateTime {
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  DateTime? _parseSpecialistLocalDateTime(String raw) {
    final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2})').firstMatch(raw.trim());
    if (match == null) return DateTime.tryParse(raw)?.toLocal();
    return DateTime(
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
      int.parse(match.group(4)!),
      int.parse(match.group(5)!),
    );
  }

  Future<void> _loadFreeSlots() async {
    setState(() {
      _loadingSlots = true;
      _errorMessage = null;
    });

    try {
      final now = DateTime.now();
      final from = DateTime(now.year, now.month, now.day);
      final to = from.add(const Duration(days: 28));
      final url =
          'https://api-sabios.lmagalhaes.com/api/v1/agenda/specialists/${widget.mentor.id}/slots?from=${_formatIsoDate(from)}&to=${_formatIsoDate(to)}';

      final response = await ApiClient.get(url);
      final parsed = <DateTime>[];
      if (response is List) {
        for (final item in response) {
          final dt = _parseSpecialistLocalDateTime(item.toString());
          if (dt != null) {
            parsed.add(dt);
          }
        }
      }
      parsed.sort();

      if (!mounted) return;
      setState(() {
        _availableSlots = parsed;
        _loadingSlots = false;
        if (parsed.isNotEmpty) {
          final first = parsed.first;
          _selectedDate = DateTime(first.year, first.month, first.day);
          _selectedTime = TimeOfDay(hour: first.hour, minute: first.minute);
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _availableSlots = [];
        _loadingSlots = false;
        _errorMessage = _parseError(e);
      });
    }
  }

  Future<void> _pickDate() async {
    if (_loadingSlots) return;

    final dayKeys = _availableDayKeys;
    if (dayKeys.isEmpty) {
      setState(() {
        _errorMessage = 'Este especialista não possui dias disponíveis nos próximos 30 dias.';
      });
      return;
    }

    final sortedDates = _availableSlots
        .map((dt) => DateTime(dt.year, dt.month, dt.day))
        .toList()
      ..sort();

    final firstDate = sortedDates.first;
    final lastDate = sortedDates.last;

    DateTime safeInitial = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    if (safeInitial.isBefore(firstDate) ||
        safeInitial.isAfter(lastDate) ||
        !dayKeys.contains(_formatIsoDate(safeInitial))) {
      safeInitial = firstDate;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (day) => dayKeys.contains(_formatIsoDate(day)),
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedDate = picked;
        _errorMessage = null;
        final dayTimes = _slotsForSelectedDate;
        if (dayTimes.isNotEmpty) {
          _selectedTime = dayTimes.first;
        }
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
        _errorMessage = null;
      });
    }
  }

  String _parseError(Object error) {
    if (error is ApiException) {
      return error.message.isNotEmpty
          ? error.message
          : 'Erro ${error.statusCode} ao reservar horário.';
    }
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _handleBooking() async {
    if (_isSubmitting) return;

    final scheduled = _scheduledDateTime;
    if (!scheduled.isAfter(DateTime.now().add(const Duration(minutes: 5)))) {
      setState(() {
        _errorMessage = 'Selecione uma data e horário futuros.';
      });
      return;
    }

    final title = _titleController.text.trim();
    if (title.isEmpty) {
      setState(() {
        _errorMessage = 'Informe o tema da sessão.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      await MentoringService.createMentoring(
        specialistId: widget.mentor.id,
        scheduledAt: scheduled,
        title: title,
        description: 'Mentoria agendada via aplicativo Sábios.',
        doubts: _doubtsController.text.trim().isNotEmpty
            ? _doubtsController.text.trim()
            : null,
      );

      if (!mounted) return;
      setState(() {
        _confirmed = true;
        _isSubmitting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _errorMessage = _parseError(e);
      });
    }
  }
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    final daySlots = _slotsForSelectedDate;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 14,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x660C2221),
            blurRadius: 40,
            offset: Offset(0, -10),
          ),
        ],
      ),
<<<<<<< Updated upstream
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.primaryTeal.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 20),

          if (_confirmed) ...[

=======
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
>>>>>>> Stashed changes
            Container(
              width: 48,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.primaryTeal.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(999),
              ),
<<<<<<< Updated upstream
              alignment: Alignment.center,
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.successText,
                size: 34,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Horário reservado',
              style: TextStyle(
                fontFamily: AppTextStyles.serifFamily,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sua sessão com ${widget.mentor.name} foi adicionada à agenda para ${widget.mentor.available.toLowerCase()}.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Concluir',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ] else ...[

            Row(
              children: [
                NetworkAvatar(
                  imageUrl: widget.mentor.image,
                  name: widget.mentor.name,
                  size: 76,
                  borderRadius: 22,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.mentor.name,
                        style: const TextStyle(
                          fontFamily: AppTextStyles.serifFamily,
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.mentor.role,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentAmber,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.accentOchre,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.mentor.rating} • ${widget.mentor.sessions}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),


            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.borderLight),
=======
            ),
            const SizedBox(height: 20),

            if (_confirmed) ...[
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceSuccess,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.successText,
                  size: 34,
                ),
>>>>>>> Stashed changes
              ),
              const SizedBox(height: 18),
              const Text(
                'Horário reservado',
                style: TextStyle(
                  fontFamily: AppTextStyles.serifFamily,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Solicitação enviada para ${widget.mentor.name} em ${_formatDate(_selectedDate)} às ${_formatTime(_selectedTime)}. O link da sala será disponibilizado na sua agenda.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: widget.onClose,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Concluir',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ] else ...[
              Row(
                children: [
                  NetworkAvatar(
                    imageUrl: widget.mentor.image,
                    name: widget.mentor.name,
                    size: 76,
                    borderRadius: 22,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.mentor.name,
                          style: const TextStyle(
                            fontFamily: AppTextStyles.serifFamily,
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.mentor.role,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.accentAmber,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 16,
                              color: AppColors.accentOchre,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.mentor.rating} • ${widget.mentor.sessions}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

<<<<<<< Updated upstream

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _confirmed = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryTeal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  'Reservar este horário',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
=======
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('DATA E HORÁRIO', style: AppTextStyles.eyebrow),
                        Text(
                          widget.mentor.price,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickDate,
                            icon: const Icon(Icons.calendar_today_outlined, size: 17),
                            label: Text(_formatDate(_selectedDate)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _pickTime,
                            icon: const Icon(Icons.schedule_rounded, size: 17),
                            label: Text(_formatTime(_selectedTime)),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    if (_loadingSlots)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      )
                    else if (daySlots.isNotEmpty)
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: daySlots.map((time) {
                          final isSelected = time.hour == _selectedTime.hour &&
                              time.minute == _selectedTime.minute;
                          return ChoiceChip(
                            label: Text(_formatTime(time)),
                            selected: isSelected,
                            selectedColor: AppColors.primaryTeal,
                            labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? Colors.white : AppColors.textPrimary,
                            ),
                            onSelected: (_) {
                              setState(() {
                                _selectedTime = time;
                                _errorMessage = null;
                              });
                            },
                          );
                        }).toList(),
                      )
                    else
                      const Text(
                        'Sem horários livres cadastrados para esta data. Escolha outra data ou use o seletor de horário.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                      ),
                  ],
>>>>>>> Stashed changes
                ),
              ),
              const SizedBox(height: 12),

<<<<<<< Updated upstream

            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: widget.onClose,
                child: const Text(
                  'Agora não',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textMuted,
=======
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Tema da sessão',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderLight),
>>>>>>> Stashed changes
                  ),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _doubtsController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Dúvidas ou contexto (opcional)',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.borderLight),
                  ),
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handleBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                      : const Text(
                    'Reservar este horário',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),

              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: widget.onClose,
                  child: const Text(
                    'Agora não',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}