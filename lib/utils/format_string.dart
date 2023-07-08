import 'dart:convert';
import 'dart:core';
class formatString {
  static String StringVNToUk(String input) {
    var output =
        input.replaceAll(RegExp(r'[^\w\s]+'), ''); // Xóa các ký tự đặc biệt
    output = output.replaceAll(' ', ''); // Xóa khoảng trắng
    return ascii
        .decode(utf8.encode(output))
        .toLowerCase(); // Chuyển đổi thành chữ không dấu và chuyển thành chữ thường
  }
}
