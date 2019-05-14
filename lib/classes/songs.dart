import 'package:flutter/material.dart';
class DemoPlaylist {
  final List<DemoSong> songs;

  DemoPlaylist({
    @required this.songs,
  });
}
//class
class DemoSong {
  final String audioUrl;
  final String imageUrl;
  final String songTitle;
  final String artist;
//constractor od class
  DemoSong({
    @required this.audioUrl,
    @required this.imageUrl,
    @required this.songTitle,
    @required this.artist,
  });
}

final demoPlaylist =  DemoPlaylist(
  songs: [
     DemoSong(
      audioUrl:
          'https://www.musiqar.com/uploads/tracks/2027674003_867526035_1819224198.mp3',
      imageUrl:
          'http://www.albawaba.com/sites/default/files/im/amrdiab_Oct10.jpg',
      songTitle: 'ya 7abibi w nta ganmy',
      artist: 'Amr Diab',
    ),
     DemoSong(
      audioUrl:
          'https://api.soundcloud.com/tracks/402538329/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      imageUrl:
          'https://i1.sndcdn.com/avatars-000344712337-f6po4d-t120x120.jpg',
      songTitle: 'Simply',
      artist: 'Kumbor',
    ),
     DemoSong(
      audioUrl:
          'https://api.soundcloud.com/tracks/266891990/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      imageUrl:
          'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
      songTitle: 'Electro Monotony',
      artist: 'Nights & Weekends',
    ),
     DemoSong(
      audioUrl:
          'https://api.soundcloud.com/tracks/260578593/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      imageUrl:
          'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
      songTitle: 'Debut Trance',
      artist: 'Nights & Weekends',
    ),
     DemoSong(
      audioUrl:
          'https://api.soundcloud.com/tracks/258735531/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      imageUrl:
          'https://i1.sndcdn.com/artworks-000165346750-e36z3a-t500x500.jpg',
      songTitle: 'Debut',
      artist: 'Nights & Weekends',
    ),
     DemoSong(
      audioUrl:
          'https://api.soundcloud.com/tracks/9540352/stream?secret_token=s-tj3IS&client_id=LBCcHmRB8XSStWL6wKH2HPACspQlXg2P',
      imageUrl:
          'https://i1.sndcdn.com/avatars-000215855222-tic5d8-t120x120.jpg',
      songTitle: 'Assn1-tribal-beat',
      artist: 'Matt',
    ),
  ],
);
