import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef MultiBlocWidgetBuilder2<S1, S2> = Widget Function(
    BuildContext context, S1 state1, S2 state2);

typedef MultiBlocBuildWhen2<S1, S2> = bool Function(S1 previous1, S1 current1, S2 previous2, S2 current2);

class MultiBlocBuilder2<B1 extends BlocBase<S1>, S1, B2 extends BlocBase<S2>, S2>
    extends StatelessWidget {
  final MultiBlocWidgetBuilder2<S1, S2> builder;
  final MultiBlocBuildWhen2<S1, S2>? buildWhen;

  const MultiBlocBuilder2({super.key, required this.builder, this.buildWhen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<B1, S1>(
      buildWhen: (previous1, current1) => buildWhen?.call(previous1, current1, context.read<B2>().state, context.read<B2>().state) ?? true,
      builder: (context, state1) {
        return BlocBuilder<B2, S2>(
          buildWhen: (previous2, current2) => buildWhen?.call(context.read<B1>().state, context.read<B1>().state, previous2, current2) ?? true,
          builder: (context, state2) {
            return builder(context, state1, state2);
          },
        );
      },
    );
  }
}
