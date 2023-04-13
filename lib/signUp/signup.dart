import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/utils.dart';
import 'package:software/homePage.dart';

import '../commonWidgets/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String name='';
  String mailId='';
  String password='';
  String confirmPassword='';

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));

    WidgetsFlutterBinding.ensureInitialized();
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  [

              const Center(
                child: Text("Signup",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),),
              ),
              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                heading: "Full Name",
                hintText: 'Enter Your Full Name',
                textAction: TextInputAction.next,
                onchanged: (value) {
                  name=value!;
                },
                validator: (String? value) {
                  const pattern =
                      r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$";
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Enter Your Full Name';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid Full Name';
                  }
                  return null;
                },
              ),
              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                heading: "email",
                hintText: 'Enter Your Email Address',
                isEmail: true,
                textAction: TextInputAction.next,
                onchanged: (value) {
                  mailId=value!;
                },
                validator: (String? value) {
                  const pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Enter Your Email Address';
                  } else if (!regExp.hasMatch(value)) {
                    return 'Please enter valid Email address';
                  }
                  return null;
                },
              ),

              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                isPassword: true,
                heading: "password",
                hintText: 'Enter Your Password',
                textAction: TextInputAction.done,
                onchanged: (value) {
                  password=value!;
                },
                validator: (String? value) {
                  const pattern =
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  } else if (!regExp.hasMatch(value)) {
                    return 'enter valid password';
                  }
                  return null;
                },
              ),

              MyTextFormField(
                isMandatory: false,
                opacity: 1,
                isPassword: true,
                heading: "Confirm password",
                hintText: 'Enter Your Password',
                textAction: TextInputAction.next,
                onchanged: (value) {
                  confirmPassword=value!;
                },
                validator: (String? value) {
                  if (value!.isEmpty) {
                    return 'Enter Your password';
                  } else if (password!=confirmPassword) {
                    return 'passwords do not match';
                  }
                  return null;
                },
              ),

              Padding(
                padding: const EdgeInsets.all(15.0),
                child:GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      width: 0.8.sw,
                      height: .12.sw,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(const Radius.circular(50)),
                        color: Colors.green.shade200,
                      ),
                      child: Center(
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .color,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  onTap: () async{
                    if (_formKey.currentState!.validate()) {
                      try {
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                            email: mailId,
                            password: password
                        ).then((value) async {
                          var firebaseUser = FirebaseAuth.instance.currentUser;
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc(firebaseUser!.uid)
                              .set({'userId': firebaseUser.uid,
                                    'userName':name,
                                    'cart':{},
                          }, SetOptions(merge: true));
                        }
                        );
                        var firebaseUser = FirebaseAuth.instance.currentUser;
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(firebaseUser!.uid).collection('userOrders').doc('orders')
                            .set({'ordersList':{}}, SetOptions(merge: true));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          Fluttertoast.showToast(
                              msg: "The account already exists for that email.",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.TOP,
                              timeInSecForIosWeb: 1);
                        }
                      } catch (e) {
                        print(e);
                      }
                    }

                     // Navigator.push(
                    //     context, MaterialPageRoute(builder: (context) => const SignupPage()));
                  },
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}

