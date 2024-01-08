import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/common_widgets/my_card.dart';
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
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: petsData.length,
            itemBuilder: (context, index) {
              String petId = petsIdData[index];
              Pets pet = petsData[index];
              return _buildPetDataItem(petId, pet);
            },
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
      child: MyCard(
        pet: pet,
      ),
    );
  }
}
