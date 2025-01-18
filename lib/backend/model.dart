class Product {
  final String? productId;
  final String productName;
  final String productDescription;
  final String productPrice;
 

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
    
  });

 
  Map<String, dynamic> toMap() {
    return {
      'productId':productId,
      'productName': productName,
      'productDescription': productDescription,
      'productPrice': productPrice,
      
    };
  }

  factory Product.form(Map<String,dynamic>data) {
  
    return Product(
      productName: data['productName'] ?? '',
      productDescription: data['productDescription'] ?? '',
      productPrice: data['productPrice'] ?? '',
      productId: data['productId'],
    );
  }
}
