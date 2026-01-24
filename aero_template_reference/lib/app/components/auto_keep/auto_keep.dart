import 'package:flutter/material.dart';

class AutoKeep extends StatefulWidget {
  final Widget child;

  const AutoKeep({
    super.key,
    required this.child,
  });

  @override
  State<AutoKeep> createState() => _AutoKeepState();
}

class _AutoKeepState extends State<AutoKeep> with AutomaticKeepAliveClientMixin<AutoKeep> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
