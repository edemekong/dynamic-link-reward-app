import 'package:dynamic_link_reward_app/repositories/user_repository.dart';
import 'package:dynamic_link_reward_app/services/deep_link_service.dart';
import 'package:dynamic_link_reward_app/view/reward/reward.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DeepLinkService.instance?.handleDynamicLinks();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    UserRepository.instance?.listenToCurrent(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reward App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RewardWidget(),
    );
  }
}
