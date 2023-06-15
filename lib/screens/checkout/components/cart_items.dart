import 'package:flutter/material.dart';
import 'package:foda/screens/checkout/checkout_state.dart';
import 'package:foda/screens/checkout/components/cart_item_card.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:provider/provider.dart';

class CartItemList extends StatelessWidget {
  const CartItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<CheckoutState>();

    return Expanded(
      child: ListView.builder(
        itemCount: state.cart.length + 1,
        padding: const EdgeInsets.only(top: AppTheme.elementSpacing),
        itemBuilder: (context, index) {
          if (index == state.cart.length) {
            return Padding(
              padding: const EdgeInsets.only(top: AppTheme.cardPadding * 1.5),
              child: Column(
                children: [
                  Text(
                    "Итого",
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text(
                    "${state.cart.length} позиции",
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          color: AppTheme.grey,
                        ),
                  ),
                  Text(
                    "${state.getTotalAmount}С̲",
                    style: Theme.of(context).textTheme.headline2?.copyWith(
                          color: AppTheme.red,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: kToolbarHeight),
                ],
              ),
            );
          }
          return CartItemCard(
            cartItem: state.cart[index],
            food: state.cartItems[state.cart[index].foodId],
          );
        },
      ),
    );
  }
}
