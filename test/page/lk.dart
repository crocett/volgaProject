import '../widget/appbar_widget.dart';
import 'package:flutter/material.dart';
import '../user_pref.dart';
import '../widget/profile_widget.dart';
import '../model/user.dart';
import '../widget/button_widget.dart';
import 'edit_profile.dart';

class PersonalAccount extends StatefulWidget {
  const PersonalAccount({super.key});

  @override
  State<PersonalAccount> createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  final user = UserPreferences.myUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/fon_backg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: 100),
              ProfileWidget(
                imagePath: user.imagePath,
                onClicked: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 25),
              buildName(user),
              const Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 30),
                child: Center(child: buildUpgrateButton()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildName(User user) => Column(
    children: [
      Text(
        user.name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      const SizedBox(height: 4),
      Text(user.level, style: TextStyle(color: Colors.grey)),
    ],
  );

  Widget buildUpgrateButton() =>
      ButtonWidget(text: 'Мои достижения', onClicked: () {});
}
