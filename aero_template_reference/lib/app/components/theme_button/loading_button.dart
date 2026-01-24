import 'package:flutter/material.dart';

import '../../data/utils/utils.dart';
import '../theme_config/theme_config.dart';

class LoadingButton extends StatefulWidget {
  final Future<void> Function()? onPressed;

  final ButtonStyle? style;

  final Widget? child;

  final Widget? loading;

  const LoadingButton({
    super.key,
    required this.onPressed,
    this.style,
    required this.child,
    this.loading,
  });

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: widget.style,
      onPressed: widget.onPressed == null
          ? null
          : isLoading
              ? null
              : _handleLoading,
      child: isLoading ? widget.loading ?? themeConfig.loadingWidget(context) : widget.child,
    );
  }

  void _handleLoading() {
    setState(() {
      isLoading = true;
    });
    utils.tools.exceptionCapture(() async {
      await widget.onPressed!();
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }, dioError: (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      utils.error.dioError(e);
    }, error: (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      utils.error.error(e);
    });
  }
}
