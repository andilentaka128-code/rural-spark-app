import 'custom_business_gap_analysis.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/app_colors.dart';

class ExploreBusinessIdeasScreen extends StatefulWidget {
  const ExploreBusinessIdeasScreen({super.key});

  @override
  State<ExploreBusinessIdeasScreen> createState() =>
      _ExploreBusinessIdeasScreenState();
}

class _ExploreBusinessIdeasScreenState
    extends State<ExploreBusinessIdeasScreen> {
  final TextEditingController _townController = TextEditingController();
  final TextEditingController _customSkillsController = TextEditingController();
  final TextEditingController _businessIdeaController = TextEditingController();

  String? _province;
  String? _areaType;

  final Set<String> _selectedSkills = {};

  bool _showResults = false;

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

  final List<String> _areaTypes = [
    'Rural village',
    'Township',
    'Small town',
    'City',
  ];

  final List<String> _skills = [
    'Land or garden',
    'Cooking skills',
    'Sewing skills',
    'Computer or smartphone',
    'Hairdressing skills',
    'Farming experience',
    'Teaching skills',
    'Small startup budget',
  ];

  final List<Map<String, dynamic>> _businessIdeas = [
    {
      'name': 'Vegetable Farming',
      'category': 'Agriculture',
      'skills': ['Land or garden', 'Farming experience'],
      'areas': ['Rural village', 'Small town', 'Township'],
      'competitorSearch': 'vegetable sellers and fresh produce shops',
      'description':
          'Grow vegetables and supply households, markets and local shops.',
      'gap': 'Investigate whether customers struggle to find affordable fresh vegetables or reliable local deliveries.',
      'difference': 'Consider vegetable bundles, regular household deliveries or supplying local food businesses.',
      'requirements':
          'Suitable land, water, seeds, tools and potential buyers.',
    },
    {
      'name': 'Poultry Farming',
      'category': 'Agriculture',
      'skills': ['Land or garden', 'Farming experience'],
      'areas': ['Rural village', 'Small town', 'Township'],
      'competitorSearch': 'poultry farms and chicken sellers',
      'description':
          'Raise chickens for eggs or meat and sell to local customers.',
      'gap': 'Check whether customers need more convenient access to eggs or chicken products.',
      'difference': 'Explore pre-orders, scheduled collection or reliable local delivery.',
      'requirements':
          'Poultry housing, chicks, feed, water and animal-care knowledge.',
    },
    {
      'name': 'Home Catering',
      'category': 'Food',
      'skills': ['Cooking skills', 'Small startup budget'],
      'areas': ['Rural village', 'Township', 'Small town', 'City'],
      'competitorSearch': 'catering services and takeaway food',
      'description':
          'Prepare meals for events, workplaces and community gatherings.',
      'gap': 'Investigate demand for affordable meals, event catering or delivery services.',
      'difference': 'Consider affordable meal packages, advance ordering or catering for small events.',
      'requirements': 'Cooking equipment, ingredients, food safety knowledge and customers.',
    },
    {
      'name': 'Sewing and Tailoring',
      'category': 'Fashion',
      'skills': ['Sewing skills'],
      'areas': ['Rural village', 'Township', 'Small town', 'City'],
      'competitorSearch': 'tailors and clothing alteration services',
      'description':
          'Provide clothing repairs, alterations and custom garments.',
      'gap': 'Check whether residents need convenient clothing repairs or school uniform alterations.',
      'difference': 'Offer collection services, clear turnaround times or affordable repair packages.',
      'requirements': 'Sewing machine, thread, fabric and sewing equipment.',
    },
    {
      'name': 'Digital Services',
      'category': 'Technology',
      'skills': ['Computer or smartphone'],
      'areas': ['Rural village', 'Township', 'Small town', 'City'],
      'competitorSearch': 'internet cafes printing and computer services',
      'description': 'Assist residents with CVs, digital documents and online applications.',
      'gap': 'Investigate whether residents travel far for printing, scanning or online application assistance.',
      'difference': 'Consider appointment-based assistance, document preparation or mobile services.',
      'requirements': 'Computer or suitable device, internet, digital skills and possibly a printer.',
    },
    {
      'name': 'Hair Salon',
      'category': 'Beauty',
      'skills': ['Hairdressing skills'],
      'areas': ['Rural village', 'Township', 'Small town', 'City'],
      'competitorSearch': 'hair salons and braiding services',
      'description':
          'Provide hairstyling, braiding and basic haircare services.',
      'gap': 'Investigate demand for home appointments, affordable braiding or convenient booking times.',
      'difference': 'Offer appointments, transparent pricing or mobile hairstyling services.',
      'requirements': 'Hair products, styling tools, workspace and customers.',
    },
    {
      'name': 'Tutoring Services',
      'category': 'Education',
      'skills': ['Teaching skills'],
      'areas': ['Rural village', 'Township', 'Small town', 'City'],
      'competitorSearch': 'tutoring centres and extra lessons',
      'description': 'Provide academic support to learners in your community.',
      'gap': 'Investigate whether learners need affordable support in particular school subjects.',
      'difference': 'Offer small-group lessons, weekend classes or flexible tutoring sessions.',
      'requirements': 'Subject knowledge, learning materials and a suitable teaching space.',
    },
    {
      'name': 'Mobile Car Wash',
      'category': 'Services',
      'skills': ['Small startup budget'],
      'areas': ['Township', 'Small town', 'City'],
      'competitorSearch': 'car wash businesses',
      'description':
          'Provide vehicle cleaning services to local vehicle owners.',
      'gap': 'Investigate demand for convenient vehicle cleaning at homes or workplaces.',
      'difference': 'Consider booking services, collection arrangements or water-efficient cleaning methods.',
      'requirements': 'Cleaning supplies, suitable water access and transport.',
    },
    {
      'name': 'Seedling Production',
      'category': 'Agriculture',
      'skills': ['Land or garden', 'Farming experience'],
      'areas': ['Rural village', 'Small town'],
      'competitorSearch': 'plant nurseries and seedling suppliers',
      'description':
          'Grow vegetable seedlings for gardeners and small-scale farmers.',
      'gap': 'Investigate whether local growers struggle to obtain suitable seedlings nearby.',
      'difference':
          'Offer seasonal seedling packs, growing advice or pre-orders.',
      'requirements':
          'Seeds, trays, growing medium, water and protected growing space.',
    },
    {
      'name': 'Community Printing Services',
      'category': 'Technology',
      'skills': ['Computer or smartphone', 'Small startup budget'],
      'areas': ['Rural village', 'Township', 'Small town'],
      'competitorSearch': 'printing scanning and internet cafes',
      'description':
          'Offer printing, scanning and document preparation services.',
      'gap': 'Check whether residents have limited access to affordable printing and scanning.',
      'difference': 'Consider WhatsApp document submission, collection times or mobile printing arrangements.',
      'requirements':
          'Printer, computer, paper, electricity and internet access.',
    },
  ];

  @override
  void dispose() {
    _townController.dispose();
    _customSkillsController.dispose();
    _businessIdeaController.dispose();
    super.dispose();
  }

  String get _location {
    return '${_townController.text.trim()}, $_province, South Africa';
  }

  int _scoreIdea(Map<String, dynamic> idea) {
    int score = 0;

    final skills = List<String>.from(idea['skills']);
    final areas = List<String>.from(idea['areas']);

    for (final skill in skills) {
      if (_selectedSkills.contains(skill)) {
        score += 5;
      }
    }

    if (areas.contains(_areaType)) {
      score += 3;
    }

    return score;
  }

  List<Map<String, dynamic>> get _recommendations {
    final matches = _businessIdeas.where((idea) {
      final skills = List<String>.from(idea['skills']);

      return skills.any(_selectedSkills.contains);
    }).toList();

    matches.sort((a, b) => _scoreIdea(b).compareTo(_scoreIdea(a)));

    return matches;
  }

  void _analyseOpportunities() {
    if (_province == null ||
        _areaType == null ||
        _townController.text.trim().isEmpty ||
        _selectedSkills.isEmpty &&
            _customSkillsController.text.trim().isEmpty &&
            _businessIdeaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select your province, area type, town and at least one skill.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _showResults = true;
    });
  }

  Future<void> _findCompetitors(Map<String, dynamic> idea) async {
    final search = '${idea['competitorSearch']} near $_location';

    final uri = Uri.https('www.google.com', '/maps/search/', {
      'api': '1',
      'query': search,
    });

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open Google Maps.')),
        );
      }
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Google Maps.')),
      );
    }
  }

  void _showBusinessDetails(Map<String, dynamic> idea) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(idea['name'] as String),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggested for: $_location',
                  style: const TextStyle(
                    color: AppColors.darkGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(idea['description'] as String),
                const SizedBox(height: 20),
                const Text(
                  'Possible Market Gap',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(idea['gap'] as String),
                const SizedBox(height: 20),
                const Text(
                  'How You Could Be Different',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(idea['difference'] as String),
                const SizedBox(height: 20),
                const Text(
                  'What You May Need',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                Text(idea['requirements'] as String),
                const SizedBox(height: 20),
                const Text(
                  'Competitor Research',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Open Google Maps to explore businesses offering '
                  'similar services in your selected area.',
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => _findCompetitors(idea),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text('Find Competitors Near Me'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Market gaps are suggestions to investigate, '
                  'not verified findings. Compare real competitors, '
                  'prices and customer needs before investing.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Business Ideas'),
        backgroundColor: AppColors.lightGreen,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.travel_explore,
                  size: 65,
                  color: AppColors.darkGreen,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Find Business Opportunities',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Enter your location and select your skills. '
                  'Rural Spark will suggest business ideas and '
                  'possible market gaps to investigate.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                const Text(
                  '1. Your Business Location',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _province,
                  decoration: const InputDecoration(
                    labelText: 'Province',
                    border: OutlineInputBorder(),
                  ),
                  items: _provinces.map((province) {
                    return DropdownMenuItem(
                      value: province,
                      child: Text(province),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _province = value;
                      _showResults = false;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _townController,
                  decoration: const InputDecoration(
                    labelText: 'Town or Village',
                    hintText: 'e.g. Mthatha, Qumbu, Lusikisiki',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) {
                    setState(() {
                      _showResults = false;
                    });
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _areaType,
                  decoration: const InputDecoration(
                    labelText: 'Type of Area',
                    border: OutlineInputBorder(),
                  ),
                  items: _areaTypes.map((area) {
                    return DropdownMenuItem(value: area, child: Text(area));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _areaType = value;
                      _showResults = false;
                    });
                  },
                ),
                const SizedBox(height: 28),
                const Text(
                  '2. Your Skills and Resources',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _skills.map((skill) {
                    return FilterChip(
                      label: Text(skill),
                      selected: _selectedSkills.contains(skill),
                      selectedColor: AppColors.lightGreen,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedSkills.add(skill);
                          } else {
                            _selectedSkills.remove(skill);
                          }

                          _showResults = false;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 25),
                const SizedBox(height: 24),
                const Text(
                  '3. Enter Your Own Skills and Business Idea',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreen,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _customSkillsController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Write your skills',
                    hintText: 'e.g. Baking, fixing phones, welding',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.build_outlined),
                  ),
                  onChanged: (_) {
                    setState(() => _showResults = false);
                  },
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _businessIdeaController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Your Own Business Idea',
                    hintText: 'e.g. I want to start a bakery that sells affordable bread',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lightbulb_outline),
                  ),
                  onChanged: (_) {
                    setState(() => _showResults = false);
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _analyseOpportunities,
                    icon: const Icon(Icons.search),
                    label: const Text('Analyse My Business Opportunities'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                if (_showResults) ...[
                  const SizedBox(height: 30),
                  const Text(
                    '3. Recommended Business Ideas',
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Based on your skills and selected location: $_location',
                  ),
                  const SizedBox(height: 18),
                  if (_recommendations.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(18),
                        child: Text(
                          'No matching ideas found. Try selecting '
                          'another skill or resource.',
                        ),
                      ),
                    ),
                  CustomBusinessGapAnalysis(
                    location: _location,
                    skills: [
                      ..._selectedSkills,
                      _customSkillsController.text.trim(),
                    ].where((value) => value.isNotEmpty).join(', '),
                    businessIdea: _businessIdeaController.text.trim(),
                  ),
                  ..._recommendations.map((idea) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.lightGreen,
                          child: Icon(
                            Icons.lightbulb_outline,
                            color: AppColors.darkGreen,
                          ),
                        ),
                        title: Text(
                          idea['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${idea['category']} - View market opportunities',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () => _showBusinessDetails(idea),
                      ),
                    );
                  }),
                  const SizedBox(height: 18),
                  const Text(
                    'Recommendations are based on predefined '
                    'business categories, selected skills and area type. '
                    'They are not based on verified local market demand. '
                    'Google Maps opens separately for competitor research.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
