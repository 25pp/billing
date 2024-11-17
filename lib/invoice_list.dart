import 'package:billing/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class InvoiceListScreen extends StatefulWidget {
  @override
  _InvoiceListScreenState createState() => _InvoiceListScreenState();
}

class _InvoiceListScreenState extends State<InvoiceListScreen> {
  List<Map<String, dynamic>> _invoices = [];

  @override
  void initState() {
    super.initState();
    _loadInvoices();
  }

  Future<void> _loadInvoices() async {
    final database = await openDatabase(
      '${(await getApplicationDocumentsDirectory()).path}/invoice.db',
    );
    final invoices = await database.query('invoices');
    setState(() {
      _invoices = invoices;
    });
  }

  // Future<void> _openInvoice(int index) async {
  //   final invoice = _invoices[index];
  //   final pdfPath = invoice['pdfPath'] as String;
  //   // Open or download the PDF file
  // }
  Future<void> _openInvoice(int index) async {
    final invoice = _invoices[index];
    final pdfPath = invoice['pdfPath'] as String;

    // Open the PDF file using the default viewer
    final result = await OpenFile.open(pdfPath);

    if (result.type != ResultType.done) {
      // Handle errors, if any
      print("Could not open PDF: ${result.message}");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Could not open PDF: ${result.message}')),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        backgroundColor: ColorConstant.royalBlue,
        title: Text('Invoices',style: TextStyle(color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: _invoices.length,
          itemBuilder: (context, index) {
            final invoice = _invoices[index];
            return Card(
              margin: EdgeInsets.all(6),
              child: ListTile(
                trailing: Icon(Icons.open_in_browser_outlined),
                title: Text('Invoice No. ${invoice['invoiceNo']}'),
                subtitle: Text('Date: ${invoice['invoiceDate']}'),
                onTap: () => _openInvoice(index),
              ),
            );
          },
        ),
      ),
    );
  }
}