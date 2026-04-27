import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

// Controllers
import 'package:hisab_server/controllers/auth_controller.dart';
import 'package:hisab_server/controllers/settings_controller.dart';
import 'package:hisab_server/controllers/branch_controller.dart';
import 'package:hisab_server/controllers/product_controller.dart';

void main() async {
  // Initialize Controllers
  final authCtrl = AuthController();
  final settingsCtrl = SettingsController();
  final branchCtrl = BranchController(); 
  final productCtrl = ProductController();

  final router = Router()
    // --- Onboarding & Auth ---
    ..post('/register-business', authCtrl.registerBusiness)
    ..post('/setup/define-attributes', settingsCtrl.defineProductAttributes)
    ..post('/signup', authCtrl.signUp)
    ..post('/login', authCtrl.login) 
    
    // --- Branch Management ---
    ..post('/get-branches', branchCtrl.getCompanyBranches) 
    ..post('/add-branch', branchCtrl.addBranch)

    // --- Product & Inventory Management ---
    ..post('/add-product', productCtrl.addProduct)          // For "Add Product" form
    ..post('/get-branch-stock', productCtrl.getBranchProducts) // For Dashboard cards
    ..post('/update-stock', productCtrl.updateStock);       // NEW: For "Add Stock" popup

  // Setup Pipeline
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addHandler(router.call); 

  // Start Server
  final ip = InternetAddress.anyIPv4;
  final port = 8080;
  final server = await serve(handler, ip, port);

  print('✅ Server live at: http://${server.address.address}:${server.port}');
}