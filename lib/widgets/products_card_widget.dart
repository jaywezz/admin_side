import 'package:adminside/app_screen/product_details.dart';
import 'package:adminside/models/productsData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget{
  @override
  _ProductsState createState() {

    return _ProductsState();
  }
}

class _ProductsState extends State<Products>{


  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<ProductsData>>(context) ?? [];
    print(products.length);
    if(products.length == 0){
      return Center(child: Text('Oops!!,No items in this catgory',style: TextStyle(
        fontSize: 13
      ),),

      );

    }else{
      try{
        return GridView.builder(

            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index){
              return SingleProduct(

                product_name: products[index].productName,
                product_id: products[index].producsId,
                product_picture: products[index].images,
                product_price: products[index].productPrice,
                product_category: products[index].producsCategory,
                product_rating: products[index].productRating,
                product_description: products[index].productDescription,
              );

            }
        );
      }catch(e){print(e.toString());}

  }}
}

class SingleProduct extends StatelessWidget{
  final String product_name;
  final double product_price;
  final List product_picture;
  final String product_description;
  final String product_category;
  final String product_id;
  final int product_rating;

  const SingleProduct({Key key,this.product_id, this.product_name, this.product_price, this.product_picture, this.product_description, this.product_category, this.product_rating}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return Card(

      child: Hero(
        tag: product_picture[0],
        child: Material(
          child: InkWell(
            onTap: (){

              Navigator.push(context, MaterialPageRoute(builder: (_) =>ProductDetailsTest(
                product_name: product_name,
                product_price: product_price,
                product_description: product_description,
                product_rating: product_rating,
                product_category: product_category,
                product_picture: product_picture,
                product_id: product_id,

              )));

            },
            child: GridTile(

              footer: Container(
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(10),
                    color: Colors.white60,
                  ),
                  height: 65,

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(product_name,style: TextStyle(
                                    color:Colors.black
                                ),),
                                Text(product_price.toString(),style:
                                TextStyle(
                                    color:Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14
                                ),),
                              ],
                            ),


                            //Row
                          ],
                        ),
                        // product text name

                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text("4.4",style:
                                TextStyle(
                                    color:Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10
                                ),),
                                Icon(Icons.star, size: 10, color: Colors.yellow,),
                                Icon(Icons.star, size: 10, color: Colors.yellow,),
                                Icon(Icons.star, size: 10, color: Colors.yellow,),
                                Icon(Icons.star, size: 10, color: Colors.yellow,)
                              ],
                            ),
                            Text("Available 19",style:
                            TextStyle(
                                color:Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 10
                            ),),
                          ],

                        )
                        //Row
                        //Number rating, star icon       available
                      ],
                    ),
                  )
              ),
              child: InkWell(
//                onTap: () => Navigator.of(context).push(
//                    MaterialPageRoute(builder: (context) => ProductDetailsTest(
//                      product_name: product_name,
//                      product_price: product_price,
//                      assetPath: product_picture,
//                    ))
//                ),
                child: Image.network(product_picture[0],filterQuality: FilterQuality.low,
                  fit: BoxFit.cover,)

              ),

            ),

          ),
        ),
      ),

    );
  }


}

