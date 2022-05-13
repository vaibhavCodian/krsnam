import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, // mix in default queue callback implementations
        SeekHandler { // mix in default seek callback implementations

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) {
    return super.addQueueItems(mediaItems);
  }

  final _player = AudioPlayer();
  final _player2 = AudioPlayer();


  AudioPlayerHandler() {
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      _player.setAudioSource(
          AudioSource.uri(
            Uri.parse("asset:///assets/audio/krishna_chant.mp3"),
          )
      );
      _player2.setAudioSource(
          AudioSource.uri(
            Uri.parse("asset:///assets/audio/theta_waves.mp3"),
          )
      );
      _player.playerStateStream.listen((state) => {
        if(state.processingState == ProcessingState.completed){
          print("hello"),
          _player.seek(Duration.zero)
        }
      });
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Future<void> setSpeed(double speed) async {
    _player.setSpeed(speed);
  }

  Future<void> play() async {
    // All 'play' requests from all origins route to here. Implement this
    // callback to start playing audio appropriate to your app. e.g. music.
    _player.play();
    _player.setSpeed(1.2);
    _player2.play();
  }
  Future<void> pause() async {
    await _player.pause();
    await _player2.pause();
  }
  Future<void> stop() async {}
  Future<void> seek(Duration position) async {}

}