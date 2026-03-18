import 'model/user.dart';

class UserPreferences {
  static late User _myUser;
  static User get myUser => _myUser;
  static set myUser(User value) => _myUser = value;
  
  static void init() {
    _myUser = const User(
      imagePath: 'assets/images/heart.png',
    name: 'Алиса',
    level: 'Уровень 2',
    isDartMode: false,
    );
  }
}
