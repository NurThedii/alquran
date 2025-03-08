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
  late int currentSurahIndex;

  // Define the primary color
  final Color primaryColor = Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    currentSurahIndex = widget.allSurahs.indexWhere(
      (s) => s['nomor'] == widget.surah['nomor'],
    );
    fetchAyat();

    _audioPlayer.onDurationChanged.listen((d) => _duration.value = d);
    _audioPlayer.onPositionChanged.listen((p) => _position.value = p);
    _audioPlayer.onPlayerStateChanged.listen(
      (state) => _isPlaying.value = state == PlayerState.playing,
    );
    _audioPlayer.onPlayerComplete.listen((_) {
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
    final fetchedAyat = await QuranService.getAyatBySurah(
      widget.surah['nomor'].toString(),
    );
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

  void showAudioModal() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 5,
                width: 40,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Text(
                widget.surah['nama_latin'],
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Sedang Memutar',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<Duration>(
                valueListenable: _position,
                builder: (context, position, child) {
                  return ValueListenableBuilder<Duration>(
                    valueListenable: _duration,
                    builder: (context, duration, child) {
                      return Column(
                        children: [
                          SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: RoundSliderThumbShape(
                                enabledThumbRadius: 6,
                              ),
                              overlayShape: RoundSliderOverlayShape(
                                overlayRadius: 14,
                              ),
                              activeTrackColor: primaryColor,
                              inactiveTrackColor: Colors.grey[200],
                              thumbColor: primaryColor,
                              overlayColor: primaryColor.withOpacity(0.2),
                            ),
                            child: Slider(
                              value: position.inSeconds.toDouble(),
                              max:
                                  duration.inSeconds > 0
                                      ? duration.inSeconds.toDouble()
                                      : 1.0,
                              onChanged: (value) async {
                                await _audioPlayer.seek(
                                  Duration(seconds: value.toInt()),
                                );
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formatDuration(position),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  formatDuration(duration),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              ValueListenableBuilder<bool>(
                valueListenable: _isPlaying,
                builder: (context, isPlaying, child) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: currentSurahIndex > 0 ? previousSurah : null,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  currentSurahIndex > 0
                                      ? Colors.grey[100]
                                      : Colors.grey[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.skip_previous_rounded,
                              size: 28,
                              color:
                                  currentSurahIndex > 0
                                      ? primaryColor
                                      : Colors.grey[400],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: togglePlayPause,
                          child: Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 32,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap:
                              currentSurahIndex < widget.allSurahs.length - 1
                                  ? nextSurah
                                  : null,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  currentSurahIndex <
                                          widget.allSurahs.length - 1
                                      ? Colors.grey[100]
                                      : Colors.grey[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.skip_next_rounded,
                              size: 28,
                              color:
                                  currentSurahIndex <
                                          widget.allSurahs.length - 1
                                      ? primaryColor
                                      : Colors.grey[400],
                            ),
                          ),
                        ),
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

  void nextSurah() {
    if (currentSurahIndex < widget.allSurahs.length - 1) {
      _navigateToSurah(++currentSurahIndex);
    }
  }

  void previousSurah() {
    if (currentSurahIndex > 0) {
      _navigateToSurah(--currentSurahIndex);
    }
  }

  void _navigateToSurah(int index) {
    _audioPlayer.stop();
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder:
            (context) => SurahDetailScreen(
              surah: widget.allSurahs[index],
              allSurahs: widget.allSurahs,
            ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    return "${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.surah['nama_latin'] ?? 'Surah Tanpa Nama',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (widget.surah['arti'] != null)
              Text(
                widget.surah['arti'],
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(Icons.play_circle_outline_rounded, size: 28),
              onPressed: showAudioModal,
              tooltip: "Putar Surah",
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background design element
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          isLoading
              ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              )
              : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: ayatList.length,
                  itemBuilder: (context, index) {
                    final ayat = ayatList[index];
                    final ayatNumber = ayat['nomor'].toString();

                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.05),
                            blurRadius: 10,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Ayat number container
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      ayatNumber,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Arabic text
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                            child: Align(
                              alignment:
                                  Alignment
                                      .centerRight, // Memastikan teks rata kanan
                              child: Text(
                                ayat['ar'] ?? '',
                                style: TextStyle(
                                  fontSize: 28,
                                  height: 1.5,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.right, // Rata kanan
                                textDirection:
                                    TextDirection
                                        .rtl, // Arah teks dari kanan ke kiri
                              ),
                            ),
                          ),
                          Divider(
                            color: Colors.grey[200],
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          // Translation
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              ayat['idn'] ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
      floatingActionButton:
          !isLoading
              ? FloatingActionButton(
                onPressed: showAudioModal,
                backgroundColor: primaryColor,
                child: Icon(Icons.play_arrow_rounded),
                tooltip: "Putar Audio",
                elevation: 4,
              )
              : null,
    );
  }
}
