part of '../controller/add_school_super_admin_controller.dart';

class _AddSchoolSuperAdminWidgetView
    extends
        WidgetView<
          _AddSchoolSuperAdminWidgetView,
          _AddSchoolSuperAdminControllerState
        > {
  const _AddSchoolSuperAdminWidgetView(super.ctr);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(ctr._backGroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocConsumer<AddSchoolBloc, AddSchoolState>(
          listener: (context, AddSchoolState addSchoolState) {},
          builder: (context, AddSchoolState addSchoolState) {
            return RotatingDotsLoader(
              isLoading: addSchoolState.isLoading,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: ctr._formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Space.safeTop,
                      InkWell(
                        onTap: context.pop,
                        child: SizedBox(
                          height: 40,
                          width: 40,
                          child: GlassyBackground(
                            borderColor: AppColors.blackColor,
                            padding: AppPadding.z,
                            child: Icon(
                              Icons.arrow_back_ios,
                              size: 15,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),

                      Space.h16,

                      _buildSection('School Information'),
                      const SizedBox(height: 16),
                      _buildSchoolInfoSection(),
                      const SizedBox(height: 24),
                      _buildSection('School Address'),
                      const SizedBox(height: 16),
                      _buildAddressSection(),
                      const SizedBox(height: 24),
                      _buildSection('Admin User Details'),
                      const SizedBox(height: 16),
                      _buildAdminUserSection(),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSection(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey,
      ),
    );
  }

  Widget _buildSchoolInfoSection() {
    return Column(
      children: [
        TextFormField(
          controller: ctr._schoolNameController,
          decoration: const InputDecoration(
            labelText: 'School Name *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter school name';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ctr._emailController,
          decoration: const InputDecoration(
            labelText: 'Email *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ctr._phoneController,
          decoration: const InputDecoration(
            labelText: 'Phone *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAddressSection() {
    return Column(
      children: [
        TextFormField(
          controller: ctr._addressController,
          decoration: const InputDecoration(
            labelText: 'Address *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter address';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctr._cityController,
                decoration: const InputDecoration(
                  labelText: 'City *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter city';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: ctr._stateController,
                decoration: const InputDecoration(
                  labelText: 'State/Province *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter state';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctr._countryController,
                decoration: const InputDecoration(
                  labelText: 'Country *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter country';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: ctr._postalCodeController,
                decoration: const InputDecoration(
                  labelText: 'Postal Code *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter postal code';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdminUserSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: ctr._adminFirstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: ctr._adminLastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name *',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ctr._adminEmailController,
          decoration: const InputDecoration(
            labelText: 'Admin Email *',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter admin email';
            }
            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ctr._adminUsernameController,
          decoration: const InputDecoration(
            labelText: 'Username *',
            border: OutlineInputBorder(),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter username';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: ctr._adminPasswordController,
          decoration: const InputDecoration(
            labelText: 'Password *',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter password';
            }
            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (ctr._formKey.currentState?.validate() ?? false) {
            ctr._addSchool();
          }
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text('Add School', style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
