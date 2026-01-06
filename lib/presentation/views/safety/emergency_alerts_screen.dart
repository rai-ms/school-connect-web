import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/presentation/widgets/gradient/glassy_background.dart';
import '../../../core/utils/app_style.dart';
import '../../../core/utils/app_colors.dart';

class EmergencyAlertsScreen extends StatefulWidget {
  const EmergencyAlertsScreen({super.key});

  @override
  State<EmergencyAlertsScreen> createState() => _EmergencyAlertsScreenState();
}

class _EmergencyAlertsScreenState extends State<EmergencyAlertsScreen>
    with TickerProviderStateMixin {
  bool _isTriggering = false;
  bool _alertTriggered = false;
  late AnimationController _pulseController;
  late AnimationController _shakeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _shakeAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );

    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void _triggerEmergencyAlert() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red.shade50,
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red.shade700, size: 32),
              const SizedBox(width: 8),
              Text(
                'Emergency Alert',
                style: TextStyle(
                  color: Colors.red.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to trigger an emergency alert?\n\n'
            'This will immediately notify school administration and emergency contacts.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('TRIGGER ALERT'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      setState(() {
        _isTriggering = true;
      });

      _shakeController.forward();

      // TODO: Implement API call to trigger emergency alert
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isTriggering = false;
          _alertTriggered = true;
        });

        _showSuccessDialog();
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green.shade50,
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
              const SizedBox(width: 8),
              Text(
                'Alert Sent',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Text(
            'Emergency alert has been successfully triggered.\n\n'
            'School administration and emergency contacts have been notified.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.pop();
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alerts'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Emergency Instructions
              GlassyBackground(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emergency,
                        size: 48,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Emergency Alert System',
                        style: AppStyles.large.bold.white,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Use this button only in case of genuine emergencies that require immediate attention.',
                        style: AppStyles.medium.regular.white,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // SOS Button
              Expanded(
                child: Center(
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: AnimatedBuilder(
                          animation: _shakeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(_shakeAnimation.value, 0),
                              child: GestureDetector(
                                onTap: _isTriggering
                                    ? null
                                    : _triggerEmergencyAlert,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _isTriggering
                                        ? AppColors.safetyOrange
                                        : AppColors.safetyRed,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _isTriggering
                                              ? Icons.hourglass_empty
                                              : Icons.emergency,
                                          size: 64,
                                          color: AppColors.whiteColor,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          _isTriggering ? 'SENDING...' : 'SOS',
                                          style: AppStyles.large.bold.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Emergency Contacts
              GlassyBackground(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Contacts',
                        style: AppStyles.medium.bold.white,
                      ),
                      const SizedBox(height: 12),
                      _EmergencyContact(
                        icon: Icons.phone,
                        title: 'School Security',
                        number: '+1 (555) 123-4567',
                      ),
                      const SizedBox(height: 8),
                      _EmergencyContact(
                        icon: Icons.local_police,
                        title: 'Local Police',
                        number: '911',
                      ),
                      const SizedBox(height: 8),
                      _EmergencyContact(
                        icon: Icons.medical_services,
                        title: 'Medical Emergency',
                        number: '911',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmergencyContact extends StatelessWidget {
  const _EmergencyContact({
    required this.icon,
    required this.title,
    required this.number,
  });

  final IconData icon;
  final String title;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.whiteColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.small.bold.white),
              Text(
                number,
                style: AppStyles.small.regular.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement call functionality
          },
          icon: const Icon(Icons.call, color: AppColors.whiteColor),
        ),
      ],
    );
  }
}
