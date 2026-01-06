import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:student_management/core/services/route_service/app_routing.dart'
    show RouteService;
import 'package:student_management/core/utils/app_dimension.dart';

// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
const double figmaDesignWidth = 440;
const double figmaDesignHeight = 812;
const num figmaDesignStatusBar = 0;

typedef ResponsiveBuild =
    Widget Function(
      BuildContext context,
      Orientation orientation,
      DeviceType deviceType,
    );

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  /// Builds the widget whenever the orientation changes.
  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            SizeUtils.setScreenSize(constraints, orientation);
            return builder(context, orientation, SizeUtils.deviceType);
          },
        );
      },
    );
  }
}

class SizeUtils {
  /// Device's BoxConstraints
  static late BoxConstraints boxConstraints;

  /// Device's Orientation
  static late Orientation orientation;

  /// Type of Device
  ///
  /// This can either be mobile or tablet
  static late DeviceType deviceType;

  /// Device's Height
  static late double height;

  /// Device's Width
  static late double width;

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    // Sets boxConstraints and orientation
    boxConstraints = constraints;
    orientation = currentOrientation;

    // Sets screen width and height
    if (orientation == Orientation.portrait) {
      width = boxConstraints.maxWidth.isNonZero(defaultValue: figmaDesignWidth);
      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width = boxConstraints.maxHeight.isNonZero(
        defaultValue: figmaDesignWidth,
      );
      height = boxConstraints.maxWidth.isNonZero();
    }
    deviceType = DeviceType.mobile;
  }
}

/// This extension is used to set padding/margin (for the top and bottom side) &
/// height of the screen or widget according to the Viewport height.
extension ResponsiveExtension on num {
  /// This method is used to get device viewport width.
  double get _width => SizeUtils.width;

  /// This method is used to get device viewport height.
  double get _height => SizeUtils.height;

  /// This method is used to set padding/margin (for the left and Right side) &
  /// width of the screen or widget according to the Viewport width.
  double get h => ((this * _width) / figmaDesignWidth);

  /// This method is used to set padding/margin (for the top and bottom side) &
  /// height of the screen or widget according to the Viewport height.
  double get v => (this * _height) / (figmaDesignHeight - figmaDesignStatusBar);

  /// This method is used to set smallest px in image height and width
  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  /// This method is used to set text font size according to Viewport
  double get fSize => adaptSize;
}

