import 'package:flutter/widgets.dart';
import '../../l10n/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  String get langCode => Localizations.localeOf(this).languageCode;
}