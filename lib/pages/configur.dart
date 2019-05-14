import 'dart:math';
import 'package:fluttery/gestures.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_music/main.dart';
import './bottom_Control.dart';
import './Themes.dart';
import '../classes/songs.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MusicPage extends StatefulWidget {
  @override
  _MusicPageState createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> {
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<FirebaseUser> _signout() async {
    await googleSignIn.signOut().then((user) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
    await _auth.signOut().then((user) {
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    //why here the root in audio not scaffold??
    //3lshan lma a3m navigate mn saf7a l saf7a el song mto2fsh yb2 lazm el hierarcy ll class yb2a audio

    // return Audio(
    // to single song
    //   audioUrl: demoPlaylist.songs[0].audioUrl,
    return AudioPlaylist(
      //to playlist song
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      // playbackState: PlaybackState.paused,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => Hossam()));
            },
          ),
          title: Text(''),
          actions: <Widget>[
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                // to update widget direct
                setState(() {
                  _signout();
                });
              },
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(),
        ),
        body: Column(
          children: <Widget>[
            //seek bar=====================
            Expanded(
              //3lshan el image lkol song
              child: AudioPlaylistComponent(
                playlistBuilder:
                    (BuildContext context, Playlist playlist, Widget child) {
                  String imageUrl =
                      demoPlaylist.songs[playlist.activeIndex].imageUrl;
                  return AudioRadioSeekBar(
                    imageUrl: imageUrl,
                  );
                },
              ),
            ),
            //visualization
            // Container(
            //   // width: double.infinity,
            //   height: 125,
            // ),
            //song title name artest
            BottomControl(),
          ],
        ),
      ),
    );
  }
}

class AudioRadioSeekBar extends StatefulWidget {
  final String imageUrl;
  AudioRadioSeekBar({this.imageUrl});
  @override
  _AudioRadioSeekBarState createState() => _AudioRadioSeekBarState();
}

