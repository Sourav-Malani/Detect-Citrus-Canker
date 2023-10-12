import 'package:flutter/material.dart';

class CitrusCankerRecommendationsPage_Final extends StatelessWidget {
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

              SizedBox(height: 16), // Add some space before the Final Stage ExpansionTile
              ExpansionTile(
                leading: Image.asset(
                  "assets/icons/sickle_logo.png",
                  width: 35, // Set the desired width
                  height: 35,
                  color: Colors.green,
                ),
                title: Text(
                  'Final Stage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                children: [
                  ListTile(
                    title: Text(
                      'Final Stage Recommendations:',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '1. Quarantine: At the final stage, it''s crucial to quarantine and remove the infected citrus trees from your orchard or garden to prevent further spread.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '2. Disinfection: Clean and disinfect all tools and equipment used in the affected area to prevent contamination.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '3. Monitor Nearby Trees: Keep a close watch on nearby healthy trees for any signs of infection. Take immediate action if symptoms appear.',
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      '4. Seek Expert Advice: Consider consulting with a professional agricultural extension service or horticulturist for guidance on managing the disease in its final stage.',
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