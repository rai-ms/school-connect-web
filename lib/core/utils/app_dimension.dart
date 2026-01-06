import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_global.dart';

extension KBorderRadius on BorderRadius {
  // same radius for all corners
  static BorderRadius get kZero => BorderRadius.zero;
  static BorderRadius get kAll6 => BorderRadius.circular(6.responsive);
  static BorderRadius dynamic(double value) =>
      BorderRadius.circular(value.responsive);
  static BorderRadius get kAll8 => BorderRadius.circular(8.responsive);
  static BorderRadius get kAll10 => BorderRadius.circular(10.responsive);
  static BorderRadius get kAll12 => BorderRadius.circular(12.responsive);
  static BorderRadius get kAll14 => BorderRadius.circular(14.responsive);
  static BorderRadius get kAll15 => BorderRadius.circular(15.responsive);
  static BorderRadius get kAll16 => BorderRadius.circular(16.responsive);
  static BorderRadius get kAll18 => BorderRadius.circular(18.responsive);
  static BorderRadius get kAll20 => BorderRadius.circular(20.responsive);
  static BorderRadius get kAll22 => BorderRadius.circular(22.responsive);
  static BorderRadius get kAll26 => BorderRadius.circular(26.responsive);
  static BorderRadius get kAll30 => BorderRadius.circular(30.responsive);
  static BorderRadius get kAll36 => BorderRadius.circular(36.responsive);
  static BorderRadius get kAll40 => BorderRadius.circular(40.responsive);
  static BorderRadius get kAll52 => BorderRadius.circular(52.responsive);
  static BorderRadius get kAll60 => BorderRadius.circular(60.responsive);
  static BorderRadius get kAll70 => BorderRadius.circular(70.responsive);
  static BorderRadius get kAll100 => BorderRadius.circular(100.responsive);
  static BorderRadius get kAll50 => BorderRadius.circular(50.responsive);
  static BorderRadius get kAll200 => BorderRadius.circular(200.responsive);
  // Different radius for different corners
  static BorderRadius get kTopLeft30TopRight30 => BorderRadius.only(
        topLeft: Radius.circular(30.responsive),
        topRight: Radius.circular(30.responsive),
      );
  static BorderRadius get kTopLeft30BottomLeft30 => BorderRadius.only(
        topLeft: Radius.circular(30.responsive),
        bottomLeft: Radius.circular(30.responsive),
      );
  static BorderRadius get kTopRight30BottomRight30 => BorderRadius.only(
        topRight: Radius.circular(30.responsive),
        bottomRight: Radius.circular(30.responsive),
      );
  static BorderRadius get kTop20 => BorderRadius.only(
        topLeft: Radius.circular(20.responsive),
        topRight: Radius.circular(20.responsive),
      );
  static BorderRadius get kBottom20 => BorderRadius.only(
        bottomLeft: Radius.circular(20.responsive),
        bottomRight: Radius.circular(20.responsive),
      );
  static BorderRadius get kBottom16 => BorderRadius.only(
        bottomLeft: Radius.circular(16.responsive),
        bottomRight: Radius.circular(16.responsive),
      );
  static BorderRadius get kBottom18 => BorderRadius.only(
        bottomLeft: Radius.circular(18.responsive),
        bottomRight: Radius.circular(18.responsive),
      );
  static BorderRadius get kTopLeft20TopRight20 => BorderRadius.only(
        topLeft: Radius.circular(20.responsive),
        topRight: Radius.circular(20.responsive),
      );
}

