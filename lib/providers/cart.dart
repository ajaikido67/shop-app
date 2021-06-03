import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class CartItem {
  final String id;
  final String? title;
  final int quantity;
  final double price;
  bool? orderStatus;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    this.orderStatus = false,
  });
}

class Cart with ChangeNotifier {
  Map<String?, CartItem> _items = {};
  int i = 0;
  bool orderStatus = false;
  bool initLoad = true;
  List _orderItems = [];

  Future<void> loadInitCart() async {
    try {
      final cartUrl = Uri.https(
          'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/users/hhghj88jjh.json');
      final response = await http.get(cartUrl);
      if (convert.jsonDecode(response.body) == null) {
        return;
      }

      if (convert.jsonDecode(response.body)['cart'] != null) {
        final savedCart = convert.jsonDecode(response.body)['cart'] as List;
        i = 0;
        savedCart.forEach((e) {
          _items.putIfAbsent(
            e['id'],
            () => CartItem(
                id: e['id']!,
                title: e['title'],
                quantity: e['quantity'],
                price: e['price']),
          );
          i = i + int.parse(e['quantity'].toString());
        });
        //print('_items on initLoad = $_items');
      }
    } catch (error) {
      throw error;
    }
  }

  Map<String?, CartItem> get items {
    //  loadInitCart();
    return {..._items};
  }

  void clearCart() {
    _items = {};
    i = 0;
    notifyListeners();
  }

  void updateOrderStatus(String? productId, bool? orderStatus) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingItem) => CartItem(
              id: existingItem.id,
              title: existingItem.title,
              quantity: existingItem.quantity,
              price: existingItem.price,
              orderStatus: orderStatus));
    }
    notifyListeners();
  }

  Future<void> addItem(
    String? productId,
    double price,
    String? title,
  ) async {
    try {
      if (_items.containsKey(productId)) {
        // var itemQty = _items[productId];

        _items.update(
            productId,
            (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                quantity: existingItem.quantity + 1,
                price: existingItem.price));
        // await http.patch(cartUrl,
        //    body: convert.jsonEncode({productId: itemQty!.quantity + 1}));
      } else {
        print('item add');
        _items.putIfAbsent(
          productId,
          () =>
              CartItem(id: productId!, title: title, quantity: 1, price: price),
        );
      }
      print('_items in add module = $_items');
      _orderItems = _items.entries
          .map((e) => {
                'id': e.key!,
                'title': e.value.title,
                'quantity': e.value.quantity,
                'price': e.value.price
              })
          .toList();

      print('_orderItems = $_orderItems');
      String jj = DateTime.now().toIso8601String();
      print(jj);
      final cartUrl = Uri.https(
          'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/users/hhghj88jjh.json');
      await http.patch(cartUrl,
          body: convert.jsonEncode({'cart': _orderItems}));
    } catch (error) {
      print(error);
    }

    i++;
    notifyListeners();
  }

  Future<void> removeCartItem(String? productId) async {
    if (!_items.containsKey(productId)) {
      return;
    }
    final urlPatch = Uri.https(
        'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/users/hhghj88jjh/cart.json');

    if (_items[productId]!.quantity > 1) {
      await http.patch(urlPatch,
          body:
              convert.jsonEncode({productId: _items[productId]!.quantity - 1}));

      _items.update(productId, (cartItem) {
        return CartItem(
            id: cartItem.id,
            title: cartItem.title,
            quantity: cartItem.quantity - 1,
            price: cartItem.price);
      });
    } else {
      final urlDelete = Uri.https(
          'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
          '/users/hhghj88jjh/cart/$productId.json');
      await http.delete(urlDelete);
      _items.remove(productId);
    }

    i--;
    notifyListeners();
  }

  int get itemCount {
    if (initLoad) {
      loadInitCart();
      initLoad = !initLoad;
      print('initLoad = $initLoad');
    }
    return i;
  }

  double get itemTotal {
    var total = 0.0;
    _items.forEach((key, item) {
      if (item.orderStatus!) {
        total += item.quantity * item.price;
      }
    });
    return total;
  }

  Future<void> removeItem(String? id, int cartItemQty) async {
    _items.remove(id);
    i = i - cartItemQty;
    final urlDelete = Uri.https(
        'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/users/hhghj88jjh/cart/$id.json');
    await http.delete(urlDelete);
    notifyListeners();
  }
}
