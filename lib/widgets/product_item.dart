import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

import 'package:shop_app/providers/product.dart';
import '../screens/product_detail_screen.dart';

// ignore: must_be_immutable
class ProductItem extends StatelessWidget {
  final List prodFav;

  ProductItem(this.prodFav);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Color.fromRGBO(0, 153, 255, 0.5),
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
          leading: Consumer<Product>(
            builder: (context, product, child) => IconButton(
              icon: (Icon(
                product.isFavorite! ? Icons.favorite : Icons.favorite_border,
              )),
              onPressed: () {
                product.toggleFavourite(product.id!, prodFav);
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added to Cart'),
                  action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        cart.removeCartItem(product.id);
                      }),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
