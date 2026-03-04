import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Search');
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[600],
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70.0),
        child: AppBar(
          leading: Icon(Icons.search, color: Colors.white),
          title: TextField(
            controller: _searchController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Поиск чего-то там',
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),

              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 0.2),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      icon: Icon(Icons.cancel, color: Colors.white),
                    )
                  : null,
            ),
          ),
          shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.red[600],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 110.0),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
          color: Colors.white,
        ),
        constraints: const BoxConstraints.expand(),
        child: Center(child: Text('Какой-то текст')),
      ),

      // child: Stack(
      //   children: [
      //     Positioned.fill(
      //       child: DecoratedBox(
      //         decoration: BoxDecoration(
      //           image: DecorationImage(
      //             image: AssetImage("assets/images/fon_backg.png"),
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ),
      //     const Text('Пока ничего нет'),
      //   ],
      // ),
      //),
    );
  }
}
