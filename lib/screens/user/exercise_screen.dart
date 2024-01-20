import 'package:flutter/material.dart';
import 'package:mindcare_app/models/ExerciseModel.dart';
import 'package:mindcare_app/services/ExerciseService.dart';
import 'package:mindcare_app/themes/themeColors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:just_audio/just_audio.dart';

class ExerciseDescription extends StatelessWidget {
  final String exerciseId;

  const ExerciseDescription({Key? key, required this.exerciseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              return Center(child: Text('No exercises with Id: $exerciseId'));
            } else {
              final exercise = snapshot.data!.data![0];
              return ListView(
                children: [
                  _buildExerciseDetails(exercise),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<ExerciseResponse> _fetchExercise() async {
    try {
      final exerciseData = await ExerciseService().getExerciseById(exerciseId);
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

  Widget _buildExerciseDetails(ExerciseData exercise) {
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
        if (exercise.video != null && exercise.audio == null)
          _buildVideoPlayer(exercise.video!),
        if (exercise.audio != null && exercise.video == null)
          _buildAudioPlayer(exercise.audio!),
        if (exercise.video != null && exercise.audio != null)
          _buildVideoPlayer(exercise.video!),
        if (exercise.video == null && exercise.audio == null)
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
                    'Exercise explanation', style: TextStyle(
                    fontSize: 16,
                  ),),
                  const SizedBox(),
                Text(
                  exercise.explanation ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildVideoPlayer(String videoUrl) {
    final videoCode = _extractVideoId(videoUrl);
    return YoutubePlayer(
      controller: YoutubePlayerController(
        initialVideoId: videoCode,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      ),
      liveUIColor: Colors.amber,
    );
  }

  String _extractVideoId(String videoUrl) {
    // Extraer el ID del video de la URL completa de YouTube
    final Uri uri = Uri.parse(videoUrl);
    final String videoId = uri.queryParameters['v'] ?? '';

    return videoId;
  }

  Widget _buildAudioPlayer(String audioUrl) {
    return AudioPlayerWidget(audioUrl: audioUrl);
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
    player.dispose();
    super.dispose();
  }
}
