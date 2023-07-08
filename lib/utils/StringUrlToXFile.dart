import 'dart:io';
import 'dart:math';
import 'package:appchat_socket/models/image_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class StringUrlToXFile {
  static Future<XFile?> getImageXFileByUrl(String imageUrl) async {
    // generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl) );
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    if(file==null)return null;
    XFile xf  =XFile(file.path);
    return xf;
  }
  static List<String> convertObjectImageToString(List<imagePost> imgP ){
    List<String> result =[];
     imgP.forEach((element) {
        result.add(element.image_url);
    });
    return result;
  }
}
