import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:software/signUp/login.dart';
import 'package:software/signUp/signup.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override

  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(750, 1334));

    return Scaffold(
      resizeToAvoidBottomInset:false,
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:  [
            const Center(
              child: Text("Hello!",
              style: TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
              child: SvgPicture.asset(
                "assets/icons/books.svg",
                height: 0.7.sw,
                width: 0.5.sw,
                fit: BoxFit.fitWidth,
              ),
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 0.5.sw,
                  height: .12.sw,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(const Radius.circular(50)),
                    color: Colors.red.shade200,
                  ),
                  child: Center(
                    child: Text(
                      'Login',
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
              onTap: (){

                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const LoginPage()));
              },
            ),

            GestureDetector(
              key: Key('signUp'),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  width: 0.5.sw,
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
              onTap: (){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => const SignupPage()));
              },
            ),

          ],
        ),
      ),
    );
  }
}
