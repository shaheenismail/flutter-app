import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/providers/auth_provider.dart';
import 'package:restaurant/providers/cart_provider.dart';
import 'package:restaurant/providers/supplier_provider.dart';
import 'package:restaurant/screens/cart_screen.dart';
import 'package:restaurant/screens/login_screens.dart';
import 'package:restaurant/screens/order_success_screen.dart';
import 'package:restaurant/screens/splash_screen.dart';
import 'package:restaurant/screens/supplier_detail_screen.dart';
import 'package:restaurant/screens/supplier_list_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => SupplierProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MaterialApp(
        title: 'Supplier App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/': (context) => const LoginScreen(),
          '/suppliers': (context) => const SupplierListScreen(),
          '/supplier-details': (context) => const SupplierDetailScreen(),
          '/cart': (context) => const CartScreen(),
          '/order-success': (context) => const OrderSuccessScreen(),
        },
      ),
    );
  }
}