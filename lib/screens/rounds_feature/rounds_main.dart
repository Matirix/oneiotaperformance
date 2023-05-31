import 'dart:async';

import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/screens/rounds_feature/add_round_page.dart';
import '../../models/round_model.dart';

import '../../api/persistent_data.dart';
import '../../utils/custom_app_bar.dart';
import '../../api/one_iota_api.dart';
import '../../api/auth.dart';

class RoundsMain extends StatefulWidget {
  const RoundsMain({super.key});

  @override
  State<RoundsMain> createState() => RoundsMainState();
}

class RoundsMainState extends State<RoundsMain> {
  late TextEditingController textEditingController;
  Future<List<Round>>? _futureRounds;
  List<Round> roundsList = [];

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    loadRounds();
  }

  Future<void> loadRounds() async {
    _futureRounds = OneIotaAuth().getRounds(token: Auth.idToken);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  List<Round> filteredRounds = [];

  void filterRounds(String query) {
    setState(() {
      filteredRounds = roundsList.where((item) {
        return (item.roundType).toLowerCase().contains(query.toLowerCase()) ||
            (item.date ?? '').toLowerCase().contains(query.toLowerCase()) ||
            (item.courseName ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (item.score.toString())
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            (item.inProgress ? "In Progress" : '')
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    });
  }

  FutureBuilder<List<Round>> futureRoundsListBuilder() {
    return FutureBuilder<List<Round>>(
        future: _futureRounds,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            if (roundsList.isEmpty) {
              snapshot.data?.forEach((element) {
                roundsList.add(element);
              });
              filteredRounds = List.from(roundsList);
            }
            return Expanded(
              child: ListView.builder(
                itemCount: filteredRounds.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                      onTap: () {
                        PersistentData.currentRoundEdit = filteredRounds[index];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddRound()));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff155b94),
                        ),
                        child: Card(
                          color: const Color(0xff155B94),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      filteredRounds[index].formattedDate,
                                      style: const TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      filteredRounds[index].inProgress
                                          ? 'In Progress'
                                          : '-',
                                      style: const TextStyle(
                                        fontFamily: "Inter",
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                        color: Color(0xff87CA80),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (filteredRounds[index].score ?? '-'),
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18,
                                      color: Color(0xff87CA80),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    filteredRounds[index].courseName ??
                                        "No Course",
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    filteredRounds[index].roundType,
                                    style: const TextStyle(
                                      fontFamily: "Inter",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
                },
              ),
            );
          } else if (snapshot.hasError) {
            return const Text(
              'Could not retrieve past rounds, please check your internet connection',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {
                  PersistentData.currentRoundEdit = null;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddRound()));
                },
                child: Container(
                  width: 350,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 2,
                      color: Colors.grey.withOpacity(0.5),
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff87CA80),
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 40,
                          color: Color(0xff155B94),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Add New Round",
                        style: TextStyle(
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                          color: Color(0xff155b94),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Rounds",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Search (Date, Course, etc)',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (query) {
                  filterRounds(query);
                },
              ),
              const SizedBox(height: 16),
              futureRoundsListBuilder(),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
