import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
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
     color: const Color(0xFFF0EBE5), // Set the background color here
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
         SizedBox(height: 70),
         Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: [
             Row(
               children: [
                SizedBox(
                  width: 250,
                  height: 40,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(
                        color: Color(0xFF31304D),
                        width: 2.2,
                      ),
                      color: const Color(0xFFF0EBE5),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Color(0xFF31304D)),
                        SizedBox(width: 6.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20, right: 0.0),
                  child: Row(
                    children: [
                      _buildIconContainer(Icons.favorite_border),
                      SizedBox(width: 18.0),
                      _buildIconContainer(Icons.notifications_none),
                    ],
                  ),
                ),
               ],
             ),
           ],
         ),
         SizedBox(height: 22),
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Container(
               width: 390,
               height: 32,
               child: ElevatedButton(
                onPressed: () {
                  // Handle button press if needed
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF31314D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    side: BorderSide(
                      color: const Color(0xFF31304D),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.discount, size: 17.0),
                    SizedBox(width: 5.0),
                    Text(
                      'Promotional Offers',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
               ),
             ),
           ],
         ),
         SizedBox(height: 20), // Add space below the button
       ],
     ),
   );
 }

 Widget _buildContent(int index) {
   return Container(
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
