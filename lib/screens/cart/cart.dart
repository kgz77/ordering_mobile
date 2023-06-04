import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda/components/app_scaffold.dart';
import 'package:foda/repositories/user_repository.dart';
import 'package:foda/screens/authentication/authentication_state.dart';
import 'package:foda/services/get_it.dart';

import '../../services/authentication_service.dart';

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
          // print(docs.first.data());
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${docs[index]['deliveryMethods']}"),
              );
            },
          );
        },
      ),
    );
  }
}
