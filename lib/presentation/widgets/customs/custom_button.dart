import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_dimension.dart';
import 'package:student_management/core/utils/app_style.dart';

class CommonButton extends StatefulWidget {
  final Color color;
  final Color? buttonHoverColor;
  final Color? textHoverColor;
  final Color? textColor;
  final String label;
  final void Function() onTap;
  final double? width;
  final double? height;
  final Color? borderColor;
  final double borderRadius;
  final bool isLoading;
  final TextStyle? style;

  const CommonButton({
    required this.color,
    this.textHoverColor = AppColors.msuGreen,
    required this.label,
    required this.onTap,
    this.borderColor,
    this.width,
    this.isLoading = false,
    this.height = 54,
    super.key,
    this.borderRadius = 14,
    this.buttonHoverColor,
    this.textColor = AppColors.whiteColor,
    this.style,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (bool onHover) {
        if (widget.buttonHoverColor == null) return;
        setState(() {
          hover = onHover;
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          border: Border.all(
            color:
                widget.borderColor ??
                (hover
                    ? (widget.buttonHoverColor ?? widget.color)
                    : widget.color),
          ),
          color: hover
              ? (widget.buttonHoverColor ?? widget.color)
              : widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: Center(
          child: widget.isLoading
              ? const CircularProgressIndicator(color: AppColors.whiteColor)
              : Text(
                  widget.label,
                  style:
                      widget.style ??
                      AppStyles.larger.semiBold.copyWith(
                        color: (hover
                            ? (widget.textHoverColor ?? widget.textColor)
                            : widget.textColor),
                      ),
                ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onPressed,
    required this.isActive,
    this.label = "",
    this.isLoading = false,
    this.enabledColor = AppColors.whiteColor,
    this.loaderColor = AppColors.blackColor,
    this.elevation,
    this.height,
    this.width,
    this.disabledColor = AppColors.greyColor,
    this.activeTxtStyle,
    this.inActiveTxtStyle,
    this.child,
    this.padding,
    this.borderSide = BorderSide.none,
    this.borderRadius = 14,
    this.isDense = false,
    this.enableHapticFeedback = false,
    this.loaderHeight = 25,
    this.loadingText,
    this.isButtonFitted = false,
  });

  final void Function()? onPressed;
  final bool isActive;
  final bool isLoading;
  final String label;
  final Color enabledColor;
  final Color loaderColor;
  final Color disabledColor;
  final double? elevation;
  final double? height;
  final TextStyle? activeTxtStyle;
  final TextStyle? inActiveTxtStyle;
  final Widget? child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final BorderSide borderSide;
  final double borderRadius;
  final bool isDense;
  final bool enableHapticFeedback;
  final double loaderHeight;
  final String? loadingText;
  final bool isButtonFitted;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: SizedBox(
        width: width?.responsive ?? (isDense ? null : double.infinity),
        height: (height ?? 54).responsive,
        child: TextButton(
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(
              AppColors.blackColor.withValues(alpha: 0.3),
            ),
            elevation: WidgetStateProperty.all<double?>(elevation),
            padding: WidgetStateProperty.all(
              padding ?? KEdgeInsets.kHorizontal20,
            ),
            backgroundColor: isActive
                ? WidgetStateProperty.all<Color>(enabledColor)
                : WidgetStateProperty.all<Color>(disabledColor),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: borderSide,
              ),
            ),
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: !isLoading && isActive
              ? () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  onPressed?.call();
                }
              : null,
          child: isLoading
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (loadingText != null) ...[
                      Text(
                        loadingText!,
                        style: activeTxtStyle ?? AppStyles.medium.bold.black,
                      ),
                      KSizedBox.w10,
                    ],
                    SizedBox(
                      height: loaderHeight,
                      child: FittedBox(
                        child: Center(
                          child: CupertinoActivityIndicator(
                            color: !isActive
                                ? AppColors.whiteColor
                                : AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : child ??
                    (isButtonFitted
                        ? FittedBox(
                            child: Text(
                              label,
                              overflow: TextOverflow.ellipsis,
                              style: (isActive
                                  ? activeTxtStyle ??
                                        AppStyles.medium.bold.black
                                  : inActiveTxtStyle ??
                                        AppStyles.medium.bold.greyColor),
                            ),
                          )
                        : Text(
                            label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: (isActive
                                ? activeTxtStyle ?? AppStyles.medium.bold.black
                                : inActiveTxtStyle ??
                                      AppStyles.medium.bold.greyColor),
                          )),
        ),
      ),
    );
  }
}
