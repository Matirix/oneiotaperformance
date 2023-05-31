import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/widgets/settings_feature_widgets/image_selector_widget.dart';

import '../utils/app_colors.dart';
import '../api/auth.dart';
import '../widgets/settings_feature_widgets/custom_text_field_widget.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? dropdownValue = 'America / Vancouver';
  bool detailsToggle = false;

  bool pastRoundSummaryEmailToggle = false;
  bool pastRoundSummaryPushToggle = false;

  bool eventStatRemindersEmailToggle = false;
  bool eventStatRemindersPushToggle = false;

  bool postEventSummaryEmailToggle = false;
  bool postEventSummaryPushToggle = false;

  List<String> timezones = [
    "America / Vancouver",
    "America / Toronto",
    "America / Halifax",
    "America / St. John's",
  ];

  List<CustomTextField> textFieldsBeforeDivider = [
    CustomTextField(
        label: "Name", tooltip: "", showHint: false, isEditable: true),
    CustomTextField(
        label: "Gender",
        tooltip:
            "We identify all users gender and year of birth in order to be able to provide accurate statistical comparisons that are relevant to you",
        isEditable: true,
        showHint: true),
    CustomTextField(
        label: "Year of Birth",
        tooltip:
            "We identify all users gender and year of birth in order to be able to provide accurate statistical comparisons that are relevant to you",
        isEditable: true,
        showHint: true),
    CustomTextField(
        label: "Account Type",
        tooltip:
            "You account type cannot be modified using our app. To update your account type, leave a program or join a program, visit our website",
        isEditable: false,
        showHint: true)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Account Info",
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Auth().signOut();
                        },
                        child: const Text(
                          "Sign Out",
                          style: TextStyle(
                            color: Colors.lightBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const ImageSelector(),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 180,
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: textFieldsBeforeDivider.length,
                            itemBuilder: (context, index) {
                              return textFieldsBeforeDivider[index];
                            }),
                      ),
                      const Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      SizedBox(
                        child: CustomTextField(
                            label: "Email",
                            tooltip: "",
                            isEditable: true,
                            showHint: false),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Password",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 80,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                      elevation:
                                          MaterialStateProperty.all<double>(0),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              AppColors.darkBlue),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {},
                                    child: const Text(
                                      "Change",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                elevation: MaterialStateProperty.all<double>(0),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        AppColors.darkBlue),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                              onPressed: () {},
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Text("Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
                Container(
                  // Settings Column
                  padding: const EdgeInsets.all(20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Timezone",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              width: 170,
                              height: 30,
                              // decoration: BoxDecoration(
                              //   color: Colors.white,
                              //   borderRadius: BorderRadius.circular(8),
                              // ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  borderRadius: BorderRadius.circular(8),
                                  icon: null,
                                  value: dropdownValue,
                                  // icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),

                                  onChanged: (String? newValue) {
                                    print(newValue);
                                    setState(() {
                                      dropdownValue = newValue!;
                                    });
                                  },
                                  items: timezones
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Detail Level",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ]),
                            SizedBox(
                              width: 170,
                              height: 30,
                              child: Row(
                                children: [
                                  const Text(
                                    "Basic",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Switch(
                                    value: detailsToggle,
                                    onChanged: (value) {
                                      setState(() {
                                        detailsToggle = value;
                                        print(detailsToggle);
                                      });
                                    },
                                    // activeTrackColor: Colors.lightGreenAccent,
                                    activeColor: AppColors.lightGreen,
                                  ),
                                  const Text(
                                    "Advanced",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [
                                  Text(
                                    "Health Service",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ]),
                            Center(
                              child: Container(
                                width: 170,
                                height: 25,
                                color: Colors.grey[100],
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.center,
                                  ),
                                  child: const Text(
                                    "Link to Health",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black,
                                    ),
                                  ),
                                  onPressed: () {}, // TODO
                                ),
                              ),
                            )
                          ],
                        )
                      ]),
                ),
                const Text("Notifications",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
                Container(
                    // Notifications Column
                    padding: const EdgeInsets.all(20),
                    child: Column(children: [
                      const NotificationsLabel(),

                      CheckBoxRow(
                          label: "Past Round Summary",
                          emailToggle: pastRoundSummaryEmailToggle,
                          pushToggle: pastRoundSummaryPushToggle,
                          onEmailToggleChanged: (bool? value) {
                            setState(() {
                              print(value);
                              pastRoundSummaryEmailToggle = value!;
                              print(pastRoundSummaryEmailToggle);
                            });
                          },
                          onPushToggleChanged: (bool? value) {
                            setState(() {
                              print(value);
                              pastRoundSummaryPushToggle = value!;
                              print(pastRoundSummaryPushToggle);
                            });
                          }),
                      CheckBoxRow(
                          label: "Event Stat Reminder",
                          emailToggle: eventStatRemindersEmailToggle,
                          pushToggle: eventStatRemindersPushToggle,
                          onEmailToggleChanged: (bool? value) {
                            setState(() {
                              print(value);
                              eventStatRemindersEmailToggle = value!;
                              print(eventStatRemindersEmailToggle);
                            });
                          },
                          onPushToggleChanged: (bool? value) {
                            setState(() {
                              print(value);
                              eventStatRemindersPushToggle = value!;
                              print(eventStatRemindersPushToggle);
                            });
                          }),
                      CheckBoxRow(
                          label: "Post Event Summary",
                          emailToggle: postEventSummaryEmailToggle,
                          pushToggle: postEventSummaryPushToggle,
                          onEmailToggleChanged: (bool? value) {
                            setState(() {
                              print(value);
                              postEventSummaryEmailToggle = value!;
                              print(postEventSummaryEmailToggle);
                            });
                          },
                          onPushToggleChanged: (bool? value) {
                            setState(() {
                              print(value);
                              postEventSummaryPushToggle = value!;
                              print(postEventSummaryPushToggle);
                            });
                          }),

                      // Container(
                      //   width: 170,
                      //   height: 30,
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(8),
                      //   ),
                      // child: TextFormField(
                      //   style: const TextStyle(
                      //     fontSize: 12,
                      //   ),
                      //   decoration: InputDecoration(
                      //     hintText: "Placeholder",
                      //     enabled: isEditable,
                      //     border: InputBorder.none,
                      //     contentPadding: const EdgeInsets.symmetric(
                      //       vertical: 12,
                      //       horizontal: 12,
                      //     ),
                      //   ),
                      // ),
                      // ),
                    ])),
              ]),
        ),
      ),
    );
  }
}

class NotificationsLabel extends StatelessWidget {
  const NotificationsLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 150,
          child: Text("Type",
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
        ),
        Row(
          children: const [
            Text("Email",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(
              width: 10,
            ),
            Text("Push",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ],
    );
  }
}

class CheckBoxRow extends StatelessWidget {
  final String label;
  final bool emailToggle;
  final bool pushToggle;
  final ValueChanged<bool?> onEmailToggleChanged;
  final ValueChanged<bool?> onPushToggleChanged;

  const CheckBoxRow({
    Key? key,
    required this.label,
    required this.emailToggle,
    required this.pushToggle,
    required this.onEmailToggleChanged,
    required this.onPushToggleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        Row(
          children: [
            Checkbox(
              value: emailToggle,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: const VisualDensity(vertical: -4.0),
              activeColor: AppColors.darkBlue,
              onChanged: onEmailToggleChanged,
            ),
            Checkbox(
              value: pushToggle,
              onChanged: onPushToggleChanged,
            ),
          ],
        )
      ],
    );
  }
}
