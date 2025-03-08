import 'package:flutter/material.dart';

class DoaDetailScreen extends StatelessWidget {
  final Map<String, dynamic> doa;

  DoaDetailScreen({required this.doa});

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
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              doa['arab'] ?? 'Teks Arab tidak tersedia',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              doa['latin'] ?? 'Teks Latin tidak tersedia',
              style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 10),
            Text(
              doa['translation'] ??
                  doa['terjemahan'] ??
                  'Terjemahan tidak tersedia',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
