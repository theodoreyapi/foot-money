import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:footmoney/constants/constants.dart';
import 'package:footmoney/src/themes/themes.dart';
import 'package:gap/gap.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/utilis.dart';
import '../../../widgets/widgets.dart';
import '../../forgot/forgot.dart';
import '../../menus/menus.dart';
import '../../register/register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  var login = TextEditingController();
  var password = TextEditingController();

  String phoneInicator = "";
  String initialCountry = 'CI';
  PhoneNumber number = PhoneNumber(isoCode: 'CI');

  final _snackBar = const SnackBar(
    content: Text("Tous les champs sont obligatoires"),
    backgroundColor: Colors.red,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset("assets/images/login.png"),
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
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 4.w),
                            decoration: BoxDecoration(
                              color: appWhite,
                              borderRadius: BorderRadius.circular(3.w),
                              border: Border.all(),
                            ),
                            child: InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                phoneInicator = number.phoneNumber!;
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
                          Gap(1.h),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ForgotPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Téléphone oublié?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: appOrange,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          Gap(1.h),
                          SubmitButton(
                            AppConstants.btnLogin,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await loginUser(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(_snackBar);
                              }
                            },
                          ),
                          Gap(3.h),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                            child: Text(
                              "Vous n'avez pas de compte? S'enregistrer",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: appOrange,
                                fontStyle: FontStyle.normal,
                                fontWeight: FontWeight.w300,
                                fontSize: 15,
                              ),
                            ),
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
      ),
    );
  }

  Future<void> loginUser(BuildContext context) async {
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    Text(
                      "Authentification...",
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
      Uri.parse(ApiUrls.postLoginUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': phoneInicator, 'password': password.text}),
    );

    final Map<String, dynamic> responseData = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final SharedPreferencesHelper prefsHelper = SharedPreferencesHelper();
      await prefsHelper.saveString('identifiant', responseData['identifiant']);
      await prefsHelper.saveString('nom', responseData['nom']);
      await prefsHelper.saveString('prenom', responseData['prenom']);
      await prefsHelper.saveString('phone', responseData['phone']);
      await prefsHelper.saveString('email', responseData['email']);
      await prefsHelper.saveString('photo', responseData['photo'] ?? '');

      Navigator.of(context).pop();

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const MenuPage(),
        ),
        (route) => false,
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
