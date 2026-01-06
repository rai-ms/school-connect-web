import 'package:flutter/material.dart';
import 'package:student_management/generated/l10n/s.dart';
import 'package:student_management/generated/l10n/s_en.dart';

// Localization extension on BuildContext
extension XLocalize on BuildContext {
  S get L => S.of(this) ?? SEn(); // Using English as fallback
}

extension TextStyleX on TextStyle? {
  TextStyle? get s12 => this?.copyWith(fontSize: 12);
  TextStyle? get s14 => this?.copyWith(fontSize: 14);
  TextStyle? get s16 => this?.copyWith(fontSize: 16);
  TextStyle? get s18 => this?.copyWith(fontSize: 18);
  TextStyle? get s20 => this?.copyWith(fontSize: 20);
  TextStyle? get s22 => this?.copyWith(fontSize: 22);
  TextStyle? get s24 => this?.copyWith(fontSize: 24);
  TextStyle? get s26 => this?.copyWith(fontSize: 26);
  TextStyle? get s28 => this?.copyWith(fontSize: 28);
  TextStyle? get s30 => this?.copyWith(fontSize: 30);
  TextStyle? get s32 => this?.copyWith(fontSize: 32);

  TextStyle? get w2 => this?.copyWith(fontWeight: FontWeight.w200);
  TextStyle? get w3 => this?.copyWith(fontWeight: FontWeight.w300);
  TextStyle? get w4 => this?.copyWith(fontWeight: FontWeight.w400);
  TextStyle? get w5 => this?.copyWith(fontWeight: FontWeight.w500);
  TextStyle? get w6 => this?.copyWith(fontWeight: FontWeight.w600);
  TextStyle? get w7 => this?.copyWith(fontWeight: FontWeight.w700);
}
