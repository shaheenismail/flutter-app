import 'package:flutter/material.dart';

class SupplierHome extends StatelessWidget {
  const SupplierHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text("Suppliers",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),),
            ),
Container(
  height: size.height * 0.18,
  width: size.height * 0.18,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(15.0),
    color: Colors.red,
    
  ),
  child:  Padding(
  padding: const EdgeInsets.all(10.0),
  child: Container(
    height: size.height * 0.18,
    width: size.height * 0.18,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(15.0),
      color: Colors.white,
    ),
    
  ),
),
),
          ],
        ),
      ),
    );
  }
}