import 'package:dynamic_link_reward_app/models/user.dart';
import 'package:dynamic_link_reward_app/repositories/user_repository.dart';
import 'package:dynamic_link_reward_app/view/auth/auth.dart';
import 'package:dynamic_link_reward_app/view/reward/reward_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RewardView extends StatelessWidget {
  const RewardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<RewardState>(context);

    return SafeArea(
      child: Scaffold(
        body: ValueListenableBuilder<User?>(
          valueListenable: UserRepository.instance!.currentUserNotifier,
          builder: (context, value, widget) {
            if (value != null) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${value.reward}', style: Theme.of(context).textTheme.headline3),
                    Text('My Reward', style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(height: 20),
                    Text('Email: ${value.email}', style: Theme.of(context).textTheme.headline6),
                    Text('Referrers: ${value.referrers}', style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: 30),
                    SelectableText('Refer Link: ${value.referLink}', style: Theme.of(context).textTheme.headline6),
                    const SizedBox(height: 30),
                    TextButton(
                      onPressed: () {
                        state.userRepo?.logOutUser();
                      },
                      child: Text(
                        'Log-out',
                      ),
                    )
                  ],
                ),
              );
            } else {
              return AuthWidget();
            }
          },
        ),
      ),
    );
  }
}

class RewardWidget extends StatelessWidget {
  const RewardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = RewardState();
    return ChangeNotifierProvider(
      create: (_) => state,
      child: ChangeNotifierProvider.value(
        value: state,
        child: RewardView(),
      ),
    );
  }
}
