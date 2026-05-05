import 'package:flutter/material.dart';
import 'package:socialnetwork/app/pages/splash/splash_page.dart';

import 'package:socialnetwork/app/pages/wellcome/wellcome_page.dart';

import 'package:socialnetwork/app/pages/scanner/scanner_page.dart';

import 'package:socialnetwork/app/pages/creategroup/creategroup_page.dart';

import 'package:socialnetwork/app/pages/signin/email/email_page.dart';
import 'package:socialnetwork/app/pages/signin/password/password_page.dart';
import 'package:socialnetwork/app/pages/forgot/forgot_page.dart';

import 'package:socialnetwork/app/pages/verify/signup/signup_page.dart';

import 'package:socialnetwork/app/pages/verify/forgot/forgot_page.dart';
import 'package:socialnetwork/app/pages/forgot/password/password_page.dart';


import 'package:socialnetwork/app/pages/signup/email/email_page.dart';
import 'package:socialnetwork/app/pages/signup/name/name_page.dart';
import 'package:socialnetwork/app/pages/signup/birthday/birthday_page.dart';
import 'package:socialnetwork/app/pages/signup/gender/gender_page.dart';
import 'package:socialnetwork/app/pages/signup/avatar/avatar_page.dart';
import 'package:socialnetwork/app/pages/signup/password/password_page.dart';

import 'package:socialnetwork/app/pages/main/main_page.dart';
import 'package:socialnetwork/app/pages/searchaccount/searchaccount_page.dart';

import 'package:socialnetwork/app/pages/setting/setting_page.dart';
import 'package:socialnetwork/app/pages/setting/account/account_page.dart';
import 'package:socialnetwork/app/pages/setting/change/change_page.dart';
import 'package:socialnetwork/app/pages/setting/darkmode/darkmode_page.dart';
import 'package:socialnetwork/app/pages/setting/language/language_page.dart';
import 'package:socialnetwork/app/pages/setting/activity/activity_page.dart';
import 'package:socialnetwork/app/pages/setting/switchaccount/switchaccount_page.dart';

import 'package:socialnetwork/app/pages/follow/followers/followers_page.dart';
import 'package:socialnetwork/app/pages/follow/following/following_page.dart';
import 'package:socialnetwork/app/pages/friends/friends_page.dart';

import 'package:socialnetwork/app/pages/qrcode/qrcode_page.dart';

class Routes {

  static const String splash = '/';

  static const String main = '/main';

  static const String wellcome = '/wellcom';

  static const String createGroup = '/creategroup';
  static const String scanner = '/scanner';

  static const String signinEmail = '/signin/email';

  static const String signinPassword = '/signin/password';
  static const String forgot = '/forgot';

  static const String forgetPassword = '/forgetpassword';

  static const String verifySignUp = '/verifysignup';
  static const String verifyForget = '/verifyforget';
  static const String forgotPassword = '/forgetpassword';

  static const String signupEmail = '/signup/email';
  static const String signupName = '/signup/name';
  static const String signupBirthday = '/signup/birthday';
  static const String signupGender = '/signup/gender';
  static const String signupAvatar = '/signup/avatar';
  static const String signupPassword = '/signup/password';

  static const String search = '/search';
  
  static const String setting = '/setting';
  static const String account = '/account';
  static const String change = '/change';
  static const String darkmode = '/darkmode';
  static const String language = '/language';
  static const String activity = '/activity';
  static const String switchAccount = '/switchaccount';

  static const String followers = '/followers';
  static const String following = '/following';
  static const String friends = '/friends';

  static const String qrCode = '/qrcode';

  static final Map<String, WidgetBuilder> routes = {
    splash: (_) => SplashPage(),  

    wellcome: (_) => WellcomePage(),
    scanner: (_) => const ScannerPage(),

    createGroup: (_) => CreateGroupPage(),

    signinEmail: (_) => SignInEmailPage(),

    signinPassword: (_) => SignInPasswordPage(),
    forgot: (_) => ForgetPage(),

    verifySignUp: (_) => VerifySignUpPage(),

    verifyForget: (_) => VerifyForgotPage(),
    forgotPassword: (_) => ForgotPasswordPage(),

    signupEmail: (_) => SignUpEmailPage(),
    signupName: (_) => SignUpNamePage(),
    signupBirthday: (_) => SignUpBirthdayPage(),
    signupGender: (_) => SignUpGenderPage(),
    signupAvatar: (_) => SignUpAvatarPage(),
    signupPassword: (_) => SignUpPasswordPage(),
    
    main: (_) => MainPage(),
    search: (_) => SearchAccountPage(),

    setting: (_) => const SettingPage(),
    account: (_) => const AccountPage(),
    change: (_) => const ChangePage(),
    darkmode: (_) => const DarkmodePage(),
    language: (_) => const LanguagePage(),
    activity: (_) => const ActivityPage(),
    switchAccount: (_) => const SwitchAccountPage(),

    followers: (_) => const FollowersPage(),
    following: (_) => const FollowingPage(),
    friends: (_) => const FriendsPage(),

    qrCode: (_) => const QRCodePage(),

  };
}