import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/pets/data/pets_service.dart';

class MyPetsScreen extends StatefulWidget {
  const MyPetsScreen({super.key});

  @override
  State<MyPetsScreen> createState() => _MyPetsScreenState();
}

class _MyPetsScreenState extends State<MyPetsScreen> {
  final PetsService _petsService = PetsService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("My Pets"),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, addPetsScreen);
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            const Center(
              child: Text("Colont"),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // height: ,
                width: MediaQuery.of(context).size.width,
                // color: Colors.blue,
                child: StreamBuilder(
                  stream: _petsService.getAllPetsByCurrentUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text(
                        "Error: ${snapshot.error}",
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Waiting");
                    }

                    return GridView(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 250,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 10,
                      ),
                      children: snapshot.data!.docs
                          .map((document) => _buildPetDataItem(document))
                          .toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPetDataItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    return Container(
      width: 160,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 5,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: GestureDetector(
        onTap: () {},
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  data['imagePath'],
                  width: MediaQuery.of(context).size.width,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              Text(
                data['name'],
                style: const TextStyle(
                  color: Color(0xFFFC6011),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
