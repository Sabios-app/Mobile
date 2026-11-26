import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/network_avatar.dart';
import '../../home/widgets/mentor_booking_sheet.dart';
import '../../../services/specialist_service.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final Set<String> _favoriteMentorIds = {};
  bool _isLoading = false;

  final List<String> _filters = ['Todos', 'Finanças', 'Vendas', 'Liderança', 'Estratégia'];

  List<Mentor> _remoteMentors = [];

  @override
  void initState() {
    super.initState();
    _fetchSpecialists();
  }

  Future<void> _fetchSpecialists() async {
    setState(() => _isLoading = true);
    try {
      final list = await SpecialistService.getSpecialists(
        search: _searchQuery.isNotEmpty ? _searchQuery : null,
        specialty: _selectedFilter != 'Todos' ? _selectedFilter : null,
      );

      if (!mounted) return;
      setState(() {
        _remoteMentors = list.map((s) {
          return Mentor(
            id: s.id,
            name: s.user.name.isNotEmpty ? s.user.name : s.title,
            role: s.specialty.isNotEmpty ? s.specialty : s.title,
            image: (s.user.avatarUrl != null && s.user.avatarUrl!.isNotEmpty)
                ? s.user.avatarUrl!
                : '',
            rating: s.rating > 0 ? s.rating.toStringAsFixed(1).replaceAll('.', ',') : '5,0',
            sessions: 'Sessões disponíveis',
            price: 'R\$ ${s.hourlyRate.toInt()}',
            available: s.isAvailable ? 'Disponível' : 'Indisponível no momento',
            tags: [s.specialty, 'Consultoria'],
            bio: s.bio,
          );
        }).toList();
        _isLoading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleFavorite(String mentorId) {
    setState(() {
      if (_favoriteMentorIds.contains(mentorId)) {
        _favoriteMentorIds.remove(mentorId);
      } else {
        _favoriteMentorIds.add(mentorId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchSpecialists,
          color: AppColors.primaryTeal,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              const Text('CONSELHEIROS VERIFICADOS', style: AppTextStyles.eyebrow),
              const SizedBox(height: 6),
              const Text('Encontre a experiência certa', style: AppTextStyles.heading1),
              const SizedBox(height: 18),

              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppColors.textPlaceholder),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        onChanged: (val) {
                          _searchQuery = val;
                          _fetchSpecialists();
                        },
                        decoration: const InputDecoration(
                          hintText: 'Tema, desafio ou nome',
                          hintStyle: TextStyle(color: AppColors.textPlaceholder, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = _selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(
                          filter,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.primaryTeal,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                          side: BorderSide(
                            color: isSelected ? Colors.transparent : AppColors.borderLight,
                          ),
                        ),
                        onSelected: (val) {
                          setState(() => _selectedFilter = filter);
                          _fetchSpecialists();
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryTeal)),
                )
              else if (_remoteMentors.isEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Center(
                    child: Text(
                      'Nenhum especialista encontrado no momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    ),
                  ),
                )
              else
                ..._remoteMentors.map((mentor) {
                  final isFav = _favoriteMentorIds.contains(mentor.id);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(18),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            NetworkAvatar(
                              imageUrl: mentor.image,
                              name: mentor.name,
                              size: 58,
                              borderRadius: 16,
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    mentor.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    mentor.role,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 16, color: AppColors.accentGold),
                                      const SizedBox(width: 4),
                                      Text(
                                        mentor.rating,
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        mentor.sessions,
                                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () => _toggleFavorite(mentor.id),
                              icon: Icon(
                                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                color: isFav ? Colors.redAccent : AppColors.textPlaceholder,
                              ),
                            ),
                          ],
                        ),
                        if (mentor.bio.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          Text(
                            mentor.bio,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13,
                              height: 1.4,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              mentor.price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              ),
                              onPressed: () => MentorBookingSheet.show(context, mentor),
                              child: const Text(
                                'Agendar',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }
}
