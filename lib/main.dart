import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/home.dart';
import 'pages/menu.dart';
import 'pages/order.dart';
import 'pages/details.dart';
import 'pages/cart.dart';
import 'pages/order_history.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // remove barra de navegação do Android
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bom Hamburguer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.black,
          secondary: Colors.red,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Home(),
        '/menu': (context) => MenuPage(),
        '/order': (context) => OrderPage(),
        '/details': (context) => DetailsPage(),
        '/cart': (context) => CartPage(),
        '/history': (context) => OrderHistory(),
      },
    );
  }
}
