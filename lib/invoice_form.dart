import 'dart:convert';
import 'dart:io';
import 'package:billing/dashboard.dart';
import 'package:billing/utils/color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sqflite/sqflite.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String invoiceNo = '';
  // String invoiceDate = '';
  String challanNo = '';
  String purchaseOrder = '';
  String vendorCode = '';
  String customerGst= '';
  String customerDetail = '';
  final List<String> products = [
    'STUD M20 (20+14+46)MM 8.8',
    'HX HD SCREW M20X100 CA-4770-4/0 8.8',
    'WASHER 30 160HV ISO8738',
    'WASHER 70 160HV ISO8738',
    'CYLINDRICAL PIN 10h8X40 C40 IS2393',
    'CLEVIS PIN W/O HD B70h11X200X160 C40 ISO2340',
    'CLEVIS PIN WITH HEAD B12h11X36X30 SS304 ISO2341',
    'WASHER A50 300HV DIN125-2',
    'CYLINDRICAL PIN 10h8X40 AISI316 IS2393',
    'WASHER 48 300HV A3C ISO7090',
    'WASHER 42 200HV A3C ISO7090',
  ];

  // Currently selected product
  String? selectedProduct;
  Database? _database;

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final path = '${documentsDir.path}/invoice.db';

    _database = await openDatabase(
      path,
      version: 3, // Increment version to apply schema changes
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE invoices ADD COLUMN purchaseOrder TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE invoices ADD COLUMN vendorCode TEXT');
          await db.execute('ALTER TABLE invoices ADD COLUMN customerGst TEXT');
          await db.execute('ALTER TABLE invoices ADD COLUMN customerDetail TEXT');
        }
      },
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE invoices (
          id INTEGER PRIMARY KEY,
          invoiceNo TEXT,
          invoiceDate TEXT,
          challanNo TEXT,
          purchaseOrder TEXT,
          vendorCode TEXT,
          customerGst TEXT,
          customerDetail TEXT,
          pdfPath TEXT
        )
      ''');
      },
    );
  }

  Future<void> _saveInvoice(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(
            child: pw.Text(
                'Invoice No: $invoiceNo\n'
                'Date: ${_dateController.text}\n'
                'Challan No: $challanNo\n'
                'Purchase Order: $purchaseOrder\n'
                'Vendor Code: $vendorCode\n'
                'Customer GST: $customerGst\n'
                'Customer Detail: $customerDetail'),
          ),
        ),
      );

      final appDir = await getApplicationDocumentsDirectory();
      final pdfPath = '${appDir.path}/invoice_$invoiceNo.pdf';
      final file = File(pdfPath);
      await file.writeAsBytes(await pdf.save());

      await _database!.insert('invoices', {
        'invoiceNo': invoiceNo,
        'invoiceDate': _dateController.text,
        'challanNo': challanNo,
        'purchaseOrder': purchaseOrder,
        'vendorCode': vendorCode,
        'customerGst': customerGst,
        'customerDetail': customerDetail,
        'pdfPath': pdfPath,
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>Dashboard()),
      );
      // Navigate to the list screen or display a success message
    }
  }
  DateTime? selectedDate;
  final TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: ColorConstant.white
        ),
        backgroundColor: ColorConstant.royalBlue,
        title: Text('Create Invoice',style: TextStyle(color: ColorConstant.white),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Invoice No.'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the invoice number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    invoiceNo = value!;
                  },
                ),
                TextFormField(
                  controller: _dateController,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode()); // Prevents keyboard from appearing
                    _selectDate(context);
                  },
                  decoration: InputDecoration(
                    labelText: 'Invoice Date',
                  ),
                  readOnly: true, // Makes the field read-only
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Challan No.'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the challan number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    challanNo = value!;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Purchase Order No.'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the purchase order number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    purchaseOrder = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Vendor Code'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the vendor code';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    vendorCode = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Customer GST No.'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the customer gst number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    customerGst = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Customer Details'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the customer details';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    customerDetail = value!;
                  },
                ),
                SizedBox(height: 8,),
                DropdownButton<String>(
                  value: selectedProduct,
                  hint: Text('Choose a product'),
                  isExpanded: true,
                  items: products.map((product) {
                    return DropdownMenuItem<String>(
                      value: product,
                      child: Text(product),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedProduct = value;
                    });
                  },
                ),
               SizedBox(height: 8,),
                // Add more TextFormFields for other fields
                GestureDetector(
                  onTap: (){
                    _saveInvoice(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                        color: ColorConstant.royalBlue,
                      borderRadius:  BorderRadius.circular(12)
                    ),
                    padding: EdgeInsets.all(12),

                    child: Text("Save",style: TextStyle(color: ColorConstant.white),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
