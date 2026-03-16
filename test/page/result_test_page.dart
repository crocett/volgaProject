import 'package:flutter/material.dart';
import '../database_helper.dart';
import '../constants.dart';

class ResultTestPage extends StatefulWidget {
  const ResultTestPage({super.key});

  @override
  State<ResultTestPage> createState() => _ResultTestPageState();
}

class _ResultTestPageState extends State<ResultTestPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _allResults = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllResults();
  }

  Future<void> _loadAllResults() async {
    try {
      final results = await _dbHelper.getAllTestResultsWithStats();
      setState(() {
        _allResults = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: Text('Все достижения'),
        backgroundColor: background,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _allResults.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 20),
                  Text('Нет пройденных тестов', style: TextStyle(fontSize: 18)),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _allResults.length,
              itemBuilder: (context, index) {
                final test = _allResults[index];
                return _buildTestCard(test);
              },
            ),
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
        subtitle: Text('$result/$totalQuestions • ${test['created_at'] ?? ''}'),
        trailing: Text(
          '$percentage%',
          style: TextStyle(fontWeight: FontWeight.bold, color: color),
        ),
      ),
    );
  }
}
