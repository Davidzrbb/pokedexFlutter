import 'package:flutter/material.dart';
import 'package:sandbox_app/ui/screens/welcome.dart';
import 'package:sandbox_app/ui/utils_widget/app_bar.dart';
import '../utils_widget/bottom_navigation.dart';

class WelcomeParent extends StatelessWidget {
  const WelcomeParent({super.key});

  @override
  Widget build(BuildContext context) {
     return const Scaffold(
      appBar: BaseAppBar(),
      body: Welcome(),
      bottomNavigationBar: BottomNavigatorBar(),
    );
  }
}
