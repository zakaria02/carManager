import 'package:mycarmanager/Service/http.dart';
import 'package:path/path.dart' as PATH;
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'dart:io';
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';

class UploadPicture {
  int carId;
  final server = "http://192.168.1.87";
  final createFolderLink = "mycarmanager/images/createFolder.php";
  final deleteFolderLink = "mycarmanager/images/deleteFolder.php";
  final uploadFolderLink = "mycarmanager/images/uploads";
  final uploadLink = "mycarmanager/images/upload.php";

  UploadPicture({this.carId});

  createFolder() async {
    try {
      final paramDir = {
        "carId": "$carId",
      };

      var url = Uri.http("192.168.1.87", createFolderLink);

      http
          .post(
        url,
        body: paramDir,
      )
          .then((value) {
        print(value.body);
      });
      return true;
    } catch (e) {
      print(e.message);
      return false;
    }
  }

  Future upload(File imageFile) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final path = tempDir.path;

      Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
      Img.Image smallerImg = Img.copyResize(image, width: 500);

      String title = PATH.basename(imageFile.path);
      int _indT = title.lastIndexOf(".");
      String _extT = title.substring(_indT);

      var _img = new File("$path/image_$title.$_extT")
        ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

      // ignore: deprecated_member_use
      var stream = new http.ByteStream(DelegatingStream.typed(_img.openRead()));
      var length = await _img.length();
      var uri = Uri.parse("$server/$uploadLink?carId=$carId");

      var request = new http.MultipartRequest("POST", uri);

      String name = PATH.basename(imageFile.path);

      var multipartFile =
          new http.MultipartFile("image", stream, length, filename: name);

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        final data = {
          'id': carId,
          'link': "$server/$uploadFolderLink/$carId/$name"
        };
        addData("images", data);
        return true;
      } else {
        print("Upload failed");
        return false;
      }
    } catch (e) {
      print("error");
      return false;
    }
  }
}
