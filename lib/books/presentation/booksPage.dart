

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:software/books/application/books_watcher_bloc.dart';
import 'package:software/books/presentation/BooksDescription.dart';

import '../../injection.dart';
import '../domain/bookDetails.dart';


class BooksPage extends StatefulWidget {
BooksPage(this.userId);
final String userId;
  @override
  _BooksPageState createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  String defaultIdValue = '';
  var midSizeList;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  BooksDisplayed booksDisplayed=BooksDisplayed();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider<BooksWatcherBloc>(
            create: (context) => getIt<BooksWatcherBloc>()
              ..add( BooksWatcherEvent.watchAllStarted()),
          ),
        ],
        child: BlocBuilder<BooksWatcherBloc, BooksWatcherState>(
          builder: (context, state) {
            return state.map(
              initial: (_) => Container(),
              loadInProgress: (_) => const Center(
                child: CircularProgressIndicator(),
              ),
              loadSuccess: (state) {
                print('load succsess');
                log(state.bookDetailsList.toJson().toString());
                return ListView.builder(
                    itemCount: state.bookDetailsList.booksList.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:  Duration(seconds: 1),
                                  pageBuilder: (_, __, ___) => BooksDescription(state.bookDetailsList.booksList.values.elementAt(index),widget.userId)));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            width: 0.4.sw,
                            height: 0.3.sw,
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
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Hero(
                                    tag: state.bookDetailsList.booksList.values.elementAt(index).bookId!,
                                    child: Container(
                                      clipBehavior: Clip.hardEdge,
                                      width: .25.sw,
                                      height: .3.sw,
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
                                        imageUrl: state.bookDetailsList.booksList.values.elementAt(index).imageurl!,
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
                                Column(
                                  crossAxisAlignment:CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        width: .63.sw,
                                        height: .1.sw,
                                        //color: Colors.green,
                                        child: Text(state.bookDetailsList.booksList.values.elementAt(index).name!,
                                        maxLines: 2,
                                        style:  const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Container(
                                        width: .63.sw,
                                        height: .08.sw,
                                       // color: Colors.green,
                                        child: Text(state.bookDetailsList.booksList.values.elementAt(index).author!,
                                          maxLines: 2,
                                          style:  const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                      child: Container(
                                        width: .63.sw,
                                        height: .05.sw,
                                        //color: Colors.green,
                                        child: Row(
                                          children:  [
                                            Text('Price: ${state.bookDetailsList.booksList.values.elementAt(index).price.toString()}£',
                                              maxLines: 2,
                                              style:  const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SizedBox(width: 0.05.sw,),
                                            Text('\u{2B50} ${state.bookDetailsList.booksList.values.elementAt(index).ratings.toString()}',
                                              maxLines: 2,
                                              style:  const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SizedBox(width: 15),
                                            GestureDetector(
                                              child: Padding(
                                                padding: const EdgeInsets.only(),
                                                child: Container(
                                                  width: .3.sw,
                                                  height: .05.sw,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.all(Radius.circular(50)),
                                                    color: Colors.black54,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Add to cart',
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
                                                    .set({'cart': { state.bookDetailsList.booksList.values.elementAt(index).bookId:{
                                                  'bookId':state.bookDetailsList.booksList.values.elementAt(index).bookId,
                                                  'name':state.bookDetailsList.booksList.values.elementAt(index).name,
                                                  'author':state.bookDetailsList.booksList.values.elementAt(index).author,
                                                  'description':state.bookDetailsList.booksList.values.elementAt(index).description,
                                                  'publisher':state.bookDetailsList.booksList.values.elementAt(index).publisher,
                                                  'price':state.bookDetailsList.booksList.values.elementAt(index).price,
                                                  'ratings':state.bookDetailsList.booksList.values.elementAt(index).ratings,
                                                  'imageurl':state.bookDetailsList.booksList.values.elementAt(index).imageurl,
                                                }
                                                }
                                                }, SetOptions(merge: true)).then((value) {
                                                  Fluttertoast.showToast(
                                                      msg: 'Book added to cart',
                                                      toastLength: Toast.LENGTH_SHORT,
                                                      gravity: ToastGravity.TOP,
                                                      timeInSecForIosWeb: 1);
                                                });
                                              },
                                            ),
                                          ],

                                        )
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });

              },
              loadFailure: (state) {
                return Container();
              },
            );
          },
        )

      ),
    );
  }
}

class BooksDisplayed{
  final FakeFirebaseFirestore firebaseFirestore = FakeFirebaseFirestore();
  BookDetailsList bookDetailsList=BookDetailsList(booksList: {});

  Map<String, dynamic> booksList={'booksList':
  {
  '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
  '202fbc89-27a1-419f-b9a6-029c2ab18b31': {'bookId': '202fbc89-27a1-419f-b9a6-029c2ab18b31', 'name': 'Interesting Facts For Curious Minds: 1572 Random Facts', 'author': 'Jordan Moore', 'description': 'Interesting Facts For Curious Minds gives you the answer to all these and many, many more questions that I know have crossed your mind from time to time. This book is divided into 63 chapters by topic for your convenience, bringing you a nice mix of science, history, pop culture, and all sorts of stuff in between. Each chapter contains 25 concise yet engaging factoids that are sure to make you think and at times laugh', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https//firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.57.11%20PM.png?alt=media&token=503d89de-e69c-4664-b20f-99fb8504141a'},
  'e8caa86d-4d52-45e7-8161-4490759e1538': {'bookId': 'e8caa86d-4d52-45e7-8161-4490759e1538', 'name': 'The Bullet That Missed: (The Thursday Murder Club 3)', 'author': 'Richard Osman, description: It is an ordinary Thursday and things should finally be returning to normal.Except trouble is never far away where the Thursday Murder Club are concerned. A decade-old cold case leads them to a local news legend and a murder with no body and no answers.Then a new foe pays Elizabeth a visit. Her mission? Kill...or be killed.', 'publisher': 'publisher', 'price': 10, 'ratings': 4, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.49.06%20PM.png?alt=media&token=1a353a95-7166-46c4-875e-f5b3db1c7064'},
  '59cda50c-32df-4a34-9090-8befd6f29359': {'bookId': '59cda50c-32df-4a34-9090-8befd6f29359', 'name': 'The island of trees' , 'author': 'Elif shafak, description: It is 1974 on the island of Cyprus. Two teenagers, from opposite sides of a divided land, meet at a tavern in the city they both call home. The tavern is the only place that Kostas, who is Greek and Christian, and Defne, who is Turkish and Muslim, can meet, in secret, hidden beneath the blackened beams from which hang garlands of garlic, chilli peppers and wild herbs', 'publisher': 'publisher', 'price': 20, 'ratings': 3, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.09.45%20PM.png?alt=media&token=c8a8a21d-1e0b-4f25-b10f-1f86cb8b538e'},
  '29fe458f-ebd2-4cae-915f-88f5058d090d': {'bookId': '29fe458f-ebd2-4cae-915f-88f5058d090d', 'name': 'No Plan B: The unputdownable new 2022 Jack Reacher' , 'author': 'Lee Child, description: Gerrardsville, Colorado. One tragic event. Two witnesses. Two conflicting accounts. One witness sees a woman throw herself in front of a bus - clearly suicide. The other witness is Jack Reacher. And he sees what really happened - a man in grey hoodie and jeans, swift and silent as a shadow, pushing the victim to her death, before grabbing her bag and sauntering away.', 'publisher': 'publisher', 'price': 10, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.03.11%20PM.png?alt=media&token=45b094e1-79c4-4752-a125-42e22f138a10'}
  }};
  Future<Map<String, dynamic>> books( ) async {
    await firebaseFirestore
        .collection('books')
        .doc('books')
        .set(booksList);
    return booksList;
  }

}