extension KEdgeInsets on EdgeInsets {
  // zero
  static EdgeInsets get kZero => EdgeInsets.zero;
  static EdgeInsets k(double h, double v) =>
      EdgeInsets.symmetric(horizontal: h, vertical: v);
  // all sides same value
  static EdgeInsets get k1 => EdgeInsets.all(1.responsive);
  static EdgeInsets get k2 => EdgeInsets.all(2.responsive);
  static EdgeInsets get k4 => EdgeInsets.all(4.responsive);
  static EdgeInsets get k6 => EdgeInsets.all(6.responsive);
  static EdgeInsets get k8 => EdgeInsets.all(8.responsive);
  static EdgeInsets get k10 => EdgeInsets.all(10.responsive);
  static EdgeInsets get k11 => EdgeInsets.all(11.responsive);
  static EdgeInsets get k12 => EdgeInsets.all(12.responsive);
  static EdgeInsets get k14 => EdgeInsets.all(14.responsive);
  static EdgeInsets get k16 => EdgeInsets.all(16.responsive);
  static EdgeInsets get k18 => EdgeInsets.all(18.responsive);
  static EdgeInsets get k20 => EdgeInsets.all(20.responsive);
  static EdgeInsets get k31 => EdgeInsets.all(31.responsive);

  // Horizontal Sides same
  static EdgeInsets get kHorizontal2 =>
      EdgeInsets.symmetric(horizontal: 2.responsive);
  static EdgeInsets get kHorizontal3 =>
      EdgeInsets.symmetric(horizontal: 3.responsive);
  static EdgeInsets get kHorizontal4 =>
      EdgeInsets.symmetric(horizontal: 4.responsive);
  static EdgeInsets get kHorizontal5 =>
      EdgeInsets.symmetric(horizontal: 5.responsive);
  static EdgeInsets get kHorizontal6 =>
      EdgeInsets.symmetric(horizontal: 6.responsive);
  static EdgeInsets get kHorizontal8 =>
      EdgeInsets.symmetric(horizontal: 8.responsive);
  static EdgeInsets get kHorizontal10 =>
      EdgeInsets.symmetric(horizontal: 10.responsive);
  static EdgeInsets get kHorizontal11 =>
      EdgeInsets.symmetric(horizontal: 11.responsive);
  static EdgeInsets get kHorizontal12 =>
      EdgeInsets.symmetric(horizontal: 12.responsive);
  static EdgeInsets get kHorizontal13 =>
      EdgeInsets.symmetric(horizontal: 13.responsive);
  static EdgeInsets get kHorizontal14 =>
      EdgeInsets.symmetric(horizontal: 14.responsive);
  static EdgeInsets get kHorizontal15 =>
      EdgeInsets.symmetric(horizontal: 15.responsive);
  static EdgeInsets kHorizontal20 =
      EdgeInsets.symmetric(horizontal: 20.responsive);
  static EdgeInsets kHorizontal25 =
      EdgeInsets.symmetric(horizontal: 25.responsive);
  static EdgeInsets get kHorizontal30 =>
      EdgeInsets.symmetric(horizontal: 30.responsive);
  static EdgeInsets get kHorizontal35 =>
      EdgeInsets.symmetric(horizontal: 35.responsive);
  static EdgeInsets get kHorizontal42 =>
      EdgeInsets.symmetric(horizontal: 42.responsive);
  static EdgeInsets get kHorizontal48 =>
      EdgeInsets.symmetric(horizontal: 48.responsive);
  static EdgeInsets get kHorizontal50 =>
      EdgeInsets.symmetric(horizontal: 50.responsive);

  // Vertical Sides same
  static EdgeInsets get kVertical3 =>
      EdgeInsets.symmetric(vertical: 3.responsive);
  static EdgeInsets get kVertical6 =>
      EdgeInsets.symmetric(vertical: 6.responsive);
  static EdgeInsets get kVertical10 =>
      EdgeInsets.symmetric(vertical: 10.responsive);
  static EdgeInsets get kVertical12 =>
      EdgeInsets.symmetric(vertical: 12.responsive);
  static EdgeInsets get kVertical14 =>
      EdgeInsets.symmetric(vertical: 14.responsive);
  static EdgeInsets get kVertical17 =>
      EdgeInsets.symmetric(vertical: 17.responsive);
  static EdgeInsets get kVertical20 =>
      EdgeInsets.symmetric(vertical: 20.responsive);
  static EdgeInsets get kVertical26 =>
      EdgeInsets.symmetric(vertical: 26.responsive);
  static EdgeInsets get kVertical30 =>
      EdgeInsets.symmetric(vertical: 30.responsive);
  static EdgeInsets get kVertical16 =>
      EdgeInsets.symmetric(vertical: 16.responsive);

