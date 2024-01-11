import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:pets_shop/src/constants/checkout.dart';
import 'package:pets_shop/src/constants/route.dart';
import 'package:pets_shop/src/features/checkout/data/checkout_service.dart';
import 'package:pets_shop/src/features/checkout/domain/checkout.dart';
import 'package:pets_shop/src/features/pets/domain/pets_model.dart';
import 'package:pets_shop/src/features/profile/domain/profile_model.dart';

class CheckoutScreen extends StatefulWidget {
  final String petId;
  final Pets pet;
  final ProfileModel profile;
  const CheckoutScreen({
    super.key,
    required this.pet,
    required this.profile,
    required this.petId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum Payment { BCA, BRI, COD }

class _CheckoutScreenState extends State<CheckoutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Payment _payment = Payment.BCA;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Checkout"),
        ),
      ),
      body: StreamBuilder(
        stream: null,
        builder: (context, snapshot) {
          return Column(
            children: [
              Expanded(
                flex: 8,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 20),
                    child: Column(
                      children: [
                        // Delivery Address
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Delivery Address",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Text(
                                widget.profile.address,
                                softWrap: true,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),

                        // Payment Method
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Payment Method",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  paymentMethod(
                                    "https://i.pinimg.com/originals/29/61/0b/29610b7dbf7e4ea5070626923a12cba8.png",
                                    "Bank Central Asia",
                                    Payment.BCA,
                                  ),
                                  paymentMethod(
                                    "https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEjeXjr9tLxk36ccLwYO4m3m98zyLhfjALPaDtITFj4gG-XTLEIiNT2wasZvIsHs33UjuPzhGKzWZiL5TSVrFzaTBeiPuIYUwv7kRDEafzuVMd4MA0UI33_JzUPUiwfv9ZJoeo_l8xjmOVh-gqP0iG6qejC0Rl2aVfG49Y0QnVCDbadrR6CUdJ7rMQ/w320-h271/Bank%20BRI%20Logo.png",
                                    "Bank Rakyat Indonesia",
                                    Payment.BRI,
                                  ),
                                  paymentMethod(
                                    "https://i.pinimg.com/originals/1f/12/24/1f12246010077836ca0d49927df89996.png",
                                    "Cash On Delivery",
                                    Payment.COD,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Gap(20),

                        // Product
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "You Want to Adoption",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 15),
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
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 125,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const Gap(20),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                widget.pet.name,
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(widget.pet.category),
                                              Text(
                                                "${widget.pet.gender}, ${widget.pet.age} months old",
                                              ),
                                            ],
                                          ),
                                          const Gap(10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 12),
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                "Rp${widget.pet.price.toString()}",
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.pink,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Adoption Pet"),
                                content: const Text(
                                  "Are you sure you want to adopt this pet?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                      context,
                                      'Cancel',
                                    ),
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      var currentUser = _auth.currentUser!.uid;
                                      try {
                                        Checkout checkout = Checkout(
                                          petId: widget.petId,
                                          buyerUid: currentUser,
                                          sellerUid: widget.pet.userUid,
                                          name: widget.pet.name,
                                          category: widget.pet.category,
                                          description: widget.pet.description,
                                          age: widget.pet.age,
                                          gender: widget.pet.gender,
                                          price: widget.pet.price,
                                          imagePath: widget.pet.imagePath,
                                          status: CheckoutStatus.pending.name,
                                          buyTime: Timestamp.now(),
                                        );

                                        // var price = checkout.price;
                                        // print(price);
                                        // // print(widget.profile.email);

                                        // var doc = await FirebaseFirestore
                                        //     .instance
                                        //     .collection('saldo')
                                        //     .doc(currentUser)
                                        //     .get();
                                        // var data = doc.data();
                                        // var pengurangan =
                                        //     double.parse(data!['price']) -
                                        //         price;
                                        // print(pengurangan);
                                        await CheckoutService()
                                            .sendCheckoutData(checkout);
                                        await CheckoutService()
                                            .deletePetFromDatabase(
                                                widget.petId);
                                        Navigator.pushNamed(
                                          context,
                                          bottomNavScreen,
                                          arguments: {
                                            'index': 0,
                                          },
                                        );
                                      } catch (e) {
                                        print(e);
                                      }
                                    },
                                    child: const Text(
                                      'Adopt',
                                      style: TextStyle(
                                        color: Colors.pink,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 60,
                            vertical: 15,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.pink,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "Checkout",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  ListTile paymentMethod(String path, String paymentName, Payment value) {
    return ListTile(
      title: Row(
        children: [
          Image.network(
            path,
            width: 40,
            height: 40,
          ),
          const Gap(10),
          Text(
            paymentName,
            softWrap: true,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      leading: Radio(
        value: value,
        groupValue: _payment,
        onChanged: (value) {
          setState(() {
            _payment = value!;
          });
        },
      ),
    );
  }
}
