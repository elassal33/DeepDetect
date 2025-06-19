import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:grad_project/models/customer.dart';
import 'package:grad_project/screens/customerImage.dart';
import 'package:grad_project/widgets/custom_textfield.dart';
import 'package:grad_project/widgets/custom_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:grad_project/helper/create_customer.dart';

class CustomersPage extends StatefulWidget {
  final String token;
  static String id = 'CustomersPage';
  const CustomersPage({required this.token});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final ApiService apiService = ApiService();
  List<Customer> customers = [];
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = false; // To show loading indicator

  String? _signatureUrl;

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
    _searchCustomers(""); // Load all customers initially
  }

  Future<void> _fetchCustomers() async {
    try {
      final fetched = await apiService.getCustomers(widget.token);
      setState(() => customers = fetched);
    } catch (e) {
      _showSnackBar('Failed to load customers: $e');
    }
  }

  Future<void> _deleteCustomer(int id) async {
    try {
      await apiService.deleteCustomer(id, widget.token);
      setState(() => customers.removeWhere((c) => c.id == id));
      _showSnackBar("Customer deleted successfully");
    } catch (e) {
      _showSnackBar('Customer deleted successfully');
    }
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

  void _showSnackBar(String msg) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

  Future<void> _showCreateCustomerDialog() async {
    final fNameCtrl = TextEditingController();
    final lNameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Customer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: fNameCtrl,
              hintText: 'First Name',
              labelText: 'First Name',
            ),
            const SizedBox(width: 20),
            CustomTextField(
              controller: lNameCtrl,
              hintText: 'Last Name',
              labelText: 'Last Name',
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: () async => await _pickImage(),
              child: const Text("Choose Signature File"),
            ),
           // if (_selectedImage != null) Text(_selectedImage!.name),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (fNameCtrl.text.isEmpty ||
                  lNameCtrl.text.isEmpty ||
                  _selectedImage == null) {
                _showSnackBar("Please fill in all fields");
                return;
              }

              try {
                final newCustomer = Customer(
                  id: 0,
                  firstName: fNameCtrl.text,
                  lastName: lNameCtrl.text,
                  signatureUrl: '',
                  email: '',
                  phoneNumber: '',
                  address: '',
                  createdAt: '',
                  updatedAt: '',
                );

                final created =
                    await apiService.createCustomer(newCustomer, widget.token);

                final url = await apiService.uploadSignature(
                  created.id.toString(),
                  _selectedImage!.path,
                  widget.token,
                );

                final updatedCustomer = created.copyWith(signatureUrl: url);
                setState(() => customers.add(updatedCustomer));

                Navigator.pop(context);
              } catch (e) {
                _showSnackBar('Error: $e');
              }
            },
            child: const Text("Create"),
          )
        ],
      ),
    );
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = picked);
    }
  }

  Future<void> _showDeleteCustomerDialog() async {
    Customer? selectedCustomer;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Delete Customer'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Select a customer to delete:"),
                  const SizedBox(height: 10),
                  DropdownButton<Customer>(
                    isExpanded: true,
                    hint: const Text("Choose customer"),
                    value: selectedCustomer,
                    onChanged: (Customer? newValue) {
                      setState(() {
                        selectedCustomer = newValue!;
                      });
                    },
                    items:
                        customers.map<DropdownMenuItem<Customer>>((Customer c) {
                      return DropdownMenuItem<Customer>(
                        value: c,
                        child: Text('${c.id}) ${c.firstName} ${c.lastName}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: selectedCustomer == null
                      ? null
                      : () async {
                          await _deleteCustomer(selectedCustomer!.id!);

                          Navigator.pop(context);
                        },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // const CircleAvatar(
                  //   radius: 30,
                  //   backgroundColor: Colors.grey,
                  //   child: Icon(
                  //     Icons.person,
                  //     size: 30,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (query) {
                        _searchCustomers(
                            query); // Call search function as user types
                      },
                      decoration: InputDecoration(
                        hintText: '      Search customers...',
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
                  const SizedBox(width: 20),
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
                        //subtitle: customer.signatureUrl.isNotEmpty ? Text(customer.signatureUrl) : null,
                        trailing: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onTap: () {
                         Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignatureUploadPage(
                                token: widget.token,
                                customerId: customer.id!,
                              ),
                            ),
                          );


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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "addCustomerBtn",
            onPressed: _showCreateCustomerDialog,
            child: const Icon(Icons.add),
            tooltip: "Add Customer",
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: "deleteCustomerBtn",
            backgroundColor: Colors.red,
            onPressed: _showDeleteCustomerDialog,
            child: const Icon(Icons.delete),
            tooltip: "Delete Customer",
          ),
        ],
      ),
      bottomNavigationBar:
          CustomBottomNavBar(selectedIndex: 2, token: widget.token),
    );
  }
}
