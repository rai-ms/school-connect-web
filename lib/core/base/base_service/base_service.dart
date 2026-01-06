
import 'package:flutter/material.dart';


/// [BaseService] is used, so that service will create once at the app starting
/// Every Service class available in the app, must inherit [BaseService]
/// [init] must be called before [MyApp] in [main] so that single instance will be create

@protected
abstract class BaseService<T, P> {
  /// const constructor
  const BaseService();

  /// Initial Method [init] for setup
  T init({required P param});
}