import 'dart:convert';

import 'package:bitcoin_ticker/Networking.dart';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const String kAPIKey = '088C453F-10C0-46E8-B9FF-3E39890577CB';
const String kURL = 'https://rest.coinapi.io/v1/exchangerate';



class CoinData {


  Future<dynamic> getCoinData(String currency) async {

    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList){

      NetworkHelper networkHelper = NetworkHelper(url: '$kURL/$crypto/$currency?apikey=$kAPIKey');
      var data = await networkHelper.getData();



      double coinData = data['rate'];

      print('coindata: $coinData');

      cryptoPrices[crypto] = coinData.toStringAsFixed(0);

    }

    return cryptoPrices;

  }


}
