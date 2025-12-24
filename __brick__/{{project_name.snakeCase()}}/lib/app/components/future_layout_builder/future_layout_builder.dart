import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme_config/theme_config.dart';

class FutureLayoutBuilderController {
  _FutureLayoutBuilderState? _state;

  FutureLayoutBuilderController();

  /// 重载
  /// 重载
  void reload() {
    _state?.reload();
  }

  /// 绑定状态
  void _bindState(_FutureLayoutBuilderState state) {
    _state = state;
  }
}

class FutureLayoutBuilder<T> extends StatefulWidget {
  final Widget Function(T) builder;

  final Function()? future;

  final FutureLayoutBuilderController? controller;

  final ThemeConfig? config;

  final Duration? delayed;

  /// 是否需要拉取
  final T? data;

  const FutureLayoutBuilder({
    super.key,
    required this.builder,
    this.future,
    this.config,
    this.data,
    this.controller,
    this.delayed,
  });

  @override
  State<FutureLayoutBuilder<T>> createState() => _FutureLayoutBuilderState<T>();
}

class _FutureLayoutBuilderState<T> extends State<FutureLayoutBuilder<T>> {
  late Future<dynamic> _future;

  bool _isReloading = false;

  ValueKey key = ValueKey(DateTime.now());

  @override
  initState() {
    super.initState();
    widget.controller?._bindState(this);
    _future = onFuture();
  }

  @override
  void didUpdateWidget(covariant FutureLayoutBuilder<T> oldWidget) {
    if (widget.future != oldWidget.future) {
      _future = onFuture();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller?._bindState(this);
  }

  @override
  Widget build(BuildContext context) {
    if (_isReloading) {
      return widget.config?.loadingWidget(context) ?? themeConfig.loadingWidget(context);
    }
    if (widget.data != null) {
      return widget.builder(widget.data as T);
    }
    return FutureBuilder(
      key: key,
      future: _future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data is Error || snapshot.data is DioException || snapshot.data is MissingPluginException) {
            return widget.config?.loadFailWidget(context, snapshot.data, reload) ?? themeConfig.loadFailWidget(context, snapshot.data, reload);
          } else {
            return widget.builder(snapshot.data);
          }
        } else if (snapshot.hasError) {
          return widget.config?.loadFailWidget(context, snapshot.data, reload) ?? themeConfig.loadFailWidget(context, snapshot.data, reload);
        } else {
          return widget.config?.loadingWidget(context) ?? themeConfig.loadingWidget(context);
        }
      },
    );
  }

  void reload() async {
    _isReloading = true;
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      key = ValueKey(DateTime.now());
      _future = onFuture();
      _isReloading = false;
      if (mounted) setState(() {});
    });
  }

  Future<dynamic> onFuture() async {
    try {
      if (widget.future == null) {
        await Future.delayed(Duration.zero);
        return true;
      }

      final List<Future<dynamic>> futures = [
        Future.delayed(widget.delayed ?? Duration.zero),
        widget.future!.call(),
      ];

      dynamic res = await Future.wait(futures);
      return res[1] ?? true;
    } catch (e) {
      return e;
    }
  }
}
