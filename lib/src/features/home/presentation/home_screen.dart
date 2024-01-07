import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/common_widgets/my_card.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/home/application/home_service.dart';
import 'package:pets_shop/src/features/pets/data/categories_repository.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';
import 'package:pets_shop/src/features/pets/presentation/pet_details.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final HomeService _homeService = HomeService();
  final List<String> _categories = [
    'All',
    'Dog',
    'Bird',
    'Cat',
    'Hamsters',
    'Fish',
    'Rabbit',
  ];
  String _selectedCategory = "All";
  ProfileModel? profile;

  Map<String, dynamic> petData = {};

  List<Pets> _allDataPets = [];
  List<String> _allIdDataPets = [];
  List<Pets> _allSearchPetsData = [];
  List<String> _allSearchIdPetsData = [];

  @override
  void initState() {
    getClientStream();
    getPetStream();
    Future.delayed(const Duration(milliseconds: 1000));
    searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void _onSearchChanged() {
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    var showResultsId = [];

    if (searchController.text != "") {
      for (var i = 0; i < _allDataPets.length; i++) {
        var name = _allDataPets[i].name.toLowerCase();
        var category = _allDataPets[i].category.toLowerCase();
        var search = searchController.text.toLowerCase();
        if (name.contains(search) || category.contains(search)) {
          showResults.add(_allDataPets[i]);
          showResultsId.add(_allIdDataPets[i]);
        }
      }
    } else {
      showResults = List.from(_allDataPets);
      showResultsId = List.from(_allIdDataPets);
    }

    setState(() {
      _allSearchPetsData = List.from(showResults);
      _allSearchIdPetsData = List.from(showResultsId);
    });
  }

  filterPetsByCategory(String category) {
    var showResults = [];
    var showResultsId = [];

    if (_selectedCategory != "All") {
      for (var i = 0; i < _allDataPets.length; i++) {
        var categoryPet = _allDataPets[i].category;
        if (categoryPet.contains(category)) {
          showResults.add(_allDataPets[i]);
          showResultsId.add(_allIdDataPets[i]);
        }
      }
    } else {
      showResults = List.from(_allDataPets);
      showResultsId = List.from(_allIdDataPets);
    }

    setState(() {
      _allSearchPetsData = List.from(showResults);
      _allSearchIdPetsData = List.from(showResultsId);
    });
  }

  handleCategorySelection(String category) {
    setState(() {
      _selectedCategory = category;
    });

    filterPetsByCategory(category);
  }

  getClientStream() async {
    try {
      var dataUser = await _homeService.getUserData();

      setState(() {
        profile = ProfileModel.fromMap(dataUser.data() as Map<String, dynamic>);
      });
    } catch (e) {
      print(e);
    }
  }

  getPetStream() async {
    try {
      await _homeService.getAllPetsWithoutCurrentUser().then((value) {
        setState(() {
          _allIdDataPets = value['id'] as List<String>;
          _allDataPets = value['data'] as List<Pets>;
        });
      });
      filterPetsByCategory(_selectedCategory);
      searchResultList();
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // if (_allDataPets.isEmpty || _allIdDataPets.isEmpty) {
    //   return const Scaffold();
    // }

    print(_allSearchPetsData);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          profile?.fullName ?? "null",
          style: TextStyle(),
        ),
        actions: [
          const Icon(Icons.notifications),
          const Gap(10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, myProfileScreen);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: networkImage(profile?.image ??
                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
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
            // Search Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Search For A Pet",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  hintText: "Search",
                ),
              ),
            ),

            // Category
            _buildCategoryList(),

            // list view of pets
            const Gap(10),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: _allSearchPetsData.length,
                  itemBuilder: (context, index) {
                    var petId = _allSearchIdPetsData[index];
                    var pet = _allSearchPetsData[index];

                    return _buildPetDataItem(petId, pet);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildCategoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          var category = _categories[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () => handleCategorySelection(category),
              child: Column(
                children: [
                  // Icon(CupertinoIcons.cat)
                  Chip(
                    label: Text(category),
                    backgroundColor: _selectedCategory == category
                        ? Colors.blue
                        : Colors.grey.shade300,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPetDataItem(String petId, Pets pet) {
    PetsService().checkIsFavorite(petId).any((element) {
      if (element.exists) {
        print(element);
        return true;
      } else {
        print("nothing");
        return false;
      }
    });

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
      child: StreamBuilder(
          stream: PetsService().checkIsFavorite(petId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text("error");
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            return MyCard(
              pet: pet,
              icon: Icon(
                snapshot.data!.exists ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                if (snapshot.data!.exists) {
                  PetsService().removeFavoritePetData(petId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pet data was remove from favorites!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  PetsService().sendFavoritePetData(petId, pet);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content:
                          Text('Pet data was successfully add to favorites!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            );
          }),
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
