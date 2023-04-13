import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:software/books/presentation/booksPage.dart';
import 'package:software/homePage.dart';
import 'package:software/orders/presentation/ordersPage.dart';
import 'package:uuid/uuid.dart';

class BookingSuccessPage extends StatefulWidget {
BookingSuccessPage(this.uId);
final String uId;
  @override
  _BookingSuccessPageState createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 2),
            () {

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrdersPage(widget.uId)),
          );

        });
  }
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(height: .5.sw),
              Container(
                width: 1.sw,
                height: 1.sw,
                child: Container(
                  margin: EdgeInsets.all(4),
                  child: Lottie.asset(
                    'assets/icons/tickMark.json',
                    width: 250,
                    height: 250,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "Order Successful",
                  style: TextStyle(
                      color: Colors.green,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ));
  }
}

