import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:footmoney/models/matchs/list_match_model.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/constants.dart';
import '../../../themes/themes.dart';

class DetailHistoryPage extends StatefulWidget {
  MatchModel? match;

  DetailHistoryPage({
    super.key,
    this.match,
  });

  @override
  State<DetailHistoryPage> createState() => _DetailHistoryPageState();
}

class _DetailHistoryPageState extends State<DetailHistoryPage> {
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    fetchStatesVotes();
  }

  Future<void> fetchStatesVotes() async {
    try {
      final response = await http.get(
          Uri.parse("${ApiUrls.getStateVoteUrl}${widget.match!.idMatch!}"));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        setState(() {
          dataMap =
              jsonResponse.map((key, value) => MapEntry(key, value.toDouble()));
        });
      } else {
        print('Erreur lors de la récupération des données');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  final colorList = <Color>[
    const Color(0xff009D48),
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xff6c5ce7),
    const Color(0xffe17055),
  ];

  @override
  Widget build(BuildContext context) {
    DateTime parsedTime = DateFormat("HH:mm:ss").parse(widget.match!.heure!);
    String formattedTime = DateFormat("HH:mm").format(parsedTime);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/ligue.png",
                    height: 25,
                    width: 25,
                  ),
                  Gap(2.w),
                  Text(
                    "Ligue 1 - Journée ${widget.match!.journee!}",
                    style: TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Gap(2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Text(
                      widget.match!.equipeOne!,
                      style: TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Image.network(
                    widget.match!.equipeOneLogo!,
                    height: 25,
                    width: 25,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  Gap(2.w),
                  Column(
                    children: [
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      /* Text(
                        "2 : 0",
                        style: TextStyle(
                          color: appRed,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),*/
                    ],
                  ),
                  Gap(2.w),
                  Image.network(
                    widget.match!.equipeTwoLogo!,
                    height: 25,
                    width: 25,
                    errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      widget.match!.equipeTwo!,
                      style: TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
              Gap(4.h),
              Center(
                child: dataMap.isNotEmpty
                    ? PieChart(
                  dataMap: dataMap,
                  animationDuration: const Duration(milliseconds: 800),
                  chartLegendSpacing: 32,
                  chartRadius: MediaQuery.of(context).size.width / 3.2,
                  colorList: colorList,
                  initialAngleInDegree: 0,
                  chartType: ChartType.ring,
                  ringStrokeWidth: 32,
                  centerText: "Votes",
                  legendOptions: const LegendOptions(
                    showLegendsInRow: false,
                    legendPosition: LegendPosition.right,
                    showLegends: true,
                    legendShape: BoxShape.circle,
                    legendTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  chartValuesOptions: const ChartValuesOptions(
                    showChartValueBackground: true,
                    showChartValues: true,
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: true,
                    decimalPlaces: 1,
                  ),
                )
                    : Text(
                  "Pas d'homme du macth voté",
                  style: TextStyle(
                    color: appRed,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
