import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_vote/sign3.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class SignPage2 extends StatefulWidget {
  final String AddharNumber;
  SignPage2({required this.AddharNumber});
  @override
  State<SignPage2> createState() => _SignPage2State();
  
}

class _SignPage2State extends State<SignPage2> {
  
  final _picker = ImagePicker();
  List<File> imageFiles = [];
  File? image_1, image_2, image_3, image_4;
  bool showSpinner = false;

  Future<void> getImage_1() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    //final pickedFile_1 =
    //   await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    // final List<XFile>? selectedImages = await _picker.pickMultiImage();
    if (pickedFile != null) {
      // image_1 = File(pickedFile.path);
      setState(() {
        XFile xFileAtIndex = pickedFile;
        File fileAtIndex = File(xFileAtIndex.path);
        image_1 = File(xFileAtIndex.path);
        imageFiles.add(fileAtIndex);
      });
    } else {
      print('no image selected');
    }
  }

  Future getImage_2() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      // image_2 = File(pickedFile.path);
      setState(() {
        XFile xFileAtIndex = pickedFile;
        File fileAtIndex = File(xFileAtIndex.path);
        image_2 = File(xFileAtIndex.path);
        imageFiles.add(fileAtIndex);
      });
    } else {
      print('no image selected');
    }
  }

  Future getImage_3() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      //image_3 = File(pickedFile.path);
      setState(() {
        XFile xFileAtIndex = pickedFile;
        File fileAtIndex = File(xFileAtIndex.path);
        image_3 = File(xFileAtIndex.path);
        imageFiles.add(fileAtIndex);
      });
    } else {
      print('no image selected');
    }
  }

  Future getImage_4() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      //image_4 = File(pickedFile.path);
      setState(() {
        XFile xFileAtIndex = pickedFile;
        File fileAtIndex = File(xFileAtIndex.path);
        image_4 = File(xFileAtIndex.path);
        imageFiles.add(fileAtIndex);
        for (int i = 0; i < imageFiles.length; i++) {
          print(i);
          print(imageFiles[i]);
        }
      });
    } else {
      print('no image selected');
    }
  }

  // Future<void> _uploadImages() async {
  //   if (imageFiles.isNotEmpty) {
  //     // Create a multipart request
  //     print("request ke ander");
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('http://192.168.29.216:5000/photos/upload'),
  //     );
  //     print("request ke ander janae wala he");
  //     // Add each image file to the request
  //     for (int i = 0; i < imageFiles.length; i++) {
  //       var file = imageFiles[i];
  //       request.files.add(
  //         await http.MultipartFile.fromPath(
  //             'files', // field name in the multer configuration
  //             file.path),
  //       );
  //       request.headers.addAll({"Content-type": "multipart/form-data"});
  //     }
  //     print("request ke bhar");
  //     // Send the request
  //     try {
  //       final response = await request.send();
  //       if (response.statusCode == 200) {
  //         print('Upload completed 1');
  //       } else {
  //         print('Upload failed with status ${response.statusCode}');
  //       }
  //     } catch (error) {
  //       print('Error during upload: $error');
  //     }
  //   }
  // }
  Future<String> post(
    String ext, AddharNumber
  ) async {
    print('post is hitted----' + ext);
    final url = 'http://172.20.10.2:5000/post';

    try {
      print("ye hit hoga" + ext + AddharNumber);
      final response = await http
          .post(Uri.parse(url), body: {'ext': ext, 'AddharNumber': AddharNumber}
              // headers: {'Content-Type': 'application/json'},
              );
      print("ye hit hogya2");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        print('Response data: $responseData');
        return responseData['v'];
        //return json.decode(response.body);
      } else {
        print('Request failed with status: ${response.statusCode}');
        return 'Request failed with status: ${response.statusCode}';
      }
    } catch (error) {
      print('Error: $error');
      return 'Error occured: $error';
    }
  }

  Future<void> uploadFile(List<File> file) async {
    var response;
    for (int i = 0; i < file.length; i++) {
      var str = file[i].path;
      var x = str.lastIndexOf('.');
      var ext = str.substring(x + 1);
      print('storage me aya hai==============================' + ext);
      String url = await post(ext, widget.AddharNumber);

      Dio dio = new Dio();
      var len = await file[i].length();
      response = await dio.put(url,
          data: file[i].openRead(),
          options: Options(headers: {
            Headers.contentLengthHeader: len,
          } // set content-length
              ));
    }
    if (response.statusCode == 200) {
      // Get.to(homePage());
      print("uploaded");
    } else {
      print('error uploading image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/bac_app1.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Color.fromRGBO(0, 151, 178, .4),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Container(
                      height: 50,
                      width: 360,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Fill your Addar cards Photos",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                      ),
                    ))),
                Center(
                  child: Text(
                    "Photo of Front Side 📇🪪",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        height: 80,
                        width: 100,
                        color: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            getImage_1();
                          },
                          child: image_1 == null
                              ? Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 90,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Center(
                                        child: IconButton(
                                            iconSize: 30,
                                            onPressed: () {
                                              getImage_1();
                                            },
                                            icon: Icon(Icons.add)))
                                  ],
                                )
                              : Container(
                                  child: Center(
                                    child: Image.file(
                                      File(image_1!.path).absolute,
                                      height: 80,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Photo of Back Side ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        height: 80,
                        width: 100,
                        color: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            getImage_2();
                          },
                          child: image_2 == null
                              ? Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 90,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Center(
                                        child: IconButton(
                                            iconSize: 30,
                                            onPressed: () {
                                              getImage_2();
                                            },
                                            icon: Icon(Icons.add)))
                                  ],
                                )
                              : Container(
                                  child: Center(
                                    child: Image.file(
                                      File(image_2!.path).absolute,
                                      height: 80,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        )),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Container(
                      height: 50,
                      width: 360,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Fill your Voter cards Photos",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 22),
                        )),
                      ),
                    ))),
                Center(
                  child: Text(
                    "Photo of Front Side 📇🪪",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        height: 80,
                        width: 100,
                        color: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            getImage_3();
                          },
                          child: image_3 == null
                              ? Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 90,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Center(
                                        child: IconButton(
                                            iconSize: 30,
                                            onPressed: () {
                                              getImage_3();
                                            },
                                            icon: Icon(Icons.add)))
                                  ],
                                )
                              : Container(
                                  child: Center(
                                    child: Image.file(
                                      File(image_3!.path).absolute,
                                      height: 80,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Photo of Back Side ",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                        height: 80,
                        width: 100,
                        color: Colors.white,
                        child: GestureDetector(
                          onTap: () {
                            getImage_4();
                          },
                          child: image_4 == null
                              ? Stack(
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 60,
                                        width: 90,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Center(
                                        child: IconButton(
                                            iconSize: 30,
                                            onPressed: () {
                                              getImage_4();
                                            },
                                            icon: Icon(Icons.add)))
                                  ],
                                )
                              : Container(
                                  child: Center(
                                    child: Image.file(
                                      File(image_4!.path).absolute,
                                      height: 80,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                        )),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Please Verify your detail before Submitting",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (image_4 != null &&
                            image_3 != null &&
                            image_2 != null &&
                            image_1 != null) {
                          print("function ke ander j");
                          // _uploadImages();
                          print(imageFiles.length);
                          // print(AddharNumber);
                          uploadFile(imageFiles);

                          print("Upload completed");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignPage3()));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightGreen,
                          alignment: Alignment.center,
                          shape: StadiumBorder()),
                      child: Container(
                        height: 50,
                        width: 100,
                        child: Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                      )),
                )
              ],
            ),
          )),
    );
  }
}
