import 'package:dynamic_link_reward_app/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'auth_state.dart';

class AuthView extends StatelessWidget {
  const AuthView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<AuthState>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 60),
            if (state.signInState == SignInState.signup)
              CustomTextField(
                label: 'Name',
                controller: state.nameController,
              ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email',
              controller: state.emailController,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Password',
              controller: state.passwordController,
            ),
            const SizedBox(height: 16 * 2),
            state.isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : TextButton(
                    onPressed: () async {
                      state.signUpLogin();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        state.signInState == SignInState.signup ? 'Create Account' : 'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    if (state.signInState == SignInState.login) {
                      state.changeState = SignInState.signup;
                    } else {
                      state.changeState = SignInState.login;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      state.signInState != SignInState.signup ? 'Register' : 'Login',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AuthWidget extends StatelessWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = AuthState();
    return ChangeNotifierProvider(
      create: (_) => state,
      child: ChangeNotifierProvider.value(
        value: state,
        child: AuthView(),
      ),
    );
  }
}
