import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:software/signUp/login.dart';
import 'package:software/signUp/signup.dart';
import 'package:software/signUp/welcomePage.dart';
import 'package:flutter/material.dart';

void main(){
group('testing login page email field', () {

  testWidgets('testing for email validation for empty sting', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home:  LoginPage()));
    final getEmailTextField=find.byKey(ValueKey('emailText'));
    await tester.pump();
    var result=EmailFieldValidate.validateEmail('');
    expect(result, 'Please enter email');
  });
  testWidgets('testing for email validation for correct input--ekanth@gmail.com', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home:  LoginPage()));
    final getEmailTextField=find.byKey(ValueKey('emailText'));
    await tester.pump();
    var result=EmailFieldValidate.validateEmail('ekanth@gmail.com');

  });

  testWidgets('testing for email validation for wrong input--xyx#gmail.com', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home:  LoginPage()));
    final getEmailTextField=find.byKey(ValueKey('emailText'));
    await tester.pump();
    var result=EmailFieldValidate.validateEmail('xyx#gmail.com');
    expect(result, 'enter valid email address');
  });


  // testWidgets('testing sign in page', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home:  SignupPage()));
  // });
  //
  // testWidgets('testing sign in page', (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(home:  WelcomePage()));
  // });

});


group('testing login page password field', () {




});

}