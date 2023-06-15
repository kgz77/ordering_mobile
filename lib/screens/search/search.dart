import 'package:flutter/material.dart';
import 'package:foda/constant/route_name.dart';
import 'package:foda/screens/home/components/food_card.dart';
import 'package:foda/states/overview_state.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:provider/provider.dart';

import '../../components/app_scaffold.dart';
import '../../models/food.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = context.read<OverviewState>();

    return AppScaffold(
      body: SafeArea(
        child: Column(
          children: [

            TextField(
              style: TextStyle(fontSize: 20),
              controller: controller,
              onChanged: (value) => setState(() {}),
              decoration: const InputDecoration(
                hintText: "Поиск по названию",
                hintStyle: TextStyle(fontSize: 15),
                prefixIcon: Icon(Icons.search, size: 37,),
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                fillColor: AppTheme.purpleDark,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  borderSide: BorderSide(color: AppTheme.white, width: 1.0)
                )
              ),
            ),


            Expanded(
              child: ValueListenableBuilder<List<Food>>(
                valueListenable: state.foodRepository.foodsNotifier,
                builder: (context, foods, _) {

                  List<Food> filteredFoods = foods
                      .where((element) => element.title.contains(controller.text))
                      .toList();
                  return ListView.builder(
                    // physics: const ClampingScrollPhysics(),
                    itemCount: filteredFoods.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(

                            leading: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                    filteredFoods[index].imageUrl),),
                            title: Text(
                              filteredFoods[index].title,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              filteredFoods[index].description,
                              style: TextStyle(fontSize: 12),
                            ),
                            trailing: Text(
                              "${filteredFoods[index].price} С̲",
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ListTileStyle.list,
                            onTap: () {
                              // build(context) {
                              //   return FoodCard(food: filteredFoods[index);
                                Navigator.pushNamed(context, foodDetailPath, arguments: filteredFoods[index]);
                              },
                          ),
                          Divider(
                            color: Color.fromARGB(255, 77, 77, 78),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
