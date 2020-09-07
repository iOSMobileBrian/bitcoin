import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

 CoinData coinData = CoinData();
 String rateBTC;
 String rateETH;
 String rateLTC;
 String selectedCurrency = 'USD';
 bool isWaiting = false;
 Map<String,String> cryptoValues = {};

  DropdownButton<String> androidButton(){

    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems, onChanged: (value){
        setState(() {
        selectedCurrency = value;
        print(selectedCurrency);


});

});

  }


  CupertinoPicker iOSPicker(){

    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0, onSelectedItemChanged: (selectedIndex) {
      print(selectedIndex);

      setState(() {
       //int index = selectedIndex;
        selectedCurrency = currenciesList[selectedIndex];
        print(selectedCurrency);
        getExchangeData();
      });

    }, children:pickerItems,

    );

  }


  void getExchangeData() async {

    isWaiting = true;

    try {

        var exchangeData = await coinData.getCoinData(selectedCurrency);

        isWaiting = false;


        if (exchangeData == null) {
          rateLTC = '?';
          rateETH = '?';
          rateBTC = '?';
        }

        setState(() {
          cryptoValues = exchangeData;
        });
    }catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();

    getExchangeData();
  }








  @override
  Widget build(BuildContext context) {





    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Column(
              children: [
                CryptoCard(value: isWaiting? '?': cryptoValues['BTC'] , selectedCurrency: selectedCurrency, cryptoCurrency: 'BTC',),
                CryptoCard(value: isWaiting? '?': cryptoValues['LTC'] , selectedCurrency: selectedCurrency, cryptoCurrency: 'LTC',),
                CryptoCard(value: isWaiting? '?': cryptoValues['ETH'] , selectedCurrency: selectedCurrency, cryptoCurrency: 'ETH',),
              ],
            ),
            ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidButton(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {

  CryptoCard({@required this.value,@required this.selectedCurrency,@required this.cryptoCurrency});

String value;
String cryptoCurrency;
String selectedCurrency;


  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child:
             Text(
               '1 $cryptoCurrency = $value $selectedCurrency',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
              ),
            ),
        ),
      );
  }
}


