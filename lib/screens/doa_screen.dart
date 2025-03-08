import 'package:flutter/material.dart';
import '../services/doa_service.dart';
import 'doa_detail_screen.dart';

class DoaScreen extends StatefulWidget {
  @override
  _DoaScreenState createState() => _DoaScreenState();
}

class _DoaScreenState extends State<DoaScreen> {
  List<dynamic> doas = [];
  bool isLoading = true;
  bool isError = false;

  // Define the primary color
  final Color primaryColor = Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    fetchDoas();
  }

  Future<void> fetchDoas() async {
    try {
      final fetchedDoas = await DoaService.getDoas();
      setState(() {
        doas = fetchedDoas;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      print("Error fetching doa: $e");
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Daftar Doa',
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
                        'Memuat Doa...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: primaryColor, // Warna teks biru
                        ),
                      ),
                    ],
                  ),
                )
                : isError
                ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Gagal memuat data. Periksa koneksi internet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: fetchDoas,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, // Warna tombol biru
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 24,
                          ),
                        ),
                        child: Text(
                          "Coba Lagi",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                : doas.isEmpty
                ? Center(
                  child: Text(
                    "Tidak ada data doa",
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                )
                : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  itemCount: doas.length,
                  itemBuilder: (context, index) {
                    final doa = doas[index];

                    // Ambil title dengan alternatif jika kosong
                    String title = doa['title']?.toString().trim() ?? '';
                    if (title.isEmpty) {
                      title =
                          doa['judul']?.toString().trim() ??
                          'Judul Tidak Diketahui';
                    }

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
                                builder: (context) => DoaDetailScreen(doa: doa),
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
                                    child: Icon(
                                      Icons.menu_book_rounded,
                                      size: 20,
                                      color: primaryColor, // Warna biru
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
                                        title,
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
                                      Text(
                                        'Baca Selengkapnya',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
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