  // Only Left
  static EdgeInsets get kLeft2 => EdgeInsets.only(left: 2.responsive);
  static EdgeInsets get kLeft3 => EdgeInsets.only(left: 3.responsive);
  static EdgeInsets get kLeft5 => EdgeInsets.only(left: 5.responsive);
  static EdgeInsets get kLeft10 => EdgeInsets.only(left: 10.responsive);
  static EdgeInsets get kLeft12 => EdgeInsets.only(left: 12.responsive);
  static EdgeInsets get kLeft20 => EdgeInsets.only(left: 20.responsive);
  static EdgeInsets get kLeft30 => EdgeInsets.only(left: 30.responsive);
  static EdgeInsets get kLeft50 => EdgeInsets.only(left: 50.responsive);
  static EdgeInsets get kLeft70 => EdgeInsets.only(left: 70.responsive);

  // Only Right

  static EdgeInsets get kRight4 => EdgeInsets.only(right: 4.responsive);
  static EdgeInsets get kRight6 => EdgeInsets.only(right: 6.responsive);
  static EdgeInsets get kRight8 => EdgeInsets.only(right: 8.responsive);
  static EdgeInsets get kRight10 => EdgeInsets.only(right: 10.responsive);
  static EdgeInsets get kRight12 => EdgeInsets.only(right: 12.responsive);
  static EdgeInsets get kRight14 => EdgeInsets.only(right: 14.responsive);
  static EdgeInsets get kRight20 => EdgeInsets.only(right: 20.responsive);

  // Only Top
  static EdgeInsets get kTop1 => EdgeInsets.only(top: 1.responsive);
  static EdgeInsets get kTop2 => EdgeInsets.only(top: 2.responsive);
  static EdgeInsets get kTop3 => EdgeInsets.only(top: 3.responsive);
  static EdgeInsets get kTop4 => EdgeInsets.only(top: 4.responsive);
  static EdgeInsets get kTop6 => EdgeInsets.only(top: 6.responsive);
  static EdgeInsets get kTop8 => EdgeInsets.only(top: 8.responsive);
  static EdgeInsets get kTop10 => EdgeInsets.only(top: 10.responsive);
  static EdgeInsets get kTop12 => EdgeInsets.only(top: 12.responsive);
  static EdgeInsets get kTop20 => EdgeInsets.only(top: 20.responsive);
  static EdgeInsets get kTop26 => EdgeInsets.only(top: 26.responsive);
  static EdgeInsets get kTop32 => EdgeInsets.only(top: 32.responsive);
  static EdgeInsets get kTop34 => EdgeInsets.only(top: 34.responsive);
  static EdgeInsets get kTop35 => EdgeInsets.only(top: 35.responsive);
  static EdgeInsets get kTop40 => EdgeInsets.only(top: 40.responsive);

  // Only Bottom
  static const EdgeInsets kBottom6 = EdgeInsets.only(bottom: 6);
  static const EdgeInsets kBottom9 = EdgeInsets.only(bottom: 9);
  static const EdgeInsets kBottom10 = EdgeInsets.only(bottom: 10);
  static const EdgeInsets kBottom13 = EdgeInsets.only(bottom: 13);
  static const EdgeInsets kBottom14 = EdgeInsets.only(bottom: 14);
  static const EdgeInsets kBottom20 = EdgeInsets.only(bottom: 20);
  static const EdgeInsets kBottom26 = EdgeInsets.only(bottom: 26);
  static const EdgeInsets kbottom30 = EdgeInsets.only(bottom: 30);
  static const EdgeInsets kbottom32 = EdgeInsets.only(bottom: 32);
  static const EdgeInsets kbottom34 = EdgeInsets.only(bottom: 34);
  static const EdgeInsets kbottom42 = EdgeInsets.only(bottom: 42);
  static EdgeInsets get kBottom16 => EdgeInsets.only(bottom: 16.responsive);
  static EdgeInsets get kBottom18 => EdgeInsets.only(bottom: 18.responsive);
  static EdgeInsets get kbottom40 => EdgeInsets.only(bottom: 40.responsive);

