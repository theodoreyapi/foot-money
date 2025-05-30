import 'package:flutter/material.dart';
import 'package:footmoney/models/matchs/list_players_model.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import '../../../themes/themes.dart';

class DetalJoueurPage extends StatefulWidget {
  ListPlayers? joueur;
  String? club;
  String? clubLogo;

  DetalJoueurPage({
    super.key,
    this.joueur,
    this.club,
    this.clubLogo,
  });

  @override
  State<DetalJoueurPage> createState() => _DetalJoueurPageState();
}

class _DetalJoueurPageState extends State<DetalJoueurPage> {
  @override
  Widget build(BuildContext context) {
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
                    "Ligue 1",
                    style: TextStyle(
                      color: appBlack,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Gap(2.h),
              ListTile(
                leading: widget.joueur!.photoJoue! == ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(3.w),
                        child: Image.asset(
                          "assets/images/ligue.png",
                          height: 76,
                          width: 50,
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(3.w),
                        child: Image.network(
                          widget.joueur!.photoJoue!,
                          height: 76,
                          width: 50,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                title: Text(
                  "${widget.joueur!.nomJoue!} ${widget.joueur!.prenomJoue!}",
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Naissance: ${widget.joueur!.naissanceJoue!}",
                  style: TextStyle(
                    color: appSub,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/images/maillotone.png',
                      width: 30,
                      height: 30,
                    ),
                    Text(
                      widget.joueur!.dossardJoue!,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: appOrange,
                        shadows: [
                          Shadow(
                            blurRadius: 5,
                            color: appColor.withOpacity(0.8),
                            offset: const Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              ListTile(
                leading: Image.network(
                  widget.clubLogo!,
                  height: 46,
                  width: 50,
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
                title: Text(
                  widget.club!,
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Text(
                  widget.joueur!.posteJoue!,
                  style: TextStyle(
                    color: appSub,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
