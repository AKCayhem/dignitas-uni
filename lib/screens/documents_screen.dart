import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  DocumentsScreen({super.key});

  final List<Map<String, dynamic>> categories = [
    {'title': 'Inscription', 'icon': Icons.app_registration, 'count': 5},
    {'title': 'Bourses et Aides', 'icon': Icons.monetization_on, 'count': 3},
    {'title': 'Stages', 'icon': Icons.work, 'count': 4},
    {'title': 'Règlement intérieur', 'icon': Icons.gavel, 'count': 2},
    {'title': 'Calendrier universitaire', 'icon': Icons.calendar_today, 'count': 1},
    {'title': 'Examens et rattrapages', 'icon': Icons.school, 'count': 6},
    {'title': 'Procédures administratives', 'icon': Icons.description, 'count': 8},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents officiels'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final cat = categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue[100],
                child: Icon(cat['icon'], color: Colors.blue),
              ),
              title: Text(cat['title'], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${cat['count']} documents'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // In a real app, navigate to document list
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ouverture de la catégorie "${cat['title']}" (simulation)')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}