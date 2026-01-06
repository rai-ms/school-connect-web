


import 'package:flutter/material.dart';

abstract class WidgetView<T1, T2> extends StatelessWidget {
  final T2 ctr;
  T1 get widget => (ctr as State).widget as T1;
  const WidgetView(this.ctr, {super.key});

  @override
  Widget build(BuildContext context);
}
