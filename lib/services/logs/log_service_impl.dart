import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'log_service.dart';
import 'utils/query_filter.dart';

export 'log_service.dart';

class LogServiceImpl implements LogService {
  late Talker _talker;

  LogServiceImpl(
    bool isProd, {
    String? query,
  }) {
    _talker = Talker(
      loggerFilter: isProd
          ? const LogLevelTalkerLoggerFilter(LogLevel.error)
          : query != null
              ? QueryFilter(query)
              : const LogLevelTalkerLoggerFilter(LogLevel.debug),
      loggerSettings: const TalkerLoggerSettings(enableColors: true),
      loggerOutput: debugPrint,
    );
  }

  @override
  Talker get service => _talker;

  @override
  void d(String message) {
    service.debug(message);
  }

  @override
  void i(String message) {
    service.info(message);
  }

  @override
  void w(String message, [Object? error, StackTrace? stackTrace]) {
    service.warning(message, error, stackTrace);
  }

  @override
  void e(String message, [Object? error, StackTrace? stackTrace]) {
    service.error(message, error, stackTrace);
  }

  @override
  void onRouteChange(String event, String screen) {
    service.logTyped(RouteLog('$event : $screen'));
  }
}

class RouteLog extends FlutterTalkerLog {
  RouteLog(String message) : super(message);

  @override
  AnsiPen get pen => AnsiPen()..rgb(r: 185, g: 68, b: 36);

  @override
  Color get color => const Color(0xFFB94424);

  @override
  String get title => 'ROUTE';
}
