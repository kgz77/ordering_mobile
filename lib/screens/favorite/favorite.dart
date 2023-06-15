import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foda/repositories/food_repository.dart';
import 'package:foda/repositories/user_repository.dart';
import 'package:foda/screens/home/components/app_bar.dart';
import 'package:foda/services/authentication_service.dart';
import 'package:foda/services/get_it.dart';
import 'package:foda/themes/app_theme.dart';

import '../../components/app_scaffold.dart';
import '../../utils/common.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    final userRepo = locate<UserRepository>();
    final foodRepo = locate<FoodRepository>();
    final userId = AuthenicationService.instance.auth.currentUser!.uid;

    return AppScaffold(
      body: StreamBuilder(
        stream: userRepo.listenToCurrentUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var docs = snapshot.data!.favorites;

          return docs.isNotEmpty
              ? ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final item = docs[index];
                    return Dismissible(
                      key: Key(item),
                      onDismissed: (direction) async {
                        DocumentReference documentReference = FirebaseFirestore
                            .instance
                            .collection("users")
                            .doc(userId);

                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot documentSnapshot =
                              await transaction.get(documentReference);
                          docs.removeAt(index);
                          await transaction.update(
                              documentSnapshot.reference, {'favorites': docs});
                        });
                        showCustomToast("Еда удалена из избранных");
                      },
                      background: Container(
                        color: AppTheme.red,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 370),
                          child: Icon(
                            Icons.delete,
                            color: AppTheme.black,
                          ),
                        ),
                      ),
                      child: FutureBuilder(
                        future: foodRepo.getFood(docs[index]),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          }
                          return Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                        snapshot.data!.right.imageUrl)),
                                title: Text(
                                  snapshot.data!.right.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  snapshot.data!.right.description,
                                  style: TextStyle(fontSize: 12),
                                ),
                                trailing: Text(
                                  "${snapshot.data!.right.price} С̲",
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ListTileStyle.list,
                              ),
                              Divider(
                                color: Color.fromARGB(255, 77, 77, 77),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                )
              : Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 300,
                        width: 300,
                        child: Image.asset("assets/images/fav.png", )),
                    SizedBox(height: 30,),
                    Text("Пока избранных блюд нет!", style: TextStyle(fontSize: 20),),
                  ],
                ));
        },
      ),
    );
  }
}
