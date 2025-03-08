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

  // Define the primary color
  final Color primaryColor = Color(0xFF2563EB);

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
      appBar: AppBar(
        title: Text(
          'Daftar Surah',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
            color: Colors.white, // Warna teks putih
          ),
        ),
        elevation: 0,
        backgroundColor: primaryColor, // Warna AppBar biru
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              primaryColor.withOpacity(0.05), // Gradien biru
              Colors.white,
            ],
          ),
        ),
        child:
            isLoading
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Memuat Surah...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primaryColor, // Warna teks biru
                        ),
                      ),
                    ],
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  itemCount: surahs.length,
                  itemBuilder: (context, index) {
                    final surah = surahs[index];

                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => SurahDetailScreen(
                                      surah: Map<String, dynamic>.from(surah),
                                      allSurahs:
                                          surahs.cast<Map<String, dynamic>>(),
                                    ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryColor.withOpacity(
                                      0.1,
                                    ), // Warna biru
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${surah['nomor']}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: primaryColor, // Warna biru
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${surah['nama_latin'] ?? 'Surah Tanpa Nama'}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                        maxLines: 1, // Batasi teks ke 1 baris
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // Tambahkan ellipsis jika teks melebihi batas
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.book_outlined,
                                            size: 14,
                                            color: Colors.grey[600],
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            '${surah['jumlah_ayat'] ?? '0'} Ayat',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (surah['arti'] != null)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(
                                        0.1,
                                      ), // Warna biru
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          100, // Atur lebar maksimum sesuai kebutuhan
                                    ),
                                    child: Text(
                                      surah['arti'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: primaryColor, // Warna biru
                                      ),
                                      maxLines: 1, // Batasi teks ke 1 baris
                                      overflow:
                                          TextOverflow
                                              .ellipsis, // Tambahkan ellipsis jika teks melebihi batas
                                    ),
                                  ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  }
}
