import 'package:dio/dio.dart';

class DoaService {
  static Future<List<dynamic>> getDoas() async {
    try {
      final response = await Dio().get(
        'https://open-api.my.id/api/doa',
        options: Options(
          receiveTimeout: Duration(seconds: 10), // Timeout setelah 10 detik
          sendTimeout: Duration(seconds: 5),
        ),
      );

      if (response.statusCode == 200) {
        if (response.data is List) {
          return response.data;
        } else if (response.data is Map && response.data.containsKey('data')) {
          return response.data['data'];
        }
      }
    } catch (e) {
      print('Error fetching doas: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getRandomDoas(int count) async {
    try {
      // Ambil semua doa dari API
      List<dynamic> allDoas = await getDoas();

      // Acak urutan doa
      allDoas.shuffle();

      // Ambil sejumlah `count` doa secara random
      return allDoas.take(count).toList();
    } catch (e) {
      print('Error fetching random doas: $e');
      return [];
    }
  }
}