import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class MyBusinessDocumentsScreen extends StatefulWidget {
  const MyBusinessDocumentsScreen({super.key});

  @override
  State<MyBusinessDocumentsScreen> createState() =>
      _MyBusinessDocumentsScreenState();
}

class _MyBusinessDocumentsScreenState extends State<MyBusinessDocumentsScreen> {
  final _formKey = GlobalKey<FormState>();

  final _ideaController = TextEditingController();
  final _industryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();

  bool _loading = true;
  bool _saving = false;

  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _loadBusinessIdea();
  }

  Future<void> _loadBusinessIdea() async {
    final uid = _uid;

    if (uid == null) {
      if (mounted) {
        setState(() => _loading = false);
      }
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      final data = snapshot.data() ?? <String, dynamic>{};

      if (!mounted) return;

      _ideaController.text = (data['businessIdea'] ?? '').toString();
      _industryController.text = (data['industry'] ?? '').toString();
      _descriptionController.text = (data['businessDescription'] ?? '')
          .toString();

      _locationController.text = (data['location'] ?? data['town'] ?? '')
          .toString();

      setState(() => _loading = false);
    } catch (error) {
      if (!mounted) return;

      setState(() => _loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load business idea: $error')),
      );
    }
  }

  Future<void> _saveBusinessIdea() async {
    if (!_formKey.currentState!.validate()) return;

    final uid = _uid;

    if (uid == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please log in first.')));
      return;
    }

    setState(() => _saving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'businessIdea': _ideaController.text.trim(),
        'industry': _industryController.text.trim(),
        'businessDescription': _descriptionController.text.trim(),
        'location': _locationController.text.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Business idea saved successfully!')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save business idea: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<Uint8List> _generateBusinessIdeaPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          pw.Text(
            'RURAL SPARK',
            style: pw.TextStyle(
              fontSize: 26,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'BUSINESS IDEA SUMMARY',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),

          _pdfSection('Business Idea', _ideaController.text),
          _pdfSection('Industry', _industryController.text),
          _pdfSection('Business Description', _descriptionController.text),
          _pdfSection('Business Location', _locationController.text),

          pw.SizedBox(height: 30),
          pw.Divider(),
          pw.Text(
            'Prepared using Rural Spark.',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'This document is a business planning summary and '
            'does not constitute official business registration.',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfSection(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 18),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 6),
          pw.Text(
            value.trim().isEmpty ? 'Not provided' : value.trim(),
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Future<void> _viewPdf() async {
    if (_ideaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your business idea first.')),
      );
      return;
    }

    await Printing.layoutPdf(
      onLayout: (format) => _generateBusinessIdeaPdf(),
      name: 'Rural_Spark_Business_Idea.pdf',
    );
  }

  @override
  void dispose() {
    _ideaController.dispose();
    _industryController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Business Documents')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Business Idea Summary',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Edit your business idea, save your changes, '
                          'and generate a PDF document.',
                        ),
                        const SizedBox(height: 24),

                        TextFormField(
                          controller: _ideaController,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: 'Business Idea',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Please enter your business idea'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _industryController,
                          decoration: const InputDecoration(
                            labelText: 'Industry',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            labelText: 'Business Description',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _locationController,
                          decoration: const InputDecoration(
                            labelText: 'Business Location',
                            border: OutlineInputBorder(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saving ? null : _saveBusinessIdea,
                            icon: const Icon(Icons.save_outlined),
                            label: Text(
                              _saving ? 'Saving...' : 'Save Business Idea',
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: _viewPdf,
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text('View / Download PDF'),
                          ),
                        ),

                        const SizedBox(height: 20),

                        const Text(
                          'Save your changes before generating a PDF '
                          'to keep your document and Firebase information '
                          'consistent.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
