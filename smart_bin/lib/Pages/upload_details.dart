import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:smartbins/provider/user_provider.dart';
import 'home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

var uid;
class DetailsUpload extends StatefulWidget {
  @override
  _DetailsUploadState createState() => _DetailsUploadState();
}

class _DetailsUploadState extends State<DetailsUpload> {
  File _image;
  String _uploadedFileURL;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_uid().then((id) {
      setState(() {});
    });
  }
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
  Future uploadFile() async {
final user = UserProvider();
    
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('users').child(uid).child("image");
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    print("===================== P R I N T I N G ===============");
    print(uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            _image != null
                ? Image.asset(
              _image.path,
              height: 150,
            )
                : Container(height: 150),
            _image == null
                ? RaisedButton(
              child: Text('Choose File'),
              onPressed: chooseFile,
              color: Colors.cyan,
            )
                : Container(),
            _image != null
                ? RaisedButton(
              child: Text('Upload File'),
              onPressed: uploadFile,
              color: Colors.cyan,
            )
                : Container(),
            Text('Uploaded Image'),
            _uploadedFileURL != null
                ? Image.network(
              _uploadedFileURL,
              height: 150,
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

get_uid()async{
  FirebaseAuth auth= FirebaseAuth.instance;
  FirebaseUser current_user=await auth.currentUser();
  uid = current_user.uid;
}