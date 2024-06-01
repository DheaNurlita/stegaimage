import 'package:flutter/material.dart';
import 'package:stegaimage/steganografi/stegaimg.dart';
import 'package:stegaimage/watermark/watermark.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(
                'assets/image/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 50),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Steg2()),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(LinearBorder.none),
                ),
                child: const Text(
                  "Steganografi",
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: 300,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Watermrk(),
                    ),
                  );
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(LinearBorder.none),
                ),
                child: const Text(
                  "Watermarking",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
