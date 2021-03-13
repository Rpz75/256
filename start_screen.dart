import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter256/data/db/remote/response.dart';
import 'package:flutter256/ui/screens/top_navigation_screen.dart';
import 'package:flutter256/ui/widgets/rounded_icon_button.dart';
import 'package:flutter256/util/constants.dart';
import 'package:flutter256/ui/widgets/app_image_with_text.dart';
import 'package:flutter256/ui/widgets/sign_in/social_sign_in_button.dart';
import 'package:flutter256/ui/widgets/rounded_button.dart';
import 'package:flutter256/ui/screens/login_screen.dart';
import 'package:flutter256/ui/screens/register_screen.dart';
import 'package:flutter256/util/shared_preferences_utils.dart';
import 'package:flutter256/data/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter256/data/db/entity/app_user.dart';
import 'package:flutter256/data/db/remote/firebase_database_source.dart';

class StartScreen extends StatefulWidget {
  static const String id = 'start_screen';

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseDatabaseSource _databaseSource = FirebaseDatabaseSource();
  UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = Provider.of<UserProvider>(context, listen: false);
  }

  void registergoogleUser() async {
    await _userProvider
        .registergoogleUser( _scaffoldKey)
        .then((response) async {
      if (response is Success<UserCredential>) {
        Future<DocumentSnapshot> getUser(String userId) {
          final FirebaseFirestore instance = FirebaseFirestore.instance;
          print (instance.collection('users').doc(userId).get());
          instance.collection('users').doc(userId).get();
        }
        print (getUser);
        if (getUser != null) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              TopNavigationScreen.id, (route) => false);
        } else {
          Navigator.pop(context);
          Navigator.pushNamed(context, RegisterScreen.id);
        }
        }});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: kDefaultPadding,
          child: Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              children: [
                AppIconTitle(),
                Expanded(child: Container()),
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: Text(
                      "En vous connectant, vous acceptez nos Conditions Générales. Pour en savoir plus sur l'usage que nous faisons de vos données, consultez notre Politique de confidentialité et notre politique en matière de cookies.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SocialSignInButton(
                    assetName: 'images/google-logo.png',
                    text: 'Connexion avec Google',
                    textColor: Colors.black87,
                    color: Colors.white,
                    onPressed: () => {registergoogleUser()}
                    /*onPressed: () async {
                      registerUser();
                      Navigator.pop(context);
                      Navigator.pushNamed(context, RegisterScreen.id);
                    }
                      String userId = await SharedPreferencesUtil.getUserId();
                      print (userId);
                      if (userId != null) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, TopNavigationScreen.id);
                      } else {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, RegisterScreen.id);
                      }*/
                    ),
                SizedBox(height: 20),
                RoundedButton(
                  text: 'Connexion avec un numéro de téléphone',
                  onPressed: () => Navigator.pushNamed(context, LoginScreen.id),
                ),
            SizedBox(height: 20),
            SocialSignInButton(
              assetName: 'images/facebook-logo.png',
              text: 'Connexion avec Facebook',
              textColor: Colors.white,
              color: Color(0xFF334D92),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, RegisterScreen.id);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
