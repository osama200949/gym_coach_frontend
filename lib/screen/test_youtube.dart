// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'YouTube Thumbnail',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   final String videoUrl = 'YOUR_VIDEO_URL';
//   final String videoId;

//   MyHomePage()
//       : videoId = Uri.parse(videoUrl).pathSegments.last,
//         super();

//   final YoutubePlayerController _controller = YoutubePlayerController(
//     initialVideoId: videoId,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('YouTube Thumbnail'),
//       ),
//       body: Container(
//         width: double.infinity,
//         height: 200,
//         margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//         child: YoutubePlayer(
//           controller: _controller,
//           showVideoProgressIndicator: true,
//           progressIndicatorColor: Colors.amber,
//           progressColors: ProgressBarColors(
//             playedColor: Colors.amber,
//             handleColor: Colors.amberAccent,
//           ),
//           thumbnailUrl: 'https://i.ytimg.com/vi/$videoId/hqdefault.jpg',
//           onReady: () {},
//         ),
//       ),
//     );
//   }
// }
