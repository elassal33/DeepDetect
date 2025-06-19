import 'package:flutter/material.dart';
import 'package:grad_project/helper/create_customer.dart';
import 'package:grad_project/models/customer.dart';

class SearchPage extends StatefulWidget {
   SearchPage({super.key, required this.token});
   final String token;
   static String id = 'SearchPage';

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

   final ApiService apiService = ApiService();
  List<Customer> customers = [];
   final TextEditingController _searchController = TextEditingController();
  bool isLoading = false; // To show loading indicator
 
  String? _signatureUrl;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _searchCustomers(""); // Load all customers initially
  }
  Future<void> _searchCustomers(String query) async {
    setState(() {
      isLoading = true; // Show loading indicator
    });

    try {
      List<Map<String, dynamic>> searchResults =
          await apiService.searchCustomers(query, widget.token);

      setState(() {
        customers =
            searchResults.map((json) => Customer.fromJson(json)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _fetchCustomers() async {
    try {
      List<Customer> fetchedCustomers =
          await apiService.getCustomers(widget.token);
      setState(() {
        customers = fetchedCustomers;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load customers: $e')),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        _searchCustomers(
                            query); // Call search function as user types
                      },
                      decoration: InputDecoration(
                        hintText: '  Search customers...',
                        suffixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'Start Verifying',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xff4447EB),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    Customer customer = customers[index];
                    return Card(
                      color: const Color(0xffDEDDEF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          '${customer.id}) ${customer.firstName} ${customer.lastName}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onTap: () {
                          Navigator.pop(context,
                              customer); // Send customer back to HomePage
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}