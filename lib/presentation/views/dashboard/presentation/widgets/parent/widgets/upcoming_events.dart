import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import '../../../../../../../core/utils/app_style.dart';
import '../../../../../../widgets/gradient/glassy_background.dart';

class UpcomingEvents extends StatelessWidget {
  const UpcomingEvents({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> events = [
      {
        'title': 'Parent-Teacher Meeting',
        'date': 'Tomorrow, 10:00 AM',
        'color': Colors.blue,
        'icon': Icons.people,
      },
      {
        'title': 'Science Fair',
        'date': 'Friday, 2:00 PM',
        'color': Colors.green,
        'icon': Icons.science,
      },
      {
        'title': 'School Picnic',
        'date': 'Next Monday, 9:00 AM',
        'color': Colors.orange,
        'icon': Icons.celebration,
      },
    ];

    return GlassyBackground(
      child: Column(
        children: [
          for (var event in events) ...[
            _buildEventItem(
              event['title'],
              event['date'],
              event['color'],
              event['icon'],
            ),
            if (event != events.last) Container(
              height: 2,
              color: AppColors.greyColor,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEventItem(
      String title, String date, Color color, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppStyles.large.medium.greyColor,
                ),
                const SizedBox(height: 2),
                Text(
                  date,
                  style: AppStyles.semiMedium.medium.greyColor,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white70, size: 20),
            onPressed: () {
              // Handle notification
            },
          ),
        ],
      ),
    );
  }
}
