import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/payment_screen.dart';
import '../providers/cart.dart';

class CartTotal extends StatelessWidget {
  const CartTotal({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      margin: EdgeInsets.all(10),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text('Total', style: TextStyle(fontSize: 20)),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Consumer<Cart>(
              builder: (context, cart, child) => Chip(
                elevation: 10,
                side: BorderSide(color: Colors.black, width: 4),
                label: Text(
                  '\$${cart.itemTotal.toStringAsFixed(2)}',
                  style: Theme.of(context).primaryTextTheme.headline6,
                ),
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, top: 10, bottom: 10),
            child: cart.itemTotal != 0
                ? TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        PaymentScreen.routeName,
                        arguments: cart.itemTotal.toStringAsFixed(2),
                      );
                    },
                    child: Text(
                      'Order Now',
                      //style: Theme.of(context).textTheme.headline4,
                    ),
                  )
                : null,
          )
        ],
      ),
    );
  }
}
