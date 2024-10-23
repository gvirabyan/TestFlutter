import 'package:flutter/material.dart';
import 'package:untitled/pages/settings_page.dart';
import 'history_page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  String _inputHours = '';
  String _inputMinutes = '';
  String _orderDetails = '';
  String _amount = '';

  final List<Widget> _pages = [
    PageContent(title: 'Welcome to the Home Page!'),
    HistoryPage(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _loadOrderDetails();
  }

  void _onItemTapped(int index) async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _selectedIndex = index;
      _isLoading = false;
    });
  }

  Future<void> _loadOrderDetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _orderDetails = prefs.getString('order') ?? '';
    });
  }

  Future<void> _saveOrderDetails(String details) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('order', details);
  }

  void _showAddOrderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Order'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Hours',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _inputHours = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Minutes',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _inputMinutes = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                DateTime currentDate = DateTime.now();
                String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);
                String orderDetails = 'Order in process\nStart Date: $formattedDate\nTime: $_inputHours hours and $_inputMinutes minutes';

                setState(() {
                  _orderDetails = orderDetails;
                });

                _saveOrderDetails(orderDetails);
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _completeOrder() {
    print('Order completed with amount: $_amount');

    setState(() {
      _orderDetails = '';
      _amount = '';
    });
    _saveOrderDetails('');
  }

  void _cancelOrder() {
    print('Order cancelled');

    setState(() {
      _orderDetails = '';
      _amount = '';
    });
    _saveOrderDetails('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _isLoading
                    ? CircularProgressIndicator()
                    : _selectedIndex == 0
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _pages[_selectedIndex],
                    SizedBox(height: 20),
                    _orderDetails.isNotEmpty
                        ? Column(
                      children: [
                        Text(
                          _orderDetails,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 20),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: 'Amount',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _amount = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: _completeOrder,
                              child: Text('Complete Order'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _cancelOrder,
                              child: Text('Cancel Order'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                        : ElevatedButton(
                      onPressed: _showAddOrderDialog,
                      child: Text('Add Order'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                    ),
                  ],
                )
                    : _pages[_selectedIndex],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton('Home', 0),
                _buildButton('History', 1),
                _buildButton('Settings', 2),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String label, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.yellow, Colors.orange],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            color: _selectedIndex == index ? Colors.black : Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final String title;

  const PageContent({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 24),
      textAlign: TextAlign.center,
    );
  }
}
