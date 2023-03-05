import 'package:get_it/get_it.dart';

import 'logs/log_service_impl.dart';

final getIt = GetIt.instance;

void initDependencies() {
  getIt.registerSingleton<LogService>(LogServiceImpl(false));
}

LogService get logger => getIt.get();
