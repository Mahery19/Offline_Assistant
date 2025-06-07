import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  final stt.SpeechToText _speech = stt.SpeechToText();

  Future<void> listen({
    required Function(String, bool) onResult, // Second arg: isFinal
    String localeId = 'en_US',
    bool partialResults = false,
    Function(String)? onStatus,
  }) async {
    bool available = await _speech.initialize(
      onStatus: onStatus,
      onError: (error) {},
    );
    if (available) {
      _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords, result.finalResult);
        },
        localeId: localeId,
        partialResults: partialResults,
        cancelOnError: true,
      );
    } else {
      onResult('Speech recognition unavailable', true);
    }
  }

  void stop() {
    _speech.stop();
  }

  void dispose() {
    _speech.cancel();
  }
}
