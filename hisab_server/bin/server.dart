import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'package:hisab_server/services/database_service.dart'; 
import 'package:hisab_server/controllers/auth_controller.dart';
// ADD: Import the settings controller for your attributes logic
import 'package:hisab_server/controllers/settings_controller.dart';

void main(List<String> args) async {
  // Initialize your controllers
  final authCtrl = AuthController();
  final settingsCtrl = SettingsController();

  // 1. Define the Router
  final _router = Router()
    ..get('/', _rootHandler)
    ..get('/db-test', _dbTestHandler)
    ..post('/login', _loginHandler)
    ..post('/register-business', authCtrl.registerBusiness)
    // ADD: The route for saving the dynamic attributes from your Figma UI
    ..post('/setup/define-attributes', settingsCtrl.defineProductAttributes); 

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(_router);

  final server = await serve(handler, ip, port);
  
  print('--- HisabApp Full-Stack Engine ---');
  print('✅ Server live at: http://localhost:${server.port}/');
  print('-------------------------------------------');
  print('🚀 ACTIVE PATHS:');
  print('1. [GET]  /db-test              -> Check MySQL');
  print('2. [POST] /register-business    -> Company & Branch Setup');
  print('3. [POST] /setup/define-attributes -> Custom Product Fields');
  print('4. [POST] /login                -> User Authentication');
  print('-------------------------------------------');
}

// --- HANDLERS ---

Response _rootHandler(Request req) {
  return Response.ok(
    'HisabApp Backend is running!',
    headers: {'content-type': 'text/plain'},
  );
}

Future<Response> _dbTestHandler(Request request) async {
  final db = DatabaseService();
  try {
    final conn = await db.getConnection();
    await conn.query('SELECT 1'); 
    await conn.close();
    return Response.ok(jsonEncode({'status': 'connected'}), headers: {'content-type': 'application/json'});
  } catch (e) {
    return Response.internalServerError(body: jsonEncode({'error': e.toString()}), headers: {'content-type': 'application/json'});
  }
}

Future<Response> _loginHandler(Request request) async {
  // Your login logic here
  return Response.ok('Login logic running');
}