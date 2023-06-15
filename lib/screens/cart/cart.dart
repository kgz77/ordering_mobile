import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda/components/app_scaffold.dart';
import 'package:foda/repositories/user_repository.dart';
import 'package:foda/screens/authentication/authentication_state.dart';
import 'package:foda/services/get_it.dart';
import 'package:intl/intl.dart';

import '../../services/authentication_service.dart';
import '../../themes/app_theme.dart';
import '../../utils/common.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final userRepo = locate<UserRepository>();
    final userId = AuthenicationService.instance.auth.currentUser!.uid;

    return AppScaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("orders")
            .where("uid", isEqualTo: userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var docs = snapshot.data!.docs;
          docs.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));
          // print(docs.first.data());
          return docs.isNotEmpty ? ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return Dismissible(
                key: Key(docs[index]['orderId']),
                onDismissed: (direction) async {
                  DocumentReference documentReference = FirebaseFirestore
                      .instance
                      .collection("orders")
                      .doc(docs[0]['orderId']);

                  await FirebaseFirestore.instance
                      .runTransaction((transaction) async {
                    DocumentSnapshot documentSnapshot =
                    await transaction.get(documentReference);
                    docs.removeAt(index);
                    await transaction.update(
                        documentSnapshot.reference, {'uid': ''});
                  });
                  showCustomToast("Заказ удален из истории");
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
                child: Column(
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              docs[index]['orderItems'][0]['coverImageUrl']),),
                      title: Text(
                        "${docs[index]['orderItems'][0]['title']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),),
                      subtitle: Text(
                        "Дата: " + readTimestamp(docs[index]['createdAt']),
                        style: TextStyle(fontSize: 12),
                      ),
                      trailing: Text(
                        "${docs[index]['totalPrice']} С̲",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Divider(
                      color: Color.fromARGB(255, 77, 77, 77),
                    ),
                  ],
                ),
              );
            },
          ) : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: 300,
                      width: 300,
                      child: Image.asset("assets/images/his.png", )),
                  SizedBox(height: 30,),
                  Text("Пока история заказов пуст!", style: TextStyle(fontSize: 20),),
                ],
              ));
        },
      ),
    );
  }
}

String readTimestamp(int timestamp) {
  var now = new DateTime.now();
  var format = new DateFormat('dd/MM/yyyy HH:mm');
  var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp * 1000);
  var diff = date.difference(now);
  var time = '';

  if (diff.inSeconds <= 0 ||
      diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0 ||
      diff.inHours > 0 && diff.inDays == 0) {
    time = format.format(date);
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() + 'DAY AGO';
    } else {
      time = diff.inDays.toString() + 'DAYS AGO';
    }
  }

  return time;
}
