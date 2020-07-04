import 'package:flutter/material.dart';
import 'package:flutter_in_app_purchase/Controllers/Controller.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final InAppPurchase _iap = InAppPurchase.instance;

  @override
  void initState() {
    _iap.purchaseStatusStreamSubscription(
      onListen: (_) {
        print("NEW PURCHASE");
      },
      onError: (error) {
        print("ERROR");
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text("In-App-Purchase"),
      ),
      body: Row(
        children: [
          Expanded(
            child: FutureBuilder<List<ProductDetails>>(
              future: _iap.retrieveProducts(),
              initialData: List<ProductDetails>(),
              builder: (context, products) {
                if (products.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: PlatformCircularProgressIndicator(),
                  );
                }
                if (products.hasData && products.data.length != 0) {
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: products.data.map((itemProduct) {
                        return buildProductRow(itemProduct);
                      }).toList(),
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProductRow(ProductDetails productDetail) {
    return Container(
      padding: EdgeInsets.all(20),
      child: GestureDetector(
        onTap: () {
          try {
            _iap.consumeProduct(productDetail, (_) {},
                isPastPurchasesInitialized: false);
          } catch (e) {
            print(e);
          }
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    productDetail.title,
                    style: TextStyle(color: Colors.black),
                  ),
                  Text(
                    productDetail.description,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
            RaisedButton(
              color: Colors.green,
              child: Text(
                productDetail.price,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () => _iap.purchaseItem(productDetail),
            )
          ],
        ),
      ),
    );
  }
}
