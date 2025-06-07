import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // For ThemeProvider, BackgroundListenProvider

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundListen = Provider.of<BackgroundListenProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: ListView(
        shrinkWrap: true,
        children: [
          // Language selection
          ListTile(
            leading: const Icon(Icons.language),
            title: Text('language').tr(),
            subtitle: Text(context.locale.languageCode == 'en'
                ? "English"
                : "Français"),
            trailing: DropdownButton<Locale>(
              value: context.locale,
              onChanged: (locale) {
                if (locale != null) context.setLocale(locale);
              },
              items: const [
                DropdownMenuItem(
                  value: Locale('en'),
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('Français'),
                ),
              ],
            ),
          ),
          // Theme selection
          ListTile(
            leading: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.dark_mode
                : Icons.light_mode),
            title: Text('theme').tr(),
            trailing: DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (mode) {
                if (mode != null) themeProvider.setTheme(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
            ),
          ),
          // Background listening toggle
          ListTile(
            leading: const Icon(Icons.hearing),
            title: const Text('Enable background listening'),
            subtitle: const Text(
              'Comming Soon !',
              //'When enabled, assistant will listen automatically when app is in background (requires native service).',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Switch(
              value: backgroundListen.backgroundListen,
              onChanged: (val) => backgroundListen.setBackgroundListen(val),
            ),
          ),
          const Divider(),
          // About, Help, Rate, Contact
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('about').tr(),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Offline Assistant",
                applicationVersion: "2.0",
                applicationLegalese: "© 2025 Mahery & Fidelia",
                children: [
                  Text(
                    "Personal voice assistant offline-first.\nDeveloped by MaFi Enterprise.\nPowered by Flutter.",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text('help').tr(),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('help').tr(),
                  content: const Text(
                    "• Speak a command (like 'What's the weather?')\n"
                        "• Tap the mic to listen\n"
                        "• Try:\n"
                        "   - 'Play music'\n"
                        "   - 'Turn on Wi-Fi'\n"
                        "   - 'Call [name]'\n"
                        "   - 'Open google.com'\n"
                        "   - and more...",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('ok').tr(),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_rate_outlined),
            title: Text('rate').tr(),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('rate').tr(),
                  content: const Text(
                      "Template: Link this to the Play Store or your own rating page."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('ok').tr(),
                    ),
                  ],
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.mail_outline),
            title: Text('contact').tr(),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('contact').tr(),
                  content: const Text(
                      "Template: Add your email or contact form here.\nExample: mahery@example.com"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('ok').tr(),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
