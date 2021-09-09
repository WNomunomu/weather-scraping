import 'package:html/dom.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

void main(List<String> arguments) async {
  final url = 'https://tenki.jp/forecast/3/13/4210/10201/';
  final target = Uri.parse(url);
  final response = await http.get(target);

  if (response.statusCode != 200) {
    print('ERROR: ${response.statusCode}');
    return;
  }

  final document = parse(response.body);


  final date = getDate();
  final today = date[0];
  final tomorrow = date[1];

  final rainProbability = document.querySelectorAll('.rain-probability td').map((v) => v.text).toList();
  final temperature = document.querySelectorAll('.value').map((v) => v.text).toList();
  final weather = document.querySelectorAll('.weather-telop').map((v) => v.text).toList();
  final todayUltravioletLightData = document.querySelectorAll('#indexes-point-today > ul > li:nth-child(1) > a').map((v) => v.text).toList();
  final todayWashingData = document.querySelectorAll('#indexes-point-today > ul > li:nth-child(3) > a').map((v) => v.text).toList();
  final todayClothesData = document.querySelectorAll('#indexes-point-today > ul > li:nth-child(5) > a').map((v) => v.text).toList();
  final tomorrowUltravioletLightData = document.querySelectorAll('#indexes-point-tomorrow > ul > li:nth-child(1) > a').map((v) => v.text).toList();
  final tomorrowWashingData = document.querySelectorAll('#indexes-point-tomorrow > ul > li:nth-child(3) > a').map((v) => v.text).toList();
  final tomorrowClothesData = document.querySelectorAll('#indexes-point-tomorrow > ul > li:nth-child(5) > a').map((v) => v.text).toList();


  //天気
  final todayWeather = weather[0];
  final tomorrowWeather = weather[1];

  //最高気温と最低気温
  final todayMax = temperature[0];
  final todayMin = temperature[1];
  final tomorrowMax = temperature[2];
  final tomorrowMin = temperature[3];

  //時間による降水確率
  final todayRainProbability1 = rainProbability[0];
  final todayRainProbability2 = rainProbability[1];
  final todayRainProbability3 = rainProbability[2];
  final todayRainProbability4 = rainProbability[3];
  final tomorrowRainProbability1 = rainProbability[4];
  final tomorrowRainProbability2 = rainProbability[5];
  final tomorrowRainProbability3 = rainProbability[6];
  final tomorrowRainProbability4 = rainProbability[7];

  //紫外線
  final todayUltravioletLightPower = todayUltravioletLightData[0].split(' ');
  final todayUltravioletLightInformation = todayUltravioletLightData[0].split(' ');
  final tomorrowUltravioletLightPower = tomorrowUltravioletLightData[0].split(' ');
  final tomorrowUltravioletLightInformation = tomorrowUltravioletLightData[0].split(' ');
  
  //洗濯
  final todayWashing = todayWashingData[0].split(' ');
  final todayWashingInformation = todayWashingData[0].split(' ');
  final tomorrowWashing = tomorrowWashingData[0].split(' ');
  final tomorrowWashingInformation = tomorrowWashingData[0].split(' ');

  //服装
  final todayClothes = todayClothesData[0].split(' ');
  final tomorrowClothes = tomorrowClothesData[0].split(' ');

  //出力
  print('\n');
  print('----' + today + '----');
  print('天気         ：' + todayWeather);
  print('最高気温     ：' + todayMax + '℃');
  print('最低気温     ：' + todayMin + '℃');
  print('<降水確率>');
  print('0:00 ~ 6:00  ：' + todayRainProbability1);
  print('6:00 ~ 12:00 ：' + todayRainProbability2);
  print('12:00 ~ 18:00：' + todayRainProbability3);
  print('18:00 ~ 24:00：' + todayRainProbability4);
  print('<紫外線>');
  print(todayUltravioletLightPower[24].trim());
  print(todayUltravioletLightInformation[32].trim());
  print('<洗濯>');
  print(todayWashing[24].trim());
  print(todayWashingInformation[32].trim());
  print('<服装>');
  print(todayClothes[32].trim());
  
  
  print('\n');
  print('----' + tomorrow + '----');
  print('天気         ：' + tomorrowWeather);
  print('最高気温     ：' + tomorrowMax + '℃');
  print('最低気温     ：' + tomorrowMin + '℃');
  print('<降水確率>');
  print('0:00 ~ 6:00  ：' + tomorrowRainProbability1);
  print('6:00 ~ 12:00 ：' + tomorrowRainProbability2);
  print('12:00 ~ 18:00：' + tomorrowRainProbability3);
  print('18:00 ~ 24:00：' + tomorrowRainProbability4);
  print('<紫外線>');
  print(tomorrowUltravioletLightPower[24].trim());
  print(tomorrowUltravioletLightInformation[32].trim());
  print('<洗濯>');
  print(tomorrowWashing[24].trim());
  print(tomorrowWashingInformation[32].trim());
  print('<服装>');
  print(tomorrowClothes[32].trim());
}


//今日の日付を取得する関数
List getDate() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final todayWeekdayData = now.weekday;
  var tomorrowWeekdayData = todayWeekdayData + 1;

  if (tomorrowWeekdayData == 8) {
    tomorrowWeekdayData = 1;
  }

  String getweekday(weekdayData) {
    switch (weekdayData) {
      case 1:
        return '(月)';
      case 2:
        return  '(火)';
      case 3:
        return  '(水)';
      case 4:
        return  '(木)';
      case 5:
        return  '(金)';
      case 6:
        return  '(土)';
      case 7:
        return  '(日)'; 
    }

    return '不適切な値です';
  }

  final todayWeekday = getweekday(todayWeekdayData);
  final tomorrowWeekday = getweekday(tomorrowWeekdayData);
  
  final todayDate = today.toString() + todayWeekday;
  final tomorrowDate = tomorrow.toString() + tomorrowWeekday;

  return [todayDate, tomorrowDate];
}