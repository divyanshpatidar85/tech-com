import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simpleapp/Custom/textfield.dart';
import 'package:simpleapp/Screen/qr.dart';
import 'package:simpleapp/backend/add-product.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String qrCodeId = "";

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      String productName = _productNameController.text;
      String productDescription = _productDescriptionController.text;
      String productPrice = _productPriceController.text;

      String res = await AddProduct().addProduct(
        productName: productName,
        productDescription: productDescription,
        productPrice: productPrice,
      );

      if (res == "Product added successfully") {
        _productNameController.clear();
        _productDescriptionController.clear();
        _productPriceController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Product Added: $productName\nPrice: $productPrice"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

     
        

      } else {
        // Show error message using Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text('Add Product'),
          trailing: Container(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScannerWidget()),
                );
              },
              child: Text(
                'Scan',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Information',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _productNameController,
                        labelText: 'Product Name',
                        hintText: 'Enter Product Name',
                        customValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _productDescriptionController,
                        labelText: 'Product Description',
                        hintText: 'Enter Product Description',
                        maxLines: 4,
                        customValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        controller: _productPriceController,
                        labelText: 'Product Price',
                        hintText: 'Enter Product Price',
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        customValidator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the product price';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: Text(
                          'Add Product',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