extension FormatExtension on double {
  /// Return a [double] value with formatted according to provided fractionDigits
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

enum DeviceType { mobile, tablet, desktop }

BuildContext get ctx => RouteService.navigatorKey.currentState!.context;
double deviceHeight = MediaQuery.of(ctx).size.height;
double deviceWidth = MediaQuery.of(ctx).size.width;

/// [Space] used to add space between the widgets
/// for Height used h and for width use w with size
abstract class Space {
  static double get h => MediaQuery.sizeOf(ctx).height;
  static double get w => MediaQuery.sizeOf(ctx).width;
  static double get padBottom => MediaQuery.of(ctx).viewPadding.bottom;
  static double get insetsBottom => MediaQuery.of(ctx).viewInsets.bottom;
  static double get insetsTop => MediaQuery.of(ctx).viewInsets.top;
  static double get padTop => MediaQuery.of(ctx).viewPadding.top;
  static SizedBox get safeTop => SizedBox(height: padBottom);
  static SizedBox get safeBottom => SizedBox(height: padBottom);
  static SizedBox resH(
    double height,
    BuildContext context, {
    double? defaultHeight,
  }) => SizedBox(height: h * (height / (defaultHeight ?? figmaDesignHeight)));
  static SizedBox resW(
    double width,
    BuildContext context, {
    double? defaultWidth,
  }) => SizedBox(width: w * (width / (defaultWidth ?? figmaDesignWidth)));
  static const SizedBox z = SizedBox.shrink();
  static const Spacer f = Spacer();
  static const SizedBox h3 = SizedBox(height: 3);
  static const SizedBox h4 = SizedBox(height: 4);
  static const SizedBox h5 = SizedBox(height: 5);
  static const SizedBox h6 = SizedBox(height: 6);
  static const SizedBox h8 = SizedBox(height: 8);
  static const SizedBox h10 = SizedBox(height: 10);
  static const SizedBox h12 = SizedBox(height: 12);
  static const SizedBox h15 = SizedBox(height: 15);
  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox h18 = SizedBox(height: 18);
  static const SizedBox h20 = SizedBox(height: 20);
  static const SizedBox h22 = SizedBox(height: 22);
  static const SizedBox h24 = SizedBox(height: 24);
  static const SizedBox h25 = SizedBox(height: 25);
  static const SizedBox h30 = SizedBox(height: 30);
  static const SizedBox h34 = SizedBox(height: 34);
  static const SizedBox h40 = SizedBox(height: 40);
  static const SizedBox h45 = SizedBox(height: 45);
  static const SizedBox h50 = SizedBox(height: 50);
  static const SizedBox w4 = SizedBox(width: 4);
  static const SizedBox w5 = SizedBox(width: 5);
  static const SizedBox w6 = SizedBox(width: 6);
  static const SizedBox w8 = SizedBox(width: 8);
  static const SizedBox w10 = SizedBox(width: 10);
  static const SizedBox w12 = SizedBox(width: 12);
  static const SizedBox w16 = SizedBox(width: 16);
  static const SizedBox w20 = SizedBox(width: 20);
  static const SizedBox w24 = SizedBox(width: 24);
  static const SizedBox w30 = SizedBox(width: 30);
  static const SizedBox w40 = SizedBox(width: 40);
  static const SizedBox w50 = SizedBox(width: 50);
}

/// --------------- [AppPadding] Use to add padding as well as margin ---------------------------- //
abstract class AppPadding {
  static const EdgeInsets z = EdgeInsets.zero;
  static const EdgeInsets padA2 = EdgeInsets.all(2);
  static const EdgeInsets padA4 = EdgeInsets.all(4);
  static const EdgeInsets padL5 = EdgeInsets.only(left: 5);
  static const EdgeInsets padL8 = EdgeInsets.only(left: 8);
  static const EdgeInsets padL10 = EdgeInsets.only(left: 10);
  static const EdgeInsets padR5 = EdgeInsets.only(right: 5);
  static const EdgeInsets padR8 = EdgeInsets.only(right: 8);
  static const EdgeInsets padR10 = EdgeInsets.only(right: 10);
  static const EdgeInsets padA5 = EdgeInsets.all(5);
  static const EdgeInsets padA8 = EdgeInsets.all(8);
  static const EdgeInsets padA10 = EdgeInsets.all(10);
  static const EdgeInsets padA12 = EdgeInsets.all(12);
  static const EdgeInsets padA13 = EdgeInsets.all(13);
  static const EdgeInsets padA15 = EdgeInsets.all(15);
  static const EdgeInsets padA16 = EdgeInsets.all(16);
  static const EdgeInsets padA20 = EdgeInsets.all(20);
  static const EdgeInsets padA24 = EdgeInsets.all(24);
  static EdgeInsets padA(val) => EdgeInsets.all(val);
  static const EdgeInsets padSV5 = EdgeInsets.symmetric(vertical: 5);
  static const EdgeInsets padSV6 = EdgeInsets.symmetric(vertical: 6);
  static const EdgeInsets padSV8 = EdgeInsets.symmetric(vertical: 8);
  static const EdgeInsets padSV10 = EdgeInsets.symmetric(vertical: 10);
  static const EdgeInsets padSV12 = EdgeInsets.symmetric(vertical: 12);
  static const EdgeInsets padSV14 = EdgeInsets.symmetric(vertical: 14);
  static const EdgeInsets padSV16 = EdgeInsets.symmetric(vertical: 16);
  static const EdgeInsets padSH5 = EdgeInsets.symmetric(horizontal: 5);
  static const EdgeInsets padSH10 = EdgeInsets.symmetric(horizontal: 10);
  static const EdgeInsets padSH12 = EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets padSH16 = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets padSV20 = EdgeInsets.symmetric(vertical: 20);
  static const EdgeInsets padSV24 = EdgeInsets.symmetric(vertical: 24);
  static const EdgeInsets padSH20 = EdgeInsets.symmetric(horizontal: 20);
  static const EdgeInsets padSH24 = EdgeInsets.symmetric(horizontal: 24);
  static const EdgeInsets padSV10H20 = EdgeInsets.symmetric(
    vertical: 25,
    horizontal: 20,
  );
  static const EdgeInsets padSV25H30 = EdgeInsets.symmetric(
    vertical: 25,
    horizontal: 30,
  );
}

/// --------------- [CircularBorderRadius] Use to add circular border radius ---------------------------- //
abstract class CircularBorderRadius {
  static BorderRadius z = BorderRadius.zero;
  static BorderRadius b5 = BorderRadius.circular(5);
  static BorderRadius b6 = BorderRadius.circular(6);
  static BorderRadius b8 = BorderRadius.circular(8);
  static BorderRadius b10 = BorderRadius.circular(10);
  static BorderRadius b12 = BorderRadius.circular(12);
  static BorderRadius b15 = BorderRadius.circular(15);
  static BorderRadius b20 = BorderRadius.circular(20);
  static BorderRadius b30 = BorderRadius.circular(30);
  static BorderRadius inf = BorderRadius.circular(1000);
}

bool get isWeb => kIsWeb;

extension ResponsiveSizeSizedBox on SizedBox {
  SizedBox get r =>
      SizedBox(height: height?.responsive, width: width?.responsive);
}

extension WidgetExt on Widget {
  Widget get safe => SafeArea(child: this);
}
