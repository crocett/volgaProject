import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../database_helper.dart';
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
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late User _user = UserPreferences.myUser;

  File? _pickedImageFile;
  String? _newName;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  //загружаем текущие данные из БД
  Future<void> _loadUserProfile() async {
    try {
      final userFromDb = await _dbHelper.getUserAsModel();
      if (mounted) {
        setState(() {
          _user = userFromDb;
        });
      }
    } catch (e) {
      print('Ошибка загрузки профиля: $e');
    }
  }

  //выбор изображения из галереи
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final appDir = await getApplicationDocumentsDirectory();
        final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final savedImage = await File(pickedFile.path).copy('${appDir.path}/$fileName');

        setState(() {
          _pickedImageFile = savedImage;
          _user = _user.copyWith(imagePath: savedImage.path);
        });
        print('Фото сохранено: ${savedImage.path}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка выбора изображения: $e')),
        );
      }
    }
  }

  //сохранение изменений в БД
  void _saveProfile() async {
    if (_isSaving) {
      return;
    }
    setState(() {
      _isSaving = true;
    });

    try {
      bool success = true;

      if (_newName != null && _newName!.trim().isNotEmpty) {
        success = await _dbHelper.updateUserName(_newName!.trim());
      }

      if (_pickedImageFile != null) {
        success = await _dbHelper.updateUserPhoto(_pickedImageFile!.path) && success;
      }

      if (success && mounted) {
        UserPreferences.myUser = _user.copyWith(
          name: _newName?.trim() ?? _user.name,
          imagePath: _pickedImageFile?.path ?? _user.imagePath,
        );
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Профиль обновлен'))
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка сохраненяит'))
        );
      }
    } catch (e) {
      print('Ошибка при сохранении');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e'))
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
    //Navigator.of(context).pop(user);
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
                  //картинка
                  ProfileWidget(
                    imagePath: _pickedImageFile?.path ?? _user.imagePath,
                    isEdit: true,
                    onClicked: _pickImage,
                  ),
                  const SizedBox(height: 24),
                  //имя
                  Padding(
                    padding: EdgeInsets.all(25),
                    child: TextfieldWidget(
                      label: 'Имя',
                      text: _user.name,
                      onChanged: (name) {
                        setState(() {
                          _newName = name;
                        });
                      },
                    ),
                  ),
                  //const Spacer(),
                  SizedBox(height: 20),
                  //кнопка сохранения
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
