import 'package:flutter/material.dart';
import 'package:foda/screens/food_detail/food_detail_state.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:provider/provider.dart';

class FoodDetail extends StatelessWidget {
  const FoodDetail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<FoodDetailState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              state.food.title,
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(
              " ${state.food.price} С̲",
              style: Theme.of(context).textTheme.headline2?.copyWith(
                    color: AppTheme.red,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.cardPadding),
        Text(
          "Описание",
          style: Theme.of(context).textTheme.headline2?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: AppTheme.elementSpacing),
        Text(
          state.food.description,
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: Colors.tealAccent,
              ),
        ),
        const SizedBox(height: AppTheme.cardPadding),
        // Text(
        //   "Ингриденты",
        //   style: Theme.of(context).textTheme.headline3?.copyWith(
        //         fontWeight: FontWeight.w600,
        //       ),
        // ),
        // // const SizedBox(height: AppTheme.cardPadding),
        // SizedBox(
        //   height: 190,
        //   child: GridView.count(
        //     physics: ScrollPhysics(),
        //     childAspectRatio: 3,
        //     crossAxisCount: 3,
        //     children: List.generate(state.food.ingridients.length, (index) {
        //       return Wrap(
        //         runSpacing: 0,
        //         spacing: 0,
        //         children: [
        //           Chip(
        //             label: Container(
        //               width: 100,
        //               height: 20,
        //               child: Center(
        //                 child: Text(
        //                       "${state.food.ingridients.elementAt(index)}",
        //                   ),
        //               ),
        //             ),
        //             labelStyle: TextStyle(fontSize: 12),
        //           ),
        //         ] ,
        //         // child:
        //         //   Text("${state.food.ingridients.elementAt(index)}",
        //         //     style: TextStyle(fontSize: 18),),
        //       );
        //     }),
        //   ),
        // ),


      ],
    );
  }
}
