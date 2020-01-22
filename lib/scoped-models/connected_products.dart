import 'dart:convert';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import '../models/product.dart';

// https://flutter-products-ad98c.firebaseio.com/
// https://flutter-products-ad98c.firebaseio.com/products.json

mixin ConnectedProductsModel on Model{
  List<Product> _products = [];
  int _selProductIndex;
  User _authenticatedUser;

  void addProduct(String name, String description, double price, String image,){
    final Map<String, dynamic> productData = {
      'name' : name, 'description' : description, 'price': price, 
      'image' : 'https://cdn.pixabay.com/photo/2015/10/02/12/00/chocolate-968457_960_720.jpg'
    };
    http.post(
      // 'https://flutter-products-ad98c.firebaseio.com/products.json',
      'https://flutter-products-ad98c.firebaseio.com/products.json',
       body : json.encode(productData)
    ).then((http.Response response){
       final Map<String, dynamic> responseData = json.decode(response.body);
       print(responseData);
    });
    // final Product newProduct = Product(
    //   id: ,
    //   name: name, description: description, price: price, image: image,
    //   userId: _authenticatedUser.id,
    //   userEmail: _authenticatedUser.email,
    // );
    // _products.add(newProduct);
    // notifyListeners();
  }

}

mixin ProductsModel on ConnectedProductsModel {
  bool _showFavorites = false;

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if(_showFavorites){
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selProductIndex;
  }

  Product get selectedProduct{
    if(selectedProductIndex == null){
      return null;
    }
    return _products[selectedProductIndex];
  }

  bool get displayFavoritesOnly{
    return _showFavorites;
  }

  void updateProduct(String name, String description, double price, String image){
    final Product updatedProduct = Product(
      name: name, description: description, price: price, image: image,
      userId: selectedProduct.userId, userEmail: selectedProduct.userEmail
    );
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void deleteProduct(){
    _products.removeAt(selectedProductIndex);
    notifyListeners();
  }

  void toggleProductFavoriteStatus(){
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      name: selectedProduct.name,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: selectedProduct.userEmail,
      userId: selectedProduct.userId,
      isFavorite: newFavoriteStatus
    );
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(int index){
    _selProductIndex = index;
    notifyListeners();
  }

  void toggleDisplayMode(){
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

}

mixin UserModel on ConnectedProductsModel {
  void login(String email, String password){
    _authenticatedUser = User(
      id: '100',
      email: email,
      password: password
    );
  }
}