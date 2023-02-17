import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rest_api_implementation/addProduct.dart';
import 'package:rest_api_implementation/productListModel.dart';

class ProductList extends StatefulWidget {
  const ProductList({Key? key}) : super(key: key);

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final Client httpClient = Client();
  ProductListModel productListModel = ProductListModel();
  bool dataLoadingProgress = false;

  Future<void> getProductListFromApi() async {
    dataLoadingProgress = true;

    setState(() {});

    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await httpClient.get(uri);
    productListModel = ProductListModel.fromJson(jsonDecode(response.body));
    print(productListModel.status);
    print(productListModel.data?.length ?? '0');

    dataLoadingProgress = false;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getProductListFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product List"),
        centerTitle: true,
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProduct()));
        },
        child: Icon(Icons.add),
      ),


      body: RefreshIndicator(
        onRefresh: () async {
          getProductListFromApi();
        },
        child: dataLoadingProgress
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
                itemCount: productListModel.data?.length ?? 0,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.amber[300],
                    child: ListTile(
                      title:
                          Text(productListModel.data?[index].title ?? 'Unknown'),
                      subtitle: Text(
                          "Brand: ${productListModel.data?[index].brand ?? 'Unknown'}"),
                      leading: Text(
                          "ID: ${productListModel.data?[index].id ?? 'Unknown'}"),
                      trailing: Text(
                          "Price: ${productListModel.data?[index].price ?? 'Unknown'}"),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
