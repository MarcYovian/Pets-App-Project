import 'package:flutter/material.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';

class MyGridView extends StatefulWidget {
  final List<Pets> listPets;
  const MyGridView({super.key, required this.listPets});

  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: widget.listPets.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 175,
        mainAxisSpacing: 5,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container(
          width: 100,
          height: 100,
          color: Colors.amber,
          child: Center(
            child: Text(
              widget.listPets[index].age.toString(),
            ),
          ),
          // print("testing");
        );
      },
    );
  }
}
