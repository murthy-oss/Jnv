import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:full_picker/full_picker.dart';

import 'package:jnvapp/AuthScreens/utils.dart';



class FilePickerTest extends StatefulWidget {
  const FilePickerTest({super.key});

  @override
  State<FilePickerTest> createState() => _ExonFilePicker();
}

class _ExonFilePicker extends State<FilePickerTest> {
  ValueNotifier<double> onProgress = ValueNotifier<double>(0);

  String info = 'Not Selected !';

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Full Picker Example')),
        body: Column(
          children: <Widget>[
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Open Full Picker',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
              onPressed: () {
                FullPicker(
                  context: context,
                  prefixName: 'test',
                  file: true,
                  voiceRecorder: true,
                  video: true,
                  videoCamera: true,
                  imageCamera: true,
                  imageCropper: true,
                  multiFile: true,
                  url: true,
                  onError: (final int value) {
                    if (kDebugMode) {
                      print(' ----  onError ----=$value');
                    }
                  },
                  onSelected: (final FullPickerOutput value) {
                    if (kDebugMode) {
                      print(' ----  onSelected ----');
                    }

                    if (value.fileType != FullPickerType.url) {
                      info = '';
                      for (int i = 0; i < value.name.length; i++) {
                        info =
                            '${info}File Type :${value.fileType}\nPath File :${value.name[i]}\nSize File :${fileSize(value.bytes[i]!)}\n--------\n';
                      }
                    } else {
                      info = value.data as String;
                    }

                    setState(() {});
                  },
                );
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Output :\n\n$info',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}