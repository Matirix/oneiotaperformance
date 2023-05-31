import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:one_iota_mobile_app/api/one_iota_api.dart';

import '../../api/auth.dart';

import '../../models/auth_models.dart';

class ImageSelector extends StatefulWidget {
  const ImageSelector({super.key});

  @override
  State<ImageSelector> createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        pickedFile = result.files.first;
      });
      await uploadFileToFireStorage();
    }
  }

  Future uploadFileToFireStorage() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDwnld = await snapshot.ref.getDownloadURL();
    await OneIotaAuth().updateProfilePicture(
        token: Auth.idToken!, imageUrl: urlDwnld.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProfilePicture(),
            TextButton(
                onPressed: () {
                  selectFile();
                },
                child:
                    const Text("Edit", style: TextStyle(color: Colors.black))),
          ],
        ),
      ],
    );
  }
}

class CircularProfilePicture extends StatelessWidget {
  const CircularProfilePicture({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AccountInfo>(
      future: OneIotaAuth().fetchAccountInfo(token: Auth.idToken),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              snapshot.data!.photoUrl ?? "https://via.placeholder.com/150",
            ),
            child: snapshot.data!.photoUrl == null
                ? const Icon(Icons
                    .person) // You can replace this with any widget you want
                : null,
          );
        } else if (snapshot.hasError) {
          return const Icon(Icons.person);
        }
        return const Icon(Icons.person); //
      },
    );
  }
}
