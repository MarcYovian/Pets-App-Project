import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';

class MyCard extends StatefulWidget {
  final Pets pet;
  final void Function()? onPressed;
  final Widget icon;
  const MyCard(
      {super.key, required this.pet, this.onPressed, required this.icon});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 5,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                widget.pet.imagePath,
                width: MediaQuery.of(context).size.width,
                height: 125,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Gap(20),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.pet.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onPressed,
                      icon: widget.icon,
                    ),
                  ],
                ),
                Text(widget.pet.category),
                Text("${widget.pet.gender}, ${widget.pet.age} months old"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
