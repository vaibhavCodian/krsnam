import 'package:flutter/cupertino.dart';

class PlayerProvider extends ChangeNotifier {
  bool _isPlaying = false;
  int _waveId = 2;
  double _speed = 1.2;

  get isPlaying => _isPlaying;
  get waveId => _waveId;
  get speed => _speed;

  void setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }
  void setWaveId(int waveId) {
    _waveId = waveId;
    notifyListeners();
  }
  void setSpeed(double speed) {
    _speed = speed;
    print("Chinging Speed");
    notifyListeners();
  }
}