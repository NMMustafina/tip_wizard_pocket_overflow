import 'package:hive/hive.dart';
import '../models/check_model.dart';

class CheckService {
  static const String boxName = 'checks';

  Future<void> addCheck(CheckModel check) async {
    final box = await Hive.openBox<CheckModel>(boxName);
    await box.add(check);
  }

  Future<List<CheckModel>> getChecks() async {
    final box = await Hive.openBox<CheckModel>(boxName);
    return box.values.toList();
  }

  Future<void> deleteCheck(int index) async {
    final box = await Hive.openBox<CheckModel>(boxName);
    await box.deleteAt(index);
  }
}
