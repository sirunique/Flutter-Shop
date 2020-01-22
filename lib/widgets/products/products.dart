import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:section_1_widget/models/product.dart';
import 'package:section_1_widget/scoped-models/main.dart';
import 'package:section_1_widget/widgets/products/product_card.dart';

class Products extends StatelessWidget{
  Widget _buildProductList(List<Product> products){
    Widget productCards;

    if(products.length > 0 ){
      productCards = ListView.builder(
        itemCount: products.length,
        itemBuilder: (BuildContext context, int index) => ProductCard(products[index], index),
      );
    }
    else{
      productCards = Container();    
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}