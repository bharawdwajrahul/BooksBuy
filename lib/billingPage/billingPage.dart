
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:software/billingPage/paymentPage.dart';
import 'package:uuid/uuid.dart';
import '../cart/application/cart_watcher_bloc/cart_watcher_bloc.dart';
import '../injection.dart';
import '../orders/domain/orderDetails.dart';
import 'addressPage.dart';

class BillingPage extends StatefulWidget {
  BillingPage(this.address,this.uId);
  final String address;
  final String uId;
  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  String defaultIdValue = '';
  OrderDetailsList orderDetailsList = OrderDetailsList(ordersList: {});
  OrderBooksList orderBooksList = OrderBooksList(booksList: {});
  OrderDetails orderDetails = OrderDetails('', 0, 0, 0, 0, '', {});
  FunGrandTotal funGrandTotal=FunGrandTotal();
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
                ..add( CartWatcherEvent.watchAllStarted(widget.uId)),
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
                  noOfBooks = state.cartDetailsList.cart.length;
                  state.cartDetailsList.cart.values.forEach((element) {
                    total = total + element.price!.toInt();
                  });
                  if (state.cartDetailsList.cart.length >= 3) {
                    grandTotal = funGrandTotal.funGrandTotal(total);
                    discount = funGrandTotal.funDiscountTotal(grandTotal);
                  } else {
                    grandTotal = total + 6;
                  }

                  orderDetails.total = total;
                  orderDetails.noOfBooks = noOfBooks;
                  orderDetails.orderStatus = 'PLACED';
                  orderDetails.grandTotal = grandTotal;
                  orderDetails.discount = discount;
                  orderDetails.orderId = Uuid().v4();
                  orderDetails.booksList = state.cartDetailsList.cart;
                  return Scaffold(
                    appBar: AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.black, //change your color here
                      ),
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      title: const Text(
                        'Order Details',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    body: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Billing Addresss:',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10, right: 20),
                          child: Text(widget.address,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Billing Details:',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                              )),
                        ),
                        Visibility(
                          visible: state.cartDetailsList.cart.length < 3,
                          replacement: const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              '20% discount applied',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Add ${3 - state.cartDetailsList.cart.length} more books to get 20% off',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Padding(
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
                                    itemCount:
                                        state.cartDetailsList.cart.length,
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
                                                child: Text(
                                                  state.cartDetailsList.cart
                                                      .values
                                                      .elementAt(index)
                                                      .name!,
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
                                                  ':  ${state.cartDetailsList.cart.values.elementAt(index).price}£',
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
                                          ':  ${total}£',
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
                                          ':  ${discount}£',
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
                                          ':  ${grandTotal}£',
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
                        )
                      ],
                    ),
                    bottomNavigationBar: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 30, horizontal: 40),
                          child: Container(
                            width: .6.sw,
                            height: .12.sw,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Text(
                                'Payment',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          orderDetailsList.ordersList = {
                            '${orderDetails.orderId}': orderDetails
                          };
                          print('onTap-------');
                          print(state.cartDetailsList.cart.keys);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PaymentPage(orderDetailsList,widget.uId)));
                        }),
                  );
                },
                loadFailure: (state) {
                  return Container();
                },
              );
            },
          )),
    );
  }

  int funDiscountTotal(int grandTotal, int total ){
    grandTotal = ((total - ((total * 20) / 100)) + 6).toInt();
    discount = total - (total - ((total * 20) / 100)).toInt();
    return discount;
  }
}

 class FunGrandTotal{
  int grandTotal=0;
  int discount=0;
  int price=0;

   int funGrandTotal(int total ){
     grandTotal = ((total - ((total * 20) / 100)) + 6).toInt();
     // discount = total - (total - ((total * 20) / 100)).toInt();
     return grandTotal;
   }

   int funDiscountTotal(int grandTotal){
     int total=0;
     //grandTotal = ((total - ((total * 20) / 100)) + 6).toInt();
     discount = grandTotal - (grandTotal - ((grandTotal * 20) / 100)).toInt();
     return discount;
     }

  int funFinalPrice(int grandTotal,int discount){
    int finalPrice=0;
    finalPrice=(grandTotal-discount)+6;
    return discount;

  }

  int totalPrice(List<int> priceList){
     int price=0;
     priceList.forEach((element) {
       price=price+element;
     });
     return price;
  }
}