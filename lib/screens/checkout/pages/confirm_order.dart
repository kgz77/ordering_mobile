import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foda/components/foda_button.dart';
import 'package:foda/screens/account/account.dart';
import 'package:foda/screens/authentication/authentication_state.dart';
import 'package:foda/screens/checkout/checkout_state.dart';
import 'package:foda/screens/checkout/components/cart_summery.dart';
import 'package:foda/screens/checkout/components/payment_method.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:foda/utils/common.dart';
import 'package:provider/provider.dart';

class ConfirmOrder extends StatelessWidget {
  const ConfirmOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutState>();
    return Column(
      children: [
        const SizedBox(height: AppTheme.elementSpacing),
        Text(
          "Confirm Order",
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
            title: "Confirmation",
            gradiant: const [
              AppTheme.orange,
              AppTheme.red,
            ],
            onTap: () {


              if (state.currentUser.phone.isNotEmpty) {
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
  }
}
