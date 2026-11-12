import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class EntrepreneurProfileScreen extends StatefulWidget {
  const EntrepreneurProfileScreen({super.key});

  @override
  State<EntrepreneurProfileScreen> createState() =>
      _EntrepreneurProfileScreenState();
}

class _EntrepreneurProfileScreenState extends State<EntrepreneurProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _imagePicker = ImagePicker();

  // =====================================================
  // TEXT CONTROLLERS
  // =====================================================

  final TextEditingController _fullNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _townController = TextEditingController();

  final TextEditingController _businessNameController = TextEditingController();

  final TextEditingController _businessIdeaController = TextEditingController();

  final TextEditingController _businessDescriptionController =
      TextEditingController();

  // NEW: BUSINESS ADDRESS
  final TextEditingController _businessAddressController =
      TextEditingController();

  // =====================================================
  // DROPDOWN OPTIONS
  // =====================================================

  final List<String> _provinces = [
    'Eastern Cape',
    'Free State',
    'Gauteng',
    'KwaZulu-Natal',
    'Limpopo',
    'Mpumalanga',
    'Northern Cape',
    'North West',
    'Western Cape',
  ];

  final List<String> _industries = [
    'Agriculture',
    'Beauty and Cosmetics',
    'Construction',
    'Education',
    'Fashion and Clothing',
    'Food and Catering',
    'Information Technology',
    'Retail',
    'Tourism',
    'Transport',
    'Other',
  ];

  final List<String> _businessStages = [
    'Idea Stage',
    'Planning Stage',
    'Starting Up',
    'Already Operating',
  ];

  String? _selectedProvince;
  String? _selectedIndustry;
  String? _selectedBusinessStage;

  // =====================================================
  // SCREEN STATES
  // =====================================================

  bool _loading = true;
  bool _saving = false;
  bool _editing = false;
  bool _savingPicture = false;

  Uint8List? _profileImageBytes;

  // =====================================================
  // PROFILE PICTURE STORAGE KEY
  // =====================================================

  String? get _profilePictureKey {
    final user = _auth.currentUser;

    if (user == null) return null;

    return 'rural_spark_profile_picture_${user.uid}';
  }

  // =====================================================
  // INITIALIZE SCREEN
  // =====================================================

  @override
  void initState() {
    super.initState();

    _loadProfile();
    _loadProfilePicture();
  }

  // =====================================================
  // LOAD PROFILE FROM FIRESTORE
  // =====================================================

  Future<void> _loadProfile() async {
    final user = _auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
      return;
    }

    try {
      final document = await _firestore.collection('users').doc(user.uid).get();

      final data = document.data() ?? {};

      if (!mounted) return;

      setState(() {
        _fullNameController.text = (data['fullName'] ?? user.displayName ?? '')
            .toString();

        _phoneController.text = (data['phoneNumber'] ?? '').toString();

        _townController.text = (data['town'] ?? data['location'] ?? '')
            .toString();

        _businessNameController.text = (data['businessName'] ?? '').toString();

        _businessIdeaController.text = (data['businessIdea'] ?? '').toString();

        _businessDescriptionController.text =
            (data['businessDescription'] ?? '').toString();

        // NEW: LOAD BUSINESS ADDRESS
        _businessAddressController.text = (data['businessAddress'] ?? '')
            .toString();

        final province = data['province']?.toString();
        final industry = data['industry']?.toString();
        final stage = data['businessStage']?.toString();

        _selectedProvince = _provinces.contains(province) ? province : null;

        _selectedIndustry = _industries.contains(industry) ? industry : null;

        _selectedBusinessStage = _businessStages.contains(stage) ? stage : null;

        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage('Could not load your profile.');
    }
  }

  // =====================================================
  // LOAD SAVED PROFILE PICTURE
  // =====================================================

  Future<void> _loadProfilePicture() async {
    try {
      final key = _profilePictureKey;

      if (key == null) return;

      final preferences = await SharedPreferences.getInstance();

      final savedImage = preferences.getString(key);

      if (savedImage == null || savedImage.isEmpty) {
        return;
      }

      final imageBytes = base64Decode(savedImage);

      if (!mounted) return;

      setState(() {
        _profileImageBytes = imageBytes;
      });
    } catch (_) {
      _showMessage('Could not load your profile picture.');
    }
  }

  // =====================================================
  // SELECT AND SAVE PROFILE PICTURE
  // =====================================================

  Future<void> _pickProfilePicture() async {
    if (_savingPicture) return;

    try {
      final XFile? selectedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 75,
      );

      if (selectedImage == null) return;

      if (!mounted) return;

      setState(() {
        _savingPicture = true;
      });

      final originalBytes = await selectedImage.readAsBytes();

      final decodedImage = img.decodeImage(originalBytes);

      if (decodedImage == null) {
        _showMessage('Unable to read the selected picture.');
        return;
      }

      final resizedImage = img.copyResize(decodedImage, width: 200);

      final compressedBytes = Uint8List.fromList(
        img.encodeJpg(resizedImage, quality: 65),
      );

      final key = _profilePictureKey;

      if (key == null) {
        _showMessage('Please log in again.');
        return;
      }

      final preferences = await SharedPreferences.getInstance();

      final saved = await preferences.setString(
        key,
        base64Encode(compressedBytes),
      );

      if (!saved) {
        _showMessage('Could not save the profile picture.');
        return;
      }

      if (!mounted) return;

      setState(() {
        _profileImageBytes = compressedBytes;
      });

      _showMessage('Profile picture updated successfully!');
    } catch (_) {
      _showMessage('Could not update your profile picture. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _savingPicture = false;
        });
      }
    }
  }

  // =====================================================
  // REMOVE PROFILE PICTURE
  // =====================================================

  Future<void> _removeProfilePicture() async {
    if (_savingPicture) return;

    final key = _profilePictureKey;

    if (key == null) {
      _showMessage('Please log in again.');
      return;
    }

    setState(() {
      _savingPicture = true;
    });

    try {
      final preferences = await SharedPreferences.getInstance();

      final removed = await preferences.remove(key);

      if (!removed) {
        _showMessage('Could not remove the profile picture.');
        return;
      }

      if (!mounted) return;

      setState(() {
        _profileImageBytes = null;
      });

      _showMessage('Profile picture removed successfully.');
    } catch (_) {
      _showMessage('Could not remove the profile picture.');
    } finally {
      if (mounted) {
        setState(() {
          _savingPicture = false;
        });
      }
    }
  }

  // =====================================================
  // SAVE ENTREPRENEUR PROFILE TO FIRESTORE
  // =====================================================

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;

    if (user == null) {
      _showMessage('Please log in again.');
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'province': _selectedProvince ?? '',
        'town': _townController.text.trim(),
        'location': _townController.text.trim(),
        'businessName': _businessNameController.text.trim(),
        'businessIdea': _businessIdeaController.text.trim(),
        'industry': _selectedIndustry ?? '',
        'businessStage': _selectedBusinessStage ?? '',
        'businessDescription': _businessDescriptionController.text.trim(),

        // NEW: SAVE BUSINESS ADDRESS
        'businessAddress': _businessAddressController.text.trim(),

        'profileCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await user.updateDisplayName(_fullNameController.text.trim());

      if (!mounted) return;

      setState(() {
        _editing = false;
      });

      _showMessage('Profile updated successfully!');
    } on FirebaseException catch (e) {
      _showMessage(e.message ?? 'Could not save your profile.');
    } catch (_) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  // =====================================================
  // NEW: OPEN BUSINESS LOCATION IN GOOGLE MAPS
  // =====================================================

  Future<void> _openBusinessLocation() async {
    final address = _businessAddressController.text.trim();
    final town = _townController.text.trim();
    final province = _selectedProvince ?? '';

    if (address.isEmpty && town.isEmpty) {
      _showMessage('Please add your business location first.');
      return;
    }

    final location = [
      address,
      town,
      province,
      'South Africa',
    ].where((part) => part.isNotEmpty).join(', ');

    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': location,
    });

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        _showMessage('Could not open Google Maps.');
      }
    } catch (_) {
      _showMessage('Could not open Google Maps.');
    }
  }

  // =====================================================
  // SHOW MESSAGE
  // =====================================================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  // =====================================================
  // TEXT FIELD
  // =====================================================

  Widget _textField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    bool requiredField = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: _editing && !_saving,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (requiredField && (value == null || value.trim().isEmpty)) {
            return 'Please enter $label';
          }

          return null;
        },
      ),
    );
  }

  // =====================================================
  // DROPDOWN FIELD
  // =====================================================

  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        key: ValueKey('$label-$value'),
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        items: options.map((item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: _editing && !_saving ? onChanged : null,
      ),
    );
  }

  // =====================================================
  // PROFILE PICTURE WIDGET
  // =====================================================

  Widget _buildProfilePicture() {
    return Column(
      children: [
        CircleAvatar(
          radius: 58,
          backgroundColor: AppColors.lightGreen,
          backgroundImage: _profileImageBytes != null
              ? MemoryImage(_profileImageBytes!)
              : null,
          child: _profileImageBytes == null
              ? const Icon(Icons.person, size: 60, color: AppColors.darkGreen)
              : null,
        ),

        const SizedBox(height: 12),

        TextButton.icon(
          onPressed: _savingPicture ? null : _pickProfilePicture,
          icon: const Icon(Icons.camera_alt_outlined),
          label: Text(
            _savingPicture ? 'Saving Picture...' : 'Change Profile Picture',
          ),
          style: TextButton.styleFrom(foregroundColor: AppColors.darkGreen),
        ),

        if (_profileImageBytes != null)
          TextButton.icon(
            onPressed: _savingPicture ? null : _removeProfilePicture,
            icon: const Icon(Icons.delete_outline),
            label: const Text('Remove Picture'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
      ],
    );
  }

  // =====================================================
  // BUILD ENTREPRENEUR PROFILE SCREEN
  // =====================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entrepreneur Profile'),
        backgroundColor: AppColors.lightGreen,
        actions: [
          if (!_editing)
            IconButton(
              tooltip: 'Edit Profile',
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _editing = true;
                });
              },
            ),
        ],
      ),

      body: _auth.currentUser == null
          ? const Center(child: Text('Please log in to view your profile.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // PROFILE PICTURE
                        Center(child: _buildProfilePicture()),

                        const SizedBox(height: 16),

                        // EMAIL ADDRESS
                        Text(
                          _auth.currentUser?.email ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.grey,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // PERSONAL INFORMATION
                        const Text(
                          'Personal Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _textField(
                          label: 'Full Name',
                          controller: _fullNameController,
                          requiredField: true,
                        ),

                        _textField(
                          label: 'Phone Number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                        ),

                        _dropdown(
                          label: 'Province',
                          value: _selectedProvince,
                          options: _provinces,
                          onChanged: (value) {
                            setState(() {
                              _selectedProvince = value;
                            });
                          },
                        ),

                        _textField(
                          label: 'City / Town / Village',
                          controller: _townController,
                        ),

                        const SizedBox(height: 18),

                        // BUSINESS INFORMATION
                        const Text(
                          'Business Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),

                        const SizedBox(height: 16),

                        _textField(
                          label: 'Business Name',
                          controller: _businessNameController,
                        ),

                        _textField(
                          label: 'Business Idea',
                          controller: _businessIdeaController,
                          maxLines: 3,
                        ),

                        _dropdown(
                          label: 'Business Industry',
                          value: _selectedIndustry,
                          options: _industries,
                          onChanged: (value) {
                            setState(() {
                              _selectedIndustry = value;
                            });
                          },
                        ),

                        _dropdown(
                          label: 'Business Stage',
                          value: _selectedBusinessStage,
                          options: _businessStages,
                          onChanged: (value) {
                            setState(() {
                              _selectedBusinessStage = value;
                            });
                          },
                        ),

                        _textField(
                          label: 'Business Description',
                          controller: _businessDescriptionController,
                          maxLines: 4,
                        ),

                        const SizedBox(height: 18),

                        // ======================================
                        // NEW: BUSINESS LOCATION SECTION
                        // ======================================
                        const Text(
                          'Business Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkGreen,
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          'Add your business address so you can find '
                          'its location on Google Maps.',
                          style: TextStyle(color: Colors.grey),
                        ),

                        const SizedBox(height: 16),

                        _textField(
                          label: 'Business Address / Street / Area',
                          controller: _businessAddressController,
                          maxLines: 2,
                        ),

                        const SizedBox(height: 8),

                        OutlinedButton.icon(
                          onPressed: _openBusinessLocation,
                          icon: const Icon(Icons.location_on_outlined),
                          label: const Text('View Business on Google Maps'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.darkGreen,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ======================================
                        // SAVE OR EDIT PROFILE
                        // ======================================
                        if (_editing) ...[
                          SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _saving ? null : _saveProfile,
                              icon: const Icon(Icons.save),
                              label: Text(
                                _saving ? 'Saving...' : 'Save Changes',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkGreen,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          OutlinedButton(
                            onPressed: _saving
                                ? null
                                : () async {
                                    setState(() {
                                      _editing = false;
                                    });

                                    await _loadProfile();
                                  },
                            child: const Text('Cancel'),
                          ),
                        ] else
                          SizedBox(
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _editing = true;
                                });
                              },
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit Profile'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkGreen,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // =====================================================
  // DISPOSE CONTROLLERS
  // =====================================================

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _townController.dispose();
    _businessNameController.dispose();
    _businessIdeaController.dispose();
    _businessDescriptionController.dispose();
    _businessAddressController.dispose();

    super.dispose();
  }
}
