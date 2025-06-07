import 'package:just_audio/just_audio.dart';

class AudioService {
  static final _player = AudioPlayer();
  static List<String> _playlist = [];
  static int _currentIndex = 0;

  /// Load a playlist and start playing from the first track
  static Future<String> playPlaylist(List<String> tracks, {int startIndex = 0}) async {
    if (tracks.isEmpty) return "Playlist is empty.";
    _playlist = tracks;
    _currentIndex = startIndex.clamp(0, _playlist.length - 1);
    return await _playCurrent();
  }

  /// Play a single local file (mp3 or mp4) and reset playlist
  static Future<String> playLocalFile(String path) async {
    _playlist = [path];
    _currentIndex = 0;
    return await _playCurrent();
  }

  /// Play a single stream/URL and reset playlist
  static Future<String> playFromUrl(String url) async {
    _playlist = [url];
    _currentIndex = 0;
    return await _playCurrent();
  }

  /// Play the current track in the playlist
  static Future<String> _playCurrent() async {
    try {
      String source = _playlist[_currentIndex];
      if (source.startsWith('http')) {
        await _player.setUrl(source);
      } else {
        await _player.setFilePath(source);
      }
      await _player.play();
      return "Playing: ${_fileName(source)}";
    } catch (e) {
      return "Could not play the file/stream.";
    }
  }

  /// Next track
  static Future<String> next() async {
    if (_playlist.isEmpty) return "No playlist loaded.";
    if (_currentIndex < _playlist.length - 1) {
      _currentIndex++;
      return await _playCurrent();
    } else {
      return "You're at the last track.";
    }
  }

  /// Previous track
  static Future<String> previous() async {
    if (_playlist.isEmpty) return "No playlist loaded.";
    if (_currentIndex > 0) {
      _currentIndex--;
      return await _playCurrent();
    } else {
      return "You're at the first track.";
    }
  }

  /// Pause
  static Future<String> pause() async {
    await _player.pause();
    return "Music paused.";
  }

  /// Stop
  static Future<String> stop() async {
    await _player.stop();
    return "Music stopped.";
  }

  static String _fileName(String path) {
    return path.split('/').last;
  }
}
