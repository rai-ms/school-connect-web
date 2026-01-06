part of '../add_school_super_admin_controller.dart';

mixin _AddSchoolSuperAdmin<T extends StatefulWidget> on State<T> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _schoolNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _cityController;
  late final TextEditingController _stateController;
  late final TextEditingController _countryController;
  late final TextEditingController _postalCodeController;
  late final TextEditingController _subdomainController;
  late final TextEditingController _subscriptionPlanController;
  late final TextEditingController _websiteController;
  late final TextEditingController _adminFirstNameController;
  late final TextEditingController _adminLastNameController;
  late final TextEditingController _adminEmailController;
  late final TextEditingController _adminPhoneController;
  late final TextEditingController _adminUsernameController;
  late final TextEditingController _adminPasswordController;

  @override
  void initState() {
    _schoolNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _countryController = TextEditingController();
    _postalCodeController = TextEditingController();
    _subdomainController = TextEditingController();
    _subscriptionPlanController = TextEditingController();
    _websiteController = TextEditingController();
    _adminFirstNameController = TextEditingController();
    _adminLastNameController = TextEditingController();
    _adminEmailController = TextEditingController();
    _adminPhoneController = TextEditingController();
    _adminUsernameController = TextEditingController();
    _adminPasswordController = TextEditingController();
    super.initState();
  }

  String get _backGroundImage {
    switch (InjectorService.service
        .inject<ThemeService>()
        .themeListener
        .value) {
      case AppTheme.system:
        return AppAssets.animatedBackground;
      case AppTheme.dark:
        return AppAssets.animatedBackground;
      case AppTheme.light:
        return AppAssets.animatedBackground;
    }
  }

  @override
  void dispose() {
    _schoolNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _postalCodeController.dispose();
    _subdomainController.dispose();
    _subscriptionPlanController.dispose();
    _websiteController.dispose();
    _adminFirstNameController.dispose();
    _adminLastNameController.dispose();
    _adminEmailController.dispose();
    _adminPhoneController.dispose();
    _adminUsernameController.dispose();
    _adminPasswordController.dispose();
    super.dispose();
  }

  void _addSchool() {
    if (_formKey.currentState?.validate() ?? false) {
      final adminUser = AdminUser(
        email: _adminEmailController.text.trim(),
        firstName: _adminFirstNameController.text.trim(),
        lastName: _adminLastNameController.text.trim(),
        password: _adminPasswordController.text,
        userId: DateTime.now().millisecondsSinceEpoch.toString(),
        username: _adminUsernameController.text.trim(),
        phone: _adminPhoneController.text.trim(),
      );

      final request = AddSchoolRequest(
        name: _schoolNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        city: _cityController.text.trim(),
        state: _stateController.text.trim(),
        country: _countryController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        subdomain: _subdomainController.text.trim().toLowerCase(),
        subscriptionPlan: _subscriptionPlanController.text,
        website: _websiteController.text.trim().isNotEmpty
            ? _websiteController.text.trim()
            : null,
        adminUser: adminUser,
      );
      context.read<AddSchoolBloc>().add(AddNewSchool(request));
    }
  }
}
