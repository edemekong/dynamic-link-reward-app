import 'package:dynamic_link_reward_app/repositories/user_repository.dart';
import 'package:flutter/material.dart';

class RewardState extends ChangeNotifier {
  final userRepo = UserRepository.instance;
}
