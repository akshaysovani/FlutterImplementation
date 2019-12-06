import "package:flutter/material.dart";

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Simple Interest Calculator",
    home: SIForm(),
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.indigo,
      accentColor: Colors.indigoAccent,
    ),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Rs', 'Dollars', 'Pounds'];
  var _finalminpadding = 5.0;
  var _currentvalueselected = '';

  void initState(){
    super.initState();
    var _currentvalueselected = _currencies[0];
  }

  String resultString = "";
  TextEditingController pc = TextEditingController();
  TextEditingController roic = TextEditingController();
  TextEditingController tc = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text("Simple Interest Calculator")),
      body: Container(
        margin: EdgeInsets.all(_finalminpadding),
        child: ListView(
          children: <Widget>[
            getImageAsset(),
            Padding(
                padding: EdgeInsets.only(
                    top: _finalminpadding, bottom: _finalminpadding),
                child: TextField(
                  style: textStyle,
                  keyboardType: TextInputType.number,
                  controller: pc,
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: 'Principal amount',
                      hintText: 'e.g. 12000',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2.0))),
                )),
            Padding(
              padding: EdgeInsets.only(
                  top: _finalminpadding, bottom: _finalminpadding),
              child: TextField(
                keyboardType: TextInputType.number,
                style: textStyle,
                controller: roic,
                decoration: InputDecoration(
                    labelText: 'Rate of Interest',
                    hintText: 'e.g. 8',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0))),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: _finalminpadding, right: _finalminpadding),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: _finalminpadding),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          style: textStyle,
                          controller: tc,
                          decoration: InputDecoration(
                              labelText: 'Term',
                              hintText: 'Time in years',
                              labelStyle: textStyle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(2.0))),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: _finalminpadding),
                        child: DropdownButton<String>(
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          value: _currentvalueselected,
                          onChanged: (String newValue) {
                            _actiononchange(newValue);
                          },
                        ),
                      ),
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(top: _finalminpadding),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: _finalminpadding),
                        child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text('Calculate',textScaleFactor: 1.5,),
                            onPressed: () {
                              setState(() {
                                this.resultString = _tocalculatetotalreturns();
                              });
                            }),
                      )
                  )
                  ,
                  Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: _finalminpadding),
                        child: RaisedButton(
                            color: Theme.of(context).accentColor,
                            textColor: Theme.of(context).primaryColorDark,
                            child: Text('Reset',textScaleFactor: 1.5,), onPressed: () {
                          setState(() {
                            _refreshEverything();
                          });
                        }),
                      )
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.all(2*_finalminpadding),
                child: Text(
                    this.resultString, style: textStyle
                )
            )
          ],
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/business.jpeg');
    Image image = Image(
      image: assetImage,
      width: 100,
      height: 100,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(10 * _finalminpadding),
    );
  }

  void _actiononchange(String newValue){
    setState(() {
      this._currentvalueselected = newValue;
    });
  }

  String _tocalculatetotalreturns(){
    double principal = double.parse(pc.text);
    double roi = double.parse(roic.text);
    double years = double.parse(tc.text);

    double result = principal + (principal*roi*years)/100;
    return 'After $years years, the original amount of $principal @ $roi will be $_currentvalueselected $result';
  }

  void _refreshEverything(){
    pc.text = '';
    roic.text = '';
    tc.text = '';
    this.resultString = '';
    _currentvalueselected = _currencies[0];
  }
}