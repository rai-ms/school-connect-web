part of '../controller/login_controller.dart';

class _LoginWidgetView
    extends WidgetView<LoginController, _LoginControllerState> {
  const _LoginWidgetView(super.ctr) : super();


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
        child: Center(
          child: Container(
            width: double.infinity,
            padding: AppPadding.padSV10H20,
            margin: AppPadding.padSV25H30,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: CircularBorderRadius.b15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GradientText(text: "Get Started now"),
                Space.h10,
                Text("Enter your username and password to login",
                  style: AppStyles.regular.normal.darkCharcoal,
                  textAlign: TextAlign.center,
                ),
                Space.h20,

                AppTextField(
                  hintText: "Username",
                  controller: ctr._userNameController,
                  inputFormatters: [
                    AppInputFormatter.instance.baseInputFormatter
                  ],
                  cursorColor: AppColors.darkCharcoal,
                  textStyle: AppStyles.medium.normal.darkCharcoal.copyWith(
                    fontSize: 16,
                  ),
                ),
                Space.h8,
                AppTextField(
                  hintText: "Password",
                  controller: ctr._passwordController,
                  inputFormatters: [
                    AppInputFormatter.instance.baseInputFormatter
                  ],
                  cursorColor: AppColors.darkCharcoal,
                  textStyle: AppStyles.medium.normal.darkCharcoal.copyWith(
                    fontSize: 16,
                  ),
                ),
                Space.h20,
                BlocConsumer<LoginBloc, LoginState>(
                  listener: ctr._loginListner,
                  builder: (context, LoginState loginState) {
                    return ValidatedBuilder(
                      validations: [ctr._userNameController, ctr._passwordController],
                      builder: (context, isValidated, validation,validators) {
                        return CommonButton(
                          color: AppColors.darkCharcoal,
                          label: "Login",
                          isLoading: loginState.isLoading,
                          onTap: () {
                            if (!(isValidated ?? true)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: AppColors.chineseBlack,
                                  behavior: SnackBarBehavior.floating,
                                  dismissDirection: DismissDirection.down,
                                  elevation: 20,
                                  hitTestBehavior: HitTestBehavior.opaque,
                                  showCloseIcon: true,
                                  content: Text("NOT VALIDATED")
                                ),
                              );
                              return;
                            }
                            context.login(
                              loginEvent: LogLoginEvent(
                                username: ctr._userNameController.text,
                                lat: "",
                                long: "",
                                timeStamp: DateTime.now().toUtc().toIso8601String()
                              )
                            );
                            context.read<LoginBloc>().add(
                                LoginButtonPressed(
                                  email: ctr._userNameController.text,
                                  password: ctr._passwordController.text,
                                  rememberMe: true
                                )
                            );

                          },
                        );
                      }
                    );
                  },
                ),
                Space.h20,

              ],
            ),
          ),
        ),
      ),
    );
  }
}
