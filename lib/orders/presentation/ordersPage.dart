
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:software/billingPage/paymentPage.dart';
import 'package:software/homePage.dart';
import 'package:software/orders/domain/orderDetails.dart';
import 'package:uuid/uuid.dart';

import '../../injection.dart';
import '../application/orders_watcher_bloc/orders_watcher_bloc.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage(this.uid);
  final String uid;
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String defaultIdValue = '';

  var midSizeList;
  int total = 0;
  int noOfBooks = 0;
  int grandTotal = 0;
  int discount = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    HomePage()));
        return true;

      },
      child: Scaffold(
        body: MultiBlocProvider(
            providers: [
              BlocProvider<OrdersWatcherBloc>(
                create: (context) => getIt<OrdersWatcherBloc>()
                  ..add(const OrdersWatcherEvent.watchAllStarted()),
              ),
            ],
            child: BlocBuilder<OrdersWatcherBloc, OrdersWatcherState>(
              builder: (context, state) {
                return state.map(
                  initial: (_) => Container(),
                  loadInProgress: (_) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  loadSuccess: (state) {
                    print('order page looding-----');
                    log(state.orderDetailsList.toJson().toString());
                    state.orderDetailsList.ordersList!.forEach((key, value) {
                      print(value.grandTotal);
                    });
                    return Scaffold(
                      appBar: AppBar(
                        iconTheme: const IconThemeData(
                          color: Colors.black, //change your color here
                        ),
                        backgroundColor: Colors.white,
                        centerTitle: true,
                        title: const Text(
                          'Orders',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      backgroundColor: Colors.white,
                      body:ListView.builder(
                          itemCount: state.orderDetailsList.ordersList!.values.length,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Order(state.orderDetailsList.ordersList!.values.elementAt(index));
                          }),
                    );
                  },
                  loadFailure: (state) {
                    return Container();
                  },
                );
              },
            )),
      ),
    );
  }
}



