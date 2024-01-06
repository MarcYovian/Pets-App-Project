import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';
import 'package:pets_shop/src/features/pets/presentation/pet_details.dart';

class FavoritePets extends StatefulWidget {
  const FavoritePets({super.key});

  @override
  State<FavoritePets> createState() => _FavoritePetsState();
}

class _FavoritePetsState extends State<FavoritePets> {
  final PetsService _petsService = PetsService();

  List<Pets> petsData = [];
  List<String> petsIdData = [];

  @override
  void initState() {
    // todo
    getFavoriteDataStream();
    super.initState();
  }

  getFavoriteDataStream() async {
    var data = await _petsService.getFavoritePetData();
    setState(() {
      petsData = data.docs
          .map((e) => Pets.fromMap(e.data() as Map<String, dynamic>))
          .toList();
      petsIdData = data.docs.map((e) => e.id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("My Favorite"),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 75,
                child: Center(
                  child: Text("Buat category"),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: petsData.length,
                itemBuilder: (context, index) {
                  String petId = petsIdData[index];
                  Pets pet = petsData[index];
                  return _buildPetDataItem(petId, pet);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetDataItem(String petId, Pets pet) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetails(pet: pet, petId: petId),
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
}
