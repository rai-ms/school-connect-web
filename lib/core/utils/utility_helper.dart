import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_management/core/utils/size_utils.dart' show Space;
import 'package:student_management/presentation/widgets/animated_loader/glow_loader.dart'
    show GlowLoader;
import '../base/logger/app_logger_impl.dart';

class UtilityHelper {
  // Check Internet
  static Future<bool> isInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Log.d('connected');
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      Log.d('not connected');
      return false;
    }
  }

  static Widget assetImage({
    required String path,
    Color? color,
    double? height,
    double? width,
    bool matchTextDirection = true,
    BoxFit fit = BoxFit.fill,
  }) {
    return Image.asset(
      path,
      color: color,
      height: height,
      width: width,
      matchTextDirection: matchTextDirection,
      fit: fit,
    );
  }

  static CachedNetworkImage image(
    img, {
    double? height,
    double? width,
    String? placeHolderImage,
    File? file,
    required BuildContext context,
    BoxFit? fit,
    bool cachedExtent = true,
  }) {
    return CachedNetworkImage(
      imageUrl: img,
      height: height,
      width: width,
      memCacheHeight: cachedExtent ? 250 : null,
      memCacheWidth: cachedExtent ? 250 : null,
      progressIndicatorBuilder:
          (BuildContext imageContext, String value, DownloadProgress progress) {
            return GlowLoader(
              repeatPauseDuration: const Duration(milliseconds: 300),
              glowColor: Theme.of(context).colorScheme.inversePrimary,
              endRadius: 10,
              child: Space.z,
            );
          },
      fit: fit ?? BoxFit.contain,
      errorWidget: (context, url, error) => Container(
        color: Colors.white,
        child: file != null
            ? Image.file(
                file,
                height: height ?? 40,
                width: width ?? 40,
                fit: BoxFit.contain,
              )
            : placeHolderImage != null
            ? Image.asset(
                placeHolderImage,
                height: height ?? 40,
                width: width ?? 40,
                fit: BoxFit.contain,
              )
            : const Icon(Icons.error_outline),
      ),
    );
  }

  static String formatJoinDate(String joinDate) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(joinDate),
    );
    DateFormat formatter = DateFormat('MMM yyyy');
    return formatter.format(dateTime);
  }

  static String formatLastSeen(String joinDate, BuildContext context) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(
      int.parse(joinDate),
    );
    DateTime ct = DateTime.now();
    DateFormat formatter = DateFormat('hh:mm');
    if (ct.difference(dateTime).inDays == 1) {
      return "Yesterday";
    }
    if (ct.difference(dateTime).inDays == 1) {
      formatter = DateFormat('dd/MM/yy');
    }
    return formatter.format(dateTime);
  }
}
