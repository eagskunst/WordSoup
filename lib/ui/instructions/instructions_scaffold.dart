import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_soup/ui/game/widgets/custom_fab_row.dart';
import 'package:word_soup/ui/game/widgets/word_selection_box.dart';
import 'package:word_soup/utils/custom_fabs_props_creator.dart';

class InstructionsScaffold extends StatefulWidget{
  @override
  _InstructionsScaffoldState createState() => _InstructionsScaffoldState();
}

class _InstructionsScaffoldState extends State<InstructionsScaffold> {

  var buttonAction = '';

  void changeButtonAction(final String action) => setState(() => buttonAction = action);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: CupertinoNavigationBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
        middle: Text(
          'Instrucciones',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Mantén presionado las letras para formar un patrón',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            Container(),//Flare animation
            Text(
              'La palabra que formes irá apareciendo en un recuadro: ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            WordSelectionBox(selection: 'ARROZ'),
            Text(
              'Pulsa los botones para saber su funcionalidad!: ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600
              ),
            ),
            Text(
              buttonAction,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            CustomFabRow(
              fabsProps: CustomFabsPropsCreator.getProps([
                () => changeButtonAction('Borra tu selección actual.'),
                () => changeButtonAction('Verifica tu selección actual.'),
                () => changeButtonAction('Te mostrará la primera letra de cada palabra.'),
                () => changeButtonAction('Desbloquearás una palabra. Solo lo puedes utilizar una vez por nivel.')
              ], true),
            )
          ],
        ),
      ),
    );
  }
}