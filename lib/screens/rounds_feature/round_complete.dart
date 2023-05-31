import 'package:one_iota_mobile_app/screens/rounds_feature/add_round_page.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/rounds_main.dart';
import 'package:flutter/material.dart';

class RoundComplete extends StatelessWidget {
  const RoundComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff2C6E2E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.black,
                size: 100,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "Round Successfully Saved",
              style: TextStyle(
                fontSize: 20,
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddRound()),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'Add New Round',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0),
                  child: Container(
                    alignment: Alignment.center,
                    width: 160,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoundsMain()),
                        );
                      },
                      child: const Center(
                        child: Text(
                          'View Rounds',
                          style: TextStyle(
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
