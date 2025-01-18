import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';
import 'model.dart';


class AddProduct {
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  Uuid _uuid = Uuid();  

  Future<String> addProduct({
    required String productName,
    required String productDescription,
    required String productPrice,
  }) async {
    String productId = _uuid.v4();  

    try {
     
      Product product = Product(
        productId: productId,
        productName: productName,
        productDescription: productDescription,
        productPrice: productPrice,
      );

      
      await _firebaseFirestore.collection('products').doc(productId).set(product.toMap());

      return 'Product added successfully';
    } catch (e) {
      return 'Error adding product: $e';
    }
  }

  Future<Product?> getProduct(String productId) async {
    try {
    
      DocumentSnapshot snapshot = await _firebaseFirestore.collection('products').doc(productId).get();
      if (snapshot.exists) {
      
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return Product.form(data);  
      } else {
        return null;  
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }


    Future<List<Product>> getAllProducts() async {
    try {
     
      QuerySnapshot snapshot = await _firebaseFirestore.collection('products').get();

      List<Product> products = snapshot.docs.map((doc) {
        return Product.form(doc.data() as Map<String, dynamic>);
      }).toList();

      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return [];  
    }
  }

  Future<String> addProductToCart({
    required String id,  
  }) async {
    try {
    
      DocumentSnapshot productSnapshot = await _firebaseFirestore.collection('products').doc(id).get();

      if (productSnapshot.exists) {
        await _firebaseFirestore.collection(FirebaseAuth.instance.currentUser!.uid).doc(id).set(productSnapshot.data() as Map<String,dynamic>);

        return 'Product added to cart successfully';
      } else {
        
        return 'Item is not available';
      }
    } catch (e) {
      return 'Error adding product to cart: $e';
    }
  }


    Future<List<Product>> getUserCart() async {
    try {
      List<Product>now=[];
      String userId = FirebaseAuth.instance.currentUser!.uid;

     
      QuerySnapshot snapshot = await _firebaseFirestore.collection(userId).get();

      
      if (snapshot.docs.isEmpty) {
        return [];
      }

      for(var dataa in snapshot.docs){
          now.add(Product.form(dataa.data() as Map<String,dynamic>));
      }
      
     

      return now;
    } catch (e) {
      
      return [];
    }
  }
}
