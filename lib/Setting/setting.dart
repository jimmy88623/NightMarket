import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nightmarket/Theme/theme.dart';
import 'package:nightmarket/Theme/theme_provider.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:nightmarket/login/loginPage.dart';

class Set extends StatefulWidget {
  const Set({super.key});

  @override
  State<StatefulWidget> createState() => _SetState();
}

class _SetState extends State<Set> {
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: Provider.of<ThemeProvider>(context).themeData,
        home: Scaffold(
          appBar: AppBar(
            title:Image.asset('assets/night_market_logo.png',fit: BoxFit.contain,)
          ),
          body: SettingsList(
            sections: [
              SettingsSection(
                title: Text('Common'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: Icon(Icons.language),
                    title: Text('Language'),
                    value: Text('English'),
                  ),
                  SettingsTile.switchTile(
                    onToggle: (value) {},
                    initialValue: true,
                    leading: Icon(Icons.format_paint),
                    title: Text('Enable custom theme'),
                  ),
                ],
              ),
              SettingsSection(
                title: Text('Mode'),
                tiles: <SettingsTile>[
                  SettingsTile.switchTile(
                    onToggle: (bool value) {
                      setState(() {
                        _isDarkMode = value;
                      });
                      Provider.of<ThemeProvider>(context, listen: false)
                          .toggleTheme();
                    },
                    initialValue: _isDarkMode,
                    leading: const Icon(Icons.light),
                    title: const Text('Dark Mode'),
                  ),
                ],
              ),
              SettingsSection(
                title: Text('Account'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: Icon(Icons.phone),
                    title: Text('Phone Number'),
                  ),
                  SettingsTile.navigation(
                    leading: Icon(Icons.email),
                    title: Text('Email'),
                  ),
                ],
              ),
              SettingsSection(
                title: Text('Logout'),
                tiles: <SettingsTile>[
                  SettingsTile.navigation(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onPressed: (BuildContext ocntext) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
