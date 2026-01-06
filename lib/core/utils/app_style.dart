import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:student_management/core/app_fonts/app_fonts.dart' show AppFonts;
import 'package:student_management/core/utils/app_colors.dart' show AppColors;

class AppStyles {
  static TextStyle get baseStyle => GoogleFonts.acme();
  //----------------------------------------------------------------------------
  const AppStyles.create({required this.basic});
  static final AppStyles _instance = AppStyles.create(
    basic: AppStyles.baseStyle,
  );
  factory AppStyles() => _instance;
  //----------------------------------------------------------------------------
  final TextStyle basic;
  static final TextStyle baseFont = baseStyle.copyWith(
    fontWeight: FontWeight.w400,
  );

  /// FontSize: 10
  static final extraSmall = TextStyleSet(baseFont.copyWith(fontSize: 10));

  /// FontSize: 11
  static final semiSmall = TextStyleSet(baseFont.copyWith(fontSize: 11));

  /// FontSize: 12
  static final small = TextStyleSet(baseFont.copyWith(fontSize: 12));

  /// FontSize: 13
  static final semiRegular = TextStyleSet(baseFont.copyWith(fontSize: 13));

  /// FontSize: 14
  static final regular = TextStyleSet(baseFont.copyWith(fontSize: 14));

  /// FontSize: 15
  static final semiMedium = TextStyleSet(baseFont.copyWith(fontSize: 15));

  /// FontSize: 16
  static final medium = TextStyleSet(baseFont.copyWith(fontSize: 16));

  /// FontSize: 17
  static final semiLarge = TextStyleSet(baseFont.copyWith(fontSize: 17));

  /// FontSize: 18
  static final large = TextStyleSet(baseFont.copyWith(fontSize: 18));

  /// FontSize: 20
  static final larger = TextStyleSet(baseFont.copyWith(fontSize: 20));

  /// FontSize: 22
  static final extraLarge = TextStyleSet(baseFont.copyWith(fontSize: 22));

  /// FontSize: 24
  static final large24 = TextStyleSet(baseFont.copyWith(fontSize: 24));

  /// FontSize: 26
  static final large26 = TextStyleSet(baseFont.copyWith(fontSize: 26));

  /// FontSize: 28
  static final large28 = TextStyleSet(baseFont.copyWith(fontSize: 28));

  /// FontSize: 30
  static final large30 = TextStyleSet(baseFont.copyWith(fontSize: 30));

  /// FontSize: 32
  static final large32 = TextStyleSet(baseFont.copyWith(fontSize: 32));

  /// FontSize: 32
  static final large34 = TextStyleSet(baseFont.copyWith(fontSize: 34));

  /// FontSize: 36
  static final large36 = TextStyleSet(baseFont.copyWith(fontSize: 36));
}

extension TextStyling on TextStyle {
  TextStyle get poppins => AppFonts.poppins.merge(this);
  TextStyle get roboto => AppFonts.roboto.merge(this);
  TextStyle get inter => AppFonts.inter.merge(this);
  TextStyle get montserrat => AppFonts.montserrat.merge(this);

  //----------------------------------------------------------------------------
  // Font Color Customizations
  //----------------------------------------------------------------------------
  /// FontColor: whiteColor
  TextStyle get white => copyWith(color: AppColors.whiteColor);
  TextStyle get msuGreen => copyWith(color: AppColors.msuGreen);
  TextStyle get etonBlue => copyWith(color: AppColors.etonBlue);
  TextStyle get chineseBlack => copyWith(color: AppColors.chineseBlack);
  TextStyle get jakarta => copyWith(color: AppColors.jakarta);
  TextStyle get milkColor => copyWith(color: AppColors.milkColor);
  TextStyle get greenCyan => copyWith(color: AppColors.greenCyan);
  TextStyle get darkElectricBlue => copyWith(color: AppColors.darkElectricBlue);
  TextStyle get metallicSilver => copyWith(color: AppColors.metallicSilver);
  TextStyle get ghostWhite => copyWith(color: AppColors.ghostWhite);
  TextStyle get darkCharcoal => copyWith(color:  AppColors.darkCharcoal);

