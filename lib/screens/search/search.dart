import 'package:flutter/material.dart';
import 'package:foda/states/overview_state.dart';
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
              controller: controller,
              onChanged: (value) => setState(() {}),
            ),


            Expanded(
              child: ValueListenableBuilder<List<Food>>(
                valueListenable: state.foodRepository.foodsNotifier,
                builder: (context, foods, _) {

                  List<Food> filteredFoods = foods
                      .where((element) => element.title.contains(controller.text))
                      .toList();

                  return ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    itemCount: filteredFoods.length,
                    itemBuilder: (context, index) {
                      return Text(
                          filteredFoods[index].title,
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
