import 'package:flutter/material.dart';
import 'package:footmoney/src/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:sizer/sizer.dart';

import '../../../widgets/widgets.dart';

class DonsPage extends StatefulWidget {
  const DonsPage({super.key});

  @override
  State<DonsPage> createState() => _DonsPageState();
}

class _DonsPageState extends State<DonsPage> {
  final _formMoneyKey = GlobalKey<FormState>();

  var money = TextEditingController();

  String selected = "";
  String label = "";

  Widget customRadio(String titre, String index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selected = index;
          label = titre;
        });
      },
      style: OutlinedButton.styleFrom(
        backgroundColor: (selected == index) ? appColor : Colors.transparent,
        foregroundColor: appColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        side: BorderSide(
          color: (selected == index) ? Colors.transparent : appColor,
          width: 1.0,
        ),
      ),
      child: Text(
        titre.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(
          color: (selected == index) ? appWhite : appColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  int selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faire un don"),
      ),
      body: Padding(
        padding: EdgeInsets.all(4.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formMoneyKey,
            child: Column(
              children: [
                Text(
                  "Quel montant veux-tu donner?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: appBlack,
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                  ),
                ),
                Gap(2.h),
                Padding(
                  padding: EdgeInsets.only(
                    left: 12.w,
                    right: 12.w,
                  ),
                  child: InputText(
                    keyboardType: TextInputType.number,
                    controller: money,
                    hintText: "Montant",
                    suffixIcon: Padding(
                      padding: EdgeInsets.all(2.w),
                      child: CircleAvatar(
                        backgroundColor: appColor,
                        foregroundColor: appColor,
                        child: Text(
                          "Fcfa",
                          style: TextStyle(
                            color: appWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    validatorMessage: "Veuillez saisir votre montant",
                  ),
                ),
                Text(
                  "Min 100F",
                  style: TextStyle(
                    color: appBlack,
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Gap(2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    customRadio(
                      "1 000F",
                      "1",
                    ),
                    customRadio(
                      "2 000F",
                      "2",
                    ),
                    customRadio(
                      "5 000F",
                      "3",
                    ),
                  ],
                ),
                Gap(2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Don",
                      style: TextStyle(
                        color: appBlack,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.add,
                        color: appColor,
                        size: 15,
                      ),
                      label: Text(
                        "Ajouter un moyen de paiement",
                        style: TextStyle(
                          color: appColor,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
                ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      "assets/images/wave.jpeg",
                      height: 46,
                      width: 50,
                    ),
                  ),
                  title: Text(
                    "Wave",
                    style: TextStyle(
                      color: appBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "0748650731",
                    style: TextStyle(
                      color: appSub,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.5,
                    child: Radio<int>(
                      value: 1,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ),
                ListTile(
                  leading: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: Image.asset(
                      "assets/images/orange.png",
                      height: 46,
                      width: 50,
                    ),
                  ),
                  title: Text(
                    "Orange Money",
                    style: TextStyle(
                      color: appBlack,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "0748650731",
                    style: TextStyle(
                      color: appSub,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: Transform.scale(
                    scale: 1.5,
                    child: Radio<int>(
                      value: 2,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value!;
                        });
                      },
                    ),
                  ),
                ),
                Gap(5.h),
                SubmitButton(
                  "Donner 15 000 Fcfa",
                  onPressed: () async {
                    if (_formMoneyKey.currentState!.validate()) {
                    } else {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image.asset(
                "assets/images/wave.jpeg",
                height: 20,
                width: 20,
              ),
            ),
            Gap(2.w),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image.asset(
                "assets/images/orange.png",
                height: 20,
                width: 20,
              ),
            ),
            Gap(2.w),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image.asset(
                "assets/images/mtn.png",
                height: 20,
                width: 20,
              ),
            ),
            Gap(2.w),
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image.asset(
                "assets/images/moov.png",
                height: 20,
                width: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
