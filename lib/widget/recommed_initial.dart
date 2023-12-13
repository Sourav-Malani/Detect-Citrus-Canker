import 'package:flutter/material.dart';

class CitrusCankerRecommendationsPageInitial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Check if dark mode is enabled
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define the background color based on the theme mode
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: Text('Citrus Canker Recommendations'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: backgroundColor, // Set the background color based on theme mode
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Citrus Canker Recommendations',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor, // Set text color based on theme mode
                ),
              ),
              SizedBox(height: 16),
              _buildRecommendation(
                '1. Isolate the Infected Plant:',
                'Move the infected plant away from healthy citrus trees to prevent the disease from spreading.',
                textColor,
              ),
              _buildRecommendation(
                '2. Prune Affected Branches:',
                'Carefully prune and remove the affected branches. Disinfect your pruning tools between cuts to avoid spreading the bacteria.',
                textColor,
              ),
              _buildRecommendation(
                '3. Dispose of Debris Properly:',
                'Bag and dispose of pruned branches, leaves, and fruit in a sealed plastic bag. Do not compost or leave debris on the ground.',
                textColor,
              ),
              _buildRecommendation(
                '4. Apply Copper-based Fungicide:',
                'Spray a copper-based fungicide on the remaining healthy parts of the plant to prevent further infection.',
                textColor,
              ),
              SizedBox(height: 16), // Add some space before the ExpansionTile
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/spray.png",
                  width: 35, // Set the desired width
                  height: 35,
                ),
                title: Text(
                  'Initial Stage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Initial Stage Recommendations:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '1. Early Detection: Regularly inspect your citrus trees for any signs of citrus canker, including lesions or pustules on leaves, fruit, or stems. Early detection is key to preventing the disease from spreading.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '2. Pruning: Prune and remove infected plant parts as soon as you notice them. Use clean, disinfected pruning tools to avoid spreading the bacteria further.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '3. Dispose Properly: Properly dispose of the infected plant material by burning it or placing it in sealed plastic bags and sending it to a landfill.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '4. Copper-based Sprays: Apply copper-based fungicides or bactericides to affected areas. These treatments can help slow down the progression of the disease.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '5. Maintain Good Hygiene: Practice good hygiene when handling citrus trees. Clean your hands and tools between handling different trees to prevent cross-contamination.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '6. Isolation: Isolate infected trees from healthy ones to prevent the spread of the disease within your orchard or garden.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendation(String title, String description, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(fontSize: 16, color: textColor),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}