import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:software/billingPage/billingPage.dart';
import 'package:software/billingPage/paymentPage.dart';

import '../commonWidgets/textField.dart';
import '../orders/domain/orderDetails.dart';

class Address extends StatefulWidget {
  Address(this.uid);
  final String uid;
  @override
  State<Address> createState() => _AddressState();
}

class _AddressState extends State<Address> {
  final _formKey = GlobalKey<FormState>();
  String fullAddress='';
  String city='';
  String pinCode='';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text('Delivery Address',
          style: TextStyle(
              color: Colors.black
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: Column(
            children: [
              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                heading: "Full Address",
                hintText: 'Enter Your Full Address',
                textAction: TextInputAction.next,
                onchanged: (value) {
                  fullAddress=value!;
                },
                validator: (String? value) {
                  const pattern =
                      r"^[#.0-9a-zA-Z\s,-]+$";
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Enter Your Full Address';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid Full Address';
                  }
                  return null;
                },
              ),
              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                heading: "City",
                hintText: 'Enter City',
                textAction: TextInputAction.next,
                onchanged: (value) {
                  city=value!;
                },
                validator: (String? value) {
                  const pattern =
                      r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Enter City ';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter City';
                  }
                  return null;
                },
              ),
              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                heading: "Postal code",
                hintText: 'Enter Your Postal code',
                textAction: TextInputAction.next,
                onchanged: (value) {
                  pinCode=value!;
                },
                validator: (String? value) {
                  const pattern =
                      r'^([A-Z]{1,2}\d{1,2}[A-Z]?)\s*(\d[A-Z]{2})$';
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Enter Your Postal code';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid Postal code';
                  }
                  return null;
                },
              ),

            ],
          ),
        ),
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
                'Billing',
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

          if (_formKey.currentState!.validate()) {
            await FirebaseFirestore.instance
                .collection('Users')
                .doc(widget.uid)
                .set({'address':{
                  'fullAddress':fullAddress,
                  'city':city,
                  'postal code':pinCode,
            }
            }, SetOptions(merge: true)).then((value) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BillingPage('${fullAddress},${city},${pinCode}',widget.uid)));
            });
          }
        },
      ),
    );
  }
}
