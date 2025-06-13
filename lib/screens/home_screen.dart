/*import 'package:flutter/material.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../actions/action_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpeechService _speechService = SpeechService();
  final TTSService _ttsService = TTSService();

  String _recognizedText = 'Press the mic and speak...';
  bool _isListening = false;

  @override
  void dispose() {
    _speechService.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  void _onResult(String result) async {
    setState(() => _recognizedText = result);

    // Handle recognized text
    String response = await ActionHandler.handleCommand(result);
    await _ttsService.speak(response);
    setState(() => _recognizedText = '$result\n\nAssistant: $response');
  }

  void _listen() async {
    if (_isListening) {
      _speechService.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speechService.listen(onResult: _onResult);
      setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Offline Voice Assistant')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            _recognizedText,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
*/

/*import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/settings_sheet.dart';
import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _command = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _speech.stop();
    super.dispose();
  }

  // Listen for app lifecycle changes (foreground/background)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final backgroundListen = Provider.of<BackgroundListenProvider>(context, listen: false).backgroundListen;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App going to background
      if (backgroundListen) {
        // ---- Here: Start your native Android background service via MethodChannel
        debugPrint("Background mode enabled! Would start service here.");
        // e.g. MethodChannel('assistant_bg').invokeMethod('startBackgroundService');
      }
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground again
      // ---- Here: Stop background service if running
      debugPrint("App in foreground. Stop background listening service if active.");
      // e.g. MethodChannel('assistant_bg').invokeMethod('stopBackgroundService');
    }
  }

  /// Mic is only started via button (foreground)
  Future<void> _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => setState(() => _isListening = status == "listening"),
      onError: (err) => setState(() => _isListening = false),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _command = result.recognizedWords;
          });
          // Here: Handle command (call your assistant logic)
        },
        listenFor: const Duration(minutes: 2),
        pauseFor: const Duration(seconds: 5),
        partialResults: true,
        localeId: context.locale.languageCode == 'fr' ? "fr_FR" : "en_US",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always require mic button in foreground
    return Scaffold(
      appBar: AppBar(
        title: Text('hello').tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (ctx) => const SettingsSheet(),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _command.isEmpty
                  ? "Tap mic and speak"
                  : "Heard: $_command",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 24),
            IconButton(
              icon: Icon(_isListening ? Icons.hearing : Icons.mic),
              iconSize: 48,
              color: _isListening ? Colors.green : null,
              onPressed: _startListening,
            ),
            if (_isListening)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Listening...",
                  style: TextStyle(color: Colors.green),
                ),
              ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import '../models/interaction.dart';
import '../personalization_provider.dart';
import '../services/chatbot_engine.dart';
import '../services/mode_provider.dart';
import '../services/speech_service.dart';
import '../services/tts_service.dart';
import '../actions/action_handler.dart';
import '../widgets/settings_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

bool _isChatBotMode = false; // NEW: mode toggle
List<Interaction> _chatHistory = [];
class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final SpeechService _speechService = SpeechService();
  final TTSService _ttsService = TTSService();


  bool _isListening = false;
  String _recognizedText = 'Tap mic and speak';

  @override
  void dispose() {
    _speechService.dispose();
    _ttsService.dispose();
    super.dispose();
  }

  void _onResult(String text, bool isFinal) async {
    setState(() => _recognizedText = text);
    if (isFinal) {
      final isChatBotMode = Provider.of<ModeProvider>(context, listen: false).isChatBotMode;
      String response;
      if (isChatBotMode) {
        response = await ChatBotEngine.getReply(text);
      } else {
        final personalization = Provider.of<PersonalizationProvider>(context, listen: false);
        response = await ActionHandler.handleCommand(text, personalization);
      }
      await _ttsService.speak(response);
      setState(() {
        _chatHistory.add(Interaction(text, response));
        _recognizedText = '';
      });
    }
  }

  Future<void> _listen() async {
    if (_isListening) {
      _speechService.stop();
      setState(() => _isListening = false);
    } else {
      await _speechService.listen(
        onResult: _onResult,
        localeId: context.locale.languageCode == 'fr' ? "fr_FR" : "en_US",
        partialResults: true,
        onStatus: (status) {
          setState(() => _isListening = status == "listening");
        },
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final modeProvider = Provider.of<ModeProvider>(context);
    // Only clear if mode just changed!
    if (_lastMode != modeProvider.isChatBotMode) {
      setState(() {
        _chatHistory.clear();
        _lastMode = modeProvider.isChatBotMode;
      });
    }
  }
  bool _lastMode = false;

  @override
  Widget build(BuildContext context) {
    final isChatBotMode = Provider.of<ModeProvider>(context).isChatBotMode;
    return Scaffold(
      appBar: AppBar(
        title: Text('Offline Assistant').tr(),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => showModalBottomSheet(
              context: context,
              showDragHandle: true,
              isScrollControlled: true,
              builder: (ctx) => const SettingsSheet(),
            ),
          ),
          /*Row(
            children: [
              const Text("Assistant"),
              Switch(
                value: _isChatBotMode,
                onChanged: (val) => setState(() => _isChatBotMode = val),
              ),
              const Text("Chatbot"),
            ],
          ),*/
        ],
      ),
      body: Column(
        children: [
          // Optional: Show banner for Chatbot mode
          if (_isChatBotMode)
            Container(
              width: double.infinity,
              color: Colors.purple[50],
              padding: const EdgeInsets.all(8),
              child: const Text(
                "Chatbot mode: Your virtual friend is here!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.purple),
              ),
            ),

          // Chat history
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final item = _chatHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("You: ${item.userText}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_isChatBotMode
                            ? "Friend: ${item.assistantResponse}"
                            : "Assistant: ${item.assistantResponse}"),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Current recognition text (if you want to show it live)
          if (_recognizedText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                _recognizedText,
                style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),

          // Mic Button at the bottom
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_isListening ? Icons.hearing : Icons.mic),
                  iconSize: 48,
                  color: _isListening ? Colors.green : null,
                  onPressed: _listen,
                ),
                if (_isListening)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Listening...",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
