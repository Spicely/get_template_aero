import 'package:flutter/material.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 分割线文本
///
/// Date: 2024年12月17日 17:40:32 Tuesday
///
//////////////////////////////////////////////////////////////////////////

class DividerText extends StatefulWidget {
  final double indent;

  final String text;

  final EdgeInsetsGeometry margin;

  final Color? textColor;

  final double textSize;

  final double dividerHeight;

  final Color? color;

  const DividerText({
    super.key,
    this.indent = 20,
    this.textColor,
    this.textSize = 14,
    this.margin = const EdgeInsets.symmetric(vertical: 20),
    this.dividerHeight = 0.5,
    this.color,
    required this.text,
  });

  @override
  State<DividerText> createState() => _DividerTextState();
}

class _DividerTextState extends State<DividerText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: widget.color,
              endIndent: widget.indent,
              thickness: widget.dividerHeight,
              height: widget.dividerHeight,
            ),
          ),
          Text(
            widget.text,
            style: TextStyle(
              color: widget.textColor ?? Theme.of(context).dividerColor,
              fontSize: widget.textSize,
            ),
          ),
          Expanded(
            child: Divider(
              color: widget.color,
              indent: widget.indent,
              thickness: widget.dividerHeight,
              height: widget.dividerHeight,
            ),
          ),
        ],
      ),
    );
  }
}
