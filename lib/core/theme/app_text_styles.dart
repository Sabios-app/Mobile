import 'package:flutter/material.dart';
import 'app_colors.dart';


class AppTextStyles {
  AppTextStyles._();


  static const String serifFamily = 'serif';

  static const TextStyle brandLogo = TextStyle(
    fontFamily: serifFamily,
    fontSize: 25,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle greeting = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle heading1 = TextStyle(
    fontFamily: serifFamily,
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: serifFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontFamily: serifFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle eyebrow = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.3,
    color: AppColors.accentAmber,
  );

  static const TextStyle heroCardTag = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.1,
    color: AppColors.accentGoldLight,
  );

  static const TextStyle heroCardTitle = TextStyle(
    fontFamily: serifFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
    color: Colors.white,
  );

  static const TextStyle heroCardSubtitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textWhite60,
  );

  static const TextStyle taskTitle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  static const TextStyle taskTitleCompleted = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  static const TextStyle taskDate = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static const TextStyle mentorName = TextStyle(
    fontFamily: serifFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle mentorRole = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static const TextStyle mentorStatus = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w800,
    color: AppColors.accentAmber,
  );

  static const TextStyle actionButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w800,
    color: AppColors.primaryTeal,
  );

  static const TextStyle textButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    color: AppColors.accentAmberDark,
  );
}
