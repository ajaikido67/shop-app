import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/manage_product.dart';

import '../widgets/product_item.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  Favourites,
  All,
}

class ProductOverview extends StatefulWidget {
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  var _showOnlyFav = false;
  var isLoading = false;
  var _prodFav = [];

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });

    Provider.of<Products>(context, listen: false).loadInitProducts().then((_) {
      Future.delayed(Duration(seconds: 1), () {
        // not necessary statement..
        // just to show that the circular indicator works
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        _showOnlyFav ? productData.showFavItems : productData.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favourites) {
                  _showOnlyFav = true;
                } else {
                  _showOnlyFav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favourites'),
                value: FilterOptions.Favourites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOptions.All,
              )
            ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) {
              // print('I am buidling the badge');
              return Badge(child: ch, value: cart.itemCount.toString());
            },
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: AppBar().preferredSize.height,
              child: DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.only(left: 10),
              leading: Icon(Icons.edit),
              title: Text('Manage Products'),
              onTap: () {
                Navigator.of(context).pushNamed(ManageProductScreen.routename);
                // arguments: productData.items);
              },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 3 / 2,
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemCount: products.length,
              itemBuilder: (context, gIdx) => ChangeNotifierProvider.value(
                value: products[gIdx],
                child: ProductItem(_prodFav),
              ),
            ),
    );
  }
}
