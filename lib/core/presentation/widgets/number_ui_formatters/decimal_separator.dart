import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';

/// Returns the decimal separator for current locale
/// Defaults to '.' if locale is not found
String get currentDecimalSep {
  final locale = Intl.defaultLocale?.replaceAll('-', '_') ?? 'en';
  return numberFormatSymbols[locale]?.DECIMAL_SEP ?? '.';
}