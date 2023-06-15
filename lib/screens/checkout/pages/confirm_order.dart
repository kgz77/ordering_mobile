// import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foda/components/foda_button.dart';
import 'package:foda/screens/account/account.dart';
import 'package:foda/screens/authentication/authentication_state.dart';
import 'package:foda/screens/checkout/checkout_state.dart';
import 'package:foda/screens/checkout/components/cart_summery.dart';
import 'package:foda/screens/checkout/components/payment_method.dart';
import 'package:foda/services/authentication_service.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:foda/utils/common.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatelessWidget {
  const ConfirmOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutState>();
    final userId = AuthenicationService.instance.auth.currentUser!.uid;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("users").where("uid", isEqualTo: userId).snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return Container();
        }
        var docs = snapshot.data!.docs;
        return Column(
          children: [
            const SizedBox(height: AppTheme.elementSpacing),
            Text(
              "Подтвердить заказ",
              style: Theme.of(context).textTheme.headline2?.copyWith(
                color: AppTheme.orange,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppTheme.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: AppTheme.cardPadding),
                    CartSummery(),
                    PaymentMethod(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.cardPadding),
              child: FodaButton(
                state: state.isLoading ? ButtonState.loading : ButtonState.idle,
                title: "Подтвердить",
                gradiant: const [
                  AppTheme.orange,
                  AppTheme.red,
                ],
                onTap: () {


                  if (docs.first['phone'] != '' && docs.first['address'] != '') {
                    context.read<CheckoutState>().placeOrder();
                    return;
                  }

                  showCustomToast(
                      "Заполните обьязательные поля"
                  );

                  Navigator.push(context, CupertinoPageRoute(builder: (_) => const AccountPage()));

                },
              ),
            ),
            const SizedBox(height: kToolbarHeight),
          ],
        );
      },
    );
  }
}
