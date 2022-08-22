import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:microtask/enums/gender_enum.dart';
import 'package:microtask/enums/task_enum.dart';

class EnumTranslateServices {
  static String translateTaskStatus(BuildContext context, TaskStatus status) {
    switch (EnumToString.convertToString(status).toLowerCase()) {
      case 'doing':
        return AppLocalizations.of(context)?.doing ?? '';
      case 'done':
        return AppLocalizations.of(context)?.done ?? '';
      case 'undone':
        return AppLocalizations.of(context)?.undone ?? '';
      default:
        return AppLocalizations.of(context)?.todo ?? '';
    }
  }

  static String translateTaskRepeatType(BuildContext context, RepeatType type) {
    switch (EnumToString.convertToString(type).toLowerCase()) {
      case 'daily':
        return AppLocalizations.of(context)?.daily ?? '';
      case 'weekly':
        return AppLocalizations.of(context)?.weekly ?? '';
      case 'monthly':
        return AppLocalizations.of(context)?.monthly ?? '';
      case 'yearly':
        return AppLocalizations.of(context)?.yearly ?? '';
      default:
        return AppLocalizations.of(context)?.none ?? '';
    }
  }

  static String translateGender(BuildContext context, Gender gender) {
    if (EnumToString.convertToString(gender).toLowerCase() == 'male') {
      return AppLocalizations.of(context)?.male ?? '';
    }
    return AppLocalizations.of(context)?.female ?? '';
  }
}
