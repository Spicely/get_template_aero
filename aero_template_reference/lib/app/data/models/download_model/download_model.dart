class DownloadModel {
  final String id;

  /// 文件名
  final String name;

  /// 下载进度
  final double progress;

  DownloadModel({required this.id, required this.name, required this.progress});

  copyWith({double? progress}) => DownloadModel(
        id: id,
        name: name,
        progress: progress ?? this.progress,
      );
}
