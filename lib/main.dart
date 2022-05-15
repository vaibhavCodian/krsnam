import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:krsnam/components.dart';
import 'package:krsnam/playerProvider.dart';
import 'package:provider/provider.dart';
import 'util.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

late AudioHandler _audioHandler;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _audioHandler = await AudioService.init(
      builder: () => AudioPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.ryanheise.myapp.channel.audio',
        androidNotificationChannelName: 'Audio playback',
        androidStopForegroundOnPause: false,
        // androidNotificationOngoing: true,
      ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => PlayerProvider(),
      child: MaterialApp(
        title: 'krsnam',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colors.blueGrey),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Container(
                  child: WaveWidget(
                    backgroundColor: Color(0xffffffff),
                    size: Size(MediaQuery.of(context).size.width,
                        MediaQuery.of(context).size.height),
                    config: CustomConfig(
                      gradients: [
                        [Colors.white70, Colors.black45],
                        [Color(0xBEE0A325), Color(0xF3983C0A)],
                        [Color(0xD7406EBA), Color(0xF24C93B1)],
                        [Color(0xB99EE034), Color(0xBF4D8D32)]
                      ],
                      blur: MaskFilter.blur(BlurStyle.outer, 5),
                      durations: [35000, 19440, 10800, 6000],
                      heightPercentages: [0.20, 0.23, 0.25, 0.30],
                      gradientBegin: Alignment.topCenter,
                      gradientEnd: Alignment.bottomRight,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      topStack(_audioHandler),
                      ProgressCounter(context),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      mediaControlStack(context, _audioHandler)
                    ],
                  ),
                ),
              ],
            ),
            // SizedBox(height: 200),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
