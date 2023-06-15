import 'package:flutter/material.dart';
import 'package:foda/screens/checkout/checkout_state.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:provider/provider.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Оплата только наличными.",
            style: Theme.of(context).textTheme.headline3?.copyWith(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,

                ),
          ),
        ),
        const SizedBox(height: AppTheme.cardPadding),

                        Center(
                          child: Container(
                            height: 270,
                              width: 270,
                              child: Image.asset("assets/images/money.png",)),
                        ),
                        SizedBox(height: 30,),


      ],
    );
  }
}
