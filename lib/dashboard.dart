import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool isExpanded = false;

  void toggleFab() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isExpanded) ...[
            _buildMiniFab(Icons.description, 'Invoice',  Color(0xFF00e673), () {
              // Add create invoice logic
            }),
            const SizedBox(height: 8),
            _buildMiniFab(Icons.local_shipping, 'Challan', Color(0xFF0000ff), () {
              // Add create challan logic
            }),
            const SizedBox(height: 8),
            _buildMiniFab(Icons.request_quote, 'Quotation', Color(0xFFa300cc), () {
              // Add create quotation logic
            }),
            const SizedBox(height: 8),
          ],
          FloatingActionButton(
            onPressed: toggleFab,
            backgroundColor: Color(0xFF000066),
            child: Icon(isExpanded ? Icons.close : Icons.add,color: Colors.white,),
          ),
        ],
      ),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor:Color(0xFF000066),
        title: const Text('Dashboard',style:TextStyle(color: Colors.white),),
      ),
      drawer: Drawer(
        backgroundColor:Color(0xFF000066),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero
        ),
        child: Column(
        //  padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 40,),
            ListTile(
              tileColor: Color(0xFF000066),
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                  child: const Icon(Icons.person,size: 35,
              )),
              title: const Text('User Name' ,style: TextStyle(color: Colors.white),),
              subtitle: Text('user@example.com' ,style: TextStyle(color: Colors.white)),
              onTap: () {
                // Navigate to history page
                Navigator.pop(context);
                // Add your navigation logic here
              },
            ),
            Divider(),
       Expanded(
         child: Container(
           color: Colors.white,
           child: Column(
             children: [
               ListTile(
                 leading: const Icon(Icons.production_quantity_limits),
                 title: const Text('Products'),
                 onTap: () {
                   // Navigate to history page
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.people),
                 title: const Text('Clients'),
                 onTap: () {
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.description),
                 title: const Text('Invoices'),
                 onTap: () {
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.local_shipping),
                 title: const Text('Delivery Challans'),
                 onTap: () {
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.request_quote),
                 title: const Text('Quotations'),
                 onTap: () {
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.settings),
                 title: const Text('Settings'),
                 onTap: () {
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
               ListTile(
                 leading: const Icon(Icons.share),
                 title: const Text('Share App'),
                 onTap: () {
                   Navigator.pop(context);
                   // Share.share('Check out this awesome app!');
                 },
               ),
               const Divider(),
               ListTile(
                 leading: const Icon(Icons.info),
                 title: const Text('About Us'),
                 onTap: () {
                   Navigator.pop(context);
                   // Add your navigation logic here
                 },
               ),
             ],
           ),
         ),
       )
          ],
        ),
      ),
      body:SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              color: Color(0xFF00e673),
              title: 'Invoices',
              weeklyCount: 25,
              monthlyCount: 98,
              totalCount: 547,
            ),
            const SizedBox(height: 16),
            _buildCard(
              color: Color(0xFF0000ff),
              title: 'Delivery Challans',
              weeklyCount: 18,
              monthlyCount: 76,
              totalCount: 432,
            ),
            const SizedBox(height: 16),
            _buildCard(
              color: Color(0xFFa300cc),
              title: 'Quotations',
              weeklyCount: 12,
              monthlyCount: 45,
              totalCount: 298,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCard({
    required Color color,
    required String title,
    required int weeklyCount,
    required int monthlyCount,
    required int totalCount,
  }) {
    return Card(  color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCountItem(
                  label: 'Weekly',
                  count: weeklyCount,
                  color: color,
                ),
                _buildCountItem(
                  label: 'Monthly',
                  count: monthlyCount,
                  color: color,
                ),
                _buildCountItem(
                  label: 'Total',
                  count: totalCount,
                  color: color,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMiniFab(IconData icon, String label, Color color, VoidCallback onPressed) {
    return Container(
      width: 100, // Set a custom width here
      child: FloatingActionButton(
        backgroundColor: color,
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Optional: makes the button rectangular
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 4), // Space between icon and text
            Text(
              label,
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildCountItem({
    required String label,
    required int count,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}