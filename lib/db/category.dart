import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService{
  Firestore _categoryCollection = Firestore.instance;

  void createCategory(String category, String category_description, String photo_url){
  var id = Uuid();
  String categoryId = id.v1();

    _categoryCollection.collection('categories').document(categoryId).setData(
        {
          'category_id' : categoryId,
          'category': category,
          'description' : category_description,
          'image' : photo_url
        });

  }

  
  Future<List> getCategories(){
    return _categoryCollection.collection('categories').getDocuments().then((snaps){
      print("printing docs length");
      print(snaps.documents.length);
      return snaps.documents;
    });
  }


   // get categories


}