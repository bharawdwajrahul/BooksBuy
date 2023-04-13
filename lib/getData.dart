


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

import 'books/domain/bookDetails.dart';

 class  GetBooks {
   Map<String,Books> booksList={};
   Future<Map<String,dynamic>> getBooksData() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     print('getbooks---');
      return FirebaseFirestore.instance.collection('books').doc('books').get().then((value) {
       return value.get('booksList');
      });
   }
}