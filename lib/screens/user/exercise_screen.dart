import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mindcare_app/models/ExerciseModel.dart';
import 'package:mindcare_app/services/ExerciseService.dart';
import 'package:mindcare_app/services/UserService.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:just_audio/just_audio.dart';

class ExerciseDescription extends StatefulWidget {
  final String exerciseId;

  const ExerciseDescription({Key? key, required this.exerciseId})
      : super(key: key);

  @override
  _ExerciseDescriptionState createState() => _ExerciseDescriptionState();
}

class _ExerciseDescriptionState extends State<ExerciseDescription> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mindfulness'),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: ThemeColors.getGradient(),
          ),
          child: FutureBuilder<ExerciseResponse>(
            future: _fetchExercise(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData ||
                  snapshot.data?.data?.isEmpty == true) {
                return Center(
                    child: Text('No exercises with Id: ' + widget.exerciseId));
              } else {
                final exercise = snapshot.data!.data![0];
                return ListView(
                  children: [
                    _buildExerciseDetails(exercise, context),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<ExerciseResponse> _fetchExercise() async {
    try {
      final exerciseData =
          await ExerciseService().getExerciseById(widget.exerciseId);
      if (exerciseData != null) {
        return ExerciseResponse(
          success: true,
          data: [exerciseData],
          message: 'Exercise retrieved successfully',
        );
      } else {
        throw Exception('Failed to retrieve exercise');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Widget _buildExerciseDetails(ExerciseData exercise, BuildContext context) {
    ExerciseService exerciseService = ExerciseService();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            exercise.name ?? '',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (exercise.video!.isNotEmpty)
          _buildVideoPlayer(exercise.video!)
        else if (exercise.audio!.isNotEmpty)
          _buildAudioPlayer(exercise.audio!)
        else if (exercise.image!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Image.network(exercise.image!),
          ),
        if (exercise.explanation != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Exercise explanation',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  exercise.explanation ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        Center(
            child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: exercise.made == 1 ? Colors.grey : Colors.green,
          ),
          onPressed: _isButtonDisabled || exercise.made == 1
              ? null
              : () {
                  setState(() {
                    _isButtonDisabled = true;
                  });
                  exerciseService.exerciseMade(
                      UserService.userId.toString(), exercise.id.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check, color: Colors.green),
                          SizedBox(width: 8),
                          Text('Exercise finished successfully!'),
                        ],
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
          child: const Text('Finish Exercise'),
        )),
        const SizedBox(
          height: 16,
        )
      ],
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    final videoCode = _extractVideoId(videoUrl);
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoCode,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );

    _controller.addListener(() {
      if (_controller.value.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        liveUIColor: Colors.amber,
      ),
      builder: (context, player) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                'Exercise video',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            player,
          ],
        );
      },
    );
  }

  String _extractVideoId(String videoUrl) {
    final Uri uri = Uri.parse(videoUrl);
    final String videoId = uri.queryParameters['v'] ?? '';

    return videoId;
  }

  Widget _buildAudioPlayer(String audioUrl) {
    _audioPlayer.setUrl(audioUrl);

    double lastVolume = 1.0;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Exercise audio',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _audioPlayer.seek(
                      Duration(seconds: _audioPlayer.position.inSeconds - 10));
                },
                icon: const Icon(
                  Icons.replay_10,
                  size: 24,
                ),
              ),
              StreamBuilder<bool>(
                stream: _audioPlayer.playingStream,
                builder: (context, snapshot) {
                  final isPlaying = snapshot.data ?? false;
                  return IconButton(
                    onPressed: () {
                      if (isPlaying) {
                        _audioPlayer.pause();
                      } else {
                        _audioPlayer.play();
                      }
                    },
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 32,
                    ),
                  );
                },
              ),
              IconButton(
                onPressed: () {
                  _audioPlayer.seek(
                      Duration(seconds: _audioPlayer.position.inSeconds + 10));
                },
                icon: const Icon(
                  Icons.forward_10,
                  size: 24,
                ),
              ),
            ],
          ),
          StreamBuilder<Duration>(
            stream: _audioPlayer.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _audioPlayer.duration ?? Duration.zero;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_printDuration(position)),
                      Text(_printDuration(duration)),
                    ],
                  ),
                  Slider(
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) {
                      _audioPlayer.seek(Duration(seconds: value.toInt()));
                    },
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                  ),
                ],
              );
            },
          ),
          StreamBuilder<double>(
            stream: _audioPlayer.volumeStream,
            builder: (context, snapshot) {
              final volume = snapshot.data ?? lastVolume;
              return Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (volume > 0) {
                        lastVolume = volume;
                        _audioPlayer.setVolume(0.0);
                      } else {
                        _audioPlayer.setVolume(lastVolume);
                      }
                    },
                    icon: Icon(volume > 0 ? Icons.volume_up : Icons.volume_off),
                  ),
                  Expanded(
                    child: Slider(
                      value: volume,
                      onChanged: (newVolume) {
                        lastVolume = newVolume;
                        _audioPlayer.setVolume(newVolume);
                      },
                      min: 0,
                      max: 1,
                    ),
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  String _printDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({Key? key, required this.audioUrl}) : super(key: key);

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  final AudioPlayer player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await player.setUrl(widget.audioUrl);
    await player.play();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Audio Exercise'),
        ElevatedButton(
          onPressed: () async {
            if (player.playing) {
              await player.pause();
            } else {
              await player.play();
            }
          },
          child: Text(player.playing ? 'Pause' : 'Play'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    player.stop();
    player.dispose();
    super.dispose();
  }
}
