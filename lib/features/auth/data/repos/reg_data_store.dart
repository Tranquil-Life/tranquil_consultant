import 'package:tl_consultant/features/auth/domain/repos/reg_data_store.dart';
import 'package:tl_consultant/core/data/store.dart';

abstract class _Keys {
  static const fields = 'fields';
}

RegistrationDataStore registrationDataStore = RegistrationDataStore();

class RegistrationDataStore extends IRegistrationDataStore {
  @override
  Map<String, dynamic> get fields =>
      getStore.get(_Keys.fields) ?? <String, dynamic>{};

  @override
  void setField(String key, value) {
    Map<String, dynamic> updatedMap = Map<String, dynamic>.from(fields);
    updatedMap[key] = value;
    getStore.set(_Keys.fields, updatedMap);
  }

  @override
  void updateFields(Map<String, dynamic> newValues) {
    final updatedMap = Map<String, dynamic>.from(fields)..addAll(newValues);
    getStore.set(_Keys.fields, updatedMap);
  }
}
