import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);
  static const routeName = '/payment-screen';

  @override
  Widget build(BuildContext context) {
    final orderTotal = ModalRoute.of(context)!.settings.arguments as String?;

    return Scaffold(
      body: Center(
        widthFactor: 10,
        heightFactor: 10,
        child: Container(
          decoration: BoxDecoration(
            //color: const Color(0xff7c94b6),
            border: Border.all(
              color: Colors.black,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          //padding: EdgeInsets.all(100),
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.5,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Great, that\'s \$$orderTotal',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black,
                    width: 1,
                  )),
                  child: ListView.separated(
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: Radio(
                            value: null,
                            groupValue: null,
                            onChanged: null,
                          ),
                          title: Text('item $index'),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          Divider(),
                      itemCount: 4),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextButton.icon(
                    label: Text('Finish and pay'),
                    icon: Icon(Icons.lock),
                    onPressed: () {
                      Provider.of<Cart>(context, listen: false).clearCart();
                      Navigator.popUntil(context,
                          (ModalRoute.withName(Navigator.defaultRouteName)));
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
