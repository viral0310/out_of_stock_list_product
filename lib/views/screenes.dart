import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../provider/add_to_cart.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImagePicker picker = ImagePicker();
  late Future<List<Product>> getAllStudents;
  final GlobalKey<FormState> insertFormKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final TextEditingController cityController = TextEditingController();
  late bool isAdded = false;
  String? name;
  int? price;
  int? quantity;
  Uint8List? image;
  Uint8List? result;
  List<Product> products = [];
  int lenght = 0;
  int second = 30;
  Timer? timer;
  List<Product> isTR = [];
  List<Product> isFL = [];
  int IsSecond() {
    timer = Timer.periodic(Duration(seconds: 2), (_) {
      setState(() {
        second--;
      });
    });
    return second;
  }
/*  IsTimer(int id) {
    Timer(
      Duration(seconds: 20),
      () {
        setState(() {
          ++seconds;
              if (seconds == 5) {
            quantity = 0;
            print(quantity);
          }
        });
        //    DBHelper.dbHelper.deleteRecord(id: id);
      },
    );
  }*/

  @override
  void initState() {
    super.initState();
    //  getAllStudents = DBHelper.dbHelper.fetchAllRecords();
    getAllStudents =
        Provider.of<ProductProvider>(context, listen: false).fetchAllRecords();
    IsSecond();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Out of Stock List of Product"),
        centerTitle: true,
        leading: Center(
          child: Text("$second"),
        ),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text("$lenght"), const Icon(Icons.add_shopping_cart)],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 14,
            child: FutureBuilder(
              future: getAllStudents,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("${snapshot.error}"),
                  );
                } else if (snapshot.hasData) {
                  List<Product> data = snapshot.data as List<Product>;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, i) {
                      int qya = data[i].quantity;
                      data[i].isTrue = false;
                      return Card(
                        elevation: 3,
                        child: ListTile(
                          onTap: () async {
                            int a = IsSecond();
                            if (data[i].isTrue == false && a <= 20) {
                              print("done");
                              int resId = await Provider.of<ProductProvider>(
                                      context,
                                      listen: false)
                                  .updateRecord(
                                      quantity: 0,
                                      name: data[i].name,
                                      id: data[i].id!,
                                      price: data[i].price);

                              if (resId == 1) {
                                print("----------------------------");
                                print("Recorded update successfully");
                                print("----------------------------");

                                getAllStudents = Provider.of<ProductProvider>(
                                        context,
                                        listen: false)
                                    .fetchAllRecords();
                              } else {
                                print("----------------------------");

                                print("Recorded deletion failed.....");
                                print("----------------------------");
                              }
                            }
                          },

                          /*leading: (result != "")
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(
                                    scale: 1,
                                    data[i].image!,
                                  ),
                                )
                              : const CircleAvatar(),*/
                          title: Text(data[i].name),
                          subtitle: Text(
                              "Price = ${data[i].price}\nQuantity = ${qya}"),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  products.add(data[i]);
                                  setState(() {
                                    lenght = products.length;
                                  });
                                  //IsTimer(data[i].id!);
                                  data[i].isTrue = true;
                                  int a = IsSecond();
                                  print(data[i].isTrue);
                                  if (data[i].isTrue == true && a <= 20) {
                                    print("done");
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("change Record's"),
                                          content: const Text(
                                            "Are you sure to change the quality?",
                                          ),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: () async {
                                                  int resId = await Provider.of<
                                                              ProductProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateRecord(
                                                          quantity:
                                                              data[i].quantity,
                                                          name: data[i].name,
                                                          id: data[i].id!,
                                                          price: data[i].price);

                                                  if (resId == 1) {
                                                    print(
                                                        "----------------------------");
                                                    print(
                                                        "Recorded update successfully");
                                                    print(
                                                        "----------------------------");

                                                    getAllStudents = Provider
                                                            .of<ProductProvider>(
                                                                context,
                                                                listen: false)
                                                        .fetchAllRecords();
                                                  } else {
                                                    print(
                                                        "----------------------------");

                                                    print(
                                                        "Recorded deletion failed.....");
                                                    print(
                                                        "----------------------------");
                                                  }
                                                },
                                                child:
                                                    const Text("Add to cart")),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text("Cancel"))
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text("Delete Record's"),
                                        content: const Text(
                                          "Are you sure to delete the record?",
                                        ),
                                        actions: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                int resId = await Provider.of<
                                                            ProductProvider>(
                                                        context,
                                                        listen: false)
                                                    .deleteRecord(
                                                        id: data[i].id!);

                                                if (resId == 1) {
                                                  print(
                                                      "----------------------------");
                                                  print(
                                                      "Recorded deleted successfully");
                                                  print(
                                                      "----------------------------");

                                                  getAllStudents = Provider.of<
                                                              ProductProvider>(
                                                          context,
                                                          listen: false)
                                                      .fetchAllRecords();
                                                } else {
                                                  print(
                                                      "----------------------------");

                                                  print(
                                                      "Recorded deletion failed.....");
                                                  print(
                                                      "----------------------------");
                                                }
                                              },
                                              child: const Text("Delete")),
                                          ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text("Cancel"))
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          isThreeLine: true,
                        ),
                      );
                    },
                  );
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ValidateAndInsert();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void ValidateAndInsert() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Add Record"),
        ),
        content: Form(
          key: insertFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  XFile? xFile =
                      await picker.pickImage(source: ImageSource.gallery);
                  image = await xFile!.readAsBytes();
                  result = await FlutterImageCompress.compressWithList(
                    image!,
                    minHeight: 1920,
                    minWidth: 1080,
                    quality: 96,
                    rotate: 180,
                  );
                },
                child: const Text("Pick Image"),
              ),
              TextFormField(
                controller: nameController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter name first" : null;
                },
                onSaved: (val) {
                  setState(
                    () {
                      name = val;
                    },
                  );
                },
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: priceController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter price first" : null;
                },
                onSaved: (val) {
                  setState(
                    () {
                      price = int.parse(val!);
                    },
                  );
                },
                decoration: const InputDecoration(labelText: "price"),
              ),
              TextFormField(
                controller: quantityController,
                validator: (val) {
                  return (val!.isEmpty) ? "Enter Quantity first" : null;
                },
                onSaved: (val) {
                  setState(
                    () {
                      quantity = int.parse(val!);
                    },
                  );
                },
                decoration: const InputDecoration(labelText: "quantity"),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (insertFormKey.currentState!.validate()) {
                insertFormKey.currentState!.save();

                /* int id = await DBHelper.dbHelper.insertRecord(
                    name: name!,
                    price: price!,
                    image: result!,
                    quantity: quantity!);*/
                int id =
                    await Provider.of<ProductProvider>(context, listen: false)
                        .insertRecord(
                            name: name!,
                            price: price!,
                            image: result!,
                            quantity: quantity!);

                if (id > 0) {
                  print("--------------------------------");
                  print("Recorde inserted successfully with id of $id");
                  print("---------------------------------");

                  setState(
                    () {
                      getAllStudents =
                          Provider.of<ProductProvider>(context, listen: false)
                              .fetchAllRecords();
                    },
                  );
                } else {
                  print("---------------------------------");
                  print("Record inserted failed.........");
                  print("----------------------------------");
                }
              }

              nameController.clear();
              priceController.clear();
              quantityController.clear();

              setState(() {
                name = null;
                price = null;
                quantity = null;
                image = null;
              });
              Navigator.of(context).pop();
            },
            child: const Text("Insert"),
          ),
          ElevatedButton(
              onPressed: () {
                nameController.clear();
                priceController.clear();
                quantityController.clear();
                setState(
                  () {
                    name = null;
                    price = null;
                    quantity = null;
                    image = null;
                  },
                );
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"))
        ],
      ),
    );
  }
}
