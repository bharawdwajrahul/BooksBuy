import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:software/books/domain/bookDetails.dart';
import 'package:software/cart/presentation/cartPage.dart';

class BooksDescription extends StatefulWidget {
 BooksDescription(this.book,this.uId);

final Books book;
final String uId;
  @override
  State<BooksDescription> createState() => _BooksDescriptionState();
}

class _BooksDescriptionState extends State<BooksDescription> {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          Container(
            width: 1.sw,
            height: 1.08.sw,
            decoration: BoxDecoration(
                color: Colors.yellow.shade200,
                border: Border.all(
                  color: Colors.yellow.shade300,
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          //color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.arrow_back_ios,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          //color: Colors.grey,
                          child: const Center(
                            child: Icon(Icons.shopping_cart_rounded,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  CartPage(widget.uId)));
                      },
                    ),

                  ],
                ),
                Center(
                  child: Hero(
                    tag: widget.book.bookId!,

                    child: Container(
                      clipBehavior: Clip.hardEdge,
                      width: .5.sw,
                      height: .6.sw,
                      decoration: BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset: const Offset(0, 4), // changes position of shadow
                            ),
                          ]),
                      child: CachedNetworkImage(
                        imageUrl: widget.book.imageurl!,
                        width: .25.sw,
                        height: .3.sw,
                        fit: BoxFit.cover,

                        placeholder: (context, url) => Container(),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: .7.sw,
                      height: .12.sw,
                      //color: Colors.green,
                      child: Text(widget.book.name!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:  const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      width: .7.sw,
                      height: .1.sw,
                      //color: Colors.green,
                      child: Text(widget.book.author!,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:  const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),

          SizedBox(height: 0.1.sw,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [
              Text('Ratings \n${widget.book.ratings!} \u{2B50}',
              textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black
                ),
              ),
              SizedBox(
                width: 0.4.sw,
              ),
              Text('Price \n${widget.book.price!} £',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black
                ),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Description:',
                textAlign: TextAlign.start,
                style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              width: .95.sw,
              height: .4.sw,
             // color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(widget.book.description!,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
      bottomNavigationBar: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 40),
          child: Container(
            width: .6.sw,
            height: .12.sw,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'Add To Cart',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        onTap: () async {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(firebaseUser!.uid)
              .set({'cart': { widget.book.bookId:{
            'bookId':widget.book.bookId,
            'name':widget.book.name,
            'author':widget.book.author,
            'description':widget.book.description,
            'publisher':widget.book.publisher,
            'price':widget.book.price,
            'ratings':widget.book.ratings,
            'imageurl':widget.book.imageurl,
          }
          }
          }, SetOptions(merge: true)).then((value) {
            Fluttertoast.showToast(
                msg: 'Book added to cart',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1);
          });
          // Navigator.pop(context);
        },
      ),

    );
  }
}
