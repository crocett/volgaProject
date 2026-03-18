import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:volga/page/article_page.dart';
import '../database_helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _tagHist = false;
  bool _tagCult = false;
  bool _tagCent = false;
  bool _isSearch = false;
  bool _hasSearch = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  //поиск
  Future<void> _performSearch() async {
    setState(() {
      _isSearch = true;
      _hasSearch = true;
    });

    try {
      final keyword = _searchController.text.trim();
      if (keyword.isEmpty && !_tagHist && !_tagCult && _tagCent) {
        final all = await _dbHelper.searchArticle();
        setState(() {
          _results = all;
          _isSearch = false;
        });
        return;
      }

      //поиск по критериям
      final result = await _dbHelper.searchArticle(
        keyword: keyword.isEmpty ? null : keyword,
        historic: _tagHist,
        culture: _tagCult,
        center: _tagCent,
      );
      setState(() {
        _results = result;
        _isSearch = false;
      });
    } catch (e) {
      print('Ошибка поиска: $e');
      setState(() {
        _results = [];
        _isSearch = false;
      });
    }
  }

  //сброс фильтра
  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _tagCent = false;
      _tagCult = false;
      _tagCent = false;
      _results = [];
      _hasSearch = false;
    });
  }

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Search');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[600],
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
          children: [
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: AppBar(
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Colors.red[600],
                  statusBarIconBrightness: Brightness.dark,
                ),
                leading: Icon(Icons.search, color: Colors.white, size: 30),
                title: TextField(
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Введите...',
                    hintStyle: TextStyle(color: Colors.white),
                    labelStyle: TextStyle(color: Colors.white),

                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    //icon: Icon(Icons.cancel, color: Colors.white, size: 30,),
                  ),
                  onSubmitted: (_) => _performSearch(),
                ),
                shape: RoundedRectangleBorder(
                  //borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.red[600],
                actions: [
                  if (_searchController.text.isNotEmpty || _hasSearch)
                    IconButton(
                      onPressed: _clearFilters,
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 150.0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        constraints: const BoxConstraints.expand(),
        child: Column(
          children: [
            _buildTagFilters(),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSearch ? null : _performSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _isSearch
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text('Найти', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(child: _buildResultList()),
            // Center(
            //   child: Text(
            //     'Здесь должен быть поиск',
            //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.w200),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagFilters() {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16, vertical: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildTagChip('Исторический', _tagHist, (v) {
            setState(() {
              _tagHist = v;
            });
          }),
          _buildTagChip('Культура', _tagCult, (v) {
            setState(() {
              _tagCult = v;
            });
          }),
          _buildTagChip('Центр', _tagCent, (v) {
            setState(() {
              _tagCent = v;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildTagChip(
    String label,
    bool isSelected,
    ValueChanged<bool> onSelected,
  ) {
    return FilterChip(
      label: Text(label),
      onSelected: onSelected,
      selected: isSelected,
      selectedColor: Colors.red[200],
      checkmarkColor: Colors.white,
      backgroundColor: Colors.grey[200],
      labelStyle: TextStyle(color: isSelected ? Colors.red : Colors.black54),
    );
  }

  Widget _buildResultList() {
    if (!_hasSearch) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.grey),
            SizedBox(height: 20),
            Text('Введите запрос или выберите тег'),
          ],
        ),
      );
    }

    if (_isSearch) {
      return Center(child: CircularProgressIndicator());
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_dissatisfied_rounded,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 20),
            Text('Ничего не найдено'),
            SizedBox(height: 20),
            TextButton(
              onPressed: _clearFilters,
              child: Text('Сбросить фильтры'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(15),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final article = _results[index];
        return _buildArticleCard(article);
      },
    );
  }

  //Отдельно карточка статьи
  Widget _buildArticleCard(Map<String, dynamic> article) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailPage(article: article),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            children: [
              if (article['image'] != null)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(article['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.article, color: Colors.red),
                ),
              SizedBox(height: 15),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['name'] ?? 'Без названия',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                  
                      // Теги статьи
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: [
                          if (article['historic'] == 1) Icon(Icons.history_edu, size: 18,),
                          if (article['culture'] == 1) Icon(Icons.theater_comedy, size: 18,),
                          if (article['center'] == 1) Icon(Icons.location_city, size: 18,),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