  // Only
  static EdgeInsets get kTop10Bottom28 =>
      EdgeInsets.only(top: 10.responsive, bottom: 28.responsive);
  static EdgeInsets get kLeft70top10 =>
      EdgeInsets.only(left: 70.responsive, top: 10.responsive);
  static EdgeInsets get kLeft10top7 =>
      EdgeInsets.only(left: 10.responsive, top: 7.responsive);
  static EdgeInsets get kLeft20Right15 =>
      EdgeInsets.only(left: 20.responsive, right: 15.responsive);
  static EdgeInsets get kTop2Left12 =>
      EdgeInsets.only(top: 2.responsive, left: 12.responsive);
  static EdgeInsets get kTop6Bottom17 =>
      EdgeInsets.only(top: 6.responsive, bottom: 17.responsive);
  static EdgeInsets get kHorizontal12Vertical20 =>
      EdgeInsets.symmetric(horizontal: 12.responsive, vertical: 20.responsive);

  static EdgeInsets kHorizontal4Vertical10 =
      EdgeInsets.symmetric(horizontal: 4.responsive, vertical: 10.responsive);

  static EdgeInsets get kHorizontal42Vertical10 =>
      EdgeInsets.symmetric(horizontal: 42.responsive, vertical: 10.responsive);
  static EdgeInsets get kTop8Bottom22 =>
      EdgeInsets.only(top: 8.responsive, bottom: 22.responsive);

  static EdgeInsets get kTop8Right16 =>
      EdgeInsets.only(top: 8.responsive, right: 16.responsive);

  static EdgeInsets get kTop4Right4 =>
      EdgeInsets.only(top: 4.responsive, right: 4.responsive);

