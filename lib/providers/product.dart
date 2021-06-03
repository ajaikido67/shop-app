import 'package:flutter/foundation.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class Product extends ChangeNotifier {
  final String? id;
  final String? title;
  final String? description;
  final double price;
  final String? imageUrl;
  bool? isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavourite(String prodId, List prodFav) async {
    final url = Uri.https(
        'shopapp-133a1-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/users/hhghj88jjh.json');

    try {
      isFavorite = !isFavorite!;
      if (isFavorite!) {
        prodFav.add(prodId);
      } else {
        
        prodFav.removeWhere((id) => id == prodId);
      }
      await http.patch(url,
          body: convert.jsonEncode({
            'favouriteProds': prodFav,
          }));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
