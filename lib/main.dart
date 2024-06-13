import 'package:firebase_core/firebase_core.dart';
import 'package:flukefy/utils/colors.dart';
import 'package:flukefy/utils/firebase/firebase_default_options.dart';
import 'package:flukefy/view/screens/splash/splash_screen.dart';
import 'package:flukefy/view_model/auth_provider.dart';
import 'package:flukefy/view_model/brands_provider.dart';
import 'package:flukefy/view_model/buy_provider.dart';
import 'package:flukefy/view_model/cart_provider.dart';
import 'package:flukefy/view_model/products_provider.dart';
import 'package:flukefy/view_model/splash_provider.dart';
import 'package:flukefy/view_model/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SplashProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => BrandsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => BuyProvider()),
      ],
      child: MaterialApp(
        title: 'Flukefy',
        theme: ThemeData(
          primaryColor: AppColors.primaryColor,
          colorScheme: ColorScheme.light(primary: AppColors.primaryColor, secondary: AppColors.secondaryColor, surface: AppColors.backgroundColor),
          fontFamily: 'Averta',
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
