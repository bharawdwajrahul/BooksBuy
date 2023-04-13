
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/utils.dart';
import 'package:software/billingPage/billingPage.dart';
import 'package:software/books/domain/bookDetails.dart';
import 'package:software/books/presentation/booksPage.dart';
import 'package:software/cart/domain/cartDetails.dart';
import 'package:software/cart/presentation/cartPage.dart';
import 'package:software/orders/domain/orderDetails.dart';
import 'package:software/orders/presentation/ordersPage.dart';


void main() async {
  group('testing billing', () {
    FunGrandTotal funGrandTotal = FunGrandTotal();
    int totalPrice = 0;
    int discount = 0;
    int grandTotal = 0;

    test('Testing total price', () {
      totalPrice = funGrandTotal.totalPrice([15, 15, 10]);
      expect(totalPrice, 40);
    });
    test('Testing discount amount', () {
      discount = funGrandTotal.funDiscountTotal(totalPrice);
      expect(discount, 8);
    });

    test('Testing grand total amount', () {
      discount = funGrandTotal.funFinalPrice(totalPrice, discount);
      grandTotal = (totalPrice - discount) + 6;
      expect(grandTotal, 38);
    });
  });


  group('books testing', ()    {
    BooksDisplayed booksDisplayed=BooksDisplayed();
    booksDisplayed.books();
    BookDetailsList bookDetailsList=BookDetailsList(booksList: {});
    test('Testing all the Items in the cart', () async {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await booksDisplayed.firebaseFirestore
          .collection('books')
          .doc('books')
          .get();
      final Map<String, dynamic>? booksData = documentSnapshot.data();
      bookDetailsList=BookDetailsList.fromJson(booksData!);

      expect(booksDisplayed.booksList, booksData);
    });


    test('checking for no of books in cart is equal to 5', () {
      expect(bookDetailsList.booksList.length, 5);
    });


    test('checking all the price of the books are same', () {
      List<int> booksPrice=[];
      bookDetailsList.booksList.forEach((key, value) {
        booksPrice.add(value.price!);
      });
      expect(booksPrice,[15,15,10,20,10]);
    });

    test('Testing if the cart contains all the books', () {
      List<String> booksName=[];
      bookDetailsList.booksList.forEach((key, value) {
        booksName.add(value.name!);
      });
      expect(booksName, ['The Fellowship of the Ring: Discover Middle-earth','Interesting Facts For Curious Minds: 1572 Random Facts',
        'The Bullet That Missed: (The Thursday Murder Club 3)','The island of trees','No Plan B: The unputdownable new 2022 Jack Reacher' ]);
    });

    test('Checking for all the ratings are less then 5 and greater then 0', () {
      bool ratingsAboveFive=false;
      bookDetailsList.booksList.forEach((key, value) {
        if(value.ratings! <= 5 && value.ratings!.isGreaterThan(0)){
          ratingsAboveFive=true;
        }
        else{
          ratingsAboveFive=false;
        }
      });
      expect(ratingsAboveFive, true);
    });

  });


  group('cart testing', ()    {
    CartItems cartItems=CartItems();
    cartItems.cart();
    CartDetailsList cartDetailsList=CartDetailsList(cart: {});


    test('Testing all the Items in the cart', () async {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await cartItems.cartFirebaseFirestore
          .collection('Users')
          .doc('anOJS7zHY2cebx1OgVQ1blgjWJp1')
          .get();
      final Map<String, dynamic>? cartData = documentSnapshot.data();
      cartDetailsList=CartDetailsList.fromJson(cartData!);
      expect(cartItems.cartDetails, cartData);
    });


    test('checking for no of books in cart', () {
      expect(cartDetailsList.cart.length, 2);
    });


    test('checking for total price of the books in cart', () {
      int total=0;
      cartDetailsList.cart.forEach((key, value) {
        total=total+value.price!.toInt();
      });
      expect(total, 30);
    });

    test('Testing if the cart contains the book The Fellowship of the Ring: Discover Middle-earth', () {
      String book='';
      bool hasBook=false;
      cartDetailsList.cart.forEach((key, value) {
        if(value.name=='The Fellowship of the Ring: Discover Middle-earth'){
          hasBook=true;
        }
        else{
          hasBook==false;
        }
      });

      expect(hasBook, true);
    });

    test('Checking for name of the books in cart', () {
      List<String> booksInCart=['The Fellowship of the Ring: Discover Middle-earth','Interesting Facts For Curious Minds: 1572 Random Facts'];
      List<String> booksFromDatabase=[];
      cartDetailsList.cart.forEach((key, value) {
        booksFromDatabase.add(value.name!);
      });
      expect(booksInCart, booksFromDatabase);
    });

  });



  group('order testing', () {
    OrdersDisplayed ordersDisplayed=OrdersDisplayed();
    ordersDisplayed.orders();
    OrderDetailsList orderDetailsList=OrderDetailsList(ordersList: {});

    test('Testing all the Items in the orders', () async {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
      await ordersDisplayed.orderFirebaseFirestore
          .collection('order')
          .doc('order')
          .get();
      final Map<String, dynamic>? orderData = documentSnapshot.data();

      orderDetailsList=OrderDetailsList.fromJson(orderData!);
      expect(ordersDisplayed.orderList, orderData);
    });

    test('checking for no of orders done by the user', () {
      expect(orderDetailsList.ordersList!.length, 2);
    });

    test('checking grand total of orders', () {
      List<int> grandTotal=[];
      orderDetailsList.ordersList!.forEach((key, value) {
        grandTotal.add(value.grandTotal!);
      });
      expect(grandTotal, [38,21]);
    });

    test('checking discount price of the orders', () {
      List<int> discountPrice=[];
      orderDetailsList.ordersList!.forEach((key, value) {
        discountPrice.add(value.discount!);
      });
      expect(discountPrice, [8,0]);
    });

    test('checking book id for the orders', () {
      List<String> bookIds=[];
      orderDetailsList.ordersList!.forEach((key, value) {
        value.booksList.keys.forEach((element) {
          bookIds.add(element);
        });
      });
      expect(bookIds, [
        '0d1f2a4b-23cc-40db-a925-c7b1ad80f687',
        '202fbc89-27a1-419f-b9a6-029c2ab18b31',
        'e8caa86d-4d52-45e7-8161-4490759e1538',
        '0d1f2a4b-23cc-40db-a925-c7b1ad80f687'
      ]);
    });
  });



}
