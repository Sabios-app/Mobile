import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home/widgets/mentor_booking_sheet.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  final Set<String> _favoriteMentorIds = {'helena'};

  final List<String> _filters = ['Todos', 'Finanças', 'Vendas', 'Liderança'];

  static const _mentors = [
    Mentor(
      id: 'helena', name: 'Helena Martins', role: 'Finanças & Gestão',
      image: 'https://images.unsplash.com/photo-1758691737605-69a0e78bd193?crop=faces&fit=crop&w=200&h=200&q=85',
      rating: '4,9', sessions: '128 sessões', price: r'R$ 180', available: 'Hoje, às 17h',
      tags: ['Fluxo de caixa', 'Precificação'],
      bio: 'Ex-diretora financeira com 32 anos de experiência ajudando pequenos negócios.',
    ),
    Mentor(
      id: 'carlos', name: 'Carlos Almeida', role: 'Vendas & Estratégia',
      image: 'https://images.unsplash.com/photo-1750853752220-0facda334bd7?crop=faces&fit=crop&w=200&h=200&q=85',
      rating: '4,8', sessions: '96 sessões', price: r'R$ 160', available: 'Amanhã, às 10h',
      tags: ['Vendas', 'Planejamento'],
      bio: 'Liderou times comerciais por mais de 28 anos no varejo e atacado.',
    ),
    Mentor(
      id: 'roberto', name: 'Roberto Salles', role: 'Liderança & Pessoas',
      image: 'https://images.unsplash.com/photo-1624245532111-8f4aba352ba9?crop=faces&fit=crop&w=200&h=200&q=85',
      rating: '5,0', sessions: '74 sessões', price: r'R$ 200', available: 'Sexta, às 14h',
      tags: ['Liderança', 'Equipe'],
      bio: 'Conselheiro e ex-VP de pessoas em empresas nacionais.',
    ),
  ];

  List<Mentor> get _filteredMentors {
    return _mentors.where((mentor) {
      final matchesQuery = _searchQuery.isEmpty ||
          mentor.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mentor.role.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          mentor.tags.any((tag) => tag.toLowerCase().contains(_searchQuery.toLowerCase()));

      final matchesFilter = _selectedFilter == 'Todos' ||
          mentor.role.toLowerCase().contains(_selectedFilter.toLowerCase());

      return matchesQuery && matchesFilter;
    }).toList();
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
    final mentors = _filteredMentors;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
                      onChanged: (val) => setState(() => _searchQuery = val),
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
                      onSelected: (_) => setState(() => _selectedFilter = filter),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 18),

            Text(
              '${mentors.length} especialistas encontrados',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 14),


            ...mentors.map((mentor) {
              final isFav = _favoriteMentorIds.contains(mentor.id);
              return Container(
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderLight),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryTeal.withValues(alpha: 0.04),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Stack(
                        children: [
                          Image.network(
                            mentor.image,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              height: 180,
                              color: AppColors.surfaceSage,
                              alignment: Alignment.center,
                              child: Text(
                                mentor.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.95),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: const Text(
                                'Disponível esta semana',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Material(
                              color: isFav ? AppColors.primaryTeal : Colors.white,
                              shape: const CircleBorder(),
                              elevation: 2,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => _toggleFavorite(mentor.id),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  alignment: Alignment.center,
                                  child: Icon(
                                    isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    size: 20,
                                    color: isFav ? AppColors.accentGold : AppColors.primaryTeal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),


                      Padding(
                        padding: const EdgeInsets.all(18),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(mentor.name, style: AppTextStyles.heading3),
                                      const SizedBox(height: 2),
                                      Text(
                                        mentor.role,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.accentAmber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.star_rounded, size: 16, color: AppColors.accentOchre),
                                    const SizedBox(width: 3),
                                    Text(
                                      mentor.rating,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),


                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: mentor.tags.map((tag) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceSage,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    tag,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),

                            const SizedBox(height: 16),
                            const Divider(height: 1, color: AppColors.divider),
                            const SizedBox(height: 14),


                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: mentor.price,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                    children: const [
                                      TextSpan(
                                        text: ' / sessão',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => MentorBookingSheet.show(context, mentor),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryTeal,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                  ),
                                  child: const Text(
                                    'Ver agenda',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
