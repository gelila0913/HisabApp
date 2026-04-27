import 'package:mysql1/mysql1.dart';

class DatabaseService {
  // Connection settings for your XAMPP MySQL
  // We use 127.0.0.1 (localhost) and port 3306 (standard MySQL port)
  final ConnectionSettings settings = ConnectionSettings(
    host: '127.0.0.1', 
    port: 3306,
    user: 'root',      // Default XAMPP user
    // password: '',      // Default XAMPP password is empty
    db: 'hisab_app',   // The database name from your phpMyAdmin screenshot
  );

  // This function returns a connection that we can use to run queries
  Future<MySqlConnection> getConnection() async {
    try {
      return await MySqlConnection.connect(settings);
    } catch (e) {
      print('Database Connection Error: $e');
      rethrow;
    }
  }
}