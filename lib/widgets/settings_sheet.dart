import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../main.dart'; // For ThemeProvider, BackgroundListenProvider
import 'package:provider/provider.dart';
import '../personalization_provider.dart';
import '../services/custom_command_provider.dart';
import '../services/mode_provider.dart';

const String userGuide = '''
Offline Assistant User Guide

Welcome to Offline Assistant!
Your privacy-friendly, voice-driven personal assistant that works even without the internet.

How to Use
• Tap the microphone and speak a command.
• See and hear the assistant’s response.
• Try out these examples!

What You Can Say

Greetings
- Hello or Hi
- What's your name?

Music
- Play song or Play music
  (Plays all your music in the Music folder)
- Pause music
- Stop music
- Next song / Previous song

Notes
- Note: Buy milk
  (Saves a quick note)
- Read my notes

Reminders & Alarms
- Remind me to take medicine at 14:30
- Set alarm at 6:30

Weather, Location, and Battery (internet connection required)
- What's the weather?
- What's my location? / Where am I?
- What's my battery level?

Calls & SMS
- Call John
- Call 0341234567
- Send SMS to John Hello, how are you?
- Send SMS to 0341234567 I'll be late

Web & App Actions (internet connection required)
- Open google.com
- Open WhatsApp
- Open YouTube
- Play YouTube Imagine Dragons Believer

Device Controls
- Turn on Wi-Fi / Turn off Wi-Fi
- Turn on Bluetooth / Turn off Bluetooth
- Turn on airplane mode
- Turn off airplane mode
- Turn on flashlight
- Turn off flashlight

Time & Date
- What time is it?
- What's today's date?

Fun & Small Talk
- Tell me a joke
- Bye (Closes the app)
- Calculate 5 x 7 (Does basic math)

Tips
- You can personalize the assistant’s name and response style in Settings.
- For best results, grant the app permissions it asks for (contacts, calls, SMS, etc.).

Privacy
- This app works offline and does NOT send your voice or data to the cloud.

Having trouble?
- Try rephrasing your command.
- Check that you’ve granted the required permissions.
- For questions or suggestions, contact the developer.

Enjoy your personal Offline Assistant!
''';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context) {

    final themeProvider = Provider.of<ThemeProvider>(context);
    final backgroundListen = Provider.of<BackgroundListenProvider>(context);
    final personalization = Provider.of<PersonalizationProvider>(context);
    final customCommands = Provider.of<CustomCommandProvider>(context);
    final modeProvider = Provider.of<ModeProvider>(context);

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
                /*DropdownMenuItem(
                  value: Locale('fr'),
                  child: Text('Français'),
                ),*/
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
            leading: const Icon(Icons.person),
            title: const Text('Assistant Name'),
            subtitle: Text(personalization.assistantName),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final controller = TextEditingController(text: personalization.assistantName);
                final name = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Change Assistant Name"),
                    content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Enter name")),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                      TextButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text("OK")),
                    ],
                  ),
                );
                if (name != null && name.isNotEmpty) {
                  personalization.setAssistantName(name);
                }
              },
            ),
          ),
          ListTile(
            leading: Icon(modeProvider.isChatBotMode ? Icons.chat_bubble : Icons.smart_toy),
            title: const Text('Assistant Mode'),
            subtitle: Text(modeProvider.isChatBotMode
                ? "Chatbot (virtual friend)"
                : "Assistant (commands)"),
            trailing: Switch(
              value: modeProvider.isChatBotMode,
              onChanged: (val) {
                // Clear history when switching mode:
                Navigator.pop(context); // Dismiss settings sheet first (optional)
                modeProvider.setChatBotMode(val);
                // You’ll call a function to clear chat in HomeScreen below!
              },
            ),
          ),
          /*ListTile(
            leading: const Icon(Icons.hearing),
            title: const Text('Enable background listening'),
            subtitle: const Text(
              'Coming Soon !',
              //'When enabled, assistant will listen automatically when app is in background (requires native service).',
              style: TextStyle(fontSize: 12),
            ),
            trailing: Switch(
              value: backgroundListen.backgroundListen,
              onChanged: (val) => backgroundListen.setBackgroundListen(val),
            ),
          ),*/
          const Divider(),
          // About, Help, Rate, Contact
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text('about').tr(),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Offline Assistant",
                applicationVersion: "V 3.0",
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
                  title: const Text('Offline Assistant Guide'),
                  content: SizedBox(
                    width: double.maxFinite,
                    child: SingleChildScrollView(
                      child: Text(
                        userGuide,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('OK'),
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
                      "Coming Soon."),
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
                      "email: maherytsarovana@gmail.com.\n"
                          "github: https://github.com/Mahery19/Offline_Assistant"),
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
          /*ListTile(
            leading: const Icon(Icons.record_voice_over),
            title: const Text('Wake Word'),
            subtitle: Text(personalization.wakeWord),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final controller = TextEditingController(text: personalization.wakeWord);
                final word = await showDialog<String>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text("Change Wake Word"),
                    content: TextField(controller: controller, decoration: const InputDecoration(hintText: "Enter wake word")),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
                      TextButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text("OK")),
                    ],
                  ),
                );
                if (word != null && word.isNotEmpty) {
                  personalization.setWakeWord(word);
                }
              },
            ),
          ),

          ListTile(
            leading: const Icon(Icons.style),
            title: const Text('Response Style'),
            trailing: DropdownButton<String>(
              value: personalization.responseStyle,
              items: [
                DropdownMenuItem(value: "default", child: Text("Default")),
                DropdownMenuItem(value: "friendly", child: Text("Friendly")),
                DropdownMenuItem(value: "formal", child: Text("Formal")),
                DropdownMenuItem(value: "funny", child: Text("Funny")),
              ],
              onChanged: (style) {
                if (style != null) personalization.setResponseStyle(style);
              },
            ),
          ),*/
        ],
      ),
    );
  }
}
