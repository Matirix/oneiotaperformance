import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/models/auth_models.dart';
import 'package:one_iota_mobile_app/screens/settings_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/auth.dart';

import '../api/one_iota_api.dart';

/// This is for the header of the app, you can add icons to it.
class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  Future<AccountInfo>? _futureAccount;

  // String? username;
  String? team;
  String? userName; // Testing (For nameWidget)

  Future<void> _storeUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', name);
  }

  Future<String?> _getStoredUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('userName') == null) {
      return " ";
    }
    return prefs.getString('userName');
  }

  FutureBuilder<AccountInfo> nameWidget() {
    return FutureBuilder<AccountInfo>(
      future: _futureAccount,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userName = snapshot.data!.name;
          // _storeUserName(userName ?? ''); // Store the user's name
          // print(userName);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userName != null) // Null check
                    Text(
                      userName!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Text(
                    snapshot.data!.userType ?? 'No team',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Settings()),
                ),
                child: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(
                    snapshot.data!.photoUrl ??
                        'https://via.placeholder.com/150',
                  ),
                  child: snapshot.data!.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
              ),
            ],
          );
        }
        return Text(
          userName ?? '', // Display an empty string if userName is null
          style: const TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _futureAccount = OneIotaAuth().fetchAccountInfo(token: Auth.idToken);
    _getStoredUserName().then((storedUserName) {
      setState(() {
        userName = storedUserName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: nameWidget(),
      ),
      // centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      // actions: [
      //   Container(
      //     margin: const EdgeInsets.only(bottom: 50),
      //     child: const IconButton(
      //       color: Colors.black,
      //       icon: Icon(Icons.person),
      //       iconSize: 50,
      //       onPressed: null,
      //     ),
      //   ),
      // ],
    );
  }

  /// Returns the preferred size of the app bar. Without this, it is an error.
  Size get preferredSize => const Size.fromHeight(60);
}
