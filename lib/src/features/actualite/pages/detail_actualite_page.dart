import 'package:flutter/material.dart';
import 'package:footmoney/models/news/news_model.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../themes/themes.dart';

class DetailNewsPage extends StatefulWidget {
  NewsModel? news;

  DetailNewsPage({
    super.key,
    this.news,
  });

  @override
  State<DetailNewsPage> createState() => _DetailNewsPageState();
}

class _DetailNewsPageState extends State<DetailNewsPage> {
  @override
  void initState() {
    super.initState();
    // Activer les messages en français pour timeago
    timeago.setLocaleMessages('fr', timeago.FrMessages());
  }

  @override
  Widget build(BuildContext context) {
    // Convertir la chaîne de date en objet DateTime
    DateTime date = DateTime.parse(widget.news!.createdAt!);
    DateTime now = DateTime.now();

    // Calculer la différence entre la date actuelle et la date de la news
    Duration difference = now.difference(date);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  child: Image.network(
                    widget.news!.photoNews!,
                    height: 219,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                ),
                Gap(2.h),
                Text(
                  widget.news!.titreNews!,
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  difference.inDays < 7
                      ? timeago.format(date, locale: 'fr')
                      : DateFormat('EEEE dd-MM-yyyy', 'fr').format(date),
                  style: TextStyle(
                    color: appLoren,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Gap(2.h),
                Text(
                  widget.news!.contenuNews!,
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
