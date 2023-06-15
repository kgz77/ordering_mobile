import 'package:flutter/material.dart';
import 'package:foda/components/foda_button.dart';
import 'package:foda/constant/icon_path.dart';
import 'package:foda/constant/route_name.dart';
import 'package:foda/models/food.dart';
import 'package:foda/states/overview_state.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:provider/provider.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  const FoodCard({Key? key, required this.food}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<OverviewState>();
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, foodDetailPath, arguments: food);
      },
      child: Column(
        children: [
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 300,
                  width: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(25),
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: AppTheme.black.withOpacity(.6),
                    //     spreadRadius: 20,
                    //     blurRadius: 20,
                    //     offset: const Offset(15, 5),
                    //   ),
                    // ],
                    image: DecorationImage(
                      image: NetworkImage(food.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 85,
                  bottom: -10,
                  child: FodaCircleButton(
                    title: "",
                    gradiant: const [
                      AppTheme.orange,
                      AppTheme.orangeDark,
                    ],
                    icon: const Icon(
                      Icons.add,
                      color: AppTheme.white,
                      size: 30,
                    ),
                    onTap: () {
                      state.addToCart(food);
                    },
                  ),
                ),
                Positioned(
                  left: 170,
                  bottom: 170,
                  child: FodaCircleButton(
                    title: "",
                    gradiant: const [
                      AppTheme.darkBlue,
                      AppTheme.darkBlue,
                    ],
                    icon: Image.asset(IconPath.favourite),
                    onTap: () {
                      state.addToFavorite(food);
                    },
                  ),
                ),
                Positioned(
                    left: 9,
                    bottom: -50,
                    child: SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            food.title,
                            style: Theme.of(context).textTheme.headline5,
                          ),
                          const SizedBox(height: 250),
                          Text(
                            " ${food.price} С̲",
                            style: Theme.of(context).textTheme.headline4?.copyWith(color: AppTheme.red),
                          ),
                        ],
                      ),
                    ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
