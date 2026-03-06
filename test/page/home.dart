import 'package:flutter/material.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // body: Stack(
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
      //   ],
      // ),
      // body: Container(
      //   child: Column(
      //     children: [
      //       Padding(padding: EdgeInsets.all(20), child: ,),
      //       Text('Интересное'),
      //       TextButton(
      //         onPressed: () {},
      //         style: TextButton.styleFrom(
      //           backgroundColor: Colors.red,
      //           //primary: Colors.white,
      //           padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      //           textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      //         ),
      //         child: Text('Нажми меня', style: TextStyle(color: Colors.white)),
      //       ),
      //     ],
      //   ),
      // ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    (MediaQuery.of(context).size.width / 130).clamp(1, 10).toInt(),
                    (index) {
                    return [
                      Image.asset(
                        'assets/images/chuv.png',
                        //height: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 5),
                    ];
                  }).expand((e) => e).toList()..removeLast(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/heart_home.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  ...List.generate(
                    (MediaQuery.of(context).size.width / 130).clamp(1, 10).toInt(), 
                    (index) {
                    return [
                      Image.asset(
                        'assets/images/chuv.png',
                        //height: 35,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 5),
                    ];
                  }).expand((e) => e).toList()..removeLast(),
                ],
              ),
            ),

            // Padding(
            //   padding: EdgeInsets.all(30),
            //   child: Container(
            //     clipBehavior: Clip.antiAlias,
            //     decoration: BoxDecoration(
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(20),
            //         topRight: Radius.circular(20),
            //         bottomLeft: Radius.circular(20),
            //         bottomRight: Radius.circular(20),
            //       ),
            //       //color: const Color.fromARGB(255, 179, 172, 172),
            //     ),
            //     width: double.infinity,
            //     height: 100,
            //     child: Center(
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           Expanded(
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 // Image.asset('assets/images/chuv.png', width: 35),
            //                 // SizedBox(width: 5),
            //                 // Image.asset('assets/images/chuv.png', width: 35),
            //                 // SizedBox(width: 5),
            //                 // Image.asset('assets/images/chuv.png', width: 35),
            //               ],
            //             ),
            //           ),

            //           //SizedBox(width: 10),
            //           Expanded(
            //             child: Image.asset('assets/images/heart_home.png'),
            //           ),

            //           //SizedBox(width: 5),
            //           Expanded(
            //             child: Row(
            //               mainAxisSize: MainAxisSize.min,
            //               children: [
            //                 Image.asset('assets/images/chuv.png', width: 35),
            //                 SizedBox(width: 5),
            //                 Image.asset('assets/images/chuv.png', width: 35),
            //                 SizedBox(width: 5),
            //                 Image.asset('assets/images/chuv.png', width: 35),
            //                 //Image.asset('assets/images/chuv.png')
            //               ],
            //             ),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),

            //интересное
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: const Color.fromARGB(255, 179, 172, 172),
                ),
                width: double.infinity,
                height: 200,
                //color: const Color.fromARGB(255, 179, 172, 172),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Интересное',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            179,
                            172,
                            172,
                          ),
                          side: BorderSide(
                            color: const Color.fromARGB(150, 244, 67, 54),
                            width: 2.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Подробнее',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            //вторая про памятники
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  //shape: Image.asset(''),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: const Color.fromARGB(255, 179, 172, 172),
                ),
                width: double.infinity,
                height: 200,
                //color: const Color.fromARGB(255, 179, 172, 172),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Памятники',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Spacer(),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromARGB(
                            255,
                            179,
                            172,
                            172,
                          ),
                          side: BorderSide(
                            color: const Color.fromARGB(150, 244, 67, 54),
                            width: 2.0,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          textStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Подробнее',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.chevron_right, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            //теперь две
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 10),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: const Color.fromARGB(255, 179, 172, 172),
                      ),
                      width: double.infinity,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text('Тесты'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ),
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 10, right: 30),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                        color: const Color.fromARGB(255, 179, 172, 172),
                      ),
                      width: double.infinity,
                      height: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextButton(
                            onPressed: () {},
                            child: Text('Квесты'),
                            style: TextButton.styleFrom(
                              foregroundColor: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ),
                              textStyle: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
