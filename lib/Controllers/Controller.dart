import 'dart:async';
import 'dart:io' show Platform;
import 'package:in_app_purchase/in_app_purchase.dart';

class InAppPurchase {
  static InAppPurchaseConnection _inAppPurchaseConnectionInstance;
  static InAppPurchase _inAppPurchaseInstance;
  List<PurchaseDetails> _pastPurchases;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  static InAppPurchase get instance {
    if (_inAppPurchaseInstance == null) {
      _inAppPurchaseInstance = InAppPurchase();
    }
    if (_inAppPurchaseConnectionInstance == null) {
      _inAppPurchaseConnectionInstance = InAppPurchaseConnection.instance;
    }
    return _inAppPurchaseInstance;
  }

  Future<List<ProductDetails>> retrieveProducts(
      {List<String> productsIDs,}) async {
    assert(_inAppPurchaseConnectionInstance != null);
    assert(_inAppPurchaseInstance != null);
    final bool available = await _inAppPurchaseConnectionInstance.isAvailable();
    if (!available) {
      //TODO: Handle store not available
      return Future.error(null);
    } else {
      Set<String> _productIDs =
          productsIDs?.toSet() ?? <String>['id_one', 'id_two'].toSet();
      final ProductDetailsResponse response =
          await _inAppPurchaseConnectionInstance
              .queryProductDetails(_productIDs);
      if (response.notFoundIDs.isNotEmpty) {
        //TODO: Handle not found products IDs
        return Future.error(null);
      }
      if (response.error != null) {
        //TODO: handle products retrial response error
        return Future.error(null);
      }
      return Future<List<ProductDetails>>(() => response.productDetails);
    }
  }

  void purchaseItem(
    ProductDetails productDetails,
  ) {
    assert(_inAppPurchaseConnectionInstance != null);
    assert(_inAppPurchaseInstance != null);
    final PurchaseParam purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    if (Platform.isIOS &&
            productDetails.skProduct.subscriptionPeriod != null) {
      _inAppPurchaseConnectionInstance.buyConsumable(
        purchaseParam: purchaseParam,
      );
    } else {
      _inAppPurchaseConnectionInstance.buyNonConsumable(
        purchaseParam: purchaseParam,
      );
    }
  }

  Future<List<PurchaseDetails>> getPastPurchases() async {
    assert(_inAppPurchaseConnectionInstance != null);
    assert(_inAppPurchaseInstance != null);
    QueryPurchaseDetailsResponse response =
        await _inAppPurchaseConnectionInstance.queryPastPurchases();
    for (PurchaseDetails purchase in response.pastPurchases) {
      if (Platform.isIOS) {
        _inAppPurchaseConnectionInstance.completePurchase(purchase);
      }
    }
    if (_pastPurchases == null) _pastPurchases = response.pastPurchases;
    return Future<List<PurchaseDetails>>(() => response.pastPurchases);
  }

  void verifyPurchase(
    String productID,
  ) {
    assert(_inAppPurchaseConnectionInstance != null);
    assert(_inAppPurchaseInstance != null);
    PurchaseDetails purchase = _hasPurchased(productID);

    // TODO: record in the database
    if (purchase != null) {
    } else {
      //TODO: handle user's never purchased situation
    }
  }

  void consumeProduct(
    ProductDetails product,
    Function(BillingResultWrapper) onConsume, {
    bool isPastPurchasesInitialized = true,
  }) async {
    assert(_inAppPurchaseConnectionInstance != null);
    assert(_inAppPurchaseInstance != null);
    //TODO update the state of the consumable to a backend database
      var res =
          await _inAppPurchaseConnectionInstance.consumePurchase(purchase);
      if (onConsume != null) onConsume(res);
    }
  }


}
