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
  bool isError = false; // Tambahkan variabel error

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
        isError = false; // Jika berhasil, reset error
      });
    } catch (e) {
      print("Error fetching doa: $e");
      setState(() {
        isLoading = false;
        isError = true; // Set error jika gagal
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Daftar Doa')),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator()) // Loading indicator
              : isError
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Gagal memuat data. Periksa koneksi internet."),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: fetchDoas,
                      child: Text("Coba Lagi"),
                    ),
                  ],
                ),
              )
              : doas.isEmpty
              ? Center(child: Text("Tidak ada data doa"))
              : ListView.builder(
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

                  return ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoaDetailScreen(doa: doa),
                        ),
                      );
                    },
                  );
                },
              ),
    );
  }
}
