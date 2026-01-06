
import 'dart:async';

import 'package:dio/dio.dart';

typedef FVoid = Future<void>;
typedef FRVoid = FutureOr<void>;
typedef DioResponse<T> = Future<Response<T>>;
typedef EnDrawerOpenCallback = void Function(String price, int parameter, String date, String percentOff);