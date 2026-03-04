import 'package:flutter/material.dart';
import '../model/user.dart';
import '../user_pref.dart';
import '../widget/appbar_widget.dart';
import '../widget/profile_widget.dart';
import '../widget/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;

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
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              ProfileWidget(
                imagePath: user.imagePath,
                isEdit: true,
                onClicked: () async {},
              ),
              const SizedBox(height: 24),
              TextfieldWidget(
                label: 'Имя',
                text: user.name,
                onChanged: (name) {},
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 221, 27, 27),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Сохранить', style: TextStyle(fontSize: 17, color: Colors.white)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
