import 'package:logger/logger.dart';

Logger logger = Logger(
  // filter: null, // Use the default LogFilter (-> only log in debug mode)
  printer: PrefixPrinter(
      PrettyPrinter(
        colors: true,
        printEmojis: true,
        printTime: false,
        methodCount: 0,
        errorMethodCount: 5,
      ),
      debug: "[Firebase Multi Factor Auth]",
      info: "[Firebase Multi Factor Auth]",
      error: "[Firebase Multi Factor Auth | ERROR]"),
);
