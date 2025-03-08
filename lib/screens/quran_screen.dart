import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import 'surah_detail_screen.dart';

class QuranScreen extends StatefulWidget {
  @override
  _QuranScreenState createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  List<dynamic> surahs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSurahs();
  }

  Future<void> fetchSurahs() async {
    final fetchedSurahs = await QuranService.getAllSurahs();
    setState(() {
      surahs = fetchedSurahs;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Surah')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: surahs.length,
                itemBuilder: (context, index) {
                  final surah = surahs[index];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      title: Text(
                        '${surah['nomor']}. ${surah['nama_latin'] ?? 'Surah Tanpa Nama'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'Jumlah Ayat: ${surah['jumlah_ayat'] ?? '0'}',
                      ),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => SurahDetailScreen(
                                  surah: Map<String, dynamic>.from(
                                    surah,
                                  ), // Pastikan surah memiliki tipe Map<String, dynamic>
                                  allSurahs:
                                      surahs
                                          .cast<
                                            Map<String, dynamic>
                                          >(), // Ubah list menjadi List<Map<String, dynamic>>
                                ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
    );
  }
}
