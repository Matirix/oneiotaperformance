import 'package:flutter/material.dart';

class PuttCounterWidget extends StatefulWidget {
  final void Function(int) onNumberOfPuttsChanged;
  final void Function(List<int>) onPuttInputValuesChanged;
  final int? initialValue;
  final List<int?>? initialPutts;

  const PuttCounterWidget({
    Key? key,
    this.initialValue,
    this.initialPutts,
    required this.onNumberOfPuttsChanged,
    required this.onPuttInputValuesChanged,
  }) : super(key: key);

  @override
  State<PuttCounterWidget> createState() => PuttCounterWidgetState();
}

class PuttCounterWidgetState extends State<PuttCounterWidget> {
  TextEditingController puttCountController = TextEditingController();
  int numberOfPutts = 0;
  List<int> puttList = [];
  List<int> puttInputValues = [];
  bool isTapped = false;

  void _decrementPuttCount() {
    setState(() {
      if (numberOfPutts > 0) {
        numberOfPutts--;
        puttCountController.text = numberOfPutts.toString();
        puttList.removeLast();
        puttInputValues.removeLast();
        widget.onNumberOfPuttsChanged.call(numberOfPutts);
        widget.onPuttInputValuesChanged.call(puttInputValues);
      }
    });
  }

  void _incrementPuttCount() {
    setState(() {
      if (numberOfPutts <= 5) {
        numberOfPutts++;
        puttCountController.text = numberOfPutts.toString();
        puttList.add(numberOfPutts);
        puttInputValues.add(0);
        widget.onNumberOfPuttsChanged.call(numberOfPutts);
        widget.onPuttInputValuesChanged.call(puttInputValues);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    numberOfPutts = widget.initialValue ?? 0;
    for (int i = 0; i < numberOfPutts; i++) {
      puttList.add(i);
      int widgetInputValue = widget.initialPutts![i] ?? 0;
      puttInputValues.add(widgetInputValue);
    }
    puttCountController.text =
        numberOfPutts.toString(); // Set initial value of the TextField
  }

  @override
  void dispose() {
    puttCountController.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  void _updatePuttCount() {
    const int maxPuttCount = 6;
    const int minPuttCount = 0;

    int inputValue = int.tryParse(puttCountController.text) ?? 0;
    if (inputValue > maxPuttCount) {
      inputValue = maxPuttCount; // Limit the input value to the maximum allowed
      puttCountController.text =
          inputValue.toString(); // Update the text field with the limited value
    }
    if (inputValue < minPuttCount) {
      inputValue = minPuttCount;
      puttCountController.text = inputValue.toString();
    }

    setState(() {
      numberOfPutts = inputValue;
      puttList.clear();
      for (int i = 1; i <= numberOfPutts; i++) {
        puttList.add(i);
      }
    });
  }

  void _clearTextField() {
    if (!isTapped) {
      setState(() {
        puttCountController.clear();
        isTapped = true;
      });
    }
    isTapped = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Number of Putts:",
              style: TextStyle(
                fontFamily: "Inter",
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xff155b94),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _decrementPuttCount,
                        child: Image.asset(
                          'assets/minus.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 70,
                  height: 30,
                  child: TextField(
                    controller: puttCountController,
                    onTap: _clearTextField,
                    onChanged: (_) => _updatePuttCount(),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      isDense: true,
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
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: _incrementPuttCount,
                        child: Image.asset(
                          'assets/plus.png',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        Column(
          children: puttList.map((index) {
            final puttIndex = index;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Putt ${index + 1}',
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: Color(0xff155b94),
                    ),
                  ),
                ),
                SizedBox(
                  width: 130,
                  height: 30,
                  child: Column(children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: puttInputValues[puttIndex].toString(),
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                        maxLength: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.white,
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(20), // Set border radius
                            borderSide: const BorderSide(
                              color:
                                  Color(0xfff1f1f1), // Customize border color
                            ),
                          ),
                        ),
                        onFieldSubmitted: (_) => widget.onPuttInputValuesChanged
                            .call(puttInputValues),
                        onChanged: (value) {
                          setState(() {
                            puttInputValues[puttIndex] =
                                int.tryParse(value) ?? 0;
                          });
                        },
                      ),
                    ),
                  ]),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
