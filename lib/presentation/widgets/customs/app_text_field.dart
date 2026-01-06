import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_management/core/utils/app_colors.dart';
import 'package:student_management/core/utils/app_dimension.dart';
import 'package:student_management/core/utils/app_style.dart';
import 'package:student_management/presentation/widgets/customs/silver_validation/silver_validation.dart';

class AppTextField extends StatelessWidget {
  final String hintText;
  final AutovalidateMode? autoValidateMode;
  final String? label;
  final Widget? prefixWidget;
  final Function(String)? onChange;
  final Function()? onTap;
  final void Function()? onEditingComplete;
  final ValidatedController controller;
  final Widget? suffixWidget;
  final TextInputAction inputAction;
  final TextCapitalization textCapitalization;
  final String? errorMessage;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final bool hideErrorOnFirstChar;
  final int? countLength;
  final int? maxLines;
  final bool showLabel;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;
  final bool enableHapticFeedback;
  final Color fieldColor;
  final Color? cursorColor;
  final bool autoFocus;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final bool hideAllBorders;
  final bool hideErrorOnFocus;
  final bool isExistLoading;
  final bool readOnly;
  final bool isCollapsed;
  final bool? enabled;
  final bool autocorrect;
  final BoxConstraints? suffixIconConstraints;
  final bool obscureText;
  final Color? enableBorderColor;
  final Color? disableBorderColor;
  final double? disableBorderRadius;
  final double? enableBorderRadius;

