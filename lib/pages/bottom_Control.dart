import 'dart:math';
import 'package:fluttery/gestures.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:flutter/material.dart';
import './Themes.dart';
import '../classes/songs.dart';

class BottomControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Material(
        color: accentColor,
        shadowColor: Colors.black,
        child: Padding(
          padding: EdgeInsets.only(top: 40, bottom: 50),
          child: Column(
            children: <Widget>[
              //here arts name 
              AudioPlaylistComponent(
                playlistBuilder:
                    (BuildContext context, Playlist playlist, Widget child) {
                  final songTitle =
                      demoPlaylist.songs[playlist.activeIndex].songTitle;
                  final artistName =
                      demoPlaylist.songs[playlist.activeIndex].artist;
                  return RichText(
                    text: TextSpan(text: '', children: [
                      TextSpan(
                        text: '${songTitle}\n',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4.0,
                          height: 1.5,
                        ),
                      ),
                      TextSpan(
                        text: '${artistName}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12.0,
                          letterSpacing: 3.0,
                          height: 1.5,
                        ),
                      ),
                    ]),
                    textAlign: TextAlign.center,
                  );
                },
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  //previous buttom
                  PreviousButtom(),
                  Expanded(
                    child: Container(),
                  ),
                  //play puse buttom
                  PlayPauseButtom(),
                  Expanded(
                    child: Container(),
                  ),
                  //for next buttom
                  NextButtom(),
                  Expanded(
                    child: Container(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PreviousButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(
            Icons.skip_previous,
            color: Colors.white,
          ),
          onPressed: () {
            playlist.previous();
          },
          iconSize: 45,
        );
      },
    );
  }
}

class PlayPauseButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioComponent(
      updateMe: [WatchableAudioProperties.audioPlayerState],
      playerBuilder: (BuildContext context, AudioPlayer player, Widget child) {
        IconData icon = Icons.music_note;
        Color buttomColor = lightAccentColor;
        Function onPressed;
        if (player.state == AudioPlayerState.playing) {
          icon = Icons.pause;
          onPressed = player.pause;
          buttomColor = Colors.white;
        } else if (player.state == AudioPlayerState.paused ||
            player.state == AudioPlayerState.completed) {
          icon = Icons.play_arrow;
          onPressed = player.play;
          buttomColor = Colors.white;
        }
        return RawMaterialButton(
          shape: CircleBorder(),
          fillColor: buttomColor,
          splashColor: lightAccentColor,
          highlightColor: lightAccentColor.withOpacity(0.5),
          elevation: 10,
          highlightElevation: 5,
          onPressed: onPressed,
          child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                icon,
                color: darkAccentColor,
              )),
        );
      },
    );
  }
}

class NextButtom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AudioPlaylistComponent(
      playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
        return IconButton(
          splashColor: lightAccentColor,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.skip_next, color: Colors.white),
          onPressed: () {
            playlist.next();
          },
          iconSize: 45,
        );
      },
    );
  }
}

// for cycle image mmomkn nstbdlha b circlar avatar
class CircleClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: min(size.width, size.height) / 2,
    );
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return true;
  }
}