  /// FontColor: whiteColorColor with 0.2 opacity
  TextStyle get whiteColorOp2 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.2));

  /// FontColor: whiteColor with 0.3 opacity
  TextStyle get whiteColorOp3 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.3));

  /// FontColor: whiteColor with 0.4 opacity
  TextStyle get whiteColorOp4 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.4));

  /// FontColor: whiteColor with 0.4 opacity
  TextStyle get whiteColorOp5 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.5));

  /// FontColor: whiteColor with 0.6 opacity
  TextStyle get whiteColorOp6 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.6));

  /// FontColor: whiteColor with 0.7 opacity
  TextStyle get whiteColorOp7 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.7));

  /// FontColor: whiteColor with 0.8 opacity
  TextStyle get whiteColorOp8 =>
      copyWith(color: AppColors.whiteColor.withValues(alpha: 0.8));

  /// FontColor: Grey
  TextStyle get greyColor => copyWith(color: AppColors.greyColor);
  
  // Safety & Compliance Colors
  TextStyle get safetyOrange => copyWith(color: AppColors.safetyOrange);
  TextStyle get safetyRed => copyWith(color: AppColors.safetyRed);
  TextStyle get safetyBlue => copyWith(color: AppColors.safetyBlue);
  TextStyle get safetyGreen => copyWith(color: AppColors.safetyGreen);
  TextStyle get safetyYellow => copyWith(color: AppColors.safetyYellow);
  TextStyle get safetyLightRed => copyWith(color: AppColors.safetyLightRed);
  TextStyle get safetyLightGreen => copyWith(color: AppColors.safetyLightGreen);
  TextStyle get safetyLightBlue => copyWith(color: AppColors.safetyLightBlue);
  TextStyle get safetyLightOrange => copyWith(color: AppColors.safetyLightOrange);
  TextStyle get safetyDarkRed => copyWith(color: AppColors.safetyDarkRed);
  TextStyle get safetyDarkBlue => copyWith(color: AppColors.safetyDarkBlue);
  TextStyle get safetyDarkGreen => copyWith(color: AppColors.safetyDarkGreen);
  TextStyle get safetyGrey => copyWith(color: AppColors.safetyGrey);
  TextStyle get safetyLightGrey => copyWith(color: AppColors.safetyLightGrey);

  /// FontColor: Grey
  TextStyle get greySearched => copyWith(color: AppColors.greyColor);

  /// FontColor: Red
  TextStyle get red => copyWith(color: AppColors.crayolaRed);

  /// FontColor: Red Error
  TextStyle get redError => copyWith(color: AppColors.pigmentRed);

  /// FontColor: Black
  TextStyle get black => copyWith(color: AppColors.blackColor);

  /// FontColor: Dark Black
  TextStyle get darkBlack => copyWith(color: Colors.black);

  /// FontColor: hintTextColor
  TextStyle get hintTextColor => copyWith(color: AppColors.greyColor);

  /// FontColor: toastTextColor
  // TextStyle get toastTextColor => copyWith(color: AppColors.toastTextColor);

  /// FontColor: Dark Black
  // TextStyle get mediumGrey => copyWith(color: AppColors.mediumGrey);

  /// FontColor: DarkGrey2
  // TextStyle get darkGrey2 => copyWith(color: AppColors.darkGrey2);

  /// Custom
  TextStyle colored(Color color) => copyWith(color: color);
  TextStyle opacity(double opacity) =>
      copyWith(color: color?.withValues(alpha: opacity));
  //----------------------------------------------------------------------------
  // Other Font Customizations
  //----------------------------------------------------------------------------
  /// FontHeight: 1.25
  TextStyle get mediumHigh => copyWith(height: 1.25);

  /// FontHeight: 1.5
  TextStyle get high => copyWith(height: 1.5);

  /// FontDecoration: Underlined
  TextStyle get underlined => copyWith(
    decoration: TextDecoration.underline,
    decorationColor: color,
    decorationThickness: 1.5,
  );

  // FontWeight: w400 (normal weight)
  TextStyle get normal => copyWith(fontWeight: FontWeight.w400);

  // FontWeight: w500 (medium weight)
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  // FontWeight: w600 (semi-bold weight)
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// FontWeight: w700
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  //----------------------------------------------------------------------------
}

class TextStyleSet {
  TextStyleSet(this.original);

  final TextStyle original;

  /// FontWeight: w100
  TextStyle get superLight => original.copyWith(fontWeight: FontWeight.w100);

  TextStyle get extraLight => original.copyWith(fontWeight: FontWeight.w200);

  /// FontWeight: w300
  TextStyle get light => original.copyWith(fontWeight: FontWeight.w300);

  /// FontWeight: w400
  TextStyle get normal => original;

  /// FontWeight: w400
  TextStyle get regular => original.copyWith(fontWeight: FontWeight.w400);

  /// FontWeight: w500
  TextStyle get medium => original.copyWith(fontWeight: FontWeight.w500);

  /// FontWeight: w600
  TextStyle get semiBold => original.copyWith(fontWeight: FontWeight.w600);

  /// FontWeight: w700
  TextStyle get bold => original.copyWith(fontWeight: FontWeight.w700);

  /// FontWeight: w800
  TextStyle get extraBold => original.copyWith(fontWeight: FontWeight.w800);
}
