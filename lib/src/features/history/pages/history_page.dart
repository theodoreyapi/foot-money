import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/constants.dart';
import '../../../../models/matchs/list_match_model.dart';
import '../../../../utils/utilis.dart';
import '../../../themes/themes.dart';
import '../history.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<int> availableYears = [];
  late Future<List<MatchModel>> _matchDataFuture;

  Future<List<MatchModel>> fetchData() async {
    final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
    String? identifiant = prefsHelper.getString("identifiant");
    var url = Uri.parse("${ApiUrls.getHistoryUrl}$identifiant");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => MatchModel.fromJson(data)).toList();
    } else {
      throw Exception("Une erreur s'est produite");
    }
  }

  @override
  void initState() {
    super.initState();
    _matchDataFuture = fetchData(); // Charger les données des matchs
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: FutureBuilder<List<MatchModel>>(
            future: _matchDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('Pas de vote disponible.'),
                );
              } else {
                // Extraire les années uniques des matchs
                final matches = snapshot.data!;
                Set<int> yearsSet = matches
                    .map((match) => DateTime.parse(match.debut!).year)
                    .toSet();
                availableYears = yearsSet.toList()..sort(); // Trier les années

                // Initialiser le TabController ici
                _tabController =
                    TabController(length: availableYears.length, vsync: this);

                return Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      isScrollable: true,
                      tabs: availableYears
                          .map((year) => Tab(text: year.toString()))
                          .toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: availableYears.map((year) {
                          // Filtrer les matchs pour l'année actuelle
                          final filteredMatches = matches.where((match) {
                            DateTime matchDate = DateTime.parse(match.debut!);
                            return matchDate.year == year;
                          }).toList();

                          return MatchList(matches: filteredMatches);
                        }).toList(),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Widget pour afficher la liste des matchs
class MatchList extends StatelessWidget {
  final List<MatchModel> matches;

  const MatchList({
    super.key,
    required this.matches,
  });

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Center(
          child: Text('Aucun match trouvé pour l\'année sélectionnée.'));
    }

    return ListView.builder(
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final listMatch = matches[index];
        DateTime parsedTime = DateFormat("HH:mm:ss").parse(listMatch.heure!);
        String formattedTime = DateFormat("HH:mm").format(parsedTime);

        return GestureDetector(
          onTap: () => showBarModalBottomSheet(
            expand: true,
            context: context,
            barrierColor: appColor,
            builder: (context) => DetailHistoryPage(
              match: listMatch,
            ),
          ),
          child: Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/ligue.png",
                        height: 25,
                        width: 25,
                      ),
                      Text(
                        "Ligue 1 - J${listMatch.journee}",
                        style: TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.w300,
                          fontSize: 15,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                          color: appCard,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          "${listMatch.totalVote} Vote(s)",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.w300,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gap(1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        listMatch.equipeOne!,
                        maxLines: 1,
                        style: TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                      Image.network(
                        listMatch.equipeOneLogo!,
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
                      Text(
                        formattedTime,
                        style: TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                      Gap(2.w),
                      Image.network(
                        listMatch.equipeTwoLogo!,
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
                      Text(
                        listMatch.equipeTwo!,
                        maxLines: 1,
                        style: TextStyle(
                          color: appBlack,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    listMatch.libelleStade!,
                    maxLines: 1,
                    style: TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
