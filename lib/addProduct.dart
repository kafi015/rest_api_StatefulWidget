import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final TextEditingController ImageController = TextEditingController();
  final TextEditingController ProductCodeController = TextEditingController();
  final TextEditingController ProductNameController = TextEditingController();
  final TextEditingController QtyController = TextEditingController();
  final TextEditingController TotalPriceController = TextEditingController();
  final TextEditingController UnitPriceController = TextEditingController();

  Client httpClient = Client();

  Future<void> addNewProductToApi() async {

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');
    Response response = await httpClient.post(uri,
        headers: {
          //header e eita must dite hobe....
          'Content-type': 'application/json' // na hoy data api te jabe naaa...
        },
        body: jsonEncode({
          "Img": ImageController.text,
          "ProductCode": ProductCodeController.text,
          "ProductName": ProductNameController.text,
          "Qty": QtyController.text,
          "TotalPrice": TotalPriceController.text,
          "UnitPrice": UnitPriceController.text
        }));

    print(response.body);

    final responseJson = jsonDecode(response.body);

    if (responseJson['status'] == 'success') {

      ImageController.clear();
      ProductNameController.clear();
      ProductCodeController.clear();
      UnitPriceController.clear();
      TotalPriceController.clear();
      QtyController.clear();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product added Successfully'),backgroundColor: Colors.amber,));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product add Failed!'),backgroundColor: Colors.amber,));
    }
  }

  TextField MyTextField(lebel, controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: lebel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            MyTextField("Product Name", ProductNameController),
            SizedBox(
              height: 10,
            ),
            MyTextField("Product Code", ProductCodeController),
            SizedBox(
              height: 10,
            ),
            MyTextField("Quantity", QtyController),
            SizedBox(
              height: 10,
            ),
            MyTextField("Unit Price", UnitPriceController),
            SizedBox(
              height: 10,
            ),
            MyTextField("Total Price", TotalPriceController),
            SizedBox(
              height: 10,
            ),
            MyTextField("Image Url", ImageController),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  addNewProductToApi();
                },
                child: Text("submit")),
          ],
        ),
      ),
    );
  }
}