class _AudioRadioSeekBarState extends State<AudioRadioSeekBar> {
  double _seekPercent;
  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [
        WatchableAudioProperties.audioPlayhead,
        WatchableAudioProperties.audioSeeking,
      ],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        double playbackprograss = 0;
        if (player.audioLength != null && player.position != null) {
          playbackprograss = player.position.inMilliseconds /
              player.audioLength.inMilliseconds;
        }
        _seekPercent = player.isSeeking ? _seekPercent : null;
        return RadialSeekBar(
          progress: playbackprograss,
          seekPercent: _seekPercent,
          onSeekRequested: (double seekPercent) {
            setState(() {
              _seekPercent = seekPercent;
            });
            final seekMillis =
                (player.audioLength.inMilliseconds * seekPercent).round();
            player.seek(Duration(milliseconds: seekMillis));
          },
          child: Container(
            color: accentColor,
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}

class RadialSeekBar extends StatefulWidget {
  final double seekPercent;
  final double progress;
  final Function(double) onSeekRequested;
  final Widget child;
  RadialSeekBar(
      {this.seekPercent = 0,
      this.progress = 0,
      this.onSeekRequested,
      this.child});
  @override
  _RadialSeekBarState createState() => _RadialSeekBarState();
}

class _RadialSeekBarState extends State<RadialSeekBar> {
  double _progress = 0.0;
  PolarCoord _startDragCoord;
  double _startDragPercent;
  double _currentDragPercent;

  @override
  void initState() {
    super.initState();
    _progress = widget.progress;
  }

  @override
  void didUpdateWidget(RadialSeekBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _progress = widget.progress;
  }

  // 3lshan n3ml drag ll seek
  void _onDragStart(PolarCoord coord) {
    _startDragCoord = coord;
    _startDragPercent = _progress;
  }

  void _onDragUpdate(PolarCoord coord) {
    final dragAngle = coord.angle - _startDragCoord.angle;
    // final dragPercent = dragAngle / (2 * pi);
    setState(() {
      _currentDragPercent = (_startDragPercent + dragAngle) % 1;
    });
  }

  void _onDragEnd() {
    //m3nha lw el user 3ml drag l 6o % msln mn el cycle yb2a el song twsl l 60 %
    if (widget.onSeekRequested != null) {
      widget.onSeekRequested(_currentDragPercent);
    }
    setState(() {
      // _progress = _currentDragPercent;
      _currentDragPercent = null;
      _startDragCoord = null;
      _startDragPercent = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    /* this block for postion of drag cycle when user drag the cycle mn 8er dool 
  lw el user 3ml drag ll cycle hy3ml el song htt8er lkn el postion hyrg3 ll mkan el 3mlna mno drag*/
    double thumpostion = _progress;
    if (_currentDragPercent != null) {
      thumpostion = _currentDragPercent;
    } else if (widget.seekPercent != null) {
      thumpostion = widget.seekPercent;
    }
    return RadialDragGestureDetector(
      onRadialDragStart: _onDragStart,
      onRadialDragUpdate: _onDragUpdate,
      onRadialDragEnd: _onDragEnd,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Center(
          child: Container(
            width: 500,
            height: 500,
            // here you can use circl avatar
            child: RadialPrograssSeekbar(
              trackColor: Colors.grey,
              //passing el mo3dlat el t7t
              progressPercent: _progress,
              progressColor: accentColor,
              // el function fo2
              thumbPosition: thumpostion,
              //3lshan yb2a fe msafa ma ben el sora w el seek
              innerPadding: EdgeInsets.all(10),
              outerPadding: EdgeInsets.all(10),
              child: ClipOval(
                clipper: CircleClipper(),
                child: widget.child,
              ),
              // CircleAvatar(
              //   child: widget.child,
              //     // backgroundImage:
              //     //     NetworkImage(demoPlaylist.songs[0].imageUrl)
              //         ),
            ),
          ),
        ),
      ),
    );
  }
}

class RadialPrograssSeekbar extends StatefulWidget {
  final double trackWidth;
  final Color trackColor;
  final double progressWidth;
  final Color progressColor;
  final double progressPercent;
  final double thumbSize;
  final Color thumbColor;
  final double thumbPosition;
  //3lshan yb2a fe msafa ma ben el sora w el seek
  final EdgeInsets outerPadding;
  final EdgeInsets innerPadding;
  final Widget child;

  RadialPrograssSeekbar(
      {this.trackWidth = 3.0,
      this.trackColor = Colors.grey,
      this.progressWidth = 5.0,
      this.progressColor = Colors.black,
      this.progressPercent = 0.0,
      this.thumbSize = 10.0,
      this.thumbColor = Colors.black,
      this.thumbPosition,
      this.outerPadding = const EdgeInsets.all(0.0),
      this.innerPadding = const EdgeInsets.all(0.0),
      this.child});
  @override
  _RadialPrograssSeekbarState createState() => _RadialPrograssSeekbarState();
}

class _RadialPrograssSeekbarState extends State<RadialPrograssSeekbar> {
  //the widget tree of seekbar
  EdgeInsets _insetsForPainter() {
    final outerThickness = max(
          widget.trackWidth,
          max(widget.progressWidth, widget.thumbSize),
        ) /
        2;
    return EdgeInsets.all(outerThickness);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      //3lshan yb2a fe msafa ma ben el sora w el seek
      padding: widget.outerPadding,
      child: CustomPaint(
        foregroundPainter: RadialSeekBarPainter(
          //pass this paint here
          trackWidth: widget.trackWidth,
          trackColor: widget.trackColor,
          progressWidth: widget.progressWidth,
          progressColor: widget.progressColor,
          progressPercent: widget.progressPercent,
          thumbSize: widget.thumbSize,
          thumbColor: widget.thumbColor,
          thumbPosition: widget.thumbPosition,
        ),
        //3lshan yb2a fe msafa ma ben el sora w el seek
        child: Padding(
          padding: _insetsForPainter() + widget.innerPadding,
          child: widget.child,
        ),
      ),
    );
  }
}

class RadialSeekBarPainter extends CustomPainter {
  final double trackWidth;
  final Paint trackPaint;
  final double progressWidth;
  final Paint progressPaint;
  final double progressPercent;
  final double thumbSize;
  final Paint thumbPaint;
  final double thumbPosition;

  RadialSeekBarPainter({
    @required this.trackWidth,
    @required trackColor,
    @required this.progressWidth,
    @required progressColor,
    @required this.progressPercent,
    @required this.thumbSize,
    @required thumbColor,
    @required this.thumbPosition,
  })  
  // here intialse the paint object
  // why .. 3lshan n3ml paint ll color,style, and return paint object
  : trackPaint = Paint()
          ..color = trackColor
          // here becouse not full the cycle
          ..style = PaintingStyle.stroke
          ..strokeWidth = trackWidth,
        // for border and not full cycle
        progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = progressWidth
          ..strokeCap = StrokeCap.round,
        thumbPaint = Paint()
          ..color = thumbColor
          ..style = PaintingStyle.fill;

  // kol el code da mmok mytktbsh lw 3ndna plugin
  @override
  void paint(Canvas canvas, Size size) {
    final outerThickness = max(trackWidth, max(progressWidth, thumbSize));
    Size constrainedSize = Size(
      size.width - outerThickness,
      size.height - outerThickness,
    );

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(constrainedSize.width, constrainedSize.height) / 2;
    // 3lshan n paint track
    canvas.drawCircle(center, radius, trackPaint);
    //hna mo3dla 3lshan bdayet el 5at bta3 el song ykon mneen
    final progressAngle = 2 * pi * progressPercent;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        progressAngle, false, progressPaint);
    //to paint thumb
    final thumbAngle = 2 * pi * thumbPosition - (pi / 2);
    final thumbX = cos(thumbAngle) * radius;
    final thumbY = sin(thumbAngle) * radius;
    final thumbCenter = Offset(thumbX, thumbY) + center;
    final thumbRadius = thumbSize / 2.0;
    canvas.drawCircle(thumbCenter, thumbRadius, thumbPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
