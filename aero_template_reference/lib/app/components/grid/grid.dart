import 'package:flutter/material.dart';

part 'grid_item.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 用于展示GridItem组件的容器
///
/// Date: 2024年12月17日 17:30:50 Tuesday
///
//////////////////////////////////////////////////////////////////////////

class GridBox extends StatelessWidget {
  final List<Widget> children;

  final int crossAxisCount;

  final double mainAxisSpacing;

  final double crossAxisSpacing;

  final double childAspectRatio;

  final EdgeInsetsGeometry padding;

  final EdgeInsetsGeometry margin;

  final Color? color;

  final BoxDecoration? decoration;

  final double? height;

  const GridBox({
    super.key,
    this.children = const [],
    this.crossAxisCount = 4,
    this.mainAxisSpacing = 4,
    this.crossAxisSpacing = 5.0,
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.symmetric(vertical: 6),
    this.decoration,
    this.margin = const EdgeInsets.all(0),
    this.color,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      decoration: decoration ??
          BoxDecoration(
            borderRadius: BorderRadius.circular(0),
            color: color,
          ),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        itemCount: children.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (BuildContext context, int index) {
          return children[index];
        },
      ),
    );
  }
}
