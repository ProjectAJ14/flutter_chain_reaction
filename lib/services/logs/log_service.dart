abstract class LogService {
  dynamic get service;

  void d(String message);

  void i(String message);

  void w(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);

  void e(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);

  void onRouteChange(String event, String screen);
}
