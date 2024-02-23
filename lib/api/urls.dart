class URLs {
  // sesuaikan jika masih local gunakan ip device/url yang bisa dipakai
  static const baseUrl = 'http://192.168.100.10/api_travel';

  // getter image
  static String image(String fileName) => '$baseUrl/images/$fileName';
}
