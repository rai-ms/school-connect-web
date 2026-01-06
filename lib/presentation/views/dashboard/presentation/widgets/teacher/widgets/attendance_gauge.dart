
import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_global.dart';
import 'package:student_management/presentation/views/dashboard/presentation/manager/profile_management_bloc/profile_management_bloc.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/animations/measurment/gauge_painter.dart';

class AttendanceGauge extends StatelessWidget {
  const AttendanceGauge({
    super.key,
    required this.present,
    required this.total,
    this.size = 150,
    this.strokeWidth = 10,
    this.backgroundColor,
    this.label = "Attendance",
    required this.profileState,
  });

  final ProfileManageState profileState;
  final int present;
  final int total;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final String? label;

  double get _ratio => total == 0 ? 0 : (present / total).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? Colors.white.withValues(alpha: 0.2);
    var state = profileState;
    final profile = state.profile;
    final role = state.role?.name.toUpperCase() ?? '';
    final double percentage = _ratio * 100;
    final Color attendanceColor = _getAttendanceColor(percentage);

    return GlassyBackground(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassyBackground(
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Text(role, style: AppStyles.extraSmall.bold.white),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: L?.welcomeBack ?? '',
                        style: AppStyles.large.bold.white,
                      ),
                      TextSpan(
                        text: "${profile?.firstName}",
                        style: AppStyles.large24.bold.white,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          SizedBox(
            width: size,
            height: size,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutCubic,
              tween: Tween<double>(begin: 0, end: _ratio),
              builder: (context, animatedRatio, _) {
                final String percentLabel = (animatedRatio * 100)
                    .toStringAsFixed(0);
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: Size(size, size),
                      painter: GaugePainter(
                        ratio: animatedRatio,
                        color: attendanceColor,
                        backgroundColor: bg,
                        strokeWidth: strokeWidth,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$percentLabel%',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '$present / $total',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.white70),
                        ),
                        if (label != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            label!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color get color => _getAttendanceColor(_ratio * 100);
}

Color _getAttendanceColor(double percentage) {
  if (percentage < 70) return Colors.red;
  if (percentage < 85) return Colors.orange;
  return Colors.green;
}


