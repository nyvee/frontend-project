//import dependencies
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

//import pages
import 'package:frontend_project/pages/search_bar.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}): super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage>  {
 @override
 Widget build(BuildContext context) {
   return Scaffold(
     body: CustomScrollView(
       slivers: [
         SliverStickyHeader(
           header: _buildHeader(),
           sliver: SliverList(
             delegate: SliverChildBuilderDelegate(
               (context, index) => _buildContent(index),
               childCount: 100, // This will generate 100 content widgets
             ),
           ),
         ),
       ],
     ),
   );
 }

 Widget _buildHeader() {
 return Container(
   color: const Color(0xFFF0EBE5),
   child: Column(
     crossAxisAlignment: CrossAxisAlignment.stretch,
     children: [
       const SizedBox(height: 70),
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
         children: [
           Row(
             children: [
               SizedBox(
                width: 250,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Searchh()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: const Color(0xFF31304D),
                        width: 2.2,
                      ),
                      color: const Color(0xFFF0EBE5),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF31304D)),
                        SizedBox(width: 5, height: 0,),
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 18.0, height: 1.0),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                              isDense: true,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
               ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 0.0),
                  child: Row(
                    children: [
                      _buildIconContainer(Icons.favorite_border),
                      const SizedBox(width: 18.0),
                      _buildIconContainer(Icons.notifications_none),
                    ],
                  ),
                ),
               ],
             ),
           ],
         ),
         const SizedBox(height: 65),// Add space below the button
       ],
     ),
   );
 }

 Widget _buildContent(int index) {
   return SizedBox(
     child: Text('Content $index'),
   );
 }

 Widget _buildIconContainer(IconData iconData) {
   return Container(
     width: 40.0,
     height: 40.0,
     decoration: BoxDecoration(
       borderRadius: BorderRadius.circular(8.0),
       border: Border.all(
         color: const Color(0xFF31314D),
         width: 2.2,
       ),
       color: Colors.transparent,
     ),
     child: Center(
       child: Icon(iconData, color: const Color(0xFF31314D)),
     ),
   );
 }
}
