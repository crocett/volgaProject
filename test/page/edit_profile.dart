import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../model/user.dart';
import '../user_pref.dart';
import '../widget/appbar_widget.dart';
import '../widget/profile_widget.dart';
import '../widget/textfield_widget.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User user = UserPreferences.myUser;
  File? _pickedImageFile;

  @override
  void initState() {
    super.initState();
    user = UserPreferences.myUser;
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _pickedImageFile = File(pickedFile.path);
          user = user.copyWith(imagePath: pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка выбора изображения: $e')),
        );
      }
    }
  }

  void _saveProfile() {
    Navigator.of(context).pop(user);
    //здесь дописать сохранение в бд, но ее пока нет
  }

  @override
  Widget build(BuildContext context) {
    // final displayImage = _pickedImageFile != null
    //     ? FileImage(_pickedImageFile!)
    //     : AssetImage(user.imagePath) as ImageProvider;

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
                    isEdit: true,
                    onClicked: _pickImage,
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: TextfieldWidget(
                      label: 'Имя',

                      text: user.name,
                      onChanged: (name) {},
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 221, 27, 27),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Сохранить',
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ),

                  //const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
