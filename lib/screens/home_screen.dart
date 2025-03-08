import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/quran_service.dart';
import '../services/doa_service.dart';
import 'surah_detail_screen.dart';
import 'doa_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> surahs = [];
  List<dynamic> doas = [];
  bool isLoading = true;
  String _currentDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedSurahs = await QuranService.getRandomSurahs(5);
      final fetchedDoas = await DoaService.getRandomDoas(
        3,
      ); // Mengambil 3 doa untuk tampilan carousel

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
      backgroundColor: Color(0xFFF8F9FD),
      body:
          isLoading
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFF1E3A8A),
                      strokeWidth: 3,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Memuat konten...",
                      style: GoogleFonts.poppins(
                        color: Color(0xFF1E3A8A),
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
              : SafeArea(
                child: CustomScrollView(
                  physics: BouncingScrollPhysics(),
                  slivers: [
                    // Header
                    SliverToBoxAdapter(child: buildHeader()),

                    // Daily Prayer Card Carousel
                    SliverToBoxAdapter(child: buildDoaSection()),

                    // Surah Section
                    SliverToBoxAdapter(child: buildSurahSection()),
                  ],
                ),
              ),
    );
  }
  
  Widget buildHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "As-salamu alaykum",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    _currentDate,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  "Cari surah atau doa...",
                  style: GoogleFonts.poppins(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDoaSection() {
    if (doas.isEmpty) return SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Doa Harian",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: doas.length > 0 ? doas.length : 1,
            itemBuilder: (context, index) {
              // Fallback if no doas are available
              if (doas.isEmpty) {
                return buildDoaCard(null, index);
              }
              return buildDoaCard(doas[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget buildDoaCard(dynamic doa, int index) {
    List<List<Color>> gradients = [
      [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      [Color(0xFF047857), Color(0xFF10B981)],
      [Color(0xFF7C3AED), Color(0xFF8B5CF6)],
    ];

    List<IconData> icons = [
      Icons.favorite_rounded,
      Icons.home_rounded,
      Icons.psychology_rounded,
    ];

    return GestureDetector(
      onTap: () {
        if (doa != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DoaDetailScreen(doa: doa)),
          );
        }
      },
      child: Container(
        width: 280,
        margin: EdgeInsets.only(right: 16, bottom: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradients[index % gradients.length],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradients[index % gradients.length][0].withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              bottom: -30,
              child: Opacity(
                opacity: 0.15,
                child: Icon(
                  Icons.mosque_rounded,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        icons[index % icons.length],
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Teks judul doa
                  Flexible(
                    child: Text(
                      doa != null
                          ? (doa['title'] ?? doa['judul'] ?? 'Doa Harian')
                          : 'Doa Pilihan Hari Ini',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2, // Batasi teks ke 2 baris
                      overflow:
                          TextOverflow
                              .ellipsis, // Tambahkan ellipsis jika teks melebihi batas
                    ),
                  ),
                  SizedBox(height: 8),
                  // Teks "Baca Selengkapnya"
                  Text(
                    'Baca Selengkapnya',
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSurahSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 24, 20, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Surah Pilihan",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all surahs
                },
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: surahs.length,
            itemBuilder: (context, index) {
              dynamic surah = surahs[index];
              String namaSurah = surah['nama_latin']?.toString().trim() ?? '';
              if (namaSurah.isEmpty) {
                namaSurah =
                    surah['name']?.toString().trim() ?? 'Nama Tidak Diketahui';
              }

              return Container(
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => SurahDetailScreen(
                              surah: Map<String, dynamic>.from(surah),
                              allSurahs: surahs.cast<Map<String, dynamic>>(),
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "${surah['nomor'] ?? index + 1}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      namaSurah,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1F2937),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${surah['nama'] ?? ''}",
                                    style: GoogleFonts.amiri(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                "${surah['arti'] ?? 'Tidak ada terjemahan'} • ${surah['jumlah_ayat'] ?? 'Tidak Diketahui'} Ayat",
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: Color(0xFF6B7280),
                                ),
                              ),
                              SizedBox(height: 8),
                              if (surah['tempat_turun'] != null)
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF1E3A8A).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    surah['tempat_turun'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF1E3A8A),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
