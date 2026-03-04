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
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.imagePath,
                onClicked: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditProfilePage()),
                  );
                },
              ),
              const SizedBox(height: 24),
              buildName(user),
              const SizedBox(height: 24),
              Center(child: buildUpgrateButton()),
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
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      ),
      const SizedBox(height: 4),
      Text(user.level, style: TextStyle(color: Colors.grey)),
    ],
  );

  Widget buildUpgrateButton() =>
      ButtonWidget(text: 'Мои достижения', onClicked: () {});
}
