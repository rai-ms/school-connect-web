import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:student_management/core/services/api_service/api_dispatcher.dart';
import 'package:student_management/core/services/di/injector.dart';
import 'package:student_management/core/utils/api_end_point.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/core/utils/size_utils.dart';
import 'package:student_management/presentation/widgets/customs/toast.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _tokenController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _resetFormKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _showResetView = false;

  late final ApiDispatcher _apiDispatcher;

  @override
  void initState() {
    super.initState();
    _apiDispatcher = InjectorService.service.inject<ApiDispatcher>();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _tokenController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final response = await _apiDispatcher.call(
        type: RequestType.post,
        endPoint: ApiEndPoint.forgotPassword,
        body: {'email': _emailController.text.trim()},
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        context.snackBar(
          message: 'Reset link sent successfully. Check your email.',
          backgroundColor: AppColors.greenCyan,
        );
        setState(() => _showResetView = true);
      } else {
        final errorMsg =
            response.data?['message'] ?? 'Failed to send reset link';
        context.snackBar(message: errorMsg);
      }
    } catch (e) {
      if (!mounted) return;
      context.snackBar(message: 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!(_resetFormKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final response = await _apiDispatcher.call(
        type: RequestType.post,
        endPoint: ApiEndPoint.resetPassword,
        body: {
          'token': _tokenController.text.trim(),
          'newPassword': _newPasswordController.text,
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        context.snackBar(
          message: 'Password reset successfully.',
          backgroundColor: AppColors.greenCyan,
        );
        context.pop();
      } else {
        final errorMsg =
            response.data?['message'] ?? 'Failed to reset password';
        context.snackBar(message: errorMsg);
      }
    } catch (e) {
      if (!mounted) return;
      context.snackBar(message: 'Something went wrong. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.darkGunMetal,
        foregroundColor: AppColors.whiteColor,
        elevation: 0,
      ),
      backgroundColor: AppColors.ghostWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPadding.padSH20,
          child: _showResetView ? _buildResetView() : _buildEmailView(),
        ),
      ),
    );
  }

  Widget _buildEmailView() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Space.h30,
          Text(
            'Enter your email address and we will send you a reset link.',
            style: AppStyles.regular.regular.darkCharcoal,
            textAlign: TextAlign.center,
          ),
          Space.h24,
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: AppStyles.medium.normal.darkCharcoal,
            decoration: InputDecoration(
              hintText: 'Email address',
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
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value.trim())) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          Space.h20,
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _sendResetLink,
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
                      'Send Reset Link',
                      style: AppStyles.medium.semiBold.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetView() {
    return Form(
      key: _resetFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Space.h30,
          Text(
            'Enter the reset token from your email and your new password.',
            style: AppStyles.regular.regular.darkCharcoal,
            textAlign: TextAlign.center,
          ),
          Space.h24,
          TextFormField(
            controller: _tokenController,
            style: AppStyles.medium.normal.darkCharcoal,
            decoration: InputDecoration(
              hintText: 'Reset Token',
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
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter the reset token';
              }
              return null;
            },
          ),
          Space.h12,
          TextFormField(
            controller: _newPasswordController,
            obscureText: true,
            style: AppStyles.medium.normal.darkCharcoal,
            decoration: InputDecoration(
              hintText: 'New Password',
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
            obscureText: true,
            style: AppStyles.medium.normal.darkCharcoal,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
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
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _newPasswordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          Space.h20,
          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _resetPassword,
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
                      'Reset Password',
                      style: AppStyles.medium.semiBold.white,
                    ),
            ),
          ),
          Space.h12,
          TextButton(
            onPressed: () => setState(() => _showResetView = false),
            child: Text(
              'Back to email',
              style: AppStyles.regular.regular.darkCharcoal.underlined,
            ),
          ),
        ],
      ),
    );
  }
}
