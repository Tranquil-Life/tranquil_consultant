abstract class IRegistrationDataStore {
  Map<String, dynamic> get fields;
  void setField(String key, value);
  void updateFields(Map<String, dynamic> newValues);

}