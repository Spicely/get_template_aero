import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/utils/utils.dart';
import '../theme_config/theme_config.dart';

/////////////////////////////////////////////////////////////////////////
///
/// All rights reserved.
///
/// author: Spicely
///
/// Summary: 缓存图片组件
///
/// Date: 2024年12月17日 11:19:56 Tuesday
///
//////////////////////////////////////////////////////////////////////////

Widget _errorBuilder(BuildContext context, String url, Object error, {double? width, double? height}) => SizedBox(
      width: width,
      height: height,
      child: const Center(
        child: Icon(Icons.error),
      ),
    );

Widget _cachePlaceholder(BuildContext context, String url, {double? width, double? height}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Shimmer.fromColors(
    baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
    highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
    child: Container(width: width, height: height, color: isDark ? Colors.grey.shade800 : Colors.grey),
  );
}

class CachedConfig {
  final Widget Function(BuildContext context, String url, Object error, {double? width, double? height}) errorBuilder;

  /// 占位图
  final Widget Function(BuildContext context, String url, {double? width, double? height}) placeholder;

  const CachedConfig({
    this.errorBuilder = _errorBuilder,
    this.placeholder = _cachePlaceholder,
  });
}

class CachedImage extends StatefulWidget {
  final String? imageUrl;

  final String? assetUrl;

  final File? file;

  final double? width;

  final double? height;

  final BorderRadiusGeometry? borderRadius;

  final BoxFit? fit;

  final Color? imageColor;

  /// 内存图片
  final Uint8List? memory;

  final CachedConfig? config;

  final String? package;

  final FilterQuality filterQuality;

  const CachedImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit,
    this.assetUrl,
    this.imageColor,
    this.file,
    this.config,
    this.package,
    this.memory,
    this.filterQuality = FilterQuality.low,
  });

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  /// 全局缓存 ImageProvider 实例，避免重复创建和磁盘 I/O
  static final Map<String, CachedNetworkImageProvider> _providerCache = {};

  /// 图片是否已经在缓存中
  bool _isImageCached = false;

  /// 缓存的 ImageProvider，用于直接渲染已缓存的图片
  CachedNetworkImageProvider? _cachedProvider;

  @override
  void initState() {
    super.initState();
    _restoreOrCheckCache();
  }

  @override
  void didUpdateWidget(CachedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _isImageCached = false;
      _cachedProvider = null;
      _restoreOrCheckCache();
    }
  }

  void _restoreOrCheckCache() {
    if (utils.tools.isNotEmpty(widget.imageUrl) && _providerCache.containsKey(widget.imageUrl!)) {
      _isImageCached = true;
      _cachedProvider = _providerCache[widget.imageUrl!];
    } else {
      _checkImageCache();
    }
  }

  /// 检查图片是否已经在缓存中
  void _checkImageCache() {
    if (utils.tools.isNotEmpty(widget.imageUrl)) {
      final provider = CachedNetworkImageProvider(widget.imageUrl!);
      // 同步检查内存缓存
      final cacheKey = provider.obtainKey(ImageConfiguration.empty);
      cacheKey.then((key) {
        final cachedImage = PaintingBinding.instance.imageCache.containsKey(key);
        if (cachedImage && mounted) {
          setState(() {
            _isImageCached = true;
            _cachedProvider = provider;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(themeConfig.radius);

    if (widget.file != null) {
      if (widget.width != null && widget.height != null) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: Image(
            image: FileImage(File(widget.file!.path), scale: 2.0),
            fit: widget.fit,
            color: widget.imageColor,
            filterQuality: widget.filterQuality,
            width: widget.width,
            height: widget.height,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: borderRadius,
          child: Image(
            image: FileImage(File(widget.file!.path)),
            fit: widget.fit,
            color: widget.imageColor,
            filterQuality: widget.filterQuality,
            width: widget.width,
            height: widget.height,
          ),
        );
      }
    }

    if (utils.tools.isNotEmpty(widget.assetUrl)) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image(
          image: AssetImage(widget.assetUrl!, package: widget.package),
          fit: widget.fit,
          color: widget.imageColor,
          filterQuality: widget.filterQuality,
          width: widget.width,
          height: widget.height,
        ),
      );
    }

    if (widget.memory != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image(
          image: MemoryImage(widget.memory!),
          fit: widget.fit,
          color: widget.imageColor,
          filterQuality: widget.filterQuality,
          width: widget.width,
          height: widget.height,
        ),
      );
    }

    if (utils.tools.isNotEmpty(widget.imageUrl)) {
      // 如果图片已经在缓存中，直接使用 Image 组件渲染，完全跳过 placeholder
      if (_isImageCached && _cachedProvider != null) {
        return ClipRRect(
          borderRadius: borderRadius,
          child: Image(
            image: _cachedProvider!,
            width: widget.width,
            height: widget.height,
            fit: widget.fit,
            color: widget.imageColor,
            filterQuality: widget.filterQuality,
            gaplessPlayback: true, // 防止图片切换时闪烁
          ),
        );
      }

      return ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          width: widget.width,
          height: widget.height,
          imageUrl: widget.imageUrl!,
          filterQuality: widget.filterQuality,
          fit: widget.fit,
          // 防止从后台返回时闪白
          fadeInDuration: Duration.zero,
          fadeOutDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          useOldImageOnUrlChange: true,
          // 设置内存缓存尺寸，减少内存压力
          memCacheWidth: widget.width != null && widget.width!.isFinite ? (widget.width! * 2).toInt() : null,
          memCacheHeight: widget.height != null && widget.height!.isFinite ? (widget.height! * 2).toInt() : null,
          // 使用 imageBuilder 直接渲染图片，避免任何过渡动画
          imageBuilder: (context, imageProvider) {
            // 缓存 ImageProvider 实例
            if (widget.imageUrl != null && !_providerCache.containsKey(widget.imageUrl!)) {
              _providerCache[widget.imageUrl!] = CachedNetworkImageProvider(widget.imageUrl!);
            }
            // 图片加载完成后更新缓存状态
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_isImageCached) {
                setState(() {
                  _isImageCached = true;
                  _cachedProvider = CachedNetworkImageProvider(widget.imageUrl!);
                });
              }
            });
            return Image(
              image: imageProvider,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              color: widget.imageColor,
              filterQuality: widget.filterQuality,
              gaplessPlayback: true,
            );
          },
          placeholder: (BuildContext context, String url) => widget.config?.placeholder(context, url, width: widget.width, height: widget.height) ?? _cachePlaceholder(context, url, width: widget.width, height: widget.height),
          errorWidget: (BuildContext context, String url, Object error) => widget.config?.errorBuilder(context, url, error, width: widget.width, height: widget.height) ?? _errorBuilder(context, url, error, width: widget.width, height: widget.height),
        ),
      );
    }
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: borderRadius,
      child: Shimmer.fromColors(
        baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
        highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
        child: Container(width: widget.width, height: widget.height, color: isDark ? Colors.grey.shade800 : Colors.grey),
      ),
    );
  }
}
