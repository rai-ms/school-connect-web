import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_style.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  
  const SectionTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppStyles.large.regular.white,
    );
  }
}
