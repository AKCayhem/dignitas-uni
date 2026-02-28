import 'package:flutter/material.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  String _selectedType = 'attestation';
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _numeroController = TextEditingController();
  final _motifController = TextEditingController(); // for réclamation
  final _entrepriseController = TextEditingController(); // for stage
  String? _generatedText;

  final List<String> _types = ['attestation', 'réclamation', 'stage'];

  void _generate() {
    if (_formKey.currentState!.validate()) {
      String text = '';
      switch (_selectedType) {
        case 'attestation':
          text = '''Objet : Demande d'attestation de scolarité

Bonjour,

Je soussigné(e) ${_nomController.text} ${_prenomController.text} (numéro étudiant : ${_numeroController.text}) sollicite une attestation de scolarité pour l'année universitaire en cours.

Dans l'attente de votre retour, je vous remercie par avance.

Cordialement,
${_nomController.text} ${_prenomController.text}''';
          break;
        case 'réclamation':
          text = '''Objet : Réclamation concernant ${_motifController.text}

Bonjour,

Je me permets de vous adresser cette réclamation concernant : ${_motifController.text}.

Étudiant(e) : ${_nomController.text} ${_prenomController.text} (${_numeroController.text})

Je vous remercie de prendre en compte ma demande.

Cordialement,
${_nomController.text} ${_prenomController.text}''';
          break;
        case 'stage':
          text = '''Objet : Demande de convention de stage

Bonjour,

Je souhaite effectuer un stage au sein de l'entreprise ${_entrepriseController.text} du [date début] au [date fin].

Étudiant(e) : ${_nomController.text} ${_prenomController.text} (${_numeroController.text})

Merci de bien vouloir me faire parvenir la convention de stage.

Cordialement,
${_nomController.text} ${_prenomController.text}''';
          break;
      }
      setState(() {
        _generatedText = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer un document'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                items: _types.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.capitalize()));
                }).toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: const InputDecoration(labelText: 'Type de document'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prénom'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              TextFormField(
                controller: _numeroController,
                decoration: const InputDecoration(labelText: 'Numéro étudiant'),
                validator: (v) => v!.isEmpty ? 'Requis' : null,
              ),
              if (_selectedType == 'réclamation') ...[
                TextFormField(
                  controller: _motifController,
                  decoration: const InputDecoration(labelText: 'Motif de la réclamation'),
                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                ),
              ],
              if (_selectedType == 'stage') ...[
                TextFormField(
                  controller: _entrepriseController,
                  decoration: const InputDecoration(labelText: 'Nom de l\'entreprise'),
                  validator: (v) => v!.isEmpty ? 'Requis' : null,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _generate,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 45)),
                child: const Text('Générer'),
              ),
              const SizedBox(height: 20),
              if (_generatedText != null) ...[
                const Text('Document généré :', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SelectableText(_generatedText!),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // Copy to clipboard simulation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Copié dans le presse-papier (simulation)')),
                        );
                      },
                      icon: const Icon(Icons.copy),
                      label: const Text('Copier'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        // Send email simulation
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Email prêt à être envoyé (simulation)')),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Envoyer'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}