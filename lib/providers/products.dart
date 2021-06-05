import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://lp2.hm.com/hmgoepprod?set=quality%5B79%5D%2Csource%5B%2F71%2F46%2F7146b64727fa808d7c2b4506102343785a6ffd99.jpg%5D%2Corigin%5Bdam%5D%2Ccategory%5Bmen_tshirtstanks_shortsleeve%5D%2Ctype%5BDESCRIPTIVESTILLLIFE%5D%2Cres%5Bm%5D%2Chmver%5B1%5D&call=url[file:/product/main] ',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get showFavItems {
    return _items.where((element) => element.isFavorite!).toList();
  }

  Future<void> loadInitProducts() async {
    List favData = [];
    final prodUrl = Uri.https(
        'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json');

    final favUrl = Uri.https(
        'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/users//hhghj88jjh.json');

    try {
      final favResponse = await http.get(favUrl);
      // final ww = convert.jsonDecode(favResponse.body)['favouriteProds'];
      // print('favresponse is = $ww');
      if (convert.jsonDecode(favResponse.body) != null) {
       // print('success');
        if (convert.jsonDecode(favResponse.body)['favouriteProds'] != null) {
          favData =
              convert.jsonDecode(favResponse.body)['favouriteProds'] as List;
        }
      }
      

      final response = await http.get(prodUrl);
      final extractedData =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, value) {
        _items.add(Product(
            id: prodId,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: favData.indexOf(prodId) > -1
                ? true
                : false)); // value['isFavourite']));
      });

      notifyListeners();
    } catch (error) {
      print('there is a $error');
      //   throw error;
    }
  }

  Future<void> removeProduct(String? id) async {
    final url = Uri.parse(
        'https://shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');

    try {
      await http.delete(url);
      _items.removeWhere((prod) => prod.id == id);
      notifyListeners();
    } catch (error) {
      print('error = $error');

      throw error;
    }
  }

  findById(String? productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  Future<void> updateProduct(
      String? id, Product newProduct, String editMode) async {
    if (editMode == 'edit') {
      try {
        final url = Uri.https(
            'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
            '/products/$id.json');
        await http.patch(url,
            body: convert.jsonEncode({
              'title': newProduct.title,
              'description': newProduct.description,
              'price': newProduct.price,
              'imageUrl': newProduct.imageUrl,
            }));
        _items[_items.indexWhere((product) => product.id == id)] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    } else {
      // edit mode = 'add'
      try {
        final url = Uri.https(
            'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
            '/products.json');
        final response = await http.post(
          url,
          body: convert.jsonEncode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'isFavourite': newProduct.isFavorite,
          }),
        );
        newProduct = Product(
            id: convert.jsonDecode(response.body)['name'],
            title: newProduct.title,
            description: newProduct.description,
            price: newProduct.price,
            imageUrl: newProduct.imageUrl);

        print('newProdID = ${newProduct.id}');

        _items.add(newProduct);
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }
}
