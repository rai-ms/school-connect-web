import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef MultiBlocWidgetBuilder3<S1, S2, S3> = Widget Function(
    BuildContext context, S1 state1, S2 state2, S3 state3);

typedef MultiBlocBuildWhen3<S1, S2, S3> = bool Function(
    S1 previous1, S1 current1, S2 previous2, S2 current2, S3 previous3, S3 current3);

class MultiBlocBuilder3<B1 extends BlocBase<S1>, S1, B2 extends BlocBase<S2>, S2, B3 extends BlocBase<S3>, S3>
    extends StatelessWidget {
  final MultiBlocWidgetBuilder3<S1, S2, S3> builder;
  final MultiBlocBuildWhen3<S1, S2, S3>? buildWhen;

  const MultiBlocBuilder3({super.key, required this.builder, this.buildWhen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S1>(
      buildWhen: (previous1, current1) => buildWhen?.call(
        previous1, current1,
        context.read<B2>().state, context.read<B2>().state,
        context.read<B3>().state, context.read<B3>().state,
      ) ?? true,
      builder: (context, state1) {
        return BlocBuilder<B2, S2>(
          buildWhen: (previous2, current2) => buildWhen?.call(
            context.read<B1>().state, context.read<B1>().state,
            previous2, current2,
            context.read<B3>().state, context.read<B3>().state,
          ) ?? true,
          builder: (context, state2) {
            return BlocBuilder<B3, S3>(
              buildWhen: (previous3, current3) => buildWhen?.call(
                context.read<B1>().state, context.read<B1>().state,
                context.read<B2>().state, context.read<B2>().state,
                previous3, current3,
              ) ?? true,
              builder: (context, state3) {
                return builder(context, state1, state2, state3);
              },
            );
          },
        );
      },
    );
  }
}
