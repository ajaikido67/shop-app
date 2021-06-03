import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

import '../model/screen_arguments.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key? key}) : super(key: key);
  static const routename = '/editProduct-screen';

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProductScreen> {
  FocusNode? _descFocusNode;
  FocusNode? _priceFocusNode;
  FocusNode? _imageUrlFocusNode;
  final _imageUrlController = TextEditingController();
  bool oneTimeRun = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  var _newProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0.0,
    imageUrl: '',
    isFavorite: null,
  );

  @override
  void dispose() {
    _descFocusNode!.dispose();
    _priceFocusNode!.dispose();
    _imageUrlFocusNode!.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments productItem =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    print('msg = ${productItem.message}');
    //print('url = ${productItem.productArg.imageUrl}');
    if (oneTimeRun) {
      _imageUrlController.text = productItem.productArg!.imageUrl!;

      _newProduct = Product(
          id: productItem.productArg!.id,
          title: productItem.productArg!.title,
          description: productItem.productArg!.description,
          price: productItem.productArg!.price,
          imageUrl: productItem.productArg!.imageUrl,
          isFavorite: productItem.productArg!.isFavorite);

      oneTimeRun = false;
    }
    //print('url2 = ${_imageUrlController.text}');

    return Scaffold(
      appBar: AppBar(
        title: productItem.message == 'edit'
            ? Text('Edit Product')
            : Text('Add Product'),
      ),
      floatingActionButton: IconButton(
        color: Colors.blue,
        iconSize: 45,
        icon: Icon(Icons.save),
        onPressed: () {
          print('_formkey_validate = ${_formKey.currentState!.validate()}');
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();
          setState(() {
            _isLoading = true;
          });
          print('IconSave = ${_newProduct.id}');
          Provider.of<Products>(context, listen: false)
              .updateProduct(
                  productItem.productArg!.id, _newProduct, productItem.message)
              .catchError((error) {
            return showDialog<Null>(
                context: context,
                builder: (ctx) => AlertDialog(
                      title: Text('Oh no'),
                      content: Text(error.toString()),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text('OK'))
                      ],
                    ));
          }).then((value) {
            setState(() {
              _isLoading = false;
            });
            Navigator.of(context).pop();
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: productItem.productArg!.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _newProduct = Product(
                            id: _newProduct.id,
                            title: newValue,
                            description: _newProduct.description,
                            price: _newProduct.price,
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite);
                        //print('title = ${_newProduct.title}');
                      },
                    ),
                    TextFormField(
                      initialValue: productItem.productArg!.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      textInputAction: TextInputAction.next,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _newProduct = Product(
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: newValue,
                            price: _newProduct.price,
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: productItem.productArg!.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocusNode);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number.';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number greater than zero.';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _newProduct = Product(
                            id: _newProduct.id,
                            title: _newProduct.title,
                            description: _newProduct.description,
                            price: double.parse(newValue!),
                            imageUrl: _newProduct.imageUrl,
                            isFavorite: _newProduct.isFavorite);
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            maxLines: null,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onEditingComplete: () {
                              setState(() {});
                            },

                            //   focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              // return;
                              // setState(() {});
                              //   _saveForm();
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpeg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (newValue) {
                              _newProduct = Product(
                                  id: _newProduct.id,
                                  title: _newProduct.title,
                                  description: _newProduct.description,
                                  price: _newProduct.price,
                                  imageUrl: newValue,
                                  isFavorite: _newProduct.isFavorite);
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
