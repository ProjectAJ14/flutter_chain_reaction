import 'package:talker_flutter/talker_flutter.dart';

class QueryFilter implements TalkerLoggerFilter {
  const QueryFilter(this.query);

  final String query;

  @override
  bool shouldLog(dynamic msg, LogLevel level) {
    return msg.toString().toLowerCase().contains(query.toLowerCase());
  }
}
