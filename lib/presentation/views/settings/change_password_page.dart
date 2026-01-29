import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/api_end_point.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  late final ApiDispatcher _apiDispatcher;

  @override
  void initState() {
    super.initState();
    _apiDispatcher = InjectorService.service.inject<ApiDispatcher>();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final response = await _apiDispatcher.call(
        type: RequestType.post,
        endPoint: ApiEndPoint.changePassword,
        body: {
          'currentPassword': _currentPasswordController.text,
          'newPassword': _newPasswordController.text,
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        context.snackBar(
          message: 'Password changed successfully.',
          backgroundColor: AppColors.greenCyan,
        );
        context.pop();
      } else {
        final errorMsg =
            response.data?['message'] ?? 'Failed to change password';
        context.snackBar(message: errorMsg);
      }
    } catch (e) {
      if (!mounted) return;
      context.snackBar(message: 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  InputDecoration _passwordDecoration({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppStyles.medium.normal.greyColor,
      filled: true,
      fillColor: AppColors.whiteColor,
      border: OutlineInputBorder(
        borderRadius: CircularBorderRadius.b15,
        borderSide: const BorderSide(color: AppColors.gainsboro),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: CircularBorderRadius.b15,
        borderSide: const BorderSide(color: AppColors.gainsboro),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: CircularBorderRadius.b15,
        borderSide: const BorderSide(color: AppColors.darkCharcoal),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: AppColors.chineseBlack,
        ),
        onPressed: onToggle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: AppColors.darkGunMetal,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.ghostWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.padSH20,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Space.h30,
                Text(
                  'Enter your current password and choose a new password.',
                  style: AppStyles.regular.regular.darkCharcoal,
                  textAlign: TextAlign.center,
                ),
                Space.h24,
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: _obscureCurrent,
                  style: AppStyles.medium.normal.darkCharcoal,
                  decoration: _passwordDecoration(
                    hint: 'Current Password',
                    obscure: _obscureCurrent,
                    onToggle: () =>
                        setState(() => _obscureCurrent = !_obscureCurrent),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                Space.h12,
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: _obscureNew,
                  style: AppStyles.medium.normal.darkCharcoal,
                  decoration: _passwordDecoration(
                    hint: 'New Password',
                    obscure: _obscureNew,
                    onToggle: () =>
                        setState(() => _obscureNew = !_obscureNew),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                Space.h12,
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirm,
                  style: AppStyles.medium.normal.darkCharcoal,
                  decoration: _passwordDecoration(
                    hint: 'Confirm New Password',
                    obscure: _obscureConfirm,
                    onToggle: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _newPasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                Space.h24,
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkCharcoal,
                      foregroundColor: AppColors.whiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: CircularBorderRadius.b15,
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.whiteColor,
                          )
                        : Text(
                            'Change Password',
                            style: AppStyles.medium.semiBold.white,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
