import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';

void main() {
  runApp(
    MaterialApp(
      home: PaymentScreen(),
    ),
  );
}

class PaymentScreen extends StatelessWidget {
  ///=================== PayPal Payment Method ====================
  void startPayPalPayment(
    BuildContext context, {
    required double amount,
  }) {
    var transactions = [
      {
        "amount": {
          "total": amount.toStringAsFixed(2),
          "currency": "USD",
        },
        "description": "Test Payment for PayPal",
      }
    ];

    PaypalCheckoutView(
      clientId:
          "Af2ARcfIrqb7Jd0cfKHH_Mlw1HEsPZD-L8dkkpFZLpBGQMNHN8-vKLHqqieKYmee46DO4EcFSHL6eQgD",
      // Replace with your PayPal client ID
      sandboxMode: false,
      secretKey:
          "EE3vsp4cNu0icv83qcxljtYncxo362hmo42-JXMwN7OmiMsuGGEXecO_AWCYCN79RcTSlCBiUJCvyM4e",
      // Replace with your PayPal secret key
      transactions: transactions,
      note: "Contact us for any questions.",
      onSuccess: (Map params) {
        // Show success message and close the payment view
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Completed Successfully')),
        );

        // Extract transaction details from params
        String orderId = params['data']['cart'];
        String transactionId = params['data']['transactions'][0]
            ['related_resources'][0]['sale']['id'];

        // Log PayPal transaction details
        if (kDebugMode) {
          print("Order ID: $orderId, Transaction ID: $transactionId");
        }

        Navigator.pop(context); // Close the payment screen
      },
      onError: (error) {
        // Show error message and close the payment view
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong, Try again!')),
        );
        if (kDebugMode) {
          print("Error: $error");
        }
        Navigator.pop(context);
      },
      onCancel: () {
        // Show cancel message and close the payment view
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment cancelled')),
        );
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PayPal Payment Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            startPayPalPayment(
              context,
              amount: 100.0, // Test amount
            );
          },
          child: Text("Test PayPal Payment"),
        ),
      ),
    );
  }
}
