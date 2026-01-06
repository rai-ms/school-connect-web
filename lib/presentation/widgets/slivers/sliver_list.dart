import 'package:flutter/cupertino.dart';

class AppSliverList extends StatelessWidget{
  const AppSliverList({
    super.key,
    required this.children,
    this.controller,
    this.shrinkWrap = false,
    this.physics,
    this.spacing = 5,
    this.scrollDirection = Axis.vertical
  });
  final List<Widget> children;
  final ScrollController? controller;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final double spacing;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      slivers: [
        SliverList.builder(
          itemCount: children.length,
          itemBuilder: (context, index) => children[index],
        ),
      ],
    );
  }

}