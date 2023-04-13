import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:software/books/presentation/booksPage.dart';
import 'package:software/cart/presentation/cartPage.dart';
import 'package:software/orders/presentation/ordersPage.dart';
import 'package:software/signUp/welcomePage.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    String user = auth.currentUser!.uid;
    print('cart page---------${user}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
        'Welcome!',
        style:TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
    ),
        leading: Padding(
          padding: EdgeInsets.all(5),
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.shopping_bag_outlined,
            size: 25,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => OrdersPage(user)));

          },
        ),
      ),
    ),
        actions: [
          Padding(
            padding:const EdgeInsets.all(6),
            child: GestureDetector(
              onTap: ()async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => const WelcomePage()));
                });

              },
              child:const Icon(
                Icons.logout,

                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding:const EdgeInsets.all(6),
            child: GestureDetector(
              onTap: ()async {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) =>  CartPage(user)));
                });

              },
              child:const Icon(
                Icons.shopping_cart_rounded,
                color: Colors.black,
              ),
            ),
          ),

          // Padding(
          //   padding:const EdgeInsets.all(6),
          //   child: GestureDetector(
          //     onTap: ()async {
          //       String id=Uuid().v4().trimRight();
          //       // Navigator.push(
          //       //     context, MaterialPageRoute(builder: (context) =>  BooksPage()));
          //       await FirebaseFirestore.instance
          //           .collection('books')
          //           .doc('books')
          //           .set({'booksList': { id:{
          //         'bookId':id,
          //         'name':'The Fellowship of the Ring: Discover Middle-earth ',
          //         'author':"J R R Tolkien",
          //         'description':'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.',
          //         'publisher':'publisher',
          //         'price':15,
          //         'ratings':5,
          //         'imageurl':'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e',
          //       }
          //       }
          //       }, SetOptions(merge: true));
          //
          //     },
          //     child:const Icon(
          //       Icons.add,
          //
          //       color: Colors.black,
          //     ),
          //   ),
          // ),
        ],
    ),
      backgroundColor: Colors.white,
      body: BooksPage(user),
    );

  }
}
