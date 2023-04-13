
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:software/billingPage/addressPage.dart';
import 'package:software/billingPage/billingPage.dart';
import 'package:software/books/application/books_watcher_bloc.dart';
import 'package:software/books/domain/bookDetails.dart';
import 'package:software/books/presentation/BooksDescription.dart';
import 'package:software/cart/domain/cartDetails.dart';

import '../../injection.dart';
import '../application/cart_watcher_bloc/cart_watcher_bloc.dart';


class CartPage extends StatefulWidget {
  CartPage(this.uId);
  final String uId;
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  String defaultIdValue = '';
  var midSizeList;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MultiBlocProvider(
          providers: [
            BlocProvider<CartWatcherBloc>(
              create: (context) => getIt<CartWatcherBloc>()
                ..add( CartWatcherEvent.watchAllStarted(widget.uId)),
            ),
          ],
          child: BlocBuilder<CartWatcherBloc, CartWatcherState>(
            builder: (context, state) {
              return state.map(
                initial: (_) => Container(),
                loadInProgress: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                loadSuccess: (state) {
                  print('load succsess');
                  log(state.cartDetailsList.cart.toString());
                  return Scaffold(
                    appBar: AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.black, //change your color here
                      ),
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      title: const Text('Cart Details',
                      style: TextStyle(
                        color: Colors.black
                      ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    body: ListView.builder(
                        itemCount: state.cartDetailsList.cart.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [

                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  width: 0.92.sw,
                                  height: 0.21.sw,
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: .7.sw,
                                        height: 0.2.sw,
                                        child:Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: .63.sw,
                                                height: .09.sw,
                                               // color: Colors.red,
                                                child: Text(state.cartDetailsList.cart.values.elementAt(index).name!,
                                                  maxLines: 2,
                                                  style:  const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                              child: Container(
                                                width: .63.sw,
                                                height: .07.sw,
                                                //color: Colors.green,
                                                child: Text(state.cartDetailsList.cart.values.elementAt(index).author!,
                                                  maxLines: 2,
                                                  style:  const TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )

                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Center(
                                        child: Text('${state.cartDetailsList.cart.values.elementAt(index).price.toString()}£',
                                          maxLines: 1,
                                          style:  const TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 20,
                                top: 5,
                                child: GestureDetector(
                                  child: Container(
                                      width: .06.sw,
                                      height: .06.sw,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          width: 2,
                                          color: Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      child: Center(
                                          child: Container(
                                            color: Colors.red,
                                            width: 9,
                                            height: 2.5,
                                          ))),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (contxt) {
                                        return AlertDialog(
                                          title: const Text(
                                            'Are you sure want to remove this book from your cart?',
                                            style: TextStyle(
                                              color: Colors.black
                                            )
                                          ),
                                          actions: <Widget>[
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.black),
                                              onPressed: () => Navigator.pop(contxt),
                                              child: const Text(
                                                'CANCEL',
                                                style: TextStyle(
                                                    color:
                                                    Colors.white),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  primary: Colors.black),
                                              onPressed: () async {
                                                FirebaseAuth auth = FirebaseAuth.instance;
                                                String user = auth.currentUser!.uid;
                                                FirebaseFirestore.instance
                                                    .collection('Users')
                                                    .doc(user)
                                                    .set({
                                                  'cart': {'${state.cartDetailsList.cart.values.elementAt(index).bookId}': FieldValue.delete()}
                                                }, SetOptions(merge: true)).then((value) {
                                                  Navigator.pop(contxt);
                                                });
                                              },
                                              child: const Text(
                                                'YES',
                                                style: TextStyle(
                                                    color:
                                                    Colors.white),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),

                            ],
                          );
                        }),
                  );

                },
                loadFailure: (state) {
                  return Container();
                },
              );
            },
          )

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
                'Next',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        onTap: () async {

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>  Address(widget.uId)));
        },
      ),
    );
  }
}



class CartItems{
  final FakeFirebaseFirestore cartFirebaseFirestore = FakeFirebaseFirestore();
  CartDetailsList cartDetailsList=CartDetailsList(cart: {});

  Map<String, dynamic> cartDetails={'cart':
  {
    '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
    '202fbc89-27a1-419f-b9a6-029c2ab18b31': {'bookId': '202fbc89-27a1-419f-b9a6-029c2ab18b31', 'name': 'Interesting Facts For Curious Minds: 1572 Random Facts', 'author': 'Jordan Moore, description: Interesting Facts For Curious Minds gives you the answer to all these and many, many more questions that I know have crossed your mind from time to time. This book is divided into 63 chapters by topic for your convenience, bringing you a nice mix of science, history, pop culture, and all sorts of stuff in between. Each chapter contains 25 concise yet engaging factoids that are sure to make you think and at times laugh', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https//firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.57.11%20PM.png?alt=media&token=503d89de-e69c-4664-b20f-99fb8504141a'},
  }};
  Future<Map<String, dynamic>> cart( ) async {

    // print('printing cart json');
    // print(cartDetailsList.toJson());
    await cartFirebaseFirestore
        .collection('Users')
        .doc('anOJS7zHY2cebx1OgVQ1blgjWJp1')
        .set(cartDetails);
    return cartDetails;
  }



}