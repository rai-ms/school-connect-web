import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_management/core/services/internet_service/internet_service.dart';

class AppBlocBuilder<B extends BlocBase<S>, S> extends BlocBuilder<B, S> {
  final Widget Function(BuildContext context, S state) blocBuilder;
  final Widget Function(BuildContext context, S state) noInternetBuilder;

  AppBlocBuilder({
    super.key,
    required B super.bloc,
    required this.blocBuilder,
    required this.noInternetBuilder,
    super.buildWhen,
  }) : super(
         builder: (context, state) {
           if (InternetService.service.netListener.value ?? true) {
             return blocBuilder(context, state);
           } else {
             return noInternetBuilder(context, state);
           }
         },
       );
}