  static EdgeInsets get kLeft20Right20Top20 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 20.responsive,
      );
  static EdgeInsets get kAll11Right8 => EdgeInsets.only(
        left: 11.responsive,
        right: 8.responsive,
        top: 11.responsive,
        bottom: 11.responsive,
      );
  static EdgeInsets get kTop10Left10Right16Bottom10 => EdgeInsets.only(
        top: 10.responsive,
        left: 10.responsive,
        right: 16.responsive,
        bottom: 10.responsive,
      );

  static EdgeInsets get kTop11Left20Right20Bottom13 => EdgeInsets.only(
        top: 11.responsive,
        left: 20.responsive,
        right: 20.responsive,
        bottom: 13.responsive,
      );
  static EdgeInsets get kTop6Bottom8Left12Right12 => EdgeInsets.only(
        top: 6.responsive,
        bottom: 8.responsive,
        left: 12.responsive,
        right: 12.responsive,
      );
  static EdgeInsets get kLeft20Right20Bottom34 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        bottom: 34.responsive,
      );
  static EdgeInsets get kLeft10Right10Bottom18 => EdgeInsets.only(
        left: 10.responsive,
        right: 10.responsive,
        bottom: 18.responsive,
      );
  static EdgeInsets get kLeft8Right8Bottom14 => EdgeInsets.only(
        left: 8.responsive,
        right: 8.responsive,
        bottom: 14.responsive,
      );
  static EdgeInsets get kLeft8Right8Top8Bottom12 => EdgeInsets.only(
        left: 8.responsive,
        // right: 8,
        // top: 8,
        bottom: 12.responsive,
      );
  static EdgeInsets get kLeft14Right14Top8Bottom12 => EdgeInsets.only(
      left: 14.responsive,
      right: 14.responsive,
      top: 8.responsive,
      bottom: 12.responsive);
  static EdgeInsets get kAll18Right10 => EdgeInsets.only(
        left: 18.responsive,
        right: 10.responsive,
        top: 18.responsive,
        bottom: 18.responsive,
      );
  static EdgeInsets get kLeft11Right11Top17 => EdgeInsets.only(
        left: 11.responsive,
        right: 11.responsive,
        top: 18.responsive,
      );
  static EdgeInsets get kAll15Right10 => EdgeInsets.only(
        left: 15.responsive,
        right: 10.responsive,
        top: 15.responsive,
        bottom: 15.responsive,
      );

  static EdgeInsets get kHorizontal18Top12Bottom30 => EdgeInsets.only(
        left: 18.responsive,
        right: 18.responsive,
        top: 12.responsive,
        bottom: 30.responsive,
      );
  static EdgeInsets get kHorizontal17Vertical9 => EdgeInsets.symmetric(
        horizontal: 17.responsive,
        vertical: 9.responsive,
      );
  static EdgeInsets get kTop18Left12Right10Bottom18 => EdgeInsets.only(
        top: 18.responsive,
        left: 12.responsive,
        right: 10.responsive,
        bottom: 18.responsive,
      );
  static EdgeInsets get kTop11Left9Right11Bottom9 => EdgeInsets.only(
        top: 11.responsive,
        left: 9.responsive,
        right: 11.responsive,
        bottom: 9.responsive,
      );
  static EdgeInsets get kTop11Left21Right10Bottom11 => EdgeInsets.only(
        top: 11.responsive,
        left: 21.responsive,
        right: 10.responsive,
        bottom: 11.responsive,
      );
  static EdgeInsets get kTop20Bottom8 => EdgeInsets.only(
        top: 20.responsive,
        bottom: 8.responsive,
      );
  static EdgeInsets get kTop12Left20Right20Bottom16 => EdgeInsets.only(
        top: 12.responsive,
        left: 20.responsive,
        right: 20.responsive,
        bottom: 16.responsive,
      );
  static EdgeInsets get kTop20Left20Right20Bottom14 => EdgeInsets.only(
        top: 20.responsive,
        left: 20.responsive,
        right: 20.responsive,
        bottom: 14.responsive,
      );
  static EdgeInsets get kTop8Left20Right20Bottom12 => EdgeInsets.only(
        top: 8.responsive,
        left: 20.responsive,
        right: 20.responsive,
        bottom: 12.responsive,
      );
  static EdgeInsets get kLeft20Right20Bottom20 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        bottom: 14.responsive,
      );
  static EdgeInsets get kHorizontal20Top20 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 20.responsive,
      );
  static EdgeInsets get kHorizontal20Top24 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 24.responsive,
      );
  static EdgeInsets get kHorizontal20Bottom8 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        bottom: 8.responsive,
      );

  static EdgeInsets get kHorizontal20Top40 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 40.responsive,
      );
  static EdgeInsets get kHorizontal20Top10 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 10.responsive,
      );
  static EdgeInsets get kHorizontal20Top26 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 26.responsive,
      );
  static EdgeInsets get kHorizontal20Top34 => EdgeInsets.only(
        left: 20.responsive,
        right: 20.responsive,
        top: 34.responsive,
      );
  static EdgeInsets get kHorizontal12Top20 => EdgeInsets.only(
        left: 12.responsive,
        right: 12.responsive,
        top: 20.responsive,
      );

  static EdgeInsets get kLeft20Rigth13Top12Bottom12 => EdgeInsets.only(
        right: 13.responsive,
        left: 20.responsive,
        top: 12.responsive,
        bottom: 12.responsive,
      );
  static EdgeInsets get kLeft12Rigth7Top16Bottom16 => EdgeInsets.only(
      top: 16.responsive,
      bottom: 16.responsive,
      left: 12.responsive,
      right: 7.responsive);

  static EdgeInsets get kTop16Bottom22 =>
      EdgeInsets.only(top: 16.responsive, bottom: 22.responsive);

  static EdgeInsets get kTop22Bottom16 =>
      EdgeInsets.only(top: 22.responsive, bottom: 16.responsive);

  static EdgeInsets get kRight8Top16Bottom16 => EdgeInsets.only(
        top: 16.responsive,
        bottom: 16.responsive,
        right: 8.responsive,
      );

  static EdgeInsets get kLeft30Top13Bottom7 => EdgeInsets.only(
        top: 13.responsive,
        bottom: 7.responsive,
        left: 30.responsive,
      );

  static EdgeInsets get kLeft20Bottom6 => EdgeInsets.only(
        top: 20.responsive,
        bottom: 6.responsive,
      );

  static EdgeInsets get kRight70Top10 => EdgeInsets.only(
        right: 70.responsive,
        top: 10.responsive,
      );

  static EdgeInsets get kLeft16Right16Bottom14 => EdgeInsets.only(
        left: 16.responsive,
        right: 16.responsive,
        bottom: 14.responsive,
      );

  // Symmetric - Horizontal and Vertical
  static EdgeInsets get kHorizontal8Vertical4 => EdgeInsets.symmetric(
        horizontal: 8.responsive,
        vertical: 4.responsive,
      );

  static EdgeInsets get kHorizontal16Vertical12 => EdgeInsets.symmetric(
        horizontal: 16.responsive,
        vertical: 12.responsive,
      );

  // Symmetric - Horizontal and Vertical

  static EdgeInsets get kHorizontal12Vertical10 => EdgeInsets.symmetric(
        horizontal: 12.responsive,
        vertical: 10.responsive,
      );

  static EdgeInsets get kHorizontal11Vertical12 => EdgeInsets.symmetric(
        horizontal: 11.responsive,
        vertical: 12.responsive,
      );

  static EdgeInsets get kHorizontal16Vertical10 => EdgeInsets.symmetric(
        horizontal: 16.responsive,
        vertical: 10.responsive,
      );
  static EdgeInsets get kHorizontal14Vertical18 => EdgeInsets.symmetric(
        horizontal: 14.responsive,
        vertical: 18.responsive,
      );
  static EdgeInsets get kHorizontal20Vertical10 => EdgeInsets.symmetric(
        horizontal: 20.responsive,
        vertical: 10.responsive,
      );
  static EdgeInsets get kHorizontal18Vertical12 => EdgeInsets.symmetric(
        horizontal: 18.responsive,
        vertical: 12.responsive,
      );
  static EdgeInsets get kHorizontal12Vertical8 => EdgeInsets.symmetric(
        horizontal: 12.responsive,
        vertical: 8.responsive,
      );
  static EdgeInsets get kHorizontal10Vertical8 => EdgeInsets.symmetric(
        horizontal: 10.responsive,
        vertical: 8.responsive,
      );

  static EdgeInsets get kHorizontal12Vertical16 => EdgeInsets.symmetric(
        horizontal: 12.responsive,
        vertical: 16.responsive,
      );

  static EdgeInsets get kHorizontal20Vertical6 => EdgeInsets.symmetric(
        horizontal: 20.responsive,
        vertical: 6.responsive,
      );

  static EdgeInsets get kHorizontal20Vertical16 => EdgeInsets.symmetric(
        horizontal: 20.responsive,
        vertical: 16.responsive,
      );

  static EdgeInsets get kHorizontal20Vertical18 => EdgeInsets.symmetric(
        horizontal: 20.responsive,
        vertical: 18.responsive,
      );
  static EdgeInsets get kHorizontal20Vertical30 => EdgeInsets.symmetric(
        horizontal: 20.responsive,
        vertical: 30.responsive,
      );

  static EdgeInsets get kHorizontal12Vertical5 => EdgeInsets.symmetric(
        horizontal: 12.responsive,
        vertical: 5.responsive,
      );

  static EdgeInsets get kHorizontal20Vertical20 => EdgeInsets.symmetric(
        horizontal: 20.responsive,
        vertical: 20.responsive,
      );

  static EdgeInsets get kHorizontal28Vertical10 => EdgeInsets.symmetric(
        horizontal: 28.responsive,
        vertical: 10.responsive,
      );
  static EdgeInsets get kHorizontal14Vertical10 => EdgeInsets.symmetric(
        horizontal: 14.responsive,
        vertical: 10.responsive,
      );
  static EdgeInsets get kHorizontal14Vertical8 => EdgeInsets.symmetric(
        horizontal: 14.responsive,
        vertical: 8.responsive,
      );
  static EdgeInsets get kHorizontal6Vertical4 => EdgeInsets.symmetric(
        horizontal: 6.responsive,
        vertical: 4.responsive,
      );
  static EdgeInsets get kHorizontal10Vertical6 => EdgeInsets.symmetric(
        horizontal: 10.responsive,
        vertical: 6.responsive,
      );
  static EdgeInsets get kHorizontal15Vertical6 =>
      EdgeInsets.symmetric(horizontal: 15.responsive, vertical: 6.responsive);

  static EdgeInsets get kTop6Bottom8 =>
      EdgeInsets.only(top: 6.responsive, bottom: 8.responsive);

  static EdgeInsets get kVertical16Horizontal20 =>
      EdgeInsets.symmetric(vertical: 16.responsive, horizontal: 20.responsive);

  static EdgeInsets get kHorizontal20Vertical4 =>
      EdgeInsets.symmetric(horizontal: 20.responsive, vertical: 4.responsive);

  static EdgeInsets get kHorizontal20Vertical60 =>
      EdgeInsets.symmetric(horizontal: 20.responsive, vertical: 60.responsive);

  ///* kBottomNavigationBarHeight => 56
  ///* Total Navbar height in design => 96
  ///* Content padding from bottom => 30
  static EdgeInsets kBottomNavPadding = EdgeInsets.only(
      bottom: kBottomNavigationBarHeight +
          MediaQuery.paddingOf(ctx).bottom +
          20.responsive);
}

