import 'package:dio/dio.dart';

class QuranService {
  static final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  // Ambil semua surah
  static Future<List<dynamic>> getAllSurahs() async {
    try {
      var response = await _dio.get(
        'https://quran-api.santrikoding.com/api/surah',
      );

      print("🔍 DEBUG - Data Surah: ${response.data}"); // Debugging Output

      if (response.statusCode == 200 && response.data is List) {
        return response.data;
      } else {
        print("⚠️ Format data API tidak sesuai atau kosong.");
        return [];
      }
    } catch (e) {
      print('❌ Error fetching surah: $e');
      return [];
    }
  }

  // Ambil ayat berdasarkan nomor surah
  static Future<List<dynamic>> getAyatBySurah(dynamic surahNumber) async {
    try {
      String nomorSurah = surahNumber.toString();
      var response = await _dio.get(
        'https://quran-api.santrikoding.com/api/surah/$nomorSurah',
      );

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        var data = response.data;

        if (data.containsKey('ayat') && data['ayat'] is List) {
          List<dynamic> ayatList = data['ayat'];

          // Pastikan semua data integer dikonversi ke String
          List<Map<String, dynamic>> formattedAyatList =
              ayatList.map((ayat) {
                return {
                  'id': ayat['id'].toString(),
                  'surah': ayat['surah'].toString(),
                  'nomor': ayat['nomor'].toString(), // Konversi ke String
                  'ar': ayat['ar'],
                  'tr': ayat['tr'],
                  'idn': ayat['idn'],
                  'audio':
                      'https://santrikoding.com/storage/audio/$nomorSurah.mp3', // Tambah audio
                };
              }).toList();

          return formattedAyatList;
        }
      }
      return [];
    } catch (e) {
      print('Error fetching ayat: $e');
      return [];
    }
  }

  // Ambil surah secara acak
  static Future<List<dynamic>> getRandomSurahs(int count) async {
    List<dynamic> allSurahs = await getAllSurahs();
    allSurahs.shuffle();
    return allSurahs.take(count).toList();
  }
}
