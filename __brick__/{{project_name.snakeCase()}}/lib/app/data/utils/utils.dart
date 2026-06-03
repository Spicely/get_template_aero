import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile, Value;
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../components/cached_image/cached_image.dart';
import '../../components/dialog/permission_dialog/permission_dialog.dart';
import '../../components/dialog/upgrade_dialog/upgrade_dialog.dart';
import '../../components/theme_config/theme_config.dart';
import '../database/config_manager/config_manager.dart';
import '../database/database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import '../exception/permission_exception.dart';
import '../exception/toast_exception.dart';
import '../exception/login_cancel_exception.dart';
import '../exception/insufficient_points_exception.dart';
import '../mixins/permission_mixin.dart';
import '../models/sdk_config_model/sdk_config_model.dart';
import '../models/download_model/download_model.dart';
import '../models/upgrade_model/upgrade_model.dart';

import '../config/config.dart' as config;

part './_db.dart';
part '_apis.dart';
part '_config.dart';
part '_error.dart';
part '_extend_theme_config.dart';
part '_extend_upgrade.dart';
part '_plugins.dart';
part '_tools/_http.dart';
part '_tools/_tools.dart';
part '_tools/_upgrade.dart';

class _Utils {
  _Utils._();

  final _Tools tools = _Tools._();

  final _ExtendUpgrade upgrade = _ExtendUpgrade._();

  final Logger logger = Logger(printer: PrettyPrinter(methodCount: 3, errorMethodCount: 8, lineLength: 120, colors: true, printEmojis: true));

  final _Config config = _Config._();

  final _Error error = _Error._();

  final _Plugins plugins = _Plugins._();

  late _Apis apis = _Apis._();

  final _DB db = _DB._();

  Future<void> init() async {
    await config.init();
    await plugins.init();
    await tools.init();
    await db.init();
    apis.init();
    _ExtendThemeConfig._().init();
  }
}

final utils = _Utils._();
