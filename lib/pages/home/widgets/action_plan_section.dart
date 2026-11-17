import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class TaskItem {
  final String id;
  final String title;
  final String dueDate;
  final bool isCompleted;

  const TaskItem({
    required this.id,
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });

  TaskItem copyWith({String? id, String? title, String? dueDate, bool? isCompleted}) {
    return TaskItem(
      id: id ?? this.id,
      title: title ?? this.title,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ActionPlanSection extends StatelessWidget {
  final List<TaskItem> tasks;
  final int progressPercentage;
  final ValueChanged<String> onToggleTask;
  final VoidCallback onSeeAll;

  const ActionPlanSection({
    super.key,
    required this.tasks,
    required this.progressPercentage,
    required this.onToggleTask,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SEU PLANO', style: AppTextStyles.eyebrow),
                  SizedBox(height: 4),
                  Text('Próximos passos', style: AppTextStyles.heading2),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Text('Ver todos', style: AppTextStyles.textButton),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),


        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryTeal.withValues(alpha: 0.03),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSand.withValues(alpha: 0.55),
                    border: const Border(
                      bottom: BorderSide(color: AppColors.borderLight),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$progressPercentage% concluído',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        width: 110,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            width: (110 * (progressPercentage / 100)).clamp(0.0, 110.0),
                            height: 8,
                            decoration: BoxDecoration(
                              color: AppColors.accentOchre,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),


                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: tasks.length,
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.divider,
                  ),
                  itemBuilder: (context, index) {
                    final item = tasks[index];
                    return InkWell(
                      onTap: () => onToggleTask(item.id),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Transform.scale(
                              scale: 1.15,
                              child: Checkbox(
                                value: item.isCompleted,
                                onChanged: (val) => onToggleTask(item.id),
                                activeColor: AppColors.primaryTeal,
                                checkColor: Colors.white,
                                side: const BorderSide(
                                  color: AppColors.primaryTeal,
                                  width: 1.8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: item.isCompleted
                                        ? AppTextStyles.taskTitleCompleted
                                        : AppTextStyles.taskTitle,
                                    child: Text(item.title),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    item.dueDate,
                                    style: AppTextStyles.taskDate,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
