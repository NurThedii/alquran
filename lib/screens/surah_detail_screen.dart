import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/quran_service.dart';

class SurahDetailScreen extends StatefulWidget {
  final Map<String, dynamic> surah;
  final List<Map<String, dynamic>> allSurahs;

  SurahDetailScreen({required this.surah, required this.allSurahs});

  @override
  _SurahDetailScreenState createState() => _SurahDetailScreenState();
}

class _SurahDetailScreenState extends State<SurahDetailScreen> {
  List<dynamic> ayatList = [];
  bool isLoading = true;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ValueNotifier<Duration> _position = ValueNotifier(Duration.zero);
  final ValueNotifier<Duration> _duration = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> _isPlaying = ValueNotifier(false);
  int currentSurahIndex = 0;

  @override
  void initState() {
    super.initState();
    currentSurahIndex = widget.allSurahs.indexWhere(
      (s) => s['nomor'] == widget.surah['nomor'],
    );
    fetchAyat();

    _audioPlayer.onDurationChanged.listen((d) {
      _duration.value = d;
    });

    _audioPlayer.onPositionChanged.listen((p) {
      _position.value = p;
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      _isPlaying.value = state == PlayerState.playing;
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      _isPlaying.value = false;
      _position.value = Duration.zero;
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> fetchAyat() async {
    String surahNomor = widget.surah['nomor'].toString();
    final fetchedAyat = await QuranService.getAyatBySurah(surahNomor);
    setState(() {
      ayatList = fetchedAyat;
      isLoading = false;
    });
  }

  void togglePlayPause() async {
    if (_isPlaying.value) {
      await _audioPlayer.pause();
    } else {
      if (_position.value >= _duration.value ||
          _position.value == Duration.zero) {
        await _audioPlayer.play(UrlSource(ayatList.first['audio']));
      } else {
        await _audioPlayer.resume();
      }
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  void showAudioModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Text(
                'Sedang Memutar: ${widget.surah['nama_latin']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ValueListenableBuilder<Duration>(
                valueListenable: _position,
                builder: (context, position, child) {
                  return ValueListenableBuilder<Duration>(
                    valueListenable: _duration,
                    builder: (context, duration, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(formatDuration(position)),
                          Expanded(
                            child: Slider(
                              value: position.inSeconds.toDouble(),
                              max: duration.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final newPosition = Duration(
                                  seconds: value.toInt(),
                                );
                                await _audioPlayer.seek(newPosition);
                                _position.value = newPosition;
                              },
                            ),
                          ),
                          Text(formatDuration(duration)),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10),
              ValueListenableBuilder<bool>(
                valueListenable: _isPlaying,
                builder: (context, isPlaying, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, size: 30),
                        onPressed: previousSurah,
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40,
                        ),
                        onPressed: togglePlayPause,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, size: 30),
                        onPressed: nextSurah,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    ).whenComplete(() => _audioPlayer.stop());
  }

  void nextSurah() async {
    if (currentSurahIndex < widget.allSurahs.length - 1) {
      _audioPlayer.stop();
      setState(() => currentSurahIndex++);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => SurahDetailScreen(
                surah: widget.allSurahs[currentSurahIndex],
                allSurahs: widget.allSurahs,
              ),
        ),
      );
    }
  }

  void previousSurah() async {
    if (currentSurahIndex > 0) {
      _audioPlayer.stop();
      setState(() => currentSurahIndex--);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder:
              (context) => SurahDetailScreen(
                surah: widget.allSurahs[currentSurahIndex],
                allSurahs: widget.allSurahs,
              ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surah['nama_latin'] ?? 'Surah Tanpa Nama'),
        backgroundColor: Colors.green[700],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.play_circle_fill),
            onPressed: showAudioModal,
            tooltip: "Putar Surah",
          ),
        ],
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  itemCount: ayatList.length,
                  itemBuilder: (context, index) {
                    final ayat = ayatList[index];

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ayat ${ayat['nomor'].toString()}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                ayat['ar'] ?? '',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              ayat['idn'] ?? '',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
