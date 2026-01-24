part of 'utils.dart';

class _ExtendThemeConfig {
  _ExtendThemeConfig._();

  void init() {
    themeConfig.loadFailWidget = errorWidget;
  }

  /// 加载失败
  Widget errorWidget(BuildContext context, Object error, Function() reload) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CachedImage(assetUrl: 'assets/images/notwork.png', width: 196),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: reload, child: const Text('重试')),
        ],
      ),
    );
  }
}
