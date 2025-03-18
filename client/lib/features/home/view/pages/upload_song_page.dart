import 'dart:io';

import 'package:client/core/theme/app_pallate.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final _songName = TextEditingController();
  final _artistName = TextEditingController();
  Color selectedColor = Colors.red;
  File? selectedImage;
  File? selectedAudio;

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Song')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GestureDetector(
                onTap: selectImage,
                child:
                    selectedImage != null
                        ? Image.file(selectedImage!)
                        : DottedBorder(
                          color: Pallete.borderColor,
                          radius: Radius.circular(10),
                          borderType: BorderType.RRect,
                          dashPattern: [10, 5],
                          strokeCap: StrokeCap.round,
                          child: SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.folder_open, size: 40),
                                Text(
                                  'Select the thumbnail',
                                  style: TextStyle(fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        ),
              ),
              const SizedBox(height: 20),
              selectedAudio != null
                  ? AudioWave(path: selectedAudio!.path)
                  : CustomField(
                    hintText: 'Pick a song',
                    controller: null,
                    readOnly: true,
                    onTap: () {
                      setState(() {
                        selectAudio();
                      });
                    },
                  ),
              const SizedBox(height: 20),
              CustomField(hintText: 'Artist', controller: _artistName),
              const SizedBox(height: 20),
              CustomField(hintText: 'Song name', controller: _songName),
              const SizedBox(height: 20),
              ColorPicker(
                pickersEnabled: const {ColorPickerType.wheel: true},
                color: selectedColor,
                onColorChanged: (Color color) {
                  //setState(() {
                  selectedColor = color;
                  //});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
