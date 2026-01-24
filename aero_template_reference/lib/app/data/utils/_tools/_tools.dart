part of '../utils.dart';

class _Tools {
  _Tools._();

  /// 传输存储
  ValueNotifier<List<DownloadModel>> downloads = ValueNotifier<List<DownloadModel>>([]);

  Future<void> init() async {
    await _getVersion();
  }

  /// 异常捕获
  Future<void> exceptionCapture(Function() cb, {void Function(DioException)? dioError, void Function(Object)? error}) async {
    try {
      await cb();
    } on DioException catch (e) {
      dioError != null ? dioError.call(e) : utils.error.dioError(e);
    } catch (e) {
      error != null ? error.call(e) : utils.error.error(e);
    }
  }

  /// 版本号
  String version = '';

  /// 是否是桌面
  bool isDesktop = (Platform.isMacOS || Platform.isWindows || Platform.isLinux) ? true : false;

  /// 是否是移动端
  bool isMobile = (Platform.isAndroid || Platform.isIOS) ? true : false;

  /// 获取版本号
  Future<void> _getVersion() async {
    // 获取包信息
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    // 获取版本号和构建号
    version = packageInfo.version;
  }

  String get platform {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isMacOS) {
      return 'macOS';
    } else if (Platform.isFuchsia) {
      return 'fuchsia';
    } else if (Platform.isLinux) {
      return 'linux';
    } else {
      return 'windows';
    }
  }

  String getSecrecyMobile(String mobile) {
    if (mobile.length < 11) return mobile;
    return mobile.replaceRange(3, 7, '****');
  }

  Future<double> _getTotalSizeOfFilesInDir(FileSystemEntity file) async {
    if (file is File && file.existsSync()) {
      int length = await file.length();
      return double.parse(length.toString());
    }
    if (file is Directory && file.existsSync()) {
      List children = file.listSync();
      double total = 0;
      if (children.isNotEmpty) {
        for (final FileSystemEntity child in children) {
          total += await _getTotalSizeOfFilesInDir(child);
        }
      }

      return total;
    }
    return 0;
  }

  /// 获取文件大小
  String getFileSize(int size, {int asFixed = 1}) {
    if (size < 1024) {
      return '$size B';
    } else if (size < 1024 * 1024) {
      return '${(size / 1024).toStringAsFixed(asFixed)} KB';
    } else if (size < 1024 * 1024 * 1024) {
      return '${(size / 1024 / 1024).toStringAsFixed(asFixed)} MB';
    } else {
      return '${(size / 1024 / 1024 / 1024).toStringAsFixed(asFixed)} GB';
    }
  }

  /// 获取缓存大小
  Future<String> getCacheSize() async {
    final tempDir = await getTemporaryDirectory();
    double size = await _getTotalSizeOfFilesInDir(tempDir);

    const List<String> unitArr = ['B', 'KB', 'MB', 'GB', 'TB'];
    int index = 0;
    while (size > 1024) {
      index++;
      size = size / 1024;
    }
    String v = size.toStringAsFixed(2);
    return v + unitArr[index];
  }

  /// 判断为null 或者空字符串
  bool isEmpty(dynamic data) {
    switch (data) {
      case int _:
        return data == 0;
      case String _:
        return data.isEmpty;
      default:
        return true;
    }
  }

  /// 判断为null 或者空字符串
  bool isNotEmpty(dynamic data) {
    return !isEmpty(data);
  }

  /// 判断包含数字/字母
  bool validCharacters(String str, {int min = 6, int max = 18}) {
    if (str.length < min || str.length > max) {
      return false;
    }
    final validCharacter = RegExp('^(?![0-9]+\$)(?![a-zA-Z]+\$)[0-9A-Za-z]');
    return validCharacter.hasMatch(str);
  }

  /// 验证手机号
  bool isPhone(String str) {
    return RegExp('^[1][3,4,5,6,7,8,9][0-9]{9}\$').hasMatch(str);
  }

  /// 数字超过10000转万
  ///
  /// [unit] 单位
  String formatNumber(int number, {String unit = '万'}) {
    if (number < 10000) {
      return number.toString();
    } else {
      return (number / 10000).toStringAsFixed(1) + unit;
    }
  }

  /// 判断值是否为空
  ///
  /// 如果为空则返回默认值
  ///
  /// 如果不为空则返回属性值
  T getValue<T>(T? obj, T defaultValue) {
    return obj == null
        ? defaultValue
        : obj is String
            ? obj.isEmpty
                ? defaultValue
                : obj
            : obj;
  }

  TextInputFormatter phoneInputFormatter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      String text = newValue.text;
      //获取光标左边的文本
      final positionStr = (text.substring(0, newValue.selection.baseOffset)).replaceAll(RegExp(r"\s+\b|\b\s"), "");
      //计算格式化后的光标位置
      int length = positionStr.length;
      var position = 0;
      if (length <= 3) {
        position = length;
      } else if (length <= 7) {
        // 因为前面的字符串里面加了一个空格
        position = length + 1;
      } else if (length <= 11) {
        // 因为前面的字符串里面加了两个空格
        position = length + 2;
      } else {
        // 号码本身为 11 位数字，因多了两个空格，故为 13
        position = 13;
      }

      //这里格式化整个输入文本
      text = text.replaceAll(RegExp(r"\s+\b|\b\s"), "");
      var string = "";
      for (int i = 0; i < text.length; i++) {
        // 这里第 4 位，与第 8 位，我们用空格填充
        if (i == 3 || i == 7) {
          if (text[i] != ' ') {
            string = '$string ';
          }
        }
        string += text[i];
      }

      return TextEditingValue(
        text: string,
        selection: TextSelection.fromPosition(TextPosition(offset: position, affinity: TextAffinity.upstream)),
      );
    });
  }

  /// 下载并保存文件
  Future<String> downloadAndSaveFile(String url, {CancelToken? cancelToken, String folder = 'downloads'}) async {
    String basename = p.basename(url);
    String savePath = p.join(utils.config.directory.path, folder, basename);

    /// 先检查文件是否存在
    if (await File(savePath).exists()) {
      return savePath;
    }

    DownloadModel downloadModel = DownloadModel(id: const Uuid().v4(), name: basename, progress: 0.0);

    downloads.value = [...downloads.value, downloadModel];

    await Dio().download(
      url,
      savePath,
      cancelToken: cancelToken,
      onReceiveProgress: (count, total) {
        var model = downloadModel.copyWith(progress: count / total);
        _updateDownloadModel(model);
      },
    );
    Future.delayed(2.seconds, () {
      _removeDownload(downloadModel.id);
    });
    return savePath;
  }

  void _removeDownload(String id) {
    downloads.value = downloads.value.where((v) => v.id != id).toList();
  }

  void _updateDownloadModel(DownloadModel updatedModel) {
    final index = downloads.value.indexWhere((v) => v.id == updatedModel.id);
    if (index != -1) {
      final updatedList = [...downloads.value];
      updatedList[index] = updatedModel;
      downloads.value = updatedList;
    }
  }
}
