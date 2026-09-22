import 'package:flutter/foundation.dart';
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
      logger: TalkerLogger(
        settings: TalkerLoggerSettings(enableColors: true),
        filter: isProd
            ? const LogLevelFilter(LogLevel.error)
            : query != null
                ? QueryFilter(query)
                : const LogLevelFilter(LogLevel.debug),
        output: debugPrint,
      ),
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
    service.logCustom(RouteLog('$event : $screen'));
  }
}

class RouteLog extends TalkerLog {
  RouteLog(super.message) : super(title: 'ROUTE');

  @override
  AnsiPen get pen => AnsiPen()..rgb(r: 185, g: 68, b: 36);
}