class Order extends StatefulWidget {
  Order(this.orderDetails);
final OrderDetails? orderDetails;
  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(
                    0, 4), // changes position of shadow
              ),
            ]),
        child: Column(
          children: [
            ListView.builder(
                itemCount:widget.orderDetails!.booksList.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10),
                          child: Container(
                            width: .75.sw,
                            height: .1.sw,
                            // color: Colors.green,
                            child: Text(widget.orderDetails!.booksList.values.elementAt(index).name!,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 10),
                          child: Container(
                            // height: .1.sw,
                            // color: Colors.green,
                            child: Text(
                              ':  ${widget.orderDetails!.booksList.values.elementAt(index).price}£',
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
            Text(
              '--------------------------------------------------------',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.6),
              ),
            ),

            ///grand total
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: .75.sw,
                    height: .1.sw,
                    // color: Colors.green,
                    child: const Text(
                      'Total Price',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    // height: .1.sw,
                    // color: Colors.green,
                    child: Text(
                      ':  ${widget.orderDetails!.total}£',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: .75.sw,
                    height: .1.sw,
                    // color: Colors.green,
                    child: const Text(
                      'Discount(20%)',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    // height: .1.sw,
                    // color: Colors.green,
                    child: Text(
                      ':  ${widget.orderDetails!.discount}£',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: .75.sw,
                    height: .1.sw,
                    // color: Colors.green,
                    child: const Text(
                      'Shipping Cost',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    // height: .1.sw,
                    // color: Colors.green,
                    child: const Text(
                      ':  6£',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '--------------------------------------------------------',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.6),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Container(
                    width: .75.sw,
                    height: .1.sw,
                    // color: Colors.green,
                    child: const Text(
                      'Grand Total',
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    // height: .1.sw,
                    // color: Colors.green,
                    child: Text(
                      ':  ${widget.orderDetails!.grandTotal}£',
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// class OrdersDisplayed{
//
//   final FakeFirebaseFirestore ordersFirebaseFirestore = FakeFirebaseFirestore();
//   OrderDetailsList orderDetailsList=OrderDetailsList(ordersList: {});
//
//   Map<String, dynamic> orderList={'ordersList':
//   {
//     // '430f20e1-0c54-47cf-bcbd-f60ee14d0395':{
//   //     {'orderId': '430f20e1-0c54-47cf-bcbd-f60ee14d0395',
//   // 'discount': 8,
//   // 'grandTotal': 38,
//   // 'total': 40,
//   // 'noOfBooks': 3,
//   // 'orderStatus': 'PLACED',
//   //     'booksList':{
//   //       '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
//   //       '202fbc89-27a1-419f-b9a6-029c2ab18b31': {'bookId': '202fbc89-27a1-419f-b9a6-029c2ab18b31', 'name': 'Interesting Facts For Curious Minds: 1572 Random Facts', 'author': 'Jordan Moore', 'description': 'Interesting Facts For Curious Minds gives you the answer to all these and many, many more questions that I know have crossed your mind from time to time. This book is divided into 63 chapters by topic for your convenience, bringing you a nice mix of science, history, pop culture, and all sorts of stuff in between. Each chapter contains 25 concise yet engaging factoids that are sure to make you think and at times laugh', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https//firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.57.11%20PM.png?alt=media&token=503d89de-e69c-4664-b20f-99fb8504141a'},
//   //       'e8caa86d-4d52-45e7-8161-4490759e1538': {'bookId': 'e8caa86d-4d52-45e7-8161-4490759e1538', 'name': 'The Bullet That Missed: (The Thursday Murder Club 3)', 'author': 'Richard Osman, description: It is an ordinary Thursday and things should finally be returning to normal.Except trouble is never far away where the Thursday Murder Club are concerned. A decade-old cold case leads them to a local news legend and a murder with no body and no answers.Then a new foe pays Elizabeth a visit. Her mission? Kill...or be killed.', 'publisher': 'publisher', 'price': 10, 'ratings': 4, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.49.06%20PM.png?alt=media&token=1a353a95-7166-46c4-875e-f5b3db1c7064'},
//   //     }}
//     },
//     // 'b98c7eec-cacc-4753-8dd7-fc15d8eca316':{
//     //   {'orderId': '430f20e1-0c54-47cf-bcbd-f60ee14d0395',
//     //     'discount': 0,
//     //     'grandTotal': 21,
//     //     'total': 15,
//     //     'noOfBooks': 1,
//     //     'orderStatus': 'PLACED',
//     //     'booksList':{
//     //       '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
//     //
//     //     }}},
//     // }
//   };
//   Future<Map<String, dynamic>> orders( ) async {
//     await ordersFirebaseFirestore
//         .collection('books')
//         .doc('data')
//         .set(orderList);
//     return orderList;
//   }
//
// }


class OrdersDisplayed{
  final FakeFirebaseFirestore orderFirebaseFirestore = FakeFirebaseFirestore();
  OrderDetailsList cartDetailsList=OrderDetailsList(ordersList: {});

  // Map<String, dynamic> orderDetails={'cart':
  // {
  //   'name':'nameee',
  // }};

  Map<String, dynamic> orderList={'ordersList':{
    '430f20e1-0c54-47cf-bcbd-f60ee14d0395':
      {'orderId': '430f20e1-0c54-47cf-bcbd-f60ee14d0395',
        'discount': 8,
        'grandTotal': 38,
        'total': 40,
        'noOfBooks': 3,
        'orderStatus': 'PLACED',
        'booksList':{
          '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
          '202fbc89-27a1-419f-b9a6-029c2ab18b31': {'bookId': '202fbc89-27a1-419f-b9a6-029c2ab18b31', 'name': 'Interesting Facts For Curious Minds: 1572 Random Facts', 'author': 'Jordan Moore', 'description': 'Interesting Facts For Curious Minds gives you the answer to all these and many, many more questions that I know have crossed your mind from time to time. This book is divided into 63 chapters by topic for your convenience, bringing you a nice mix of science, history, pop culture, and all sorts of stuff in between. Each chapter contains 25 concise yet engaging factoids that are sure to make you think and at times laugh', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https//firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.57.11%20PM.png?alt=media&token=503d89de-e69c-4664-b20f-99fb8504141a'},
          'e8caa86d-4d52-45e7-8161-4490759e1538': {'bookId': 'e8caa86d-4d52-45e7-8161-4490759e1538', 'name': 'The Bullet That Missed: (The Thursday Murder Club 3)', 'author': 'Richard Osman, description: It is an ordinary Thursday and things should finally be returning to normal.Except trouble is never far away where the Thursday Murder Club are concerned. A decade-old cold case leads them to a local news legend and a murder with no body and no answers.Then a new foe pays Elizabeth a visit. Her mission? Kill...or be killed.', 'publisher': 'publisher', 'price': 10, 'ratings': 4, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.49.06%20PM.png?alt=media&token=1a353a95-7166-46c4-875e-f5b3db1c7064'},
        }
      },
    'b98c7eec-cacc-4753-8dd7-fc15d8eca316':{
        'orderId': '430f20e1-0c54-47cf-bcbd-f60ee14d0395',
        'discount': 0,
        'grandTotal': 21,
        'total': 15,
        'noOfBooks': 1,
        'orderStatus': 'PLACED',
        'booksList':{
          '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
        }
    }
  }

  };

  // Map<String, dynamic> orderList={'ordersList':
  // {
  //   '430f20e1-0c54-47cf-bcbd-f60ee14d0395':{
  //     {'orderId': '430f20e1-0c54-47cf-bcbd-f60ee14d0395',
  //       'discount': 8,
  //       'grandTotal': 38,
  //       'total': 40,
  //       'noOfBooks': 3,
  //       'orderStatus': 'PLACED',
  //       'booksList':{
  //         '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
  //         '202fbc89-27a1-419f-b9a6-029c2ab18b31': {'bookId': '202fbc89-27a1-419f-b9a6-029c2ab18b31', 'name': 'Interesting Facts For Curious Minds: 1572 Random Facts', 'author': 'Jordan Moore', 'description': 'Interesting Facts For Curious Minds gives you the answer to all these and many, many more questions that I know have crossed your mind from time to time. This book is divided into 63 chapters by topic for your convenience, bringing you a nice mix of science, history, pop culture, and all sorts of stuff in between. Each chapter contains 25 concise yet engaging factoids that are sure to make you think and at times laugh', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https//firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.57.11%20PM.png?alt=media&token=503d89de-e69c-4664-b20f-99fb8504141a'},
  //         'e8caa86d-4d52-45e7-8161-4490759e1538': {'bookId': 'e8caa86d-4d52-45e7-8161-4490759e1538', 'name': 'The Bullet That Missed: (The Thursday Murder Club 3)', 'author': 'Richard Osman, description: It is an ordinary Thursday and things should finally be returning to normal.Except trouble is never far away where the Thursday Murder Club are concerned. A decade-old cold case leads them to a local news legend and a murder with no body and no answers.Then a new foe pays Elizabeth a visit. Her mission? Kill...or be killed.', 'publisher': 'publisher', 'price': 10, 'ratings': 4, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2010.49.06%20PM.png?alt=media&token=1a353a95-7166-46c4-875e-f5b3db1c7064'},
  //       }}
  //   },
  //   'b98c7eec-cacc-4753-8dd7-fc15d8eca316':{
  //     {'orderId': '430f20e1-0c54-47cf-bcbd-f60ee14d0395',
  //       'discount': 0,
  //       'grandTotal': 21,
  //       'total': 15,
  //       'noOfBooks': 1,
  //       'orderStatus': 'PLACED',
  //       'booksList':{
  //         '0d1f2a4b-23cc-40db-a925-c7b1ad80f687': {'bookId': '0d1f2a4b-23cc-40db-a925-c7b1ad80f687', 'name': 'The Fellowship of the Ring: Discover Middle-earth' , 'author': 'J R R Tolkien', 'description': 'In a sleepy village in the Shire, a young hobbit is entrusted with an immense task. He must make a perilous journey across Middle-earth to the Cracks of Doom, there to destroy the Ruling Ring of Power – the only thing that prevents the Dark Lord Sauron’s evil dominion.Thus begins J. R. R. Tolkien’s classic tale of adventure, which continues in The Two Towers and The Return of the King.', 'publisher': 'publisher', 'price': 15, 'ratings': 5, 'imageurl': 'https://firebasestorage.googleapis.com/v0/b/bookbuy-8e567.appspot.com/o/Screenshot%202022-11-22%20at%2011.14.28%20PM.png?alt=media&token=e9416de0-0200-4ca3-8be0-286c691b164e'},
  //
  //       }}},
  // }
  // };
  Future<Map<String, dynamic>> orders( ) async {

    // print('printing cart json');
    // print(cartDetailsList.toJson());
    await orderFirebaseFirestore
        .collection('order')
        .doc('order')
        .set(orderList);
    return orderList;
  }



}