import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:spotify_clone/providers/auth_provider.dart';
import 'package:spotify_clone/screens/home/home_screen.dart';
import 'package:spotify_clone/services/spotify.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FaIcon(
                FontAwesomeIcons.spotify,
                size: 40,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Millions of songs.",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                "Free on Spotify.",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                    onPressed: () async {
                      await authProvider.login();
                      if (context.mounted) {
                        context.go(MyHomePage.routeName);
                      }
                    },
                    style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(15),
                        ),
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(36.0),
                                side: const BorderSide(color: Colors.white)))),
                    child: const Row(
                      children: [
                        FaIcon(FontAwesomeIcons.spotify,
                            color: Color.fromRGBO(29, 185, 84, 1)),
                        Expanded(
                          child: Center(
                            child: Text('Continue with Spotify',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
