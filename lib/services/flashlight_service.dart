import 'package:torch_light/torch_light.dart';

class FlashlightService {
  static Future<String> toggleFlashlight(bool turnOn) async {
    try {
      if (turnOn) {
        await TorchLight.enableTorch();
        return "Flashlight turned ON.";
      } else {
        await TorchLight.disableTorch();
        return "Flashlight turned OFF.";
      }
    } catch (e) {
      return "Sorry, I can't control the flashlight: $e";
    }
  }
}
