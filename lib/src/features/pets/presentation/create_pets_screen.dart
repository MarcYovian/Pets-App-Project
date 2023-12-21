import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_shop/src/common_widgets/my_button.dart';
import 'package:pets_shop/src/common_widgets/my_dropdown_menu.dart';
import 'package:pets_shop/src/common_widgets/my_text_field.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/pets/data/categories_repository.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';

class CreatePetsScreen extends StatefulWidget {
  const CreatePetsScreen({super.key});

  @override
  State<CreatePetsScreen> createState() => _CreatePetsScreenState();
}

class _CreatePetsScreenState extends State<CreatePetsScreen> {
  final PetsService _petsService = PetsService();
  File? imageFile;
  String? imagePath;

  final _picker = ImagePicker();

  Future<void> _openImagePicker() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
        // imgName = basename
      });
    }
  }

  String? categoriesValue = CategoriesRepository.categoriesPets.first;
  String? genderValue = CategoriesRepository.petGender.first;

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final categoriesController = TextEditingController();
  final genderController = TextEditingController();

  void sendPetData() async {
    await _petsService.sendPetsData(
      nameController.text,
      categoriesController.text,
      descriptionController.text,
      int.parse(ageController.text),
      genderController.text,
      double.parse(priceController.text),
      imagePath!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Pets"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _openImagePicker,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: imageFile == null
                          ? Border.all(
                              color: Colors.black54,
                              style: BorderStyle.solid,
                              width: 2.0,
                            )
                          : null,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: imageFile == null
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.photo,
                                    size: 48.0, color: Colors.black54),
                                SizedBox(height: 8.0),
                                Text(
                                  'Select Image',
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ],
                            ),
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              imageFile!,
                              height: 200.0,
                              width: 200.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const Gap(10),

                // Pets Name
                MyTextField(
                  controller: nameController,
                  hintText: "Pet Name",
                  obscureText: false,
                  keyboardType: TextInputType.name,
                ),
                const Gap(10),

                // Pets age
                MyTextField(
                  controller: ageController,
                  hintText: "Pet's Age (months)",
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const Gap(10),

                // pets Categories
                MyDropdownMenu(
                  dropdownMenuEntries: CategoriesRepository.categoriesPets,
                  controller: categoriesController,
                ),
                const Gap(10),

                // pets gender
                MyDropdownMenu(
                  dropdownMenuEntries: CategoriesRepository.petGender,
                  controller: genderController,
                ),
                const Gap(10),

                // Pets description
                MyTextField(
                  controller: descriptionController,
                  hintText: "Pet description",
                  obscureText: false,
                  keyboardType: TextInputType.text,
                ),
                const Gap(10),

                // Pets price
                MyTextField(
                  controller: priceController,
                  hintText: "Adopt Price",
                  obscureText: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const Gap(10),

                MyButton(
                  onTap: () async {
                    if (imageFile == null ||
                        nameController.text.isEmpty ||
                        ageController.text.isEmpty ||
                        categoriesController.text.isEmpty ||
                        genderController.text.isEmpty ||
                        descriptionController.text.isEmpty ||
                        priceController.text.isEmpty) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              "Error",
                              style: TextStyle(color: Colors.white24),
                            ),
                            content: const Text(
                              "Please fill in all the fields",
                              style: TextStyle(color: Colors.white24),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  "OK",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                            backgroundColor: Colors.orangeAccent,
                          );
                        },
                      );
                    } else {
                      uploadFile().then((value) {
                        imagePath = value;
                        sendPetData();
                      }).catchError((e) {
                        print("Error: $e");
                      });
                      Navigator.pushNamed(context, myPetsScreen);
                    }
                  },
                  text: "Submit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> uploadFile() async {
    try {
      final imageName =
          "${DateTime.now().microsecondsSinceEpoch.toString()}-${imageFile!.path.split(Platform.pathSeparator).last}";
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDireImages = referenceRoot.child('images');
      Reference referenceImageToUpload = referenceDireImages.child(imageName);
      final metadata = SettableMetadata(contentType: "image/jpeg");

      final uploadTask =
          referenceImageToUpload.putFile(File(imageFile!.path), metadata);

      await uploadTask; // Wait for the upload to complete

      final imageUrl = await referenceImageToUpload.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception(e);
    }
  }
}
