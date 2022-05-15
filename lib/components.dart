import 'package:audio_service/audio_service.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:krsnam/playerProvider.dart';
import 'package:krsnam/util.dart';
import 'package:provider/provider.dart';

/*
 * Major Components
 */
TextEditingController countsController = new TextEditingController(text: PlayerProvider().count.toString());

topStack(AudioHandler audioHandler) {
  return Consumer<PlayerProvider>(
    builder: (context, provider, child) {;
      return Stack(
        alignment: Alignment.center,
        // fit: StackFit.loose,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.78,
            height: MediaQuery.of(context).size.width * 0.76,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(11),
                image: DecorationImage(
                  image: AssetImage("assets/krishna.jpg"),
                  colorFilter: ColorFilter.mode(
                    Colors.white70.withOpacity(0.7),
                    BlendMode.modulate,
                  ),
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.width * 0.50,
              // left: MediaQuery.of(context).size.width * 0.50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {
                    // <- Stop Btn
                    await audioHandler.stop();
                  },
                  icon: Icon(FontAwesomeIcons.circleStop),
                  color: Colors.white,
                  iconSize: MediaQuery.of(context).size.width * 0.12,
                ),
                IconButton(
                  onPressed: () {
                    // <- play/pause Btn
                    provider.isPlaying
                        ? audioHandler.pause()
                        : audioHandler.play();
                  },
                  icon: provider.isPlaying
                      ? Icon(FontAwesomeIcons.pause)
                      : Icon(FontAwesomeIcons.solidCirclePlay),
                  color: Colors.white,
                  iconSize: MediaQuery.of(context).size.width * 0.12,
                ),
              ],
            ),
          ),
        ],
      );
    },
  );
}

ProgressCounter(BuildContext context) {
  return Consumer<PlayerProvider>(
    builder: (context, provider, child) {
      AudioPlayerHandler().setPlayerProvider(provider);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // todo: Implement Progress
          // Container( // <- progressn content
          //   width: MediaQuery.of(context).size.width * 0.75,
          //   margin: EdgeInsets.only(
          //     right: MediaQuery.of(context).size.width * 0.125,
          //   ),
          //   child: NeumorphicProgress(
          //     percent: 0.2,
          //     style: ProgressStyle(
          //         variant: Color(0xFF2c3e50),
          //         accent: Color(0xFF95a5a6)),
          //   ),
          // ),
          Container(      // <- Counter Content
            margin: EdgeInsets.only(
              top: 1.5,
              right: MediaQuery.of(context).size.width * 0.125,
            ),
            child: provider.isInfinity?
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(FontAwesomeIcons.infinity),
                SizedBox(width: 15),
                Text(
                  "अनन्त",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                )
              ],
            ):NeumorphicText(
              "Count: ${provider.count}",
              textAlign: TextAlign.left,
              style: NeumorphicStyle(color: Color(0xFF2C3A47)),
              textStyle: NeumorphicTextStyle(
                  fontWeight: FontWeight.w400, fontSize: 20),
            ),
          ),
        ],
      );
    },
  );
}

Container mediaControlStack(BuildContext context, AudioHandler audioHandler) {
  return Container(
    margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.height * 0.05,
        right: MediaQuery.of(context).size.height * 0.05),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NeumorphicText(
          "PACE / गति",
          textAlign: TextAlign.left,
          style: NeumorphicStyle(color: Color(0xFF2C3A47)),
          textStyle:
              NeumorphicTextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.015),
        speedControl(audioHandler),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          "Binural Wave ",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        waveControl(audioHandler),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(
          "Count / गिनती",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.025),
        Consumer<PlayerProvider>(
          builder: (context, provider, child) {
            return Row(
              children: [
                provider.isInfinity?Container():Flexible(
                  child: Neumorphic(
                    margin: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width * 0.04),
                    child: TextField(
                      controller: countsController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: "Counts",
                      ),

                      onChanged: (value){
                        provider.setCounts(int.parse(countsController.text));
                      },
                    ),
                  ),
                ),
                NeumorphicButton(
                    onPressed: () {
                      provider.setIsInfinity(!provider.isInfinity);
                    },
                    child: Row(
                      children: [
                        provider.isInfinity?
                          Icon(FontAwesomeIcons.infinity):SizedBox(),
                        SizedBox(width: 15),
                        Text(
                          provider.isInfinity?"अगणनीय":"गणनीय",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    )),
              ],
            );
          },
        ),
      ],
    ),
  );
}

