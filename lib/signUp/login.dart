import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:software/homePage.dart';

import '../commonWidgets/textField.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email='';
  String password='';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));

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
                child: Text("Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                  ),),
              ),
              // MyTextFormField(
              //   refkey: Key('emailText'),
              //   isMandatory: false,
              //   opacity: 1,
              //   heading: "email",
              //   hintText: 'Enter Your Email Address',
              //   isEmail: true,
              //   textAction: TextInputAction.next,
              //   onchanged: (value) {
              //     email=value!;
              //   },
              //   validator: (String? value) {
              //     const pattern =
              //         r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              //     RegExp regExp = new RegExp(pattern);
              //     if (value!.isEmpty) {
              //       return 'Enter Your Email Address';
              //     } else if (!regExp.hasMatch(value)) {
              //       return 'Please enter valid Email address';
              //     }
              //     return null;
              //   },
              //
              // ),

              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 10.sp,bottom: 10.sp,right: 25.sp,left: 25.sp),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.sp),
                        alignment: Alignment.topLeft,
                        child: Text('Login',
                            style:  TextStyle(
                              color: Colors.black,
                              fontSize: 30.sp,
                            )),
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontWeight: FontWeight.w500,
                            fontFamily:
                            Theme.of(context).textTheme.subtitle1!.fontFamily,
                            fontStyle: FontStyle.normal,
                            fontSize: 15),
                        decoration: InputDecoration(
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                          errorBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:  BorderSide(color: Colors.red, width: 0.0),
                          ),
                          // focusedErrorBorder: new OutlineInputBorder(
                          //   borderSide: new BorderSide(color: Colors.red, width: 0.0),
                          // ),
                          suffixIconConstraints:
                          const BoxConstraints(minWidth: 23, maxHeight: 20),
                          errorStyle: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontFamily:
                              Theme.of(context).textTheme.subtitle1!.fontFamily,
                              fontWeight: FontWeight.normal),
                          hintText: 'Enter Your Email',
                          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                          enabledBorder:  OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide:const BorderSide(
                              color: Colors.grey,
                              width: 0.0,
                            ),
                          ),
                          // border: const OutlineInputBorder(),
                        ),
                        onChanged:  (value) {
                          email=value;
                        },
                        validator: (String? value){
                          return EmailFieldValidate.validateEmail(value!);
                        },
                      ),
                    ],
                  ),
                ),
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
                  const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                  RegExp regExp = new RegExp(pattern);
                  if (value!.isEmpty) {
                    return 'Please enter password';
                  } else if (!regExp.hasMatch(value)) {
                    return 'enter valid password';
                  }
                  return null;
                },
              ),
              GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: .8.sw,
                    height: .12.sw,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(const Radius.circular(50)),
                      color: Colors.red.shade200,
                    ),
                    child: Center(
                      child: Text(
                        'Login  ',
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
                onTap: () async {
    if (_formKey.currentState!.validate()) {

        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password:password,
          ).then((value) { Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage()));
          });
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            Fluttertoast.showToast(
                msg: 'No user found for that email.',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1);
          } else if (e.code == 'wrong-password') {

            Fluttertoast.showToast(
                msg: 'Email Id or password is incorrect!',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1);
          }
        }
    }
              },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailFieldValidate{
  static String error='';
  static String validateEmail(String value){
    const pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp =  RegExp(pattern);
    if (value.isEmpty) {
      error = 'Please enter email';
    } else if (!regExp.hasMatch(value)) {
      error ='enter valid email address';
    }
    return error;
  }
}