import 'package:sqflite/sqflite.dart';

import '../database_helper.dart';
import '../widget/appbar_widget.dart';
import 'package:flutter/material.dart';
import '../user_pref.dart';
import '../widget/profile_widget.dart';
import '../model/user.dart';
import '../widget/button_widget.dart';
import 'edit_profile.dart';
import 'result_test_page.dart';

class PersonalAccount extends StatefulWidget {
  const PersonalAccount({super.key});

  @override
  State<PersonalAccount> createState() => _PersonalAccountState();
}

class _PersonalAccountState extends State<PersonalAccount> {
  //final user = UserPreferences.myUser;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late User _user = UserPreferences.myUser;

  List<Map<String, dynamic>> _recentTest = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initPage();
  }

  Future<void> _initPage() async {
    // await Future.wait([_loadUserProfile(), _loadRecentTests()]);
    // setState(() {
    //   _isLoading = false;
    // });
    await _loadUserProfile();
  }

  //загрузка профиля из бд
  Future<void> _loadUserProfile() async {
    try {
      final userFromDb = await _dbHelper.getUserAsModel();
      setState(() {
        _user = userFromDb;
        UserPreferences.myUser = userFromDb;
      });
    } catch (e) {
      print('Ошибка загрузки профиля: &e');
      setState(() {
        _user = UserPreferences.myUser;
      });
    }
  }

  //загрузка последних тестов (без изменений)
  Future<void> _loadRecentTests() async {
    try {
      final allResult = await _dbHelper.getAllTestResultsWithStats();
      setState(() {
        _recentTest = allResult.take(2).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка загрузки тестов: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(153, 244, 67, 54), 
                      //offset: Offset(5, 5),
                      blurRadius: 10,
                      spreadRadius: 2
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 0,
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: ProfileWidget(
                  imagePath: _user.imagePath,
                  onClicked: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    );
                    if (result == true) {
                      setState(() {
                        _loadUserProfile();
                      });
                    }
                  },
                ),
              ),

              const SizedBox(height: 25),
              buildName(_user),

              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _recentTest.isEmpty
                  ? _buildNoTestsMessage()
                  : _buildRecentTestsSection(),
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

  Widget buildUpgrateButton() => ButtonWidget(
    text: 'Мои достижения',
    onClicked: () {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => ResultTestPage()));
    },
  );

  Widget _buildNoTestsMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Icon(Icons.emoji_events_outlined, size: 50, color: Colors.grey[400]),
          SizedBox(height: 10),
          Text(
            'Пока нет пройденных тестов',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            'Пройдите первый тест, чтобы увидеть результат',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Последние тесты',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              if (_recentTest.length >= 2)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ResultTestPage()),
                    );
                  },
                  child: Text(
                    'Все пройденные тесты',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        ..._recentTest.map((test) => _buildTestCard(test)),

        if (_recentTest.length < 2)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ButtonWidget(
              text: 'Все тесты',
              onClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ResultTestPage()),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildTestCard(Map<String, dynamic> test) {
    final testName = test['test_title'] ?? 'Тест #${test['id_test']}';
    final result = test['t_result'] as int? ?? 0;
    final totalQuestions = test['total_questions'] as int? ?? 10;
    final percentage = (result / totalQuestions * 100).round();

    final color = percentage >= 70
        ? Colors.green
        : percentage >= 50
        ? Colors.orange
        : Colors.red;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      color: Colors.white.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color,
          child: Text(
            '$result',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(testName, style: TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          '$percentage%',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