/*
 * Minor Sub-Components
 */

// Progress Control

// Speed Control
speedControl(AudioHandler audioHandler) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      createRadioBtn(1.0, audioHandler),
      createRadioBtn(1.2, audioHandler),
      createRadioBtn(1.4, audioHandler),
      createRadioBtn(1.5, audioHandler),
      createRadioBtn(1.7, audioHandler)
    ],
  );
}

// NeuralWave Control

waveControl(AudioHandler audioHandler) {
  return Consumer<PlayerProvider>(
    builder: (context, provider, child) {
      return NeumorphicToggle(
        height: 50,
        selectedIndex: provider.waveId,
        displayForegroundOnlyIfSelected: true,
        children: [
          ToggleElement(
            // Alpha 10.5hz
            background: Center(
                child: Icon(FontAwesomeIcons.ban, color: Colors.black)
            ),
            foreground: Center(
                child: Icon(FontAwesomeIcons.ban, color: Colors.black26,)
            ),
          ),
          ToggleElement(
            // Alpha 10.5hz
            background: Center(
                child: Text(
              "ALPHA",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            foreground: Center(
                child: Text(
              "ALPHA",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
          ),
          ToggleElement(
            // Theta 8hz to 4hz
            background: Center(
                child: Text(
              "THETA",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            foreground: Center(
                child: Text(
              "THETA",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
          ),
          ToggleElement(
            // Gamma is 40hz 6hz
            background: Center(
                child: Text(
              "Gamma",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            foreground: Center(
                child: Text(
              "Gamma",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
          ),
          ToggleElement(
            background: Center(
                child: Text(
              "Nature",
              style: TextStyle(fontWeight: FontWeight.w500),
            )),
            foreground: Center(
                child: Text(
              "Nature",
              style: TextStyle(fontWeight: FontWeight.w700),
            )),
          )
        ],
        thumb: Neumorphic(
          style: NeumorphicStyle(
            color: Color(0xF2FFFFFF),
            shadowDarkColor: Color(0xFFFFFFFF),
            shadowDarkColorEmboss: Color(0xFFFFFFFF),
            shadowLightColor: Color(0xFF2610F1),
            shadowLightColorEmboss: Color(0xFFFFFFFF),
            intensity: 0.70,
            surfaceIntensity: 0,
            disableDepth: true,
            shape: NeumorphicShape.convex,
            boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.all(Radius.circular(5))),
          ),
        ),
        onChanged: (value) {
          provider.setWaveId(value);
          audioHandler.customAction(value.toString());
        },
      );
    },
  );
}

// Count control

// Neumorphic Radio Buttons
Consumer<PlayerProvider> createRadioBtn(
    double value, AudioHandler audioHandler) {
  return Consumer<PlayerProvider>(
    builder: (context, provider, child) {
      bool _selected = provider.speed == value;
      return NeumorphicRadio(
        style: NeumorphicRadioStyle(
            selectedColor: Color(0xF2FFFFFF),
            unselectedColor: Color(0xFFecf0f1),
            selectedDepth: -5,
            // disableDepth: true,
            unselectedDepth: 5,
            intensity: 0.55,
            lightSource: LightSource.bottomRight,
            border: _selected
                ? NeumorphicBorder(color: Color(0xff2c3a47), width: 1.5)
                : NeumorphicBorder.none(),
            boxShape: NeumorphicBoxShape.circle(),
            shape: NeumorphicShape.concave),
        child: Text(
          value.toString(),
          style: TextStyle(
              fontSize: _selected ? 25 : 22,
              color: Colors.black,
              fontWeight: _selected ? FontWeight.w400 : FontWeight.normal),
        ),
        value: value,
        groupValue: provider.speed,
        onChanged: (value) {
          provider.setSpeed(value as double);
          audioHandler.setSpeed(value);
        },
        padding: EdgeInsets.all(15),
      );
    },
  );
}
