import 'package:flutter/cupertino.dart';

class PlayerProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isInfinity = true;
  int _waveId = 2;
  static int counts = 108;
  double _speed = 1.2;

  String duration = "infi";

  get isPlaying => _isPlaying;
  get waveId => _waveId;
  get speed => _speed;
  get count => counts;
  get isInfinity => _isInfinity;

  void setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }
  void setIsInfinity(bool infinity) {
    _isInfinity = infinity;
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
  void setCounts(int count) {
    counts = count;
    print("Chinging Counts");
    notifyListeners();
  }


}