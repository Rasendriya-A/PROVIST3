import 'package:flutter/material.dart';
import 'package:provis_tugas_3/utils/app_colors.dart';

class AppTextStyles {
  static const time = TextStyle(
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const headingLarge = TextStyle(
    fontSize: 48,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const headingMedium = TextStyle(
    fontSize: 36,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const label = TextStyle(
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const categoryLabel = TextStyle(
    fontSize: 12,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  static const small = TextStyle(
    fontSize: 12,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const button = TextStyle(
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const appTitle = TextStyle(
    fontFamily: 'Merriweather',
    fontVariations: [
      FontVariation('wght', 700.0), // Mengatur ketebalan menjadi Bold
    ],
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const header = TextStyle(
    fontSize: 20,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const headerLight = TextStyle(
    fontSize: 24,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    color: AppColors.background, // Ganti warna sesuai kebutuhan
  );

  static const headerDark = TextStyle(
    fontSize: 24,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    color: AppColors.textDark, // Ganti warna sesuai kebutuhan
  );

  static const link = TextStyle(
    fontSize: 14,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );
}
