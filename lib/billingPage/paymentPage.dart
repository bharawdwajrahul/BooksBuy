import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:software/billingPage/addressPage.dart';
import 'package:software/books/application/books_watcher_bloc.dart';
import 'package:software/books/presentation/BooksDescription.dart';

import '../../injection.dart';
import '../cart/application/cart_watcher_bloc/cart_watcher_bloc.dart';
import '../orders/domain/orderDetails.dart';
import 'orderSuccessfull.dart';

class PaymentPage extends StatefulWidget {
  PaymentPage(this.orderDetailsList,this.uId);
  final OrderDetailsList orderDetailsList;
  final String uId;
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String defaultIdValue = '';
  var midSizeList;
  int total = 0;
  int noOfBooks = 0;
  int grandTotal = 0;
  int discount = 0;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: MultiBlocProvider(
          providers: [
            BlocProvider<CartWatcherBloc>(
              create: (context) => getIt<CartWatcherBloc>()
                ..add(CartWatcherEvent.watchAllStarted(widget.uId)),
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
                  total = 0;
                  grandTotal = 0;
                  discount = 0;
                  state.cartDetailsList.cart.values.forEach((element) {
                    total = total + element.price!.toInt();
                  });
                  if (state.cartDetailsList.cart.length >= 3) {
                    grandTotal = ((total - ((total * 20) / 100)) + 6).toInt();
                    discount = total - (total - ((total * 20) / 100)).toInt();
                  } else {
                    grandTotal = total + 6;
                  }
                  print('load succsess');
                  return Scaffold(
                    appBar: AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.black, //change your color here
                      ),
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      title: const Text(
                        'Payment',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    body: Container()
                  );
                },
                loadFailure: (state) {
                  return Container();
                },
              );
            },
          )),
      bottomNavigationBar: GestureDetector(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
          child: Container(
            width: .6.sw,
            height: .12.sw,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(50)),
              color: Colors.black,
            ),
            child: Center(
              child: Text(
                'Pay',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        onTap: () async {
          var firebaseUser = FirebaseAuth.instance.currentUser;
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.uId).collection('userOrders').doc('orders')
              .set(widget.orderDetailsList.toJson(), SetOptions(merge: true));
           Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BookingSuccessPage(widget.uId)),
          );



        },
      ),
    );
  }
}
