import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:just_audio/just_audio.dart';

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> with TickerProviderStateMixin {
  final AudioPlayer _player = AudioPlayer();
  late AnimationController _animationController;
  late AnimationController _rotateAnimationController;

  // Define the playlist
  final ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [
      AudioSource.uri(
          Uri.parse('https://serverimges.bookfet.com/Config/202410211542.mov')),
      AudioSource.uri(
          Uri.parse('https://serverimges.bookfet.com/Config/202410211542.mov')),
      AudioSource.uri(
          Uri.parse('https://serverimges.bookfet.com/Config/202410211542.mov')),
    ],
  );

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _rotateAnimationController = AnimationController(
      vsync: this,
      duration: Duration.zero,
    );

    _player.durationStream.listen((duration) {
      _rotateAnimationController.duration = duration ?? Duration.zero;
    });

    _setupAudioPlayer();
  }

  Future<void> _setupAudioPlayer() async {
    _player.playbackEventStream.listen((event) {
      switch (event.processingState) {
        case ProcessingState.idle:
          break;
        case ProcessingState.loading:
          break;
        case ProcessingState.buffering:
          break;
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          break;
      }
    }, onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });

    try {
      // Load and play the playlist
      await _player.setAudioSource(_playlist,
          initialIndex: 0, initialPosition: Duration.zero);
    } catch (e) {
      print('Error loading audio source: $e');
    }
  }

  Widget _playbackControlButton() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        final playing = snapshot.data?.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            width: 44.0,
            height: 44.0,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          _animationController.reverse();
          return IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
            ),
            iconSize: 44.0,
            onPressed: _player.play,
          );
        } else if (processingState != ProcessingState.completed) {
          _animationController.forward();
          return IconButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            icon: AnimatedIcon(
              icon: AnimatedIcons.play_pause,
              progress: _animationController,
            ),
            iconSize: 44.0,
            onPressed: _player.pause,
          );
        } else {
          return IconButton(
            icon: const Icon(Icons.replay),
            iconSize: 44.0,
            onPressed: () => _player.seek(Duration.zero),
          );
        }
      },
    );
  }

  Widget _progressBar() {
    return StreamBuilder<Duration?>(
      stream: _player.positionStream,
      builder: (context, snapshot) {
        return ProgressBar(
          progress: snapshot.data ?? Duration.zero,
          total: _player.duration ?? Duration.zero,
          buffered: _player.bufferedPosition,
          onSeek: (duration) {
            _player.seek(duration);
          },
          thumbColor: Colors.black,
          barHeight: 6.0,
          baseBarColor: Colors.grey,
          progressBarColor: Colors.black,
          bufferedBarColor: Colors.grey[700],
          timeLabelTextStyle: GoogleFonts.athiti(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  Widget _rotatingImage() {
    return StreamBuilder<PlayerState>(
      stream: _player.playerStateStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading data',
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final playerState = snapshot.data;
        final playing = playerState?.playing;
        final processingState = playerState?.processingState;

        if (playing == true && processingState != ProcessingState.completed) {
          if (_rotateAnimationController.duration != Duration.zero &&
              !_rotateAnimationController.isAnimating) {
            _rotateAnimationController.repeat();
          }
        } else if (processingState == ProcessingState.completed) {
          _rotateAnimationController.stop();
          _rotateAnimationController.reset();
        } else {
          if (_rotateAnimationController.isAnimating) {
            _rotateAnimationController.stop();
          }
        }

        return RotationTransition(
          turns: Tween<double>(begin: 0, end: 1).animate(
            CurvedAnimation(
              parent: _rotateAnimationController,
              curve: Curves.linear,
            ),
          ),
          child: Container(
            width: 300,
            height: 300,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
              shape: BoxShape.circle,
              color: Colors.grey,
              image: DecorationImage(
                image: NetworkImage(
                  'https://serverimges.bookfet.com/ad_img_novel//20240925163205.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _rotateAnimationController.stop();
    _rotateAnimationController.dispose();
    _animationController.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _rotatingImage(),
              const SizedBox(height: 40),
              Text(
                'ย้อนเวลามาครั้งนี้ ฉันขอเป็นนักธุรกิจสาวดาวรุ่งแห่งยุค 80',
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                style: GoogleFonts.athiti(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                child: Text(
                  'บทที่ 2 ความรักและความเสี่ยง',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.athiti(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              _progressBar(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    iconSize: 44.0,
                    onPressed: () async {
                      final currentIndex = _player.currentIndex;
                      if (currentIndex != null && currentIndex > 0) {
                        _player.seekToPrevious();
                      } else {
                        print('ไม่มีเพลงก่อนหน้า หรือ คุณกำลังฟังเพลงแรก');
                      }
                    },
                  ),
                  _playbackControlButton(),
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    iconSize: 44.0,
                    onPressed: () {
                      final currentIndex = _player.currentIndex;
                      final sequenceLength = _player.sequence?.length ?? 0;
                      if (currentIndex != null &&
                          currentIndex < sequenceLength - 1) {
                        _player.seekToNext();
                      } else {
                        print('ไม่มีเพลงถัดไป');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Playlist',
                style: GoogleFonts.athiti(
                  fontSize: 20,
                  color: Colors.grey[900],
                  fontWeight: FontWeight.bold,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _player.sequence?.length ?? 0,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
