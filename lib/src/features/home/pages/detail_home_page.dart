import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:footmoney/models/matchs/list_match_model.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/constants.dart';
import '../../../../models/matchs/list_players_model.dart';
import '../../../../utils/utilis.dart';
import '../../../themes/themes.dart';
import '../home.dart';

class DetailHomePage extends StatefulWidget {
  MatchModel? match;

  DetailHomePage({
    super.key,
    this.match,
  });

  @override
  State<DetailHomePage> createState() => _DetailHomePageState();
}

enum LegendShape { circle, rectangle }

class _DetailHomePageState extends State<DetailHomePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  Map<String, double> dataMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchStatesVotes();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final colorList = <Color>[
    const Color(0xff009D48),
    const Color(0xfffdcb6e),
    const Color(0xff0984e3),
    const Color(0xff6c5ce7),
    const Color(0xffe17055),
  ];

  String selected = "";
  String label = "";
  Map<String, bool> selectedButtons = {};

  Widget customRadio(String titre, String index, int etat) {
    selectedButtons.putIfAbsent(index, () => false);

    return OutlinedButton(
      onPressed: () {
        setState(() {
          selected = index;
          label = titre;
          selectedButtons[index] = !selectedButtons[index]!;
          fetchAddVotes(selected);
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: !(selectedButtons[index]! && etat != 1)
            ? Colors.transparent
            : appOrange,
        foregroundColor: appOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.w),
        ),
        side: BorderSide(
          color: !(selectedButtons[index]! && etat != 1)
              ? appOrange
              : Colors.transparent,
          width: 2.0,
        ),
      ),
      child: Text(
        titre.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: !(selectedButtons[index]! && etat != 1) ? appOrange : appWhite,
          fontSize: 8.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future<void> fetchAddVotes(String joueur) async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    String? identifiant = prefsHelper.getString("identifiant");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Row(
                  children: [
                    const CircularProgressIndicator(),
                    Text(
                      "Voting...",
                      style: TextStyle(
                        color: appColor,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w300,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    final http.Response response = await http.post(
      Uri.parse(ApiUrls.postAddVoteUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user': identifiant,
        'joueur': joueur,
        'match': widget.match!.idMatch!,
      }),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    Navigator.pop(context);

    if (response.statusCode == 200) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    "Votre homme du match a été désigné. "
                    "\nVoulez-vous faire un don a votre homme du match?",
                    style: TextStyle(
                      color: appColor,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  fetchDataOne();
                  fetchDataTwo();
                  fetchStatesVotes();
                },
                child: const Text("NON"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  fetchDataOne();
                  fetchDataTwo();
                  fetchStatesVotes();
                  showBarModalBottomSheet(
                    expand: true,
                    context: context,
                    barrierColor: appColor,
                    builder: (context) => const DonsPage(),
                  );
                },
                child: const Text("OUI"),
              ),
            ],
          );
        },
      );
    } else {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Text(
                    responseData['message'],
                    style: TextStyle(
                      color: appRed,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w300,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  fetchDataOne();
                  fetchDataTwo();
                  fetchStatesVotes();
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    }
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

  Future<List<ListPlayers>> fetchDataOne() async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    String? identifiant = prefsHelper.getString("identifiant");
    var url = Uri.parse(
        "${ApiUrls.getPlayerUrl}${widget.match!.clubOneId!}/${widget.match!.idMatch!}/$identifiant");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ListPlayers.fromJson(data)).toList();
    } else {
      throw Exception("Une erreur s'est produite");
    }
  }

  Future<List<ListPlayers>> fetchDataTwo() async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    String? identifiant = prefsHelper.getString("identifiant");
    var url = Uri.parse(
        "${ApiUrls.getPlayerUrl}${widget.match!.clubTwoId!}/${widget.match!.idMatch!}/$identifiant");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => ListPlayers.fromJson(data)).toList();
    } else {
      throw Exception("Une erreur s'est produite");
    }
  }

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
              Gap(4.h),
              TabBar(
                controller: _tabController,
                labelStyle: TextStyle(fontSize: 9.sp),
                tabs: <Widget>[
                  Tab(text: widget.match!.equipeOne!),
                  Tab(text: widget.match!.equipeTwo!),
                ],
              ),
              Gap(1.h),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    FutureBuilder<List<ListPlayers>>(
                      future: fetchDataOne(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Pass de joueur disponible.'),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.6,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final player = snapshot.data![index];
                              return GestureDetector(
                                onTap: () => showBarModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  barrierColor: appColor,
                                  builder: (context) => DetalJoueurPage(
                                    joueur: player,
                                    club: widget.match!.equipeOne!,
                                    clubLogo: widget.match!.equipeOneLogo!,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: appColor.withOpacity(.12),
                                    border: Border.all(
                                      color: appColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(3.w),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${player.nomJoue} \n${player.prenomJoue}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: appBlack,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Gap(1.h),
                                      if (player.photoJoue! == "")
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.w),
                                          child: Image.asset(
                                            "assets/images/ligue.png",
                                            height: 138,
                                            width: 90,
                                          ),
                                        )
                                      else
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.w),
                                          child: Image.network(
                                            player.photoJoue!,
                                            height: 138,
                                            width: 90,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      Gap(1.h),
                                      customRadio(
                                        "Homme du match",
                                        player.idJoue!,
                                        player.hommeDuMatch!,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                    FutureBuilder<List<ListPlayers>>(
                      future: fetchDataTwo(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                            child: Text('Pass de joueur disponible.'),
                          );
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              childAspectRatio: 0.6,
                            ),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final player = snapshot.data![index];
                              return GestureDetector(
                                onTap: () => showBarModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  barrierColor: appColor,
                                  builder: (context) => DetalJoueurPage(
                                    joueur: player,
                                    club: widget.match!.equipeTwo!,
                                    clubLogo: widget.match!.equipeTwoLogo!,
                                  ),
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: appColor.withOpacity(.12),
                                    border: Border.all(
                                      color: appColor,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(3.w),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${player.nomJoue} \n${player.prenomJoue}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: appBlack,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Gap(1.h),
                                      if (player.photoJoue! == "")
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.w),
                                          child: Image.asset(
                                            "assets/images/ligue.png",
                                            height: 138,
                                            width: 90,
                                          ),
                                        )
                                      else
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(3.w),
                                          child: Image.network(
                                            player.photoJoue!,
                                            height: 138,
                                            width: 90,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null) {
                                                return child;
                                              }
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      Gap(1.h),
                                      customRadio(
                                        "Homme du match",
                                        player.idJoue!,
                                        player.hommeDuMatch!,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
