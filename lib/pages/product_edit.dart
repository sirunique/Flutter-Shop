import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:section_1_widget/models/product.dart';
import 'package:section_1_widget/scoped-models/main.dart';

class ProductEditPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'name': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg' 
  };
  // final _nameFocusNode = FocusNode();
  // final _descriptionNode = FocusNode();
  // final _priceNode = FocusNode();

  Widget  _buildNameTextField(Product product){
    return TextFormField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(labelText: 'Product Name', ),
      initialValue: product == null ? '' : product.name,
      validator: (String value){
        if(value.isEmpty || value.length < 5){
          return 'Name is required and should ba 5+ characters long..';
        }
      },
      onSaved: (String value){
        _formData['name'] = value;
      },
    );
  }

  Widget _buildDescriptionTextField(Product product){
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Product Description'),
      initialValue: product == null ? '' : product.description,
      validator: (String value){
        if(value.isEmpty || value.length < 10 ){
          return 'Description is required and should be 10+ characters long..';
        }
      },
      onSaved: (String value){
        _formData['description'] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product product){
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: 'Product Price'),
      initialValue: product == null ? '' : product.price.toString(),
      validator: (String value){
        if(value.isEmpty || !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)){
          return 'Price is required and should ba a number';
        }
      },
      onSaved: (String value){
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildSubmitButton(){
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        return RaisedButton(
          child: Text('Save'),
          textColor: Colors.white,
          onPressed: () => _submitForm(model.addProduct, model.updateProduct, model.selectProduct, model.selectedProductIndex));
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product){
     return Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                _buildNameTextField(product),
                _buildDescriptionTextField(product),
                _buildPriceTextField(product),
                SizedBox(height: 10.0,),
                _buildSubmitButton()
              ],
            ),
          ),
        );
  }

  void _submitForm(Function addProduct, Function updateProduct, Function setSelectedProduct, [int selectedProductIndex]){
    if(!_formKey.currentState.validate()){
      return;
    }
    _formKey.currentState.save();
    if(selectedProductIndex == null){
      addProduct(
        _formData['name'], _formData['description'],
        _formData['price'], _formData['image'],
      );
    }
    else{
      updateProduct(
        _formData['name'], _formData['description'],
        _formData['price'], _formData['image'],
      );
    }

    Navigator
      .pushReplacementNamed(context, '/products')
      .then((_) => setSelectedProduct(null));

  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model){
        final Widget pageContent = _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == null
          ? pageContent
          : Scaffold(
            appBar: AppBar(
              title: Text('Edit Product'),
            ),
            body: pageContent,
          );

      },
    );
  }
}