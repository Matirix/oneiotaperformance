import 'package:flutter/material.dart';

/// This is used in the rounds entry page.
class ScoreWidget extends StatefulWidget {
  final int initialValue;
  final String labelText;
  final ValueChanged<int> onChanged;
  final int maxScoreCount;

  const ScoreWidget({
    Key? key,
    required this.initialValue,
    required this.labelText,
    required this.onChanged,
    required this.maxScoreCount,
  }) : super(key: key);

  @override
  ScoreWidgetState createState() => ScoreWidgetState();
}

class ScoreWidgetState extends State<ScoreWidget> {
  late TextEditingController textEditingController;
  late int score;
  bool isTapped = false;

  @override
  void initState() {
    super.initState();
    score = widget.initialValue;
    textEditingController = TextEditingController(text: score.toString());
    textEditingController.addListener(_handleTextChanged);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    final newText = textEditingController.text;
    const minScoreCount = 0;
    final newScore = newText.isNotEmpty ? int.tryParse(newText) : null;

    if (newScore != null && newScore != score) {
      setState(() {
        if (newScore <= widget.maxScoreCount) {
          score = newScore;
        } else {
          score = widget.maxScoreCount;
          textEditingController.text = widget.maxScoreCount.toString();
        }
        if (newScore >= minScoreCount) {
          score = newScore;
        } else {
          score = minScoreCount;
          textEditingController.text = minScoreCount.toString();
        }
      });
      widget.onChanged(score);
    }
  }

  void _decrementScore() {
    final newScore = score - 1;
    if (newScore >= 0) {
      setState(() {
        score = newScore;
        textEditingController.text = newScore.toString();
      });
      widget.onChanged(score);
    }
  }

  void _incrementScore() {
    final newScore = score + 1;
    if (newScore <= widget.maxScoreCount) {
      setState(() {
        score = newScore;
        textEditingController.text = newScore.toString();
      });
      widget.onChanged(score);
    }
  }

  void _clearTextField() {
    if (!isTapped) {
      setState(() {
        textEditingController.clear();
        isTapped = true;
      });
    }
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.labelText,
          style: const TextStyle(
            fontFamily: "Inter",
            fontWeight: FontWeight.w700,
            fontSize: 15,
            color: Color(0xff155b94),
          ),
        ),
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _decrementScore,
                  child: Image.asset(
                    'assets/minus.png',
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 70,
              height: 30,
              child: TextField(
                controller: textEditingController,
                onTap: _clearTextField,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20), // Set border radius
                    borderSide: const BorderSide(
                      color: Color(0xfff1f1f1), // Customize border color
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: GestureDetector(
                  onTap: _incrementScore,
                  child: Image.asset(
                    'assets/plus.png',
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
