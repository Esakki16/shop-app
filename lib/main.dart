import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/cart_screen.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/pro_products.dart';
import './providers/auth.dart';
import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';
import './helpers/custom_route.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProProducts>(
          create: (ctx) => ProProducts(),
          update: (ctx, auth, pr) =>
              pr!..update(auth.token, pr.items, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(),
          update: (ctx, auth, or) =>
              or!..update(auth.token!, or.orders, auth.userId!),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((ctx, auth, _) => MaterialApp(
              title: 'My Shop',
              theme: ThemeData(
                primarySwatch: Colors.pink,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android : CustomPageTransitionBuilder(),
                  TargetPlatform.iOS : CustomPageTransitionBuilder(),
                }),
              ),
              home: auth.isAuth
                  ? ProductOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authSnapshot) =>
                          authSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? const SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => const CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
                //AuthScreen.routeName: (ctx) => AuthScreen(),
              },
            )),
      ),
    );
  }
}
