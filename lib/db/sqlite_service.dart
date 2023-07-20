import 'package:mysql_client/mysql_client.dart';
import 'package:project/db/encrypt.dart';
import 'package:project/models/connection.dart';
import 'package:project/models/user.dart';
import 'package:mysql_manager/src/mysql_manager.dart';

class SqliteService {
  Future<void> createUser(User user) async {
    print('connecting');
    final MySQLManager manager = MySQLManager.instance;
    final conn = await manager.init();
    print('connected');
    user.password = EncryptData.encryptAES(user.password);
    var res = await conn.execute(
      'INSERT INTO users (First_Name, Last_Name, Email_Address, Company,' +
          'Position, Password_user) values ("${user.firstname}", "${user.lastname}", ' +
          '"${user.email}", "${user.company}", "${user.position}", "${user.password}")',
    );
    print(res.affectedRows);
  }

  Future<List<Connection>?> allConnections() async {
    List<Connection>? connections = [];
    print('connecting');
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "",
      databaseName: "linkedin",
    );
    print('connecting');
    await conn.connect();
    var res = await conn.execute('SELECT * FROM connections');
    for (final row in res.rows) {
      connections.add(Connection(
          row.assoc()['First_Name']!,
          row.assoc()['Last_Name']!,
          row.assoc()['Email_Address']!,
          row.assoc()['Company']!,
          row.assoc()['Position']!,
          row.assoc()['Connection']!));
    }
    await conn.close();
    return connections;
  }
  /*
  Future<BigInt> createUser(User user) async {
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "linkedin",
    );
    await conn.connect();
    user.password = EncryptData.encryptAES(user.password);
    var res = await conn.execute(
      'INSERT INTO users (First_Name, Last_Name, Email_Address, Company,' +
          'Position, Password_user) values ("${user.firstname}", "${user.lastname}", ' +
          '"${user.email}", "${user.company}", "${user.position}", "${user.password}")',
    );

    print(res.affectedRows);

    await conn.close();
    return res.affectedRows;
  }

  Future<User?> login(String email, String password) async {
    User? user = null;
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "linkedin",
    );
    await conn.connect();
    password = EncryptData.encryptAES(password);
    print(
        'SELECT * FROM users WHERE Email_Address = "$email" AND Password_user = "$password")');
    var res = await conn.execute(
        'SELECT * FROM users WHERE Email_Address = "$email" AND Password_user = "$password"');
    for (final row in res.rows) {
      user = User.login(row.assoc()['Email_Address']!);
    }
    print(user?.email);
    await conn.close();
    return user;
  }

  Future<List<Connection>?> allConnections() async {
    List<Connection>? connections = [];
    print('connecting');
    final conn = await MySQLConnection.createConnection(
      host: "127.0.0.1",
      port: 3306,
      userName: "root",
      password: "password",
      databaseName: "linkedin",
    );
    print('connecting');
    await conn.connect();
    var res = await conn.execute('SELECT * FROM connections');
    for (final row in res.rows) {
      connections.add(Connection(
          row.assoc()['First_Name']!,
          row.assoc()['Last_Name']!,
          row.assoc()['Email_Address']!,
          row.assoc()['Company']!,
          row.assoc()['Position']!,
          row.assoc()['Connection']!));
    }
    await conn.close();
    return connections;
  }*/
}
