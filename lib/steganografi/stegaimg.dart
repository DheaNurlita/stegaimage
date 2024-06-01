import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:steganograph/steganograph.dart';

class Steg2 extends StatefulWidget {
  const Steg2({super.key});

  @override
  State<Steg2> createState() => _Steg1State();
}

class _Steg1State extends State<Steg2> {
  final encriptionKey = 'abcde12345';
  final keypair = Steganograph.generateKeypair();
  TextEditingController msgToEmbed = TextEditingController();
  final directory = Directory("/storage/emulated/0/Download");

  File? img;
  File? imgToEmbed;
  File? imgEncoded;

  File? imgDecoded;
  String? msgDecoded;

  Future<void> pickSource() async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      img = File(result.path);
    }
    setState(() {});
  }

  Future<void> encode() async {
    // * simple encode message
    imgEncoded = await Steganograph.encode(
      image: img!,
      message: msgToEmbed.text,
      outputFilePath: '${directory.path}/result.png',
    );
    // await save();
    debugPrint('encoding success...');
  }

  Future<void> pickEncoded() async {
    final ImagePicker picker = ImagePicker();
    final XFile? result = await picker.pickImage(source: ImageSource.gallery);
    if (result != null) {
      imgEncoded = File(result.path);
    }
    setState(() {});
  }

  Future<void> decode() async {
    // * simple decode message
    msgDecoded = await Steganograph.decode(
      image: imgEncoded!,
    );
    debugPrint(msgDecoded);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steganografi '),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              // Image.asset('assets/apple.jpg'),

              const SizedBox(height: 30),
              img == null
                  ? InkWell(
                      onTap: () => pickSource(),
                      child: Container(
                        height: 200,
                        width: 200,
                        color: Colors.white,
                        child: const Icon(
                          Icons.camera,
                          color: Colors.black,
                          size: 50,
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        SizedBox(
                          height: 200,
                          // width: 200,
                          // color: Colors.white,
                          child: Image.file(img!),
                        ),
                        // Text(img!.path),
                        // Image.file(File(img!.path)),
                        const SizedBox(height: 40),
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: msgToEmbed,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'input message',
                              labelText: 'Secret Message',
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(shape: MaterialStateProperty.all(LinearBorder.none)),
                              onPressed: () {
                                encode();
                                msgToEmbed.clear();
                              },
                              child: const Text("encode"),
                            ),
                            const SizedBox(width: 50),
                            ElevatedButton(
                              style: ButtonStyle(shape: MaterialStateProperty.all(LinearBorder.none)),
                              onPressed: () {
                                pickEncoded();
                              },
                              child: const Text("decode"),
                            ),
                          ],
                        ),
                      ],
                    ),
              const SizedBox(height: 20),

              imgEncoded == null
                  ? const Text('empty')
                  : Column(
                      children: [
                        SizedBox(
                          // height: 300,
                          width: 300,
                          // color: Colors.white,
                          child: Image.file(
                            File(imgEncoded!.path),
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ButtonStyle(shape: MaterialStateProperty.all(LinearBorder.none)),
                          onPressed: () => decode(),
                          child: const Text("decode"),
                        ),
                        const SizedBox(height: 30),
                        Text(msgDecoded!),
                        const SizedBox(height: 30),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
