abstract class IStore {
  set (String key, dynamic val);
  get (String key);
  Future<void> clearAllData();

}
