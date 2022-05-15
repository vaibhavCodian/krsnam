import 'package:flutter/cupertino.dart';

class PlayerProvider extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isInfiity = false;
  int _waveId = 1;
  int _counts = 108;
  double _speed = 1.2;

  String duration = "infi";

  get isPlaying => _isPlaying;
  get waveId => _waveId;
  get speed => _speed;
  get counts => _counts;
  get isInfiity => _isInfiity;

  void setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
    notifyListeners();
  }
  void setIsInfinity(bool infinity) {
    _isInfiity = infinity;
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
  void setCounts(int counts) {
    _counts = counts;
    print("Chinging Counts");
    notifyListeners();
  }


}