class MyDataBase{
  static final String DB_NAME1 = "luluflutterapp";
  static final List<String> dbTables = [DB_TABLE_FRIEND];
  static final List<String> dbSql = [friend];

  static final String DB_TABLE_FRIEND = "friend";
  static final String friend = 'CREATE TABLE friend (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, sex TEXT, birthday TEXT, university TEXT, address TEXT)';

}