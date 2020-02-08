import 'dart:math';

class WordThemeGenerator{
  static const List _animales = ["ABEJA", "AGUILA", "BURRO", "CEBRA", "CERDO", "CISNE", "CIERVO", "FOCA", "LORO", "TIGRE", "POLLO", "TORO", "ZORRO",
                                "VACA", "LEON", "PERDIZ", "OSO", "OVEJA", "JIRAFA", "MONO", "JABALI", "PERRO", "GATO"]; // 23

  static const List _partes = ["BIGOTE", "BRAZO", "CABELLO", "LABIO", "OJO", "PECHO", "PIE", "TOBILLO", "BOCA", "CABEZA", "CARA", "ESPALDA", "MANO",
                              "LENGUA", "NALGA", "NARIZ", "OREJA", "PIEL", "PIERNA", "UÑA", "SANGRE", "RODILLA", "CEJA"]; // 23

  static const List _frutas = ["MANGO", "MELON", "MORA", "PAPAYA", "SANDIA", "UVA", "LIMON", "LIMA", "FRESA", "COCO", "CEREZA", "PIÑA", "PALTA", 
                              "PERA", "BANANA", "KIWI", "HIGO", "POMELO", "CIRUELA", "DURAZNO", "MANZANA", "PLATANO", "GRANADA"]; // 23

  static const List _objetos = ["SILLA", "MESA", "MUEBLE", "PELOTA", "BATE", "CARRO", "SUETER", "CAMISA", "PLATO", "CUCHARA", "TENEDOR", "CONTROL",
                                "RUEDA", "COBIJA", "MANTA", "TECLADO", "BOLSA", "ESPEJO", "BALDE", "PALO", "SIERRA", "MAZO", "LENTES"]; // 23

  static const List _paises = ["ALBANIA", "FRANCIA", "ANGOLA", "CHILE", "AUSTRIA", "BELGICA", "BRASIL", "CAMBOYA", "CHINA", "COREA", "CROACIA",
                              "CUBA", "ECUADOR", "EGIPTO", "ESPAÑA", "RUSIA", "ETIOPIA", "HAITI", "INDIA", "IRAK", "IRLANDA", "ITALIA", "ISRAEL"]; // 23

  static const List _ciudades = ["TOKIO", "PARIS", "LONDRES", "SEUL", "OSAKA", "SHANGAI", "MOSCU", "PEKIN", "CHICAGO","DALLAS", "CAIRO", "CARACAS",
                                "MILAN", "ROMA", "DELHI", "TORONTO", "SEATTLE", "WUHAN", "MIAMI", "SIDNEY", "LIMA", "MADRID", "BOGOTA"]; // 23

  static const List _ingles = ["CAR", "MOUTH", "APPLE", "MOUSE", "WOOD", "TREE", "SHOE", "HAIR", "HAND", "BEAR", "MIRROR", "WATCH", "GRAPE", "TABLE",
                              "WHEEL", "MONKEY", "DEER", "LETTER", "SOUP", "FORK", "SPOON", "WISH", "LEG"]; // 23

  static const int maxWords = 23;

  final random = Random();

  static String getTheme(final int theme){
    switch(theme){
      case 1:
        return "ANIMALES";
        break;
      case 2:
        return "PARTES DEL CUERPO";
        break;
      case 3:
        return "FRUTAS";
        break;
      case 4:
        return "OBJETOS";
        break;
      case 5:
        return "PAISES";
        break;
      case 6:
        return "CIUDADES";
        break;
      case 7:
        return "PALABRAS EN INGLÉS";
        break;
      default:
        return "ERROR";
        break;
    }
  }

  List<String> getWords({int theme = 1, int arraySize=16}){
    List<String> wordArray = [];
    switch(theme){
      case 1:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _animales.elementAt(number) ) ) ){
            wordArray.add(_animales.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;



      case 2:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _partes.elementAt(number) ) ) ){
            wordArray.add(_partes.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;



      case 3:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _frutas.elementAt(number) ) ) ){
            wordArray.add(_frutas.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;



      case 4:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _objetos.elementAt(number) ) ) ){
            wordArray.add(_objetos.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;



      case 5:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _paises.elementAt(number) ) ) ){
            wordArray.add(_paises.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;



      case 6:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _ciudades.elementAt(number) ) ) ){
            wordArray.add(_ciudades.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;



      case 7:
        int i = 0;
        do{
          int number = random.nextInt(maxWords);
          if( !( wordArray.contains( _ingles.elementAt(number) ) ) ){
            wordArray.add(_ingles.elementAt(number));
            i++;
          }
        }while(i < arraySize);
        return wordArray;
        break;

      default:
        int i = 0;
        do{
          wordArray.add("ERROR");
          i++;
        }while(i < arraySize);
        return wordArray;
        break;

    }

  return wordArray;

  }


}