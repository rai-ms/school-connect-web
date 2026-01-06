import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppSliverGrid extends StatelessWidget {
  const AppSliverGrid({
    super.key,
    required this.children,
    this.controller,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1/1.3,
    this.shrinkWrap = true,
    this.physics,
    this.scrollDirection = Axis.vertical
  });

  final List<Widget> children;
  final ScrollController? controller;
  final int crossAxisCount;
  final double childAspectRatio;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final Axis scrollDirection;
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      shrinkWrap: shrinkWrap,
      physics: physics,
      scrollDirection: scrollDirection,
      slivers: [
        SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 10.0,
            crossAxisSpacing: 10.0,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: (BuildContext context, int index) => children[index],
          itemCount: children.length,
        )


        // SliverGrid(
        //   delegate: SliverChildBuilderDelegate(
        //         (context, index) {
        //       return children[index];
        //     },
        //     childCount: children.length,
        //
        //   ),
        //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //     crossAxisCount: crossAxisCount,
        //     mainAxisSpacing: 10.0,
        //     crossAxisSpacing: 10.0,
        //     childAspectRatio: childAspectRatio,
        //   ),
        // ),
      ],
    );
  }
}
