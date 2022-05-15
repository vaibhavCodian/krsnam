import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:krsnam/playerProvider.dart';

late int count;

class AudioPlayerHandler extends BaseAudioHandler
    with QueueHandler, // mix in default queue callback implementations
        SeekHandler { // mix in default seek callback implementations

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) {
    return super.addQueueItems(mediaItems);
  }

  final _player = AudioPlayer();
  final _playerWave = AudioPlayer();
  static PlayerProvider _playerProvider = new PlayerProvider();

  void setPlayerProvider(PlayerProvider pp){
    _playerProvider = pp;
  }

  AudioPlayerHandler() {
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
          print('A stream error occurred: $e');
        });
    // Try to load audio from a source and catch any errors.
    try {
      _player.setAsset("assets/audio/krishna_chant.mp3");
      _playerWave.setAsset("assets/audio/wave/Theta.mp3");

      _player.playerStateStream.listen((state) async => {
        count  = _playerProvider.count,
        if(state.processingState == ProcessingState.completed){
          if(_playerProvider.isInfinity){
            _player.seek(Duration.zero),
          } else {
            if (count <= 1) {
              _playerProvider.setIsPlaying(false),
              _playerProvider.setCounts(count - 1),
              await stop()
            } else {
              _player.seek(Duration.zero),
              _playerProvider.setCounts(count - 1),
            }
          }

        }

      });
      _playerWave.playerStateStream.listen((state) => {
        if(state.processingState == ProcessingState.completed){
          _playerWave.seek(Duration.zero)
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
    _playerProvider.count == 0?_playerProvider.setCounts(108):print("playing__________________");
    _playerProvider.setIsPlaying(true);

    _player.play();
    _playerWave.play();
    _player.setSpeed(1.2);
    
  }
  Future<void> pause() async {
    await _player.pause();
    await _playerWave.pause();
    _playerProvider.setIsPlaying(false);
  }
  Future<void> stop({bool isWave=false}) async {
    if (!isWave){
      _playerProvider.setIsPlaying(false);
      await _player.stop();
    }
    await _playerWave.stop();
  }
  Future<void> seek(Duration position) async {}

  @override
  Future customAction(String waveId, [Map<String, dynamic>? extras]) async {
    await stop(isWave: true);
    _playerWave.setVolume(1.0);

    if (int.parse(waveId) == 1){
      await _playerWave.setAsset("assets/audio/wave/Alpha.mp3");
    } else if (int.parse(waveId) == 2) {
      await _playerWave.setAsset("assets/audio/wave/Theta.mp3");
    } else if (int.parse(waveId) == 3) {
      await _playerWave.setAsset("assets/audio/wave/Gamma.mp3");
    }  else {
      await _playerWave.setAsset("assets/audio/wave/Nature.mp3");
    }
    _playerWave.play();

    if (int.parse(waveId) == 0){
      await _playerWave.setVolume(0.0);
      await _playerWave.stop();
    }
    return super.customAction(waveId, extras);
  }

}