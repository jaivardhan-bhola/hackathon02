import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Null isRice = null;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Crop Disease Prediction',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/backgrounds/Home.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                SizedBox(height: screenHeight * 0.02),
                Text('Choose crop type',
                    style: TextStyle(
                        fontSize: screenHeight * 0.04, color: Colors.black)),
                SizedBox(height: screenHeight * 0.02),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/Disease');
                  },
                  child: Container(
                    width: screenWidth * 0.8,
                    height: screenHeight * 0.15,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary,
                            width: screenWidth * 0.01)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.02),
                              child: Image.asset('assets/icons/rice.png')),
                        ),
                        Text(
                          "Rice",
                          style: TextStyle(fontSize: screenHeight * 0.04),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight*0.02),
                
                Icon(Icons.upload_rounded, size: screenHeight*0.2, color: Theme.of(context).colorScheme.primary,),
              
              ],
            ),
          ),
        ],
      ),
    );
  }
}
