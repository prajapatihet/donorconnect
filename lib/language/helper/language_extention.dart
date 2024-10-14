import 'package:flutter/material.dart' show BuildContext;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppLocalizationExtention on BuildContext {
  AppLocalizations get localizedString => AppLocalizations.of(this);
}
