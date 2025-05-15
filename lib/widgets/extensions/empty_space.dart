
import 'package:flutter/cupertino.dart';



 extension EmptySpace on num {

 SizedBox get asHeightBox => SizedBox(height: toDouble());
 SizedBox get asWidthBox => SizedBox(width: toDouble());

}