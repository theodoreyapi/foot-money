import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../constants/constants.dart';
import '../../../themes/themes.dart';
import '../../../widgets/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formRegisterKey = GlobalKey<FormState>();
  bool _obscure = true;

  var login = TextEditingController();
  var name = TextEditingController();
  var lastName = TextEditingController();
  var commune = TextEditingController();
  var password = TextEditingController();

  String phoneIndicator = "";
  String initialCountry = 'CI';
  PhoneNumber number = PhoneNumber(isoCode: 'CI');

  final _snackBar = const SnackBar(
    content: Text("Tous les champs sont obligatoires."),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Image.asset(
                  "assets/images/register2.png",
                  height: 30.h,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: appWhite,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(4.w),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formRegisterKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InputText(
                                keyboardType: TextInputType.text,
                                controller: name,
                                hintText: "Nom",
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.person_outline),
                                ),
                                validatorMessage: "Veuillez saisir votre nom",
                              ),
                              Gap(2.h),
                              InputText(
                                keyboardType: TextInputType.text,
                                controller: lastName,
                                hintText: "Prénom",
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.person_outline),
                                ),
                                validatorMessage:
                                    "Veuillez saisir votre prénom",
                              ),
                              Gap(2.h),
                              InputText(
                                keyboardType: TextInputType.text,
                                controller: commune,
                                hintText: "Votre commune",
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Icon(Icons.home_outlined),
                                ),
                                validatorMessage:
                                    "Veuillez saisir votre commune",
                              ),
                              Gap(2.h),
                              Container(
                                padding: EdgeInsets.only(left: 4.w),
                                decoration: BoxDecoration(
                                  color: appWhite,
                                  borderRadius: BorderRadius.circular(3.w),
                                  border: Border.all(),
                                ),
                                child: InternationalPhoneNumberInput(
                                  onInputChanged: (PhoneNumber number) {
                                    phoneIndicator = number.phoneNumber!;
                                    print(phoneIndicator);
                                  },
                                  onInputValidated: (bool value) {},
                                  errorMessage: "Le numéro est invalide",
                                  hintText: "Numéro de téléphone",
                                  selectorConfig: const SelectorConfig(
                                    selectorType:
                                        PhoneInputSelectorType.BOTTOM_SHEET,
                                  ),
                                  ignoreBlank: false,
                                  autoValidateMode: AutovalidateMode.disabled,
                                  selectorTextStyle: const TextStyle(
                                    color: Colors.black,
                                  ),
                                  initialValue: number,
                                  textFieldController: login,
                                  formatInput: true,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    signed: true,
                                    decimal: true,
                                  ),
                                  inputBorder: const OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                  ),
                                  onSaved: (PhoneNumber number) {},
                                ),
                              ),
                              Gap(2.h),
                              InputPassword(
                                hintText: "Mot de passe",
                                controller: password,
                                validatorMessage:
                                    "Votre mot de passe est obligatoire",
                                suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscure
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscure = !_obscure;
                                      });
                                    }),
                              ),
                              Gap(2.h),
                              SubmitButton(
                                AppConstants.btnRegister,
                                onPressed: () async {
                                  if (_formRegisterKey.currentState!
                                      .validate()) {
                                    await registerUser(context);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(_snackBar);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FloatingActionButton.small(
              backgroundColor: appWhite,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_outlined),
            )
          ],
        ),
      ),
    );
  }

  Future<void> registerUser(BuildContext context) async {
    final http.Response response = await http.post(
      Uri.parse(ApiUrls.postRegisterUrl),
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'nom': name.text,
        'prenom': lastName.text,
        'email': "",
        'tel': phoneIndicator,
        'commune': commune.text,
        'password': password.text,
      },
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
                    responseData['message'],
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
                },
                child: const Text("OK"),
              )
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
                },
                child: const Text("OK"),
              )
            ],
          );
        },
      );
    }
  }
}
