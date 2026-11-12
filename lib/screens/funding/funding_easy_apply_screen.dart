import '../../services/business_plan_pdf_service.dart';

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Prepares an application in Rural Spark. Does NOT submit to the funder.
class FundingEasyApplyScreen extends StatefulWidget {
  const FundingEasyApplyScreen({super.key, required this.programme});
  final String programme;

  @override
  State<FundingEasyApplyScreen> createState() => _FundingEasyApplyScreenState();
}

class _FundingEasyApplyScreenState extends State<FundingEasyApplyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _location = TextEditingController();
  final _business = TextEditingController();
  final _industry = TextEditingController();
  final _description = TextEditingController();
  final _amount = TextEditingController();
  final _purpose = TextEditingController();
  final _budget = TextEditingController();
  final List<PlatformFile> _files = [];
  bool _busy = false;
  bool _consent = false;
  String? _receiptId;
  String? _emailConfirmationStatus;
  bool _loadingProfile = true;
  bool _checkingBusinessPlan = true;
  bool _useSavedBusinessPlan = false;
  bool _hasSavedBusinessPlan = false;
  String? _businessPlanLoadError;
  Map<String, dynamic>? _savedBusinessPlan;
  final Map<String, bool> _documentChecklist = {};

  List<String> get _requiredDocuments {
    final programme = widget.programme.toLowerCase();
    if (programme.contains('nyda')) {
      return [
        'Identity document',
        'Business plan',
        'Quotations or cost estimates',
        'Business registration (if applicable)',
      ];
    }
    if (programme.contains('nef')) {
      return [
        'Identity document',
        'Business plan',
        'Financial information',
        'Business registration documents',
        'Quotations or supporting estimates',
      ];
    }
    return [
      'Identity document',
      'Business plan',
      'Quotations or cost estimates',
      'Registration documents (if applicable)',
    ];
  }

  void _fillIfBlank(TextEditingController controller, dynamic value) {
    if (controller.text.trim().isEmpty &&
        value is String &&
        value.trim().isNotEmpty) {
      controller.text = value;
    }
  }

  Future<void> _viewSavedBusinessPlan() async {
    final plan = _savedBusinessPlan;

    if (plan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No saved business plan found.')),
      );
      return;
    }

    try {
      await BusinessPlanPdfService.exportPdf(plan);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to open business plan: $error')),
      );
    }
  }

  Future<void> _loadExistingBusinessPlan() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() => _checkingBusinessPlan = false);
      }
      return;
    }

    try {
      final document = await FirebaseFirestore.instance
          .collection('business_plans')
          .doc(user.uid)
          .get();

      if (!mounted) return;

      final plan = document.data();

      setState(() {
        _savedBusinessPlan = plan;
        _hasSavedBusinessPlan = plan != null;
        _useSavedBusinessPlan = plan != null;
        _checkingBusinessPlan = false;
      });

      if (plan != null) {
        _fillIfBlank(_business, plan['businessName']);
        _fillIfBlank(_description, plan['businessDescription']);
      }
    } catch (error) {
      debugPrint('Business plan loading error: $error');

      if (mounted) {
        setState(() {
          _checkingBusinessPlan = false;
          _businessPlanLoadError = error.toString();
        });
      }
    }
  }

  Future<void> _loadSavedDetails() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (mounted) setState(() => _loadingProfile = false);
      return;
    }
    try {
      final snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (!mounted) return;
      final data = snap.data() ?? <String, dynamic>{};
      _fillIfBlank(_name, data['name']);
      _fillIfBlank(_email, data['email']);
      _fillIfBlank(_phone, data['phone']);
      _fillIfBlank(_location, data['location']);
      _fillIfBlank(_business, data['businessName']);
      _fillIfBlank(_industry, data['businessType']);
      _fillIfBlank(_description, data['businessDescription']);
      _fillIfBlank(_description, data['businessIdea']);
      _fillIfBlank(_amount, data['fundingAmount']?.toString());
      _fillIfBlank(_purpose, data['fundingPurpose']);
    } catch (_) {
      // The form remains usable if optional profile information is unavailable.
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    _name.text = user?.displayName ?? '';
    _email.text = user?.email ?? '';
    _loadSavedDetails();
    _loadExistingBusinessPlan();
  }

  @override
  void dispose() {
    for (final c in [
      _name,
      _email,
      _phone,
      _location,
      _business,
      _industry,
      _description,
      _amount,
      _purpose,
      _budget,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required' : null;

  Widget _field(
    String label,
    TextEditingController controller, {
    int lines = 1,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: TextFormField(
      controller: controller,
      maxLines: lines,
      keyboardType: keyboard,
      validator: _required,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        alignLabelWithHint: lines > 1,
      ),
    ),
  );

  Future<void> _pickDocuments() async {
    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );
      if (result.isNotEmpty && mounted) {
        setState(() {
          for (final file in result) {
            if (!_files.any((f) => f.name == file.name)) _files.add(file);
          }
        });
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not select documents: $error')),
      );
    }
  }

  Map<String, dynamic> _application() => {
    'programme': widget.programme,
    'applicantName': _name.text.trim(),
    'email': _email.text.trim(),
    'phone': _phone.text.trim(),
    'location': _location.text.trim(),
    'businessName': _business.text.trim(),
    'industry': _industry.text.trim(),
    'businessDescription': _description.text.trim(),
    'amountRequested': double.parse(_amount.text.trim()),
    'fundingPurpose': _purpose.text.trim(),
    'budget': _budget.text.trim(),
    'documentNames': _files.map((f) => f.name).toList(),
    'usesSavedBusinessPlan': _useSavedBusinessPlan && _hasSavedBusinessPlan,
    'businessPlanReference': _useSavedBusinessPlan && _hasSavedBusinessPlan
        ? 'business_plans/${FirebaseAuth.instance.currentUser!.uid}'
        : null,
    'businessPlanSnapshot': _useSavedBusinessPlan && _hasSavedBusinessPlan
        ? _savedBusinessPlan
        : null,
    'documentChecklist': _documentChecklist,
    'documentsUploaded': false,
    'status': 'submitted_to_rural_spark',
    'submittedToFunder': false,
    'createdAt': FieldValue.serverTimestamp(),
  };

  Future<void> _sendConfirmationEmail(String reference) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      throw Exception('No registered email address found.');
    }

    final response = await http.post(
      Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'service_id': 'service_qeaqthk',
        'template_id': 'template_61vbuap',
        'user_id': 'rpDFntuPjTM9bYDca',
        'template_params': {
          'to_email': user.email!,
          'applicant_name': _name.text.trim(),
          'programme': widget.programme,
          'reference': reference,
        },
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('EmailJS error ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final amount = double.tryParse(_amount.text.trim());
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid funding amount.')),
      );
      return;
    }
    if (!_consent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm the declaration first.')),
      );
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to submit your application.'),
        ),
      );
      return;
    }
    setState(() => _busy = true);
    try {
      final receipt = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fundingApplications')
          .add(_application());
      if (!mounted) return;

      setState(() {
        _receiptId = receipt.id;
        _emailConfirmationStatus = 'Sending confirmation email...';
      });

      try {
        await _sendConfirmationEmail(receipt.id);

        if (!mounted) return;
        setState(() {
          _emailConfirmationStatus =
              'Confirmation email requested successfully. Check your inbox.';
        });
      } catch (emailError) {
        if (!mounted) return;
        setState(() {
          _emailConfirmationStatus = 'Application saved, but the email could not be sent. Keep your reference.';
        });
        debugPrint('EmailJS error: $emailError');
      }
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not submit application: $error')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _downloadPdf() async {
    final doc = pw.Document();
    final entries = <String, String>{
      'Programme': widget.programme,
      'Applicant': _name.text.trim(),
      'Email': _email.text.trim(),
      'Phone': _phone.text.trim(),
      'Location': _location.text.trim(),
      'Business': _business.text.trim(),
      'Industry': _industry.text.trim(),
      'Description': _description.text.trim(),
      'Funding amount (ZAR)': _amount.text.trim(),
      'Purpose': _purpose.text.trim(),
      'Budget': _budget.text.trim(),
      'Selected documents (not attached)': _files.isEmpty
          ? 'None'
          : _files.map((f) => f.name).join(', '),
      'Rural Spark receipt': _receiptId ?? 'Not saved',
      'Status': 'Submitted to Rural Spark - NOT submitted to the funder',
    };
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Text(
            'Rural Spark - Funding Application Preparation',
            style: pw.TextStyle(fontSize: 19, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 12),
          ...entries.entries.map(
            (e) => pw.Padding(
              padding: const pw.EdgeInsets.only(bottom: 9),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    e.key,
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(e.value),
                ],
              ),
            ),
          ),
          pw.SizedBox(height: 14),
          pw.Text(
            'Important: This PDF is a preparation record only. '
            'The funding organisation has not received this application. '
            'Selected files must be attached separately when officially applying.',
          ),
        ],
      ),
    );
    await Printing.layoutPdf(
      onLayout: (_) async => doc.save(),
      name: 'rural_spark_funding_application.pdf',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_receiptId != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Rural Spark Submission')),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Color(0xFF126A4A),
                    size: 68,
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Application submitted to Rural Spark',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Programme: ${widget.programme}',
                    textAlign: TextAlign.center,
                  ),
                  SelectableText('Receipt: $_receiptId'),
                  const SizedBox(height: 12),
                  Text(
                    _emailConfirmationStatus ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF126A4A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Not submitted to the funding organisation. '
                    'Your selected documents were not uploaded or attached. '
                    '',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _downloadPdf,
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Download application PDF'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to funding'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Funding Easy Apply')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 750),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  widget.programme,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Submit your application to Rural Spark for your records. '
                  'This is not an official funding submission.',
                ),
                if (_loadingProfile) const LinearProgressIndicator(),
                const SizedBox(height: 22),
                const Text(
                  '1. Applicant details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _field('Full name', _name),
                _field('Email', _email, keyboard: TextInputType.emailAddress),
                _field('Phone number', _phone, keyboard: TextInputType.phone),
                _field('Town / village', _location),
                const SizedBox(height: 14),
                const Text(
                  '2. Business details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _field('Business name or proposed name', _business),
                _field('Business industry', _industry),
                _field('Describe your business idea', _description, lines: 3),
                const SizedBox(height: 14),
                const Text(
                  '3. Funding request',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _field(
                  'Amount requested (R)',
                  _amount,
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
                _field(
                  'What will you use the funding for?',
                  _purpose,
                  lines: 3,
                ),
                _field('Budget / breakdown of costs', _budget, lines: 3),
                const SizedBox(height: 14),
                if (_checkingBusinessPlan) const LinearProgressIndicator(),

                if (_hasSavedBusinessPlan)
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(
                            Icons.picture_as_pdf,
                            color: Color(0xFF126A4A),
                          ),
                          title: Text(
                            '${_savedBusinessPlan?['businessName'] ?? 'My Business'} - Business Plan',
                          ),
                          subtitle: const Text(
                            'Document created inside Rural Spark',
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _viewSavedBusinessPlan,
                          icon: const Icon(Icons.visibility_outlined),
                          label: const Text('View / Download Business Plan'),
                        ),
                        CheckboxListTile(
                          secondary: const Icon(
                            Icons.description_outlined,
                            color: Color(0xFF126A4A),
                          ),
                          title: const Text('Use my saved business plan'),
                          subtitle: const Text(
                            'Your business plan was found in Rural Spark. '
                            'Reuse it without uploading again.',
                          ),
                          value: _useSavedBusinessPlan,
                          onChanged: (value) {
                            setState(() {
                              _useSavedBusinessPlan = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                else if (!_checkingBusinessPlan)
                  ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(
                      _businessPlanLoadError == null
                          ? 'No saved business plan available'
                          : 'Could not load business plan',
                    ),
                    subtitle: Text(
                      'Create and save a business plan in Rural Spark '
                      'to reuse it here.',
                    ),
                  ),
                const Text(
                  '4. Supporting documents',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Select PDFs or images. For this free-plan prototype, '
                  'only file names are recorded. Files are NOT uploaded, '
                  'attached to the generated PDF, or sent to a funder.',
                ),
                const SizedBox(height: 10),
                const Text(
                  'Suggested document checklist (confirm the exact requirements on the funder website):',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                ..._requiredDocuments.map(
                  (document) => CheckboxListTile(
                    dense: true,
                    title: Text(document),
                    subtitle: const Text(
                      'Tick if you already have this document',
                    ),
                    value: _documentChecklist[document] ?? false,
                    onChanged: (value) => setState(
                      () => _documentChecklist[document] = value ?? false,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: _pickDocuments,
                  icon: const Icon(Icons.attach_file),
                  label: const Text('Select documents'),
                ),
                ..._files.map(
                  (file) => ListTile(
                    dense: true,
                    title: Text(file.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _files.remove(file)),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _consent,
                  onChanged: (value) =>
                      setState(() => _consent = value ?? false),
                  title: const Text(
                    'I confirm my information is accurate and '
                    'understand this is saved only in Rural Spark, not sent '
                    'to the funding organisation.',
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _busy ? null : _save,
                  icon: const Icon(Icons.send_outlined),
                  label: Text(_busy ? 'Submitting...' : 'Submit Application'),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
