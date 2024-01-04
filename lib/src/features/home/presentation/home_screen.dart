import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/home/application/home_service.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';
import 'package:pets_shop/src/features/pets/presentation/pet_details.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController = TextEditingController();

  final HomeService _homeService = HomeService();

  searchData(String value) {}

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _homeService.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          ProfileModel profile = ProfileModel.fromMap(
              snapshot.data!.data() as Map<String, dynamic>);
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            appBar: AppBar(
              title: Text(profile.fullName),
              actions: [
                const Icon(Icons.notifications),
                const Gap(10),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, myProfileScreen);
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(60),
                    child: networkImage(profile.image),
                  ),
                ),
                const Gap(15),
              ],
              automaticallyImplyLeading: false,
            ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: CupertinoSearchTextField(
                      placeholder: "Search",
                      controller: searchController,
                      onChanged: (value) {
                        print(value);
                      },
                    ),
                  ),
                  const Center(
                    child: Text("for Category"),
                  ),
                  const Gap(10),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: StreamBuilder(
                        stream: _homeService.getAllPetsWithoutCurrentUser(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("error : ${snapshot.error}"),
                            );
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              String petId = snapshot.data!.docs[index].id;
                              DocumentSnapshot document =
                                  snapshot.data!.docs[index];
                              Pets pet = Pets.fromMap(
                                  document.data() as Map<String, dynamic>);
                              return _buildPetDataItem(petId, pet);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildPetDataItem(String petId, Pets pet) {
    return InkWell(
      radius: 10,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetails(petId: petId, pet: pet),
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.amber,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  pet.imagePath,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Gap(20),
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(pet.name),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget networkImage(String path) {
    return Image.network(
      path,
      width: 30,
      height: 30,
      fit: BoxFit.cover,
    );
  }
}
