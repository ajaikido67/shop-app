import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import '../model/screen_arguments.dart';
import 'package:uuid/uuid.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product.dart';

class ManageProductScreen extends StatefulWidget {
  // const ManageProductScreen({Key key}) : super(key: key);
  static const routename = '/manageProduct-screen';

  @override
  _ManageProductScreenState createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  Uuid uuid = Uuid();

  // String prodId;
  Product? _initValues;

  // @override
  // void didChangeDependencies() {
  //   prodId = uuid.v1();
  //   _initValues = Product(
  //       id: prodId, title: '', description: '', price: 0.0, imageUrl: '');
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    //final productItems =
    // ModalRoute.of(context).settings.arguments as List<Product>;
    final productItems = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Product'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _initValues = Product(
                    id: '',
                    title: '',
                    description: '',
                    price: 0.0,
                    imageUrl: '');
                print('id = ${_initValues!.id}');
                Navigator.of(context).pushNamed(
                  EditProductScreen.routename,
                  arguments: ScreenArguments(_initValues, 'add'),
                );
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: ListView.separated(
          itemCount: productItems.items.length,
          separatorBuilder: (BuildContext context, int index) {
            return Divider();
          },
          itemBuilder: (BuildContext context, int index) =>
              ChangeNotifierProvider.value(
            value: productItems.items[index],
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      height: 25,
                      width: 25,
                      child:
                          Image.network(productItems.items[index].imageUrl!)),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${productItems.items[index].title}'),
                  ),
                ),
                Expanded(
                    child: SizedBox(
                        width: 70,
                        child:
                            Text('${productItems.items[index].description}'))),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text('\$${productItems.items[index].price}'),
                )),
                Expanded(
                    child: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      EditProductScreen.routename,
                      arguments:
                          ScreenArguments(productItems.items[index], 'edit'),
                    );
                  },
                )),
                Expanded(
                    child: IconButton(
                  icon: Icon(Icons.delete_forever),
                  onPressed: () async {
                    try {
                      await productItems
                          .removeProduct(productItems.items[index].id);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 1),
                          backgroundColor: Theme.of(context).errorColor,
                          content: Text(
                            'Deletion failed!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                      // throw error;
                    }
                  },
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