extension KSizedBox on SizedBox {
  // Other
  static const SizedBox kShrink = SizedBox.shrink();
  static const SizedBox kExpand = SizedBox.expand();
  static SizedBox kMediaQuerySize(
          {double heightRatio = 0, double widthRatio = 0}) =>
      SizedBox(
        height: deviceHeight * heightRatio,
        width: deviceWidth * widthRatio,
      );

  static SizedBox bottomNavSpace({double extraHeight = 0}) => SizedBox(
      height: kBottomNavigationBarHeight +
          MediaQuery.paddingOf(ctx).bottom +
          extraHeight.responsive);

  // Height
  static SizedBox get h2 => SizedBox(height: 2.responsive);
  static SizedBox get h3 => SizedBox(height: 3.responsive);
  static SizedBox get h4 => SizedBox(height: 4.responsive);
  static SizedBox get h5 => SizedBox(height: 5.responsive);
  static SizedBox get h6 => SizedBox(height: 6.responsive);
  static SizedBox get h7 => SizedBox(height: 7.responsive);
  static SizedBox get h8 => SizedBox(height: 8.responsive);
  static SizedBox get h9 => SizedBox(height: 9.responsive);
  static SizedBox get h10 => SizedBox(height: 10.responsive);
  static SizedBox get h12 => SizedBox(height: 12.responsive);
  static SizedBox get h13 => SizedBox(height: 13.responsive);
  static SizedBox get h14 => SizedBox(height: 14.responsive);
  static SizedBox get h15 => SizedBox(height: 15.responsive);
  static SizedBox get h16 => SizedBox(height: 16.responsive);
  static SizedBox get h17 => SizedBox(height: 17.responsive);
  static SizedBox get h18 => SizedBox(height: 18.responsive);
  static SizedBox get h20 => SizedBox(height: 20.responsive);
  static SizedBox get h22 => SizedBox(height: 22.responsive);
  static SizedBox get h23 => SizedBox(height: 23.responsive);
  static SizedBox get h24 => SizedBox(height: 24.responsive);
  static SizedBox get h25 => SizedBox(height: 25.responsive);
  static SizedBox get h26 => SizedBox(height: 26.responsive);
  static SizedBox get h28 => SizedBox(height: 28.responsive);
  static SizedBox get h30 => SizedBox(height: 30.responsive);
  static SizedBox get h36 => SizedBox(height: 36.responsive);
  static SizedBox get h40 => SizedBox(height: 40.responsive);
  static SizedBox get h42 => SizedBox(height: 42.responsive);
  static SizedBox get h44 => SizedBox(height: 44.responsive);
  static SizedBox get h45 => SizedBox(height: 44.responsive);
  static SizedBox get h46 => SizedBox(height: 46.responsive);
  static SizedBox get h48 => SizedBox(height: 48.responsive);
  static SizedBox get h50 => SizedBox(height: 50.responsive);
  static SizedBox get h55 => SizedBox(height: 55.responsive);
  static SizedBox get h60 => SizedBox(height: 60.responsive);
  static SizedBox get h65 => SizedBox(height: 65.responsive);
  static SizedBox get h70 => SizedBox(height: 70.responsive);
  static SizedBox get h80 => SizedBox(height: 80.responsive);
  static SizedBox get h85 => SizedBox(height: 85.responsive);
  static SizedBox get h100 => SizedBox(height: 100.responsive);
  static SizedBox get h120 => SizedBox(height: 120.responsive);
  static SizedBox get h128 => SizedBox(height: 128.responsive);
  // Width
  static SizedBox get w4 => SizedBox(width: 4.responsive);
  static SizedBox get w5 => SizedBox(width: 5.responsive);
  static SizedBox get w6 => SizedBox(width: 6.responsive);
  static SizedBox get w7 => SizedBox(width: 7.responsive);
  static SizedBox get w8 => SizedBox(width: 8.responsive);
  static SizedBox get w9 => SizedBox(width: 9.responsive);
  static SizedBox get w10 => SizedBox(width: 10.responsive);
  static SizedBox get w12 => SizedBox(width: 12.responsive);
  static SizedBox get w13 => SizedBox(width: 13.responsive);
  static SizedBox get w14 => SizedBox(width: 14.responsive);
  static SizedBox get w15 => SizedBox(width: 15.responsive);
  static SizedBox get w16 => SizedBox(width: 16.responsive);
  static SizedBox get w18 => SizedBox(width: 18.responsive);
  static SizedBox get w20 => SizedBox(width: 20.responsive);
  static SizedBox get w23 => SizedBox(width: 23.responsive);
  static SizedBox get w25 => SizedBox(width: 25.responsive);
  static SizedBox get w30 => SizedBox(width: 30.responsive);
  static SizedBox get h32 => SizedBox(height: 32.responsive);
  static SizedBox get w40 => SizedBox(width: 40.responsive);
  static SizedBox get w52 => SizedBox(width: 52.responsive);
}

extension KSpacer on Spacer {
  static const Spacer k = Spacer();
  static const Spacer k2 = Spacer(flex: 2);
  static const Spacer k3 = Spacer(flex: 3);
  static const Spacer k4 = Spacer(flex: 4);
  static const Spacer k8 = Spacer(flex: 8);
  static const Spacer k17 = Spacer(flex: 17);
  static const Spacer k19 = Spacer(flex: 19);
  static const Spacer k20 = Spacer(flex: 20);
}

extension KDuration on Duration {
  static const Duration k100mls = Duration(milliseconds: 100);
  static const Duration k200mls = Duration(milliseconds: 200);
  static const Duration k300mls = Duration(milliseconds: 300);
  static const Duration kToastDuration = Duration(seconds: 3);
}

extension AppElementDimension on double {
  static double get k48 => 48.responsive;
  static double get k50 => 50.responsive;
  static const double playerBottomPadding = 20;
  static double get bottomNavHeight =>
      (MediaQuery.viewPaddingOf(ctx).bottom > 0 ? 65 : 60).responsive +
      20.responsive;
}

extension ContainerHeight on double {
  static double get k30 => 30.responsive;
  static double get k40 => 40.responsive;
}

extension IntExtension on num {
  double get responsive => spMax;
}
