import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foda/components/app_scaffold.dart';
import 'package:foda/components/foda_button.dart';
import 'package:foda/repositories/user_repository.dart';
import 'package:foda/screens/authentication/authentication_state.dart';
import 'package:foda/services/authentication_service.dart';
import 'package:foda/services/get_it.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:foda/utils/common.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../constant/route_name.dart';
import '../../screens/authentication/authentication_view.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final userRepo = locate<UserRepository>();
    final userId = AuthenicationService.instance.auth.currentUser!.uid;
    return AppScaffold(
      body: FutureBuilder(
        future: userRepo.getCurrentUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          print(snapshot.data!.right);

          TextEditingController name =
              TextEditingController(text: snapshot.data!.right.name);
          TextEditingController phone =
              TextEditingController(text: snapshot.data!.right.phone);
          TextEditingController address =
              TextEditingController(text: snapshot.data!.right.address);

          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(30, 130, 30, 20),
              child: Column(children: [
                // -- IMAGE with ICON
                Stack(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                              snapshot.data!.right.profileImageUrl)),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: AppTheme.white),
                        child: IconButton(
                          onPressed: () {},
                          color: Colors.brown,
                          icon: Icon(
                            LineAwesomeIcons.camera,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),

                // -- Form Fields
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: name,
                        decoration: const InputDecoration(
                            label: Text("ФИО"),
                            prefixIcon: Icon(
                              LineAwesomeIcons.user,
                              color: Colors.blue,
                            )),
                      ),
                      const SizedBox(height: 50 - 20),
                      TextFormField(
                        initialValue: snapshot.data!.right.email,
                        readOnly: true,
                        decoration: const InputDecoration(
                            label: Text("Электронная почта"),
                            prefixIcon: Icon(
                              LineAwesomeIcons.envelope_1,
                              color: Colors.blue,
                            )),
                      ),
                      const SizedBox(height: 50 - 20),
                      TextFormField(
                        controller: phone,
                        decoration: InputDecoration(
                            label: snapshot.data!.right.phone.isEmpty
                                ? const Text("Добавьте номер телефона")
                                : const Text("Номер телефона"),
                            prefixIcon: const Icon(
                              LineAwesomeIcons.phone,
                              color: Colors.blue,
                            )),
                      ),
                      const SizedBox(height: 50 - 20),
                      TextFormField(
                        controller: address,
                        // initialValue: snapshot.data!.address,
                        decoration: InputDecoration(
                            label: address.text.isEmpty
                                ? const Text("Укажите адрес")
                                : const Text("Адрес"),
                            prefixIcon: const Icon(
                              LineAwesomeIcons.location_arrow,
                              color: Colors.blue,
                            )),
                      ),

                      const SizedBox(height: 50 - 20),
                      // TextFormField(
                      //   obscureText: true,
                      //   decoration: InputDecoration(
                      //     label: const Text("tPassword"),
                      //     prefixIcon: const Icon(Icons.fingerprint),
                      //     suffixIcon: IconButton(
                      //         icon: const Icon(LineAwesomeIcons.eye_slash),
                      //         onPressed: () {}),
                      //   ),
                      // ),

                      // const SizedBox(height: 30),

                      // -- Form Submit Button
                      SizedBox(
                        width: double.infinity,
                        child: FodaButton(
                          onTap: () async {
                            DocumentReference documentReference =
                                FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(userId);
                            await FirebaseFirestore.instance
                                .runTransaction((transaction) async {
                              DocumentSnapshot documentSnapshot =
                                  await transaction.get(documentReference);
                              await transaction
                                  .update(documentSnapshot.reference, {
                                'name': name.text,
                                'phone': phone.text,
                                'address': address.text,
                              });
                            });
                            showCustomToast("Данные обновлены!");
                          },
                          title: "Редактировать",
                        ),
                      ),

                      SizedBox(
                        height: 30,
                      ),
                      FodaButton(
                        gradiant: [AppTheme.orange, AppTheme.red],
                        onTap: () async {
                          await userRepo.logout();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            authPath,
                            (route) => false,
                            arguments: AuthenticationViewState.signIn,
                          );
                        },
                        title: 'Выйти',
                      ),
                      const SizedBox(height: 100),

                      // -- Created Date and Delete Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: "Аккаунт создан в: ",
                              style: TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                    text: readTimestamp(
                                        snapshot.data!.right.createdAt),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12))
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.redAccent.withOpacity(0.1),
                                elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none),
                            child: Text("Delete"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          );
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
