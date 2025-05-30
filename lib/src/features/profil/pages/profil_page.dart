import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants/constants.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(2.w),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(2.w),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.w),
                          child: Image.asset(
                            "assets/gifs/recompense.gif",
                            height: 48,
                            width: 48,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Gains",
                              style: TextStyle(
                                color: appBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "15 000 F",
                              style: TextStyle(
                                color: appBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Récompense",
                              style: TextStyle(
                                color: appBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Tickets",
                              style: TextStyle(
                                color: appBlack,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Gap(2.h),
                        Row(
                          children: [
                            Expanded(
                              child: SubmitButton(
                                AppConstants.btnCash,
                                onPressed: () async {},
                              ),
                            ),
                            Gap(2.w),
                            Expanded(
                              child: SubmitButton(
                                couleur: appOrange,
                                AppConstants.btnDons,
                                onPressed: () async {},
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(2.h),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.person_outline,
                          color: appColor,
                        ),
                        title: Text(
                          "Mon profil",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          color: appBlack,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.wallet_outlined,
                          color: appColor,
                        ),
                        title: Text(
                          "Mes opérations",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          color: appBlack,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.notifications_active_outlined,
                          color: appColor,
                        ),
                        title: Text(
                          "Notifications",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          color: appBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(2.h),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.help_outline,
                          color: appColor,
                        ),
                        title: Text(
                          "Aides",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          color: appBlack,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.note_outlined,
                          color: appColor,
                        ),
                        title: Text(
                          "Condition d'utilisation",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          color: appBlack,
                        ),
                      ),
                      const Divider(),
                      ListTile(
                        onTap: () {},
                        leading: Icon(
                          Icons.privacy_tip_outlined,
                          color: appColor,
                        ),
                        title: Text(
                          "Vie privée",
                          style: TextStyle(
                            color: appBlack,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: Icon(
                          Icons.navigate_next_outlined,
                          color: appBlack,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(2.h),
                Card(
                  child: ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.lock_clock_outlined,
                      color: appColor,
                    ),
                    title: Text(
                      "Fermer mon compte",
                      style: TextStyle(
                        color: appBlack,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(
                      Icons.navigate_next_outlined,
                      color: appBlack,
                    ),
                  ),
                ),
                Gap(2.h),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Se décconnecter",
                    style: TextStyle(
                      color: appRed,
                      fontWeight: FontWeight.bold,
                    ),
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
