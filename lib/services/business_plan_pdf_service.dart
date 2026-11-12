import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BusinessPlanPdfService {
  static Future<void> exportPdf(Map<String, dynamic> draft) async {
    final pdf = pw.Document();

    String text(String key) {
      final value = draft[key]?.toString().trim() ?? '';
      return value.isEmpty ? 'Not provided' : value;
    }

    double amount(String key) {
      final value = draft[key];

      if (value is num) {
        return value.toDouble();
      }

      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    final monthlyIncome = amount('expectedMonthlyIncome');
    final monthlyExpenses = amount('expectedMonthlyExpenses');
    final monthlyProfit = monthlyIncome - monthlyExpenses;

    pw.Widget section(String title, List<pw.Widget> children) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 18),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 17,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.Divider(),
          ...children,
        ],
      );
    }

    pw.Widget field(String label, String value) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
            ),
            pw.SizedBox(height: 4),
            pw.Text(value, style: const pw.TextStyle(fontSize: 11)),
          ],
        ),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        build: (context) => [
          pw.Text(
            'RURAL SPARK',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),

          pw.SizedBox(height: 12),

          pw.Text(
            'BUSINESS PLAN',
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold),
          ),

          pw.SizedBox(height: 8),

          pw.Text(
            text('businessName'),
            style: const pw.TextStyle(fontSize: 18),
          ),

          section('1. Business Overview', [
            field('Business Description', text('businessDescription')),
            field('Problem Being Solved', text('problemSolved')),
            field('Products and Services', text('productsServices')),
          ]),

          section('2. Customers and Market', [
            field('Target Customers', text('targetCustomers')),
            field('Customer Needs', text('customerNeeds')),
            field('Competitors', text('competitors')),
            field('Competitive Advantage', text('competitiveAdvantage')),
          ]),

          section('3. Marketing and Sales', [
            field('Marketing Strategy', text('marketingStrategy')),
            field('Sales Strategy', text('salesStrategy')),
          ]),

          section('4. Financial Plan', [
            field(
              'Startup Cost',
              'R ${amount('startupCost').toStringAsFixed(2)}',
            ),
            field(
              'Expected Monthly Income',
              'R ${monthlyIncome.toStringAsFixed(2)}',
            ),
            field(
              'Expected Monthly Expenses',
              'R ${monthlyExpenses.toStringAsFixed(2)}',
            ),
            field(
              'Expected Monthly Profit',
              'R ${monthlyProfit.toStringAsFixed(2)}',
            ),
          ]),

          pw.SizedBox(height: 20),

          pw.Text(
            'Prepared using Rural Spark',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'Rural_Spark_Business_Plan.pdf',
    );
  }
}
