import 'package:flutter/material.dart';
import 'package:socialnetwork/app/routes/routes.dart';
import 'package:socialnetwork/data/local/auth_local.dart';
import 'package:socialnetwork/app/widgets/bottomsheet/switch_account.dart';
class SettingController extends ChangeNotifier {
  
  void goToAccount(BuildContext context) {
    Navigator.pushNamed(context, Routes.account);
  }

  void goToDarkmode(BuildContext context) {
    Navigator.pushNamed(context, Routes.darkmode);
  }

  void goToLanguage(BuildContext context) {
    Navigator.pushNamed(context, Routes.language);
  }

  void goToActivity(BuildContext context) {
    Navigator.pushNamed(context, Routes.activity);
  }

  void goToFont(BuildContext context) {
    Navigator.pushNamed(context, Routes.font);
  }

  void logout(BuildContext context) async {
    await AuthLocal.logout();
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.wellcome,
      (route) => false,
    );
  }

  void switchAccount(BuildContext context) async {
    final accounts = await AuthLocal.getSavedAccounts();
    final currentEmail = await AuthLocal.getCurrentEmail();
    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => SwitchAccountBottomSheet(
        accounts: accounts,
        currentEmail: currentEmail,
        onSelectEmail: (email) async {
          if (!context.mounted) return;
          Navigator.pushNamed(
            context,
            Routes.switchAccount,
            arguments: {'email': email},
          );
        },
        onAddAccount: () {
          Navigator.pushNamed(context, Routes.signinEmail);
        },
      ),
    );
  }
}