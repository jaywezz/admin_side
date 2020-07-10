import 'package:adminside/models/categoriesData.dart';
import 'package:adminside/models/orderDetailsData.dart';
import 'package:adminside/models/ordersData.dart';
import 'package:adminside/models/productsData.dart';
import 'package:adminside/models/userData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class DataBaseService{
  final CollectionReference productCollection = Firestore.instance.collection('products');
  final Query productCategoryQuery = Firestore.instance.collection('products').where("category", isEqualTo: 'eateries');
  final CollectionReference CategoryQuery = Firestore.instance.collection('categories');



  void uploadProduct(String productName, String description, String category, int quantity, double price, List images){
    var id = Uuid();
    String productId = id.v1();

    productCollection.document(productId).setData({
      'productName' : productName,
      'id' : productId,
      'description' : description,
      'category' : category,
      'price' : price,
      'quantity' : quantity,
      'images' : images,
      'hasSize' : null,
      'hasColor' : 'red',
      'available' : 2,
      'hasRating' : 2,

    });
  }
//
//  void createSubCategory(String category, String subCategory) async{
//
//    //Get a list of all categories
//       getCategory(category);
////    _categoryCollection.collection('categories').document(category).setData({'category': category, 'subCategories': subCategory});
//
//  }



  Future createSubCategory(String category, String subCategory){
    final Query available_categories = Firestore.instance.collection('categories').where("category", isEqualTo: category);

    return available_categories.getDocuments().then((snaps){
      print("printing docs length");
      print(snaps.documents[0].documentID);
      return Firestore.instance.collection('categories').document(snaps.documents[0].documentID).collection(category).document().setData({'subCategories': subCategory});


    });
  }

  //product list from snapshot

  List<ProductsData> productListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
//      print(doc.data['images']);
      return ProductsData(
        producsId: doc.data['id'] ?? '1',
        productName: doc.data['productName'] ?? 'unable to get name',
        productDescription: doc.data['description'] ?? 'unable to load description',
        productPrice: doc.data['price'] ?? '0',
        productsAvailable: doc.data['available'] ?? '0',
        productQuantity: doc.data['quantity'] ?? '0',
        productSize: doc.data['hasSize'] ?? '0',
        productRating: doc.data['hasRating'] ?? '0',
        producthaColor: doc.data['hasColor'] ?? 'colorless',
        producsCategory: doc.data['category'] ?? 'none',
        images: doc.data['images'] ?? 'unable to load images',


      );
    }).toList();

  }
  //category list from snapshot
   List<Categories>_categoryListFromSnapsht(QuerySnapshot snapshot){

    return snapshot.documents.map((doc){
      print(doc.data['category']);
      return Categories(
        category_id: doc.data['category_id'] ?? null,
        categoryName: doc.data['category'] ?? 'Unable to get name',
        categoryDescription: doc.data['description'] ?? 'Descrption not set',
        imageUrl: doc.data['image'] ?? null


      );
    }).toList();
   }


// get products

   Stream<List<ProductsData>> get products {
    return productCollection.snapshots()
     .map(productListFromSnapshot);
   }
  Stream<List<ProductsData>>  productsById(String product_id) {
    return  Firestore.instance.collection('products').where("id", isEqualTo: product_id).snapshots()
        .map(productListFromSnapshot);
  }
  Stream<List<ProductsData>>  productsByCategory(String category) {
    if(category == null){
      return productCollection.snapshots()
          .map(productListFromSnapshot);
    }else{
      return Firestore.instance.collection('products').where("category", isEqualTo: category).snapshots()
          .map(productListFromSnapshot);
    }

  }

  Stream<List<Categories>> get categories{
    return CategoryQuery.snapshots().map(_categoryListFromSnapsht);
  }
  Stream<List<Categories>>  categoriesById(String category_id){
    return Firestore.instance.collection('categories').where('category_id', isEqualTo: category_id).snapshots().map(_categoryListFromSnapsht);
  }



  //users list stream

  Stream<List<UserData>>  get Allusers{

    return Firestore.instance.collection('users').snapshots()
        .map(_alluserListFromSnapsht);
  }

  List<UserData>_alluserListFromSnapsht(QuerySnapshot snapshot){

    return snapshot.documents.map((doc){

      return UserData(
        user_id: doc.data['user_id'] ,
        payment_method: doc.data['payment_method'] ?? null,
        phone_number: doc.data['phone_number'] ?? null,
        email: doc.data['email'] ?? null,
        city: doc.data['city'] ?? null,
        address: doc.data['address'] ?? null,
        country: doc.data['country'] ?? null,
        gender: doc.data['gender'] ?? null,
        id_no: doc.data['id_no'] ?? null,
        credit_number: doc.data['credit_number'] ?? null,
        names:  doc.data['usernane'] ?? 'Unable to load name',
//        date_entered: doc.data['date_entered'].toDate()



      );
    }).toList();
  }


  List<OrderData>orderListFromSnapsht(QuerySnapshot snapshot){

    return snapshot.documents.map((doc){
      print('again');

      try{
        return OrderData(
            order_id: doc.data['order_id'],
            user_id: doc.data['customer_id'],
            payment_id: doc.data['payment_id'] ?? null,
            paid: doc.data['paid'] ?? false,
            ship_date: doc.data['ship_date'] ?? null,
            order_status: doc.data['order_status'] ?? null,
            required_date: doc.data['required_date'] ?? null,
            status: doc.data['status']
        );
      } catch(e){
        print(e.toString());
        return null;

      }

    }).toList();
  }

  Stream<List<OrderData>> get Allorders {
    return Firestore.instance.collection('orders').snapshots()
        .map(orderListFromSnapsht);

  }
  Stream<List<OrderData>>  ordersByOID(String order_id) {
    return Firestore.instance.collection('orders').where('order_id', isEqualTo: order_id).snapshots()
        .map(orderListFromSnapsht);

  }
  Stream<List<OrderDetailsData>>  ordersDetails(String order_id) {
    print(order_id);
    print('order_id');
    return Firestore.instance.collection('ordersDetails').where('order_id', isEqualTo: order_id).snapshots()
        .map(orderDetaisListFromSnapshot);
  }
  List<OrderDetailsData>orderDetaisListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.map((doc){
      print('again');

      try{
        return OrderDetailsData(
            order_id: doc.data['order_id'] ?? 'unable to load order id',
            product_id: doc.data['product_id']  ?? 'unable to load product id',
            image: doc.data['image'] ?? 'unable to load image',
            quantity: doc.data['quantity'] ?? 0,
            productName: doc.data['productName'] ?? 'unable to load product name',
            category: doc.data['category'] ?? 'unable to load category',
            price: doc.data['price'] ?? 0

        );
      } catch(e){
        print(e.toString());
        return null;

      }

    }).toList();
  }





}
