import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product.dart';
import 'package:shop_app/screens/manage_product.dart';
import 'package:shop_app/screens/payment_screen.dart';

import 'screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());
// just testing
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.blueGrey,
          fontFamily: 'FiraSans',
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          PaymentScreen.routeName: (ctx) => PaymentScreen(),
          ManageProductScreen.routename: (ctx) => ManageProductScreen(),
          EditProductScreen.routename: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProductOverview();
  }
}
