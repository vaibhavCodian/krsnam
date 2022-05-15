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
  final _playerWave = AudioPlayer();


  AudioPlayerHandler() {
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      _player.setAsset("asset:///assets/audio/krishna_chant.mp3");
      _playerWave.setAsset("assets/audio/wave/Theta.mp3");

      _player.playerStateStream.listen((state) => {
        if(state.processingState == ProcessingState.completed){
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
    _playerWave.play();
    _playerWave.setVolume(0.8);
    
  }
  Future<void> pause() async {
    await _player.pause();
    await _playerWave.pause();
  }
  Future<void> stop({bool isWave=false}) async {
    if (!isWave){
      await _player.stop();
    }
    await _playerWave.stop();
  }
  Future<void> seek(Duration position) async {}

  @override
  Future customAction(String waveId, [Map<String, dynamic>? extras]) async {
    await stop(isWave: true);

    if (int.parse(waveId) == 0){
      await _playerWave.setAsset("assets/audio/wave/Alpha.mp3");
    } else if (int.parse(waveId) == 1) {
      await _playerWave.setAsset("assets/audio/wave/Theta.mp3");
    } else if (int.parse(waveId) == 2) {
      await _playerWave.setAsset("assets/audio/wave/Gamma.mp3");
    }  else {
      await _playerWave.setAsset("assets/audio/wave/Nature.mp3");
    }
    await play();
    return super.customAction(waveId, extras);
  }



}