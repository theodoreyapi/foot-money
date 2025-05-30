import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:footmoney/src/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/constants.dart';
import '../../../../models/news/news_model.dart';
import '../actualite.dart';

class ActualitePage extends StatefulWidget {
  const ActualitePage({super.key});

  @override
  State<ActualitePage> createState() => _ActualitePageState();
}

class _ActualitePageState extends State<ActualitePage> {
  Future<List<NewsModel>> fetchData() async {
    var url = Uri.parse(ApiUrls.getListNewsUrl);

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => NewsModel.fromJson(data)).toList();
    } else {
      throw Exception("Une erreur s'est produite");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<NewsModel>>(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Pass de media disponible.'),
              );
            } else {
              return Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => showBarModalBottomSheet(
                        expand: true,
                        context: context,
                        barrierColor: appColor,
                        builder: (context) => DetailNewsPage(
                          news: snapshot.data![0],
                        ),
                      ),
                      child: Card(
                        elevation: 5,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15)),
                              child: Image.network(
                                snapshot.data![0].photoNews!,
                                height: 219,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(2.w),
                              child: Text(
                                snapshot.data![0].titreNews!,
                                style: TextStyle(
                                  color: appBlack,
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(3.h),
                    Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data!.length - 1,
                        itemBuilder: (context, index) {
                          final article = snapshot.data![index + 1];
                          return GestureDetector(
                            onTap: () => showBarModalBottomSheet(
                              expand: true,
                              context: context,
                              barrierColor: appColor,
                              builder: (context) => DetailNewsPage(
                                news: article,
                              ),
                            ),
                            child: Card(
                              elevation: 5,
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                    child: Image.network(
                                      article.photoNews!,
                                      height: 7.h,
                                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Gap(2.w),
                                  Expanded(
                                    child: Text(
                                      article.titreNews!,
                                      style: TextStyle(
                                        color: appBlack,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
