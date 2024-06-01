import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';

class Watermrk extends StatefulWidget {
  const Watermrk({super.key});

  @override
  State<Watermrk> createState() => _WatermrkState();
}

class _WatermrkState extends State<Watermrk> {
  final _picker = ImagePicker();
  Uint8List? imgBytes;
  Uint8List? imgBytes2;
  XFile? _image;
  Uint8List? watermarkedImgBytes;
  bool isLoading = false;
  String watermarkText = "", imgname = "image not selected";
  bool isLenovoFont = false;
  Uint8List? file;
  List<bool> textOrImage = [true, false];

  pilihimage() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _image = image;
      var t = await image.readAsBytes();
      imgBytes = Uint8List.fromList(t);
    }
    setState(() {});
  }

  pilihimage2() async {
    XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      _image = image;
      imgname = image.name;
      var t = await image.readAsBytes();
      imgBytes2 = Uint8List.fromList(t);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watermarking'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                GestureDetector(
                  onTap: pilihimage,
                  child: Container(
                      margin: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(5),
                          ),
                          color: Colors.white),
                      width: 600,
                      height: 250,
                      child: _image == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Click here to choose image',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )
                          : Image.memory(imgBytes!, width: 600, height: 200, fit: BoxFit.fitHeight)),
                ),
                ToggleButtons(
                  fillColor: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  borderWidth: 3,
                  borderColor: Colors.black26,
                  selectedBorderColor: Colors.black54,
                  selectedColor: Colors.black,
                  onPressed: (index) {
                    textOrImage = [false, false];
                    setState(() {
                      textOrImage[index] = true;
                    });
                  },
                  isSelected: textOrImage,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '  Text  ',
                      ),
                    ),
                    // second toggle button
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '  Image  ',
                        ))
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                textOrImage[0]
                    ? Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: SizedBox(
                              width: 600,
                              child: TextField(
                                onChanged: (val) {
                                  watermarkText = val;
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Masukan watermark text',
                                    labelText: 'Watermark Text',
                                    // hintText: 'Watermark Text',
                                    // fillColor: Colors.white,
                                    filled: true),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: pilihimage2, child: const Text('Select Watermark image')),
                          const SizedBox(width: 20),
                          Text(imgname)
                        ],
                      ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    if (textOrImage[0]) {
                      watermarkedImgBytes = await ImageWatermark.addTextWatermark(
                        ///image bytes
                        imgBytes: imgBytes!,

                        /// Change font
                        // font: isLenovoFont ? ImageFont.readOtherFontZip(file!) : null,

                        ///watermark text
                        watermarkText: watermarkText,
                        dstX: 20,
                        dstY: 30,
                      );

                      /// default : imageWidth/2
                    } else {
                      watermarkedImgBytes = await ImageWatermark.addImageWatermark(
                          //image bytes
                          originalImageBytes: imgBytes!,
                          waterkmarkImageBytes: imgBytes2!,
                          imgHeight: 250,
                          imgWidth: 250,
                          dstY: 400,
                          dstX: 400);
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Text('Add Watermark'),
                ),
                const SizedBox(
                  height: 10,
                ),
                isLoading ? const CircularProgressIndicator() : Container(),
                watermarkedImgBytes == null ? const SizedBox() : Image.memory(watermarkedImgBytes!),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
