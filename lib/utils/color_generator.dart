import 'dart:math';


class ColorGenerator{
  static const List _colors = [0xFF063F49, 0xFFED302B, 0xFF31313E, 0xFF4D5F6F, 0xFF4CBDB2, 0xFF04353F, 0xFF056334, 0xFF697819, 0xFFC92D2F, 0xFFEA8933,
    0xFF3D2F14, 0xFFE03F4B, 0xFF18A7BB, 0xFF0B455D, 0xFF2B514D, 0xFF52B499, 0xFF5B4F50, 0xFF2D2B34, 0xFFBD0F40, 0xFF680D42, 0xFFBD0F40, 0xFF054664, 0xFF161B27,
    0xFFE7771D, 0xFFCD3C4F, 0xFF107AAB, 0xFF1E2233, 0xFF2C9678, 0xFF0B918F, 0xFFE1A434, 0xFFE5393E, 0xFF5F923D, 0xFF303048, 0xFF4F1420, 0xFF4A7F4D, 0xFF769C4C,
    0xFF8C431F, 0xFF883E51, 0xFFEE9523, 0xFFE71412];

  static const int maxColors = 40;
  var random = Random();

  List<int> getColors([int arraySize = 20]){
    List<int> colorList = [];
    int i = 0;
    do{
      int number = random.nextInt(maxColors);
      if( !( colorList.contains( _colors.elementAt(number) ) ) ){
        colorList.add(_colors.elementAt(number));
        i++;
      }
    }while(i < arraySize);
    return colorList;
  }

}
