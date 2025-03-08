import 'package:flutter/material.dart';
import '../services/quran_service.dart';
import '../services/doa_service.dart';
import 'surah_detail_screen.dart';
import 'doa_detail_screen.dart'; // Pastikan ini di-import

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> surahs = [];
  List<dynamic> doas = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedSurahs = await QuranService.getRandomSurahs(5);
      final fetchedDoas = await DoaService.getDoas();

      print("Data Doa: $fetchedDoas");
      print("Data Surah: $fetchedSurahs");

      setState(() {
        surahs = fetchedSurahs?.isNotEmpty == true ? fetchedSurahs : [];
        doas = fetchedDoas?.isNotEmpty == true ? fetchedDoas : [];
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Al-Qur'an & Doa")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // Slider untuk doa
                  Container(
                    height: 150,
                    child:
                        doas.isEmpty
                            ? Center(child: Text("Belum ada data doa"))
                            : PageView.builder(
                              itemCount: doas.length,
                              itemBuilder: (context, index) {
                                final doa = doas[index];

                                String title =
                                    doa['title']?.toString().trim() ?? '';
                                if (title.isEmpty) {
                                  title =
                                      doa['judul']?.toString().trim() ??
                                      'Judul Tidak Diketahui';
                                }

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                DoaDetailScreen(doa: doa),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: EdgeInsets.all(10),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Text(
                                          title,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                  // List surah
                  Expanded(
                    child:
                        surahs.isEmpty
                            ? Center(child: Text("Belum ada data surah"))
                            : ListView.builder(
                              itemCount: surahs.length,
                              itemBuilder: (context, index) {
                                final surah = surahs[index];

                                String namaSurah =
                                    surah['nama_latin']?.toString().trim() ??
                                    '';
                                if (namaSurah.isEmpty) {
                                  namaSurah =
                                      surah['name']?.toString().trim() ??
                                      'Nama Tidak Diketahui';
                                }

                                return Card(
                                  margin: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      namaSurah,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Jumlah Ayat: ${surah['jumlah_ayat'] ?? 'Tidak Diketahui'}',
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => SurahDetailScreen(
                                                surah: Map<
                                                  String,
                                                  dynamic
                                                >.from(
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
                  ),
                ],
              ),
    );
  }
}
