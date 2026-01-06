part of '../controller/intro_controller.dart';

class _IntroWidgetView
    extends WidgetView<IntroController, _IntroControllerState> {
  const _IntroWidgetView(super.ctr) : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.animatedBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Space.w * 0.075),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("LET’S GET STARTED",
                style: AppStyles.large36.bold.copyWith(
                fontSize: 64, color: AppColors.darkCharcoal),
              ),
              AnimatedTypingText(
                texts: ["The best is yet to come..."],
                animationDuration: Duration(seconds: 4),
                textStyle: AppStyles.large24.bold.copyWith(
                  color: AppColors.darkCharcoal
                ),
                repeat: false,
              ),
              Space.h16,
              Center(
                child: CommonButton(
                  onTap: (){
                    context.read<SplashBloc>().add(const IntroCompleted());
                    context.goNamed(RoutesName.loginScreen);
                  },
                  color: AppColors.charcoal,
                  label: "Join Now",
                  borderRadius: 30,
                ),
              ),
              Space.h16,
            ],
          ),
        ),
      ),
    );
  }
}
