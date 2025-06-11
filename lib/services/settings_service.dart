import 'package:hive/hive.dart';

class SettingsService {
  static const String boxName = 'settingsBox';
  static const String tipPercentageKey = 'defaultTipPercentage';
  static const String taxAmountKey = 'defaultTaxAmount';

  static Future<void> saveDefaultTipPercentage(double? percentage) async {
    final box = await Hive.openBox(boxName);
    if (percentage != null) {
      await box.put(tipPercentageKey, percentage);
    } else {
      await box.delete(tipPercentageKey);
    }
  }

  static Future<double?> getDefaultTipPercentage() async {
    final box = await Hive.openBox(boxName);
    return box.get(tipPercentageKey);
  }

  static Future<void> saveDefaultTaxAmount(double? tax) async {
    final box = await Hive.openBox(boxName);
    if (tax != null) {
      await box.put(taxAmountKey, tax);
    } else {
      await box.delete(taxAmountKey);
    }
  }

  static Future<double?> getDefaultTaxAmount() async {
    final box = await Hive.openBox(boxName);
    return box.get(taxAmountKey);
  }
}
