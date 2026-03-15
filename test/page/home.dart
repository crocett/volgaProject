import 'package:flutter/material.dart';
import 'quests_page.dart';
import 'all_questions_page.dart';
import 'questions_page.dart';

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
            SizedBox(height: 40),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...List.generate(
                    (MediaQuery.of(context).size.width / 130)
                        .clamp(1, 10)
                        .toInt(),
                    (index) {
                      return [
                        Image.asset(
                          'assets/images/chuv.png',
                          //height: 35,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 5),
                      ];
                    },
                  ).expand((e) => e).toList()..removeLast(),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset(
                      'assets/images/heart_home.png',
                      height: 60,
                      fit: BoxFit.contain,
                    ),
                  ),
                  ...List.generate(
                    (MediaQuery.of(context).size.width / 130)
                        .clamp(1, 10)
                        .toInt(),
                    (index) {
                      return [
                        Image.asset(
                          'assets/images/chuv.png',
                          //height: 35,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 5),
                      ];
                    },
                  ).expand((e) => e).toList()..removeLast(),
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
            SizedBox(height: 20),
            //интересное
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage('assets/images/interesnoe_img.png'),
                    fit: BoxFit.cover,
                    opacity: 0.85,
                    ),
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
                          color: Colors.white,
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
                          backgroundColor: Colors.black.withOpacity(0.25),
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
                  image: DecorationImage(image: AssetImage('assets/images/pamyatniki_img.jpg'),
                  fit: BoxFit.cover,
                  opacity: 0.85,),
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 179, 172, 172),
                ),
                width: double.infinity,
                height: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text(
                        'Памятники',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                          backgroundColor: Colors.black.withOpacity(0.25),
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
            Divider(
              height: 20,           
              thickness: 2,       
              indent: 35,           
              endIndent: 35,       
              color: Colors.red,  
            ),
            Row(
              children: [
                        Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 30, top: 10, right: 15),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => AllQuestionsPage())
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/test_img.jpg'), 
                            fit: BoxFit.cover,
                            opacity: 0.8,
                          ),
                        ),
                        width: double.infinity,
                        height: 100,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Тесты',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15, top: 10, right: 30),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context) => QuestsPage())
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/quest_img.jpg'),
                            fit: BoxFit.cover,
                            opacity: 0.8,
                          ),
                        ),
                        width: double.infinity,
                        height: 100,
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black.withOpacity(0.25),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Квесты',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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
