//import dependencies
import 'package:flutter/material.dart';

class SizeConfig {
 double widthSize(BuildContext context, double value) {
   value /= 100;
   return MediaQuery.of(context).size.width * value;
 }
}
