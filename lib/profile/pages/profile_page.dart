import 'package:flutter/material.dart';
import 'package:foda/components/app_scaffold.dart';
import 'package:foda/components/foda_button.dart';
import 'package:foda/repositories/user_repository.dart';
import 'package:foda/screens/authentication/authentication_state.dart';
import 'package:foda/services/authentication_service.dart';
import 'package:foda/services/get_it.dart';
import 'package:foda/themes/app_theme.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userRepo = locate<UserRepository>();
    final userId = AuthenicationService.instance.auth.currentUser!.uid;
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    return AppScaffold(
      // appBar: AppBar(
      //   leading: IconButton(
      //       onPressed: () => null,
      //       icon: const Icon(LineAwesomeIcons.angle_left)),
      //   title: Text("tProfile", style: Theme.of(context).textTheme.headline4),
      //   actions: [
      //     IconButton(
      //         onPressed: () {},
      //         icon: Icon(isDark ? LineAwesomeIcons.sun : LineAwesomeIcons.moon))
      //   ],
      // ),
      body: StreamBuilder(
        stream: userRepo.listenToCurrentUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          return SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 120, 40, 80),
              // width: 10,
              child: Column(
                children: [
                  /// -- IMAGE
                  Stack(
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(70),
                            child:
                                Image.network(snapshot.data!.profileImageUrl)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(150),
                              color: AppTheme.purple),
                          child: const Icon(
                            LineAwesomeIcons.alternate_pencil,
                            color: Colors.black,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(snapshot.data!.name,
                      style: Theme.of(context).textTheme.headline4),
                  Text(snapshot.data!.email,
                      style: Theme.of(context).textTheme.bodyText2),
                  const SizedBox(height: 20),

                  /// -- BUTTON
                  const SizedBox(
                    width: 250,
                    child: FodaButton(
                      onTap: null,
                      title: "Edit profile",
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 10),

                  /// -- MENU
                  ProfileMenuWidget(
                      title: "Settings",
                      icon: LineAwesomeIcons.cog,
                      onPress: () {}),
                  ProfileMenuWidget(
                      title: "Billing Details",
                      icon: LineAwesomeIcons.wallet,
                      onPress: () {}),
                  ProfileMenuWidget(
                      title: "User Management",
                      icon: LineAwesomeIcons.user_check,
                      onPress: () {}),
                  const Divider(),
                  const SizedBox(height: 10),
                  ProfileMenuWidget(
                      title: "Information",
                      icon: LineAwesomeIcons.info,
                      onPress: () {}),
                  ProfileMenuWidget(
                      title: "Logout",
                      icon: LineAwesomeIcons.alternate_sign_out,
                      textColor: Colors.red,
                      endIcon: false,
                      onPress: () {
                        // Get.defaultDialog(
                        //   title: "LOGOUT",
                        //   titleStyle: const TextStyle(fontSize: 20),
                        //   content: const Padding(
                        //     padding: EdgeInsets.symmetric(vertical: 15.0),
                        //     child: Text("Are you sure, you want to Logout?"),
                        //   ),
                        //   confirm: Expanded(
                        //     child: ElevatedButton(
                        //       onPressed: () => AuthenticationRepository.instance.logout(),
                        //       style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                        //       child: const Text("Yes"),
                        //     ),
                        //   ),
                        //   cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("No")),
                        // );
                        null;
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
