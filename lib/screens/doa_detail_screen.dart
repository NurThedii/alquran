import 'package:flutter/material.dart';

class DoaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doa;

  DoaDetailScreen({required this.doa});

  // Define the primary color
  final Color primaryColor = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    // Debugging untuk melihat isi data doa
    print("Data doa: $doa");

    // Ambil title dengan alternatif key jika kosong
    String title = doa['title']?.toString().trim() ?? '';
    if (title.isEmpty) {
      title = doa['judul']?.toString().trim() ?? 'Judul Tidak Diketahui';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
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
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul Doa
                Container(
                  padding: EdgeInsets.all(16),
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
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: primaryColor, // Warna biru
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Teks Arab
                Container(
                  padding: EdgeInsets.all(16),
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
                  child: Text(
                    doa['arab'] ?? 'Teks Arab tidak tersedia',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right, // Rata kanan untuk teks Arab
                    textDirection:
                        TextDirection.rtl, // Arah teks dari kanan ke kiri
                  ),
                ),
                SizedBox(height: 20),

                // Teks Latin
                Container(
                  padding: EdgeInsets.all(16),
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
                  child: Text(
                    doa['latin'] ?? 'Teks Latin tidak tersedia',
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Terjemahan
                Container(
                  padding: EdgeInsets.all(16),
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
                  child: Text(
                    doa['terjemah'] ??
                        doa['terjemahan'] ??
                        'Terjemahan tidak tersedia',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.5, // Jarak antar baris
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
