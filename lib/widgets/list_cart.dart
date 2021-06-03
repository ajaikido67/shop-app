import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class ListCart extends StatefulWidget {
  const ListCart({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _ListCartState createState() => _ListCartState();
}

class _ListCartState extends State<ListCart> {
  // @override
  // void initState() {
  //   Provider.of<Cart>(context, listen: false).loadInitCart().then((_) {
  //     print('loading init cart');
  //   });

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var _cartList = widget.cart.items.values.toList();

    return Container(
      child: Card(
        elevation: 10,
        margin: EdgeInsets.all(10),
        child: ListView.separated(
          separatorBuilder: (BuildContext context, int index) => Divider(
            thickness: 4,
          ),
          itemCount: _cartList.length,
          itemBuilder: (ctx, i) {
            return Dismissible(
              key: ValueKey(_cartList[i].id),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Theme.of(context).errorColor,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              ),
              onDismissed: (direction) {
                //  Provider.of<Cart>(context, listen: false)
                widget.cart.removeItem(
                  widget.cart.items.keys.toList()[i],
                  _cartList[i].quantity,
                );
              },
              confirmDismiss: (direction) => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('No')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text('Yes')),
                  ],
                  title: Text('Are you sure?'),
                  content: Text('Do you want to delete?'),
                ),
              ),
              child: SizedBox(
                height: 50,
                child: Row(
                  children: [
                    Consumer<Cart>(
                      builder: (_, cart, __) => Checkbox(
                        checkColor: Colors.black45,
                        value: _cartList[i].orderStatus,
                        tristate: false,
                        onChanged: (bool? value) {
                          _cartList[i].orderStatus = value;
                          cart.updateOrderStatus(
                              widget.cart.items.keys.toList()[i], value);
                        },
                      ),
                    ),
                    Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text('${_cartList[i].title}'),
                        )),
                    Expanded(child: Text('${_cartList[i].quantity}')),
                    Expanded(
                      child: Text(
                          '${(_cartList[i].price * _cartList[i].quantity).toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