  const AppTextField({
    super.key,
    this.label,
    this.autoValidateMode,
    this.enableBorderColor,
    this.enableBorderRadius,
    this.disableBorderRadius,
    this.disableBorderColor,
    required this.hintText,
    this.labelTextStyle,
    required this.controller,
    this.onChange,
    this.onEditingComplete,
    this.suffixWidget,
    this.prefixWidget,
    this.cursorColor,
    this.inputAction = TextInputAction.done,
    this.errorMessage,
    this.inputFormatters,
    this.keyboardType,
    this.onTap,
    this.hideErrorOnFirstChar = false,
    this.countLength,
    this.maxLines,
    this.showLabel = true,
    this.textCapitalization = TextCapitalization.none,
    this.textStyle,
    this.contentPadding,
    this.enableHapticFeedback = true,
    this.fieldColor = AppColors.transparent,
    this.autoFocus = false,
    this.hintTextStyle,
    this.hideAllBorders = false,
    this.hideErrorOnFocus = true,
    this.isExistLoading = false,
    this.readOnly = false,
    this.isCollapsed = false,
    this.enabled,
    this.autocorrect = true,
    this.suffixIconConstraints,
    this.initialValue,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    ValueNotifier<bool> obscureListener = ValueNotifier<bool>(true);
    return ValidationBuilder(
      controller: controller,
      builder: (context, error) {
        final valid =
            ((errorMessage == null) &&
            (error.isCorrect) &&
            (controller.text.isNotEmpty));
        return AnimatedBuilder(
          animation: controller.focusNode,
          builder: (context, _) {
            return AnimatedBuilder(
              animation: controller.controller,
              builder: (context, _) {
                bool hasFocus = controller.focusNode.hasFocus;
                var labelStyle =
                    labelTextStyle ?? AppStyles.regular.normal.black;
                var hintStyle = hintTextStyle ?? AppStyles.baseStyle.greyColor;
                return ValueListenableBuilder(
                  valueListenable: obscureListener,
                  builder: (context, isObscure, child) {
                    return TextFormField(
                      onTap: () {
                        if (enableHapticFeedback) {
                          HapticFeedback.vibrate();
                        }
                        onTap?.call();
                      },
                      initialValue: initialValue,
                      autocorrect: autocorrect,
                      autofocus: autoFocus,
                      autovalidateMode: autoValidateMode,
                      maxLines: maxLines,
                      cursorColor: cursorColor,
                      maxLength: countLength,
                      onTapOutside: (event) => controller.focusNode.unfocus(),
                      buildCounter:
                          (
                            BuildContext context, {
                            required int currentLength,
                            required int? maxLength,
                            required bool isFocused,
                          }) {
                            return countLength == null
                                ? null
                                : Transform(
                                    transform: Matrix4.translationValues(
                                      10,
                                      -30,
                                      0,
                                    ),
                                    child: Text(
                                      ' $currentLength/$maxLength ',
                                      style: AppStyles
                                          .semiSmall
                                          .bold
                                          .hintTextColor,
                                    ),
                                  );
                          },
                      readOnly: readOnly,
                      enabled: enabled,
                      obscureText: (obscureText)
                          ? obscureListener.value
                          : false,
                      inputFormatters: inputFormatters,
                      controller: controller.controller,
                      onEditingComplete: onEditingComplete,
                      style: textStyle ?? AppStyles.regular.normal.white,
                      keyboardType: keyboardType,
                      onChanged: (value) {
                        if (enableHapticFeedback) {
                          HapticFeedback.vibrate();
                        }
                        onChange?.call(value);
                      },
                      focusNode: controller.focusNode,
                      textInputAction: inputAction,
                      textCapitalization: textCapitalization,
                      decoration: InputDecoration(
                        hintText: hintText,
                        label: (controller.text.isEmpty && !hasFocus)
                            ? null
                            : showLabel
                            ? Text(label ?? hintText)
                            : null,
                        prefixIcon: prefixWidget,
                        suffixIconConstraints: suffixIconConstraints,
                        suffixIcon: obscureText
                            ? GestureDetector(
                                onTap: () => obscureListener.value =
                                    !obscureListener.value,
                                child: SizedBox(
                                  height: 10.responsive,
                                  width: 10.responsive,
                                  child: Center(
                                    child: isObscure
                                        ? const Icon(
                                            Icons.visibility_off_outlined,
                                            color: AppColors.chineseBlack,
                                          )
                                        : const Icon(
                                            Icons.visibility_outlined,
                                            color: AppColors.chineseBlack,
                                          ),
                                  ),
                                ),
                              )
                            : suffixWidget,
                        isCollapsed: isCollapsed,
                        contentPadding:
                            contentPadding ??
                            KEdgeInsets.kTop18Left12Right10Bottom18,
                        counterStyle: AppStyles.small.light.greyColor,
                        labelStyle:
                            !valid &&
                                (hideErrorOnFirstChar
                                    ? controller.text.length > 1
                                    : controller.text.isNotEmpty)
                            ? ((hasFocus && hideErrorOnFocus)
                                  ? labelStyle
                                  : labelStyle.redError)
                            : hasFocus
                            ? labelStyle
                            : hintStyle,
                        filled: true,
                        fillColor: fieldColor,
                        errorStyle: AppStyles.extraSmall.normal.redError,
                        // errorText: hasFocus && hideErrorOnFocus ? null : errorMessage ?? (error.errorString == null? null: "*${error.errorString}"),
                        // errorText: hasFocus && hideErrorOnFocus
                        //     ? null
                        //     : (error.errorString != null &&
                        //             (hideErrorOnFirstChar
                        //                 ? controller.text.length > 1
                        //                 : controller.text.isNotEmpty))
                        //         ? '*${error.errorString}'
                        //         : errorMessage != null
                        //             ? '*$errorMessage'
                        //             : null,
                        hintStyle: hintStyle,
                        error: hasFocus && hideErrorOnFocus
                            ? null
                            : (error.errorString != null &&
                                  (hideErrorOnFirstChar
                                      ? controller.text.length > 1
                                      : controller.text.isNotEmpty))
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '*${error.errorString}',
                                      style:
                                          AppStyles.small.normal.redError.inter,
                                    ),
                                  ),
                                ],
                              )
                            : errorMessage != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      '*$errorMessage',
                                      style:
                                          AppStyles.small.normal.redError.inter,
                                    ),
                                  ),
                                ],
                              )
                            : null,
                        errorMaxLines: 3,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: disableBorderRadius != null
                              ? KBorderRadius.dynamic(disableBorderRadius!)
                              : KBorderRadius.kAll14,
                          borderSide: BorderSide(
                            color: disableBorderColor ?? AppColors.gainsboro,
                          ),
                        ),
                        border: hideAllBorders
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderRadius: enableBorderRadius != null
                                    ? KBorderRadius.dynamic(enableBorderRadius!)
                                    : KBorderRadius.kAll14,
                                borderSide: BorderSide(
                                  color: enableBorderColor ?? Colors.grey,
                                ),
                              ),
                        errorBorder: hideAllBorders
                            ? InputBorder.none
                            : hasFocus && hideErrorOnFocus
                            ? null
                            : OutlineInputBorder(
                                borderRadius: enableBorderRadius != null
                                    ? KBorderRadius.dynamic(enableBorderRadius!)
                                    : KBorderRadius.kAll14,
                                borderSide: const BorderSide(
                                  color: AppColors.kuCrimson,
                                ),
                              ),
                        enabledBorder: hideAllBorders
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderRadius: enableBorderRadius != null
                                    ? KBorderRadius.dynamic(enableBorderRadius!)
                                    : KBorderRadius.kAll14,
                                borderSide: BorderSide(
                                  color:
                                      enableBorderColor ?? AppColors.greyColor,
                                ),
                              ),
                        focusedBorder: hideAllBorders
                            ? InputBorder.none
                            : OutlineInputBorder(
                                borderRadius: enableBorderRadius != null
                                    ? KBorderRadius.dynamic(enableBorderRadius!)
                                    : KBorderRadius.kAll14,
                                borderSide: BorderSide(
                                  color:
                                      enableBorderColor ?? AppColors.greyColor,
                                ),
                              ),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
