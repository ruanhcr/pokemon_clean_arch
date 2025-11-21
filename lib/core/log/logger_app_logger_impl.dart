import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:pokemon_clean_arch/core/log/app_logger.dart';

@Singleton(as: AppLogger)
class LoggerAppLoggerImpl implements AppLogger {
  final logger = Logger(
    printer: PrettyPrinter(
      methodCount:
          0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
    ),
  );

  var messages = <String>[];

  @override
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      logger.d(message, error: error, stackTrace: stackTrace);

  @override
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      logger.e(message, error: error, stackTrace: stackTrace);

  @override
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      logger.i(message, error: error, stackTrace: stackTrace);

  @override
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
      logger.w(message, error: error, stackTrace: stackTrace);

  @override
  void append(dynamic message) {
    messages.add(message.toString());
  }

  @override
  void closeAppend() {
    if (messages.isNotEmpty) {
      info(messages.join('\n'));
      messages = [];
    }
  }
}
