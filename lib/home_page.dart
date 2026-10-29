import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'service_catalog_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  static const Color primaryPink = Color(0xFFFF2D75);
  static const Color backgroundColor = Color(0xFFFFF5F7);
  static const Color cardColor = Colors.white;
  static const Color lightPink = Color(0xFFFFE8EF);
  static const Color borderPink = Color(0xFFF8BBD0);
  static const Color darkPink = Color(0xFFD81B60);
  static const Color green = Color(0xFF22A06B);
  static const Color orange = Color(0xFFFF8A3D);
  static const Color darkText = Color(0xFF242424);


  final List<Map<String, dynamic>> debts = 
  [
  {
    "name": "Juan Dela Cruz",
    "description": "Borrowed for school expenses",
    "total": 1500.00,
    "paid": 500.00,
    "dueDate": "September 28, 2026",
    "promisedDate": null,
    "status": "Active",
    "payments": [
      {
        "amount": 500.00,
        "date": "September 20, 2026"
      }
    ]
  },
  {
    "name": "Maria Santos",
    "description": "Shared food and transportation",
    "total": 850.00,
    "paid": 250.00,
    "dueDate": "October 3, 2026",
    "promisedDate": null,
    "status": "Active",
    "payments": [
      {
        "amount": 250.00,
        "date": "September 19, 2026"
      }
    ]
  },
  {
    "name": "Mark Reyes",
    "description": "Emergency medical bills assistance",
    "total": 3500.00,
    "paid": 3500.00,
    "dueDate": "October 15, 2026",
    "promisedDate": null,
    "status": "Paid",
    "payments": [
      {
        "amount": 2000.00,
        "date": "October 1, 2026"
      },
      {
        "amount": 1500.00,
        "date": "October 14, 2026"
      }
    ]
  },
  {
    "name": "Ana Gonzales",
    "description": "Laptop repair contribution",
    "total": 2200.00,
    "paid": 0.00,
    "dueDate": "October 10, 2026",
    "promisedDate": "October 30, 2026",
    "status": "Overdue",
    "payments": []
  },
  {
    "name": "Carlo Mendoza",
    "description": "Grocery run share",
    "total": 1200.00,
    "paid": 600.00,
    "dueDate": "November 5, 2026",
    "promisedDate": null,
    "status": "Active",
    "payments": [
      {
        "amount": 600.00,
        "date": "October 22, 2026"
      }
    ]
  },
  {
    "name": "Grace Ramos",
    "description": "Concert ticket installment",
    "total": 4500.00,
    "paid": 1500.00,
    "dueDate": "October 20, 2026",
    "promisedDate": "November 2, 2026",
    "status": "Promised",
    "payments": [
      {
        "amount": 1500.00,
        "date": "October 5, 2026"
      }
    ]
  },
  {
    "name": "Jayson Bautista",
    "description": "Apartment deposit split",
    "total": 5000.00,
    "paid": 2500.00,
    "dueDate": "November 15, 2026",
    "promisedDate": null,
    "status": "Active",
    "payments": [
      {
        "amount": 2500.00,
        "date": "October 10, 2026"
      }
    ]
  },
  {
    "name": "Liza Aquino",
    "description": "Small business inventory capital",
    "total": 8000.00,
    "paid": 8000.00,
    "dueDate": "September 15, 2026",
    "promisedDate": null,
    "status": "Paid",
    "payments": [
      {
        "amount": 3000.00,
        "date": "August 20, 2026"
      },
      {
        "amount": 3000.00,
        "date": "September 1, 2026"
      },
      {
        "amount": 2000.00,
        "date": "September 14, 2026"
      }
    ]
  },
  {
    "name": "Dexter Tan",
    "description": "Electricity and water bills share",
    "total": 950.00,
    "paid": 0.00,
    "dueDate": "November 1, 2026",
    "promisedDate": null,
    "status": "Active",
    "payments": []
  },
  {
    "name": "Rhea Torralba",
    "description": "Personal peer-to-peer loan",
    "total": 3000.00,
    "paid": 1000.00,
    "dueDate": "October 1, 2026",
    "promisedDate": "October 29, 2026",
    "status": "Overdue",
    "payments": [
      {
        "amount": 1000.00,
        "date": "September 25, 2026"
      }
    ]
  }
  ];

  @override
  void initState() {
    super.initState();
    _syncPaidPeople();
  }

  void _syncPaidPeople() {
    final fullyPaid = debts.where((debt) {
      final total = (debt['total'] as num).toDouble();
      final paid = (debt['paid'] as num).toDouble();
      return paid >= total || debt['status'] == 'Paid';
    }).toList();

    for (final debt in fullyPaid) {
      _archivePaidPerson(debt);
    }
  }

  final TextEditingController _debtSearchController = TextEditingController();
  String _selectedDebtFilter = 'All';

  @override
  void dispose() {
    _debtSearchController.dispose();
    super.dispose();
  }


  final List<Map<String, dynamic>> paidPeople = [
    {
      'name': 'Carlo Reyes',
      'description': 'Emergency loan',
      'total': 2000.00,
      'paid': 2000.00,
      'dueDate': 'September 15, 2026',
      'promisedDate': null,
      'status': 'Paid',
      'payments': [
        {
          'amount': 1000.00,
          'date': 'September 5, 2026',
        },
        {
          'amount': 1000.00,
          'date': 'September 15, 2026',
        },
      ],
    },
  ];

  final List<Map<String, dynamic>> serviceCatalog = [
    {
      'id': '1',
      'title': 'Emergency Cash Loan',
      'category': 'Loans',
      'description': 'Short-term urgent cash assistance',
      'defaultAmount': 1000.00,
      'icon': Icons.attach_money_rounded,
    },
    {
      'id': '2',
      'title': 'Food / Meal Share',
      'category': 'Shared Bills',
      'description': 'Shared dining, takeout, or food delivery split',
      'defaultAmount': 250.00,
      'icon': Icons.restaurant_rounded,
    },
    {
      'id': '3',
      'title': 'Rent & Housing Share',
      'category': 'Shared Bills',
      'description': 'Monthly house rent, apartment, or dorm split',
      'defaultAmount': 3500.00,
      'icon': Icons.home_work_rounded,
    },
    {
      'id': '4',
      'title': 'Utility Bills (Electric & Water)',
      'category': 'Utilities',
      'description': 'Electricity, water, or internet connection bill',
      'defaultAmount': 750.00,
      'icon': Icons.bolt_rounded,
    },
    {
      'id': '5',
      'title': 'Groceries & Supplies',
      'category': 'Shared Bills',
      'description': 'Supermarket, market or household goods split',
      'defaultAmount': 500.00,
      'icon': Icons.shopping_basket_rounded,
    },
    {
      'id': '6',
      'title': 'School & Tuition Expenses',
      'category': 'Education',
      'description': 'Books, tuition, school projects or exam fees',
      'defaultAmount': 1500.00,
      'icon': Icons.school_rounded,
    },
    {
      'id': '7',
      'title': 'Transportation / Gas Fare',
      'category': 'Travel',
      'description': 'Commute fare, taxi, Grab, or gasoline contribution',
      'defaultAmount': 200.00,
      'icon': Icons.directions_car_rounded,
    },
    {
      'id': '8',
      'title': 'Freelance / Labor Service',
      'category': 'Services',
      'description': 'Professional design, repair, encoding or consultation',
      'defaultAmount': 2000.00,
      'icon': Icons.work_outline_rounded,
    },
  ];

  void _openServiceCatalog() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ServiceCatalogPage(
          catalog: serviceCatalog,
          existingDebtors: [
            ...debts.map((d) => d['name'].toString()),
            ...paidPeople.map((p) => p['name'].toString()),
          ].toSet().toList(),
          onBillDebtor: _billDebtorFromCatalog,
          onAddService: (newService) {
            setState(() {
              serviceCatalog.add(newService);
            });
          },
          onDeleteService: (service) {
            setState(() {
              serviceCatalog.remove(service);
            });
          },
        ),
      ),
    );
  }

  void _billDebtorFromCatalog(
    String debtorName,
    double amount,
    String description,
  ) {
    final name = debtorName.trim();
    final existingIndex = debts.indexWhere(
      (debt) => debt['name'].toString().toLowerCase() == name.toLowerCase(),
    );

    setState(() {
      if (existingIndex >= 0) {
        final existing = debts[existingIndex];
        existing['total'] = (existing['total'] as num).toDouble() + amount;
        existing['description'] =
            description.isEmpty ? existing['description'] : description;
        existing['status'] = 'Active';
      } else {
        debts.add({
          'name': name,
          'description': description.isEmpty ? 'Personal debt' : description,
          'total': amount,
          'paid': 0.0,
          'dueDate': 'Not set',
          'promisedDate': null,
          'status': 'Active',
          'payments': [],
        });
      }

      paidPeople.removeWhere(
        (person) =>
            person['name'].toString().toLowerCase() == name.toLowerCase(),
      );
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          existingIndex >= 0
              ? 'Added ₱${amount.toStringAsFixed(2)} to $name\'s debt.'
              : 'New debt of ₱${amount.toStringAsFixed(2)} added for $name.',
        ),
      ),
    );
  }


  double get totalDebt {
    double total = 0;

    for (final debt in debts) {
      total += (debt['total'] as num).toDouble();
    }

    for (final person in paidPeople) {
      total += (person['total'] as num).toDouble();
    }

    return total;
  }

  double get totalPaid {
    double total = 0;

    for (final debt in debts) {
      total += (debt['paid'] as num).toDouble();
    }

    for (final person in paidPeople) {
      total += (person['paid'] as num).toDouble();
    }

    return total;
  }

  double get totalRemaining {
    double total = 0;

    for (final debt in debts) {
      final remaining =
          (debt['total'] as num).toDouble() -
          (debt['paid'] as num).toDouble();

      if (remaining > 0) {
        total += remaining;
      }
    }

    return total;
  }

  int get activeDebtCount {
    return debts.where((debt) {
      final total = (debt['total'] as num).toDouble();
      final paid = (debt['paid'] as num).toDouble();

      return paid < total;
    }).length;
  }


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    final username =
        user?.email?.split('@')[0] ?? 'Buddy';

    final String query = _debtSearchController.text.trim().toLowerCase();

    List<Map<String, dynamic>> filteredDebts = debts.where((debt) {
      final name = (debt['name'] ?? '').toString().toLowerCase();
      final desc = (debt['description'] ?? '').toString().toLowerCase();
      final matchesQuery =
          query.isEmpty || name.contains(query) || desc.contains(query);
      if (!matchesQuery) return false;

      final remaining =
          (debt['total'] as num).toDouble() - (debt['paid'] as num).toDouble();
      if (_selectedDebtFilter == 'Active' && remaining <= 0) return false;
      if (_selectedDebtFilter == 'Promised' &&
          (debt['promisedDate'] == null || remaining <= 0)) {
        return false;
      }

      return true;
    }).toList();

    if (_selectedDebtFilter == 'Highest') {
      filteredDebts.sort((a, b) {
        final remA =
            (a['total'] as num).toDouble() - (a['paid'] as num).toDouble();
        final remB =
            (b['total'] as num).toDouble() - (b['paid'] as num).toDouble();
        return remB.compareTo(remA);
      });
    }

    return Scaffold(
      backgroundColor: backgroundColor,


      appBar: AppBar(
        backgroundColor: primaryPink,
        elevation: 0,

        title: const Text(
          'SingilBuddy',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              _showNotifications();
            },
          ),
        ],
      ),


      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: primaryPink,
              ),

              accountName: Text(username),

              accountEmail: Text(
                user?.email ?? 'user@email.com',
              ),

              currentAccountPicture:
                  const CircleAvatar(
                backgroundColor: Colors.white,

                child: Icon(
                  Icons.person,
                  color: primaryPink,
                  size: 30,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(
                Icons.dashboard_rounded,
              ),

              title: const Text('Dashboard'),

              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.receipt_long_rounded,
              ),

              title: const Text('Collectibles'),

              onTap: () {
                Navigator.pop(context);
              },
            ),


            ListTile(
              leading: const Icon(
                Icons.account_balance_wallet_rounded,
                color: primaryPink,
              ),

              title: const Text(
                'Promissory Vault',
              ),

              subtitle: const Text(
                'View promised payment dates',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PromissoryVaultPage(
                      debts: debts,
                      onSetPromiseDate:
                          _setPromiseDate,
                      onPayDebt:
                          _showPaymentDialog,
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.history_rounded,
              ),

              title: const Text(
                'Payment History',
              ),

              onTap: () {
                Navigator.pop(context);
                _showAllHistory();
              },
            ),


            ListTile(
              leading: const Icon(
                Icons.verified_rounded,
                color: green,
              ),

              title: const Text(
                'Paid People',
              ),

              trailing: paidPeople.isNotEmpty
                  ? Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.green.shade50,
                        borderRadius:
                            BorderRadius.circular(
                          20,
                        ),
                      ),

                      child: Text(
                        '${paidPeople.length}',
                        style:
                            const TextStyle(
                          color: green,
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : null,

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        PaidPeoplePage(
                      paidPeople: paidPeople,
                      onAddNewDebt:
                          _addNewDebtToPaidPerson,
                      onDelete:
                          _deletePaidPerson,
                    ),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.inventory_2_outlined,
                color: Color(0xFF6C5CE7),
              ),

              title: const Text(
                'Service Catalog',
              ),

              subtitle: const Text(
                'Predefined debts & billing templates',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black54,
                ),
              ),

              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF6C5CE7).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${serviceCatalog.length}',
                  style: const TextStyle(
                    color: Color(0xFF6C5CE7),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),

              onTap: () {
                Navigator.pop(context);
                _openServiceCatalog();
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.alarm_rounded,
              ),

              title: const Text(
                'Payment Reminders',
              ),

              onTap: () {
                Navigator.pop(context);
                _showNotifications();
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.red,
              ),

              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),

              onTap: () async {
                await FirebaseAuth.instance
                    .signOut();
              },
            ),
          ],
        ),
      ),


      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                'Hello, $username 👋',

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),

              const SizedBox(height: 4),

              const Text(
                'Keep track of who owes you.',

                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 18),


              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      primaryPink,
                      Color(0xFFFF4F8A),
                    ],
                  ),

                  borderRadius:
                      BorderRadius.circular(20),

                  boxShadow: [
                    BoxShadow(
                      color: primaryPink
                          .withValues(alpha: 0.25),

                      blurRadius: 12,

                      offset:
                          const Offset(0, 6),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Total to Collect',

                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      '₱${totalRemaining.toStringAsFixed(2)}',

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Row(
                      children: [
                        _summaryItem(
                          'Active Debts',
                          '$activeDebtCount',
                        ),

                        const SizedBox(width: 24),

                        _summaryItem(
                          'Collected',
                          '₱${totalPaid.toStringAsFixed(2)}',
                        ),

                        const SizedBox(width: 24),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaidPeoplePage(
                                  paidPeople: paidPeople,
                                  onAddNewDebt: _addNewDebtToPaidPerson,
                                  onDelete: _deletePaidPerson,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: _summaryItem(
                            'Paid People',
                            '${paidPeople.length}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),


              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Quick Actions',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed:
                        _showAddDebtDialog,

                    child: const Text(
                      '+ Add Debt',

                      style: TextStyle(
                        color: primaryPink,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: _quickAction(
                      icon: Icons.person_add_alt_1_rounded,
                      title: 'Add Debt',
                      onTap: _showAddDebtDialog,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.inventory_2_rounded,
                      title: 'Catalog',
                      onTap: _openServiceCatalog,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.qr_code_2_rounded,
                      title: 'Payment Request',
                      onTap: () {
                        _showPaymentRequest();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _quickAction(
                      icon: Icons.history_rounded,
                      title: 'History',
                      onTap: () {
                        _showAllHistory();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),

              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderPink),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _debtSearchController,
                  onChanged: (val) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search debtors by name or note...',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: Colors.black38,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: primaryPink,
                    ),
                    suffixIcon: _debtSearchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close_rounded,
                              size: 18,
                              color: Colors.black45,
                            ),
                            onPressed: () {
                              _debtSearchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 13,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _filterChip(label: 'All', count: debts.length),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Active',
                      count: debts
                          .where((d) =>
                              (d['total'] as num).toDouble() >
                              (d['paid'] as num).toDouble())
                          .length,
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Promised',
                      icon: Icons.alarm,
                      count: debts
                          .where((d) =>
                              d['promisedDate'] != null &&
                              (d['total'] as num).toDouble() >
                              (d['paid'] as num).toDouble())
                          .length,
                    ),
                    const SizedBox(width: 8),
                    _filterChip(
                      label: 'Highest',
                      icon: Icons.arrow_downward_rounded,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'My Collectibles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                  Text(
                    _debtSearchController.text.isNotEmpty ||
                            _selectedDebtFilter != 'All'
                        ? '${filteredDebts.length} of ${debts.length} shown'
                        : '$activeDebtCount active',
                    style: const TextStyle(
                      color: primaryPink,
                      fontSize: 13,
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (debts.isEmpty)
                _emptyCollectibles()
              else if (filteredDebts.isEmpty)
                _noSearchResults()
              else
                ...filteredDebts.map(
                  (debt) => Padding(
                    padding:
                        const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child:
                        _debtCard(debt),
                  ),
                ),

              const SizedBox(height: 10),


              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Recent Payments',

                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  TextButton(
                    onPressed:
                        _showAllHistory,

                    child: const Text(
                      'View All',

                      style: TextStyle(
                        color: primaryPink,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              _recentPayments(),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),


      floatingActionButton:
          FloatingActionButton.extended(
        backgroundColor: primaryPink,
        foregroundColor: Colors.white,

        icon: const Icon(Icons.add),

        label: const Text(
          'Add Debt',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        onPressed:
            _showAddDebtDialog,
      ),
    );
  }


  Widget _emptyCollectibles() {
    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(30),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),

        border:
            Border.all(
          color: borderPink,
        ),
      ),

      child: Column(
        children: [
          Icon(
            Icons.people_outline_rounded,

            size: 50,

            color:
                primaryPink.withValues(alpha: 0.6),
          ),

          const SizedBox(height: 10),

          const Text(
            'No active debts',

            style: TextStyle(
              fontWeight:
                  FontWeight.bold,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            'Add a person to start tracking a debt.',

            textAlign:
                TextAlign.center,

            style: TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noSearchResults() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderPink),
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 10),
          const Text(
            'No matching debtors found',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _debtSearchController.text.isNotEmpty
                ? 'No debtor matches "${_debtSearchController.text}".'
                : 'No debtor matches the "$_selectedDebtFilter" filter.',
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _debtSearchController.clear();
                _selectedDebtFilter = 'All';
              });
            },
            icon: const Icon(Icons.refresh_rounded, size: 16, color: primaryPink),
            label: const Text('Reset search & filters',
                style: TextStyle(color: primaryPink)),
          ),
        ],
      ),
    );
  }

  Widget _filterChip({
    required String label,
    IconData? icon,
    int? count,
  }) {
    final isSelected = _selectedDebtFilter == label;
    return ChoiceChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedDebtFilter = label;
        });
      },
      avatar: icon != null
          ? Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : primaryPink,
            )
          : null,
      label: Text(
        count != null ? '$label ($count)' : label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: Colors.white,
      selectedColor: primaryPink,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? primaryPink : borderPink,
        ),
      ),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    );
  }


  Widget _summaryItem(
    String title,
    String value,
  ) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [
        Text(
          value,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          title,

          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }


  Widget _quickAction({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: borderPink,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: primaryPink,
              size: 24,
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 28,
              child: Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _debtCard(
    Map<String, dynamic> debt,
  ) {
    final double total =
        (debt['total'] as num)
            .toDouble();

    final double paid =
        (debt['paid'] as num)
            .toDouble();

    final double remaining =
        total - paid;

    final double progress =
        total <= 0
            ? 0
            : (paid / total)
                .clamp(0.0, 1.0);

    final bool completed =
        remaining <= 0;

    return InkWell(
      onTap: () {
        _showDebtDetails(debt);
      },

      borderRadius:
          BorderRadius.circular(18),

      child: Container(
        padding:
            const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius:
              BorderRadius.circular(18),

          border: Border.all(
            color: completed
                ? Colors.green.shade200
                : borderPink,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.04),

              blurRadius: 8,

              offset:
                  const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,

                  backgroundColor:
                      completed
                          ? Colors.green.shade50
                          : lightPink,

                  child: Text(
                    debt['name']
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),

                    style: TextStyle(
                      color: completed
                          ? green
                          : primaryPink,

                      fontWeight:
                          FontWeight.bold,

                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        debt['name'],

                        style:
                            const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 3),

                      Text(
                        debt['description'],

                        maxLines: 2,

                        overflow:
                            TextOverflow.ellipsis,

                        style:
                            const TextStyle(
                          fontSize: 12,
                          color:
                              Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),

                  decoration:
                      BoxDecoration(
                    color: completed
                        ? Colors.green.shade50
                        : lightPink,

                    borderRadius:
                        BorderRadius.circular(
                      20,
                    ),
                  ),

                  child: Text(
                    completed
                        ? 'Paid'
                        : 'Active',

                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,

                      color: completed
                          ? green
                          : darkPink,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,

              children: [
                Text(
                  '₱${paid.toStringAsFixed(2)} paid',

                  style:
                      const TextStyle(
                    fontSize: 12,
                    color:
                        Colors.black54,
                  ),
                ),

                Text(
                  '₱${total.toStringAsFixed(2)} total',

                  style:
                      const TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.w600,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 7),

            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),

              child:
                  LinearProgressIndicator(
                value: progress,

                minHeight: 7,

                backgroundColor:
                    lightPink,

                valueColor:
                    const AlwaysStoppedAnimation<
                        Color>(
                  primaryPink,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: Colors.black45,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    'Due ${debt['dueDate']}',

                    style:
                        const TextStyle(
                      fontSize: 11,
                      color:
                          Colors.black54,
                    ),
                  ),
                ),

                if (!completed)
                  Text(
                    '₱${remaining.toStringAsFixed(2)} left',

                    style:
                        const TextStyle(
                      color: primaryPink,
                      fontSize: 12,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
              ],
            ),

            if (debt['promisedDate'] != null && !completed) ...[
              const SizedBox(height: 8),

              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(9),

                decoration:
                    BoxDecoration(
                  color: lightPink,

                  borderRadius:
                      BorderRadius.circular(
                    10,
                  ),
                ),

                child: Row(
                  children: [
                    const Icon(
                      Icons.handshake_rounded,
                      color: primaryPink,
                      size: 16,
                    ),

                    const SizedBox(width: 6),

                    Expanded(
                      child: Text(
                        'Promised: ${debt['promisedDate']}',

                        style:
                            const TextStyle(
                          color: primaryPink,
                          fontSize: 11,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child:
                      OutlinedButton.icon(
                    onPressed: () {
                      _showDebtDetails(
                        debt,
                      );
                    },

                    icon: const Icon(
                      Icons.history,
                      size: 16,
                    ),

                    label:
                        const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Details',
                      ),
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          primaryPink,

                      side:
                          const BorderSide(
                        color: borderPink,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 6),

                Expanded(
                  child:
                      OutlinedButton.icon(
                    onPressed: () {
                      _showAddDebtForDebtorDialog(
                        debt,
                      );
                    },

                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 16,
                    ),

                    label:
                        const FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Add Debt',
                      ),
                    ),

                    style:
                        OutlinedButton.styleFrom(
                      foregroundColor:
                          primaryPink,

                      side:
                          const BorderSide(
                        color: borderPink,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 6,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),
                  ),
                ),

                if (!completed) ...[
                  const SizedBox(width: 6),

                  Expanded(
                    child:
                        ElevatedButton.icon(
                      onPressed: () {
                        _showPaymentDialog(
                          debt,
                        );
                      },

                      icon: const Icon(
                        Icons.payments_outlined,
                        size: 16,
                      ),

                      label:
                          const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Pay Debt',
                        ),
                      ),

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            primaryPink,

                        foregroundColor:
                            Colors.white,

                        elevation: 0,

                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 6,
                        ),

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }


  void _showDebtDetails(
    Map<String, dynamic> debt,
  ) {
    final double total =
        (debt['total'] as num)
            .toDouble();

    final double paid =
        (debt['paid'] as num)
            .toDouble();

    final double remaining =
        total - paid;

    final bool completed =
        remaining <= 0;

    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      backgroundColor:
          Colors.transparent,

      builder: (sheetContext) {
        return Container(
          constraints:
              BoxConstraints(
            maxHeight:
                MediaQuery.of(
                  sheetContext,
                ).size.height *
                0.90,
          ),

          padding:
              const EdgeInsets.all(20),

          decoration:
              const BoxDecoration(
            color: Colors.white,

            borderRadius:
                BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),

          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  Center(
                    child: Container(
                      width: 45,
                      height: 5,

                      decoration:
                          BoxDecoration(
                        color:
                            Colors.black12,

                        borderRadius:
                            BorderRadius.circular(
                          10,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      CircleAvatar(
                        radius: 27,

                        backgroundColor:
                            completed
                                ? Colors.green
                                    .shade50
                                : lightPink,

                        child: Text(
                          debt['name']
                              .toString()
                              .substring(0, 1)
                              .toUpperCase(),

                          style:
                              TextStyle(
                            color: completed
                                ? green
                                : primaryPink,

                            fontWeight:
                                FontWeight.bold,

                            fontSize: 20,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [
                            Text(
                              debt['name'],

                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(
                              debt['description'],

                              style:
                                  const TextStyle(
                                color:
                                    Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _detailRow(
                    'Total Debt',
                    '₱${total.toStringAsFixed(2)}',
                  ),

                  _detailRow(
                    'Paid',
                    '₱${paid.toStringAsFixed(2)}',
                  ),

                  _detailRow(
                    'Remaining',
                    '₱${remaining.toStringAsFixed(2)}',
                  ),

                  _detailRow(
                    'Due Date',
                    debt['dueDate'],
                  ),

                  if (debt['promisedDate'] != null && !completed)
                    _detailRow(
                      'Promised Date',
                      debt['promisedDate'],
                    ),

                  const SizedBox(height: 18),

                  if (completed)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.green.shade200,
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: green,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Debt is fully paid! No promised date can be set.',
                              style: TextStyle(
                                color: green,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: lightPink,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: borderPink,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.handshake_rounded,
                                color: primaryPink,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Promissory Commitment',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryPink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            debt['promisedDate'] == null
                                ? 'No promised payment date has been set.'
                                : 'Promised to pay on ${debt['promisedDate']}.',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                Navigator.pop(sheetContext);
                                _setPromiseDate(debt);
                              },
                              icon: const Icon(
                                Icons.event_available_rounded,
                                size: 18,
                              ),
                              label: Text(
                                debt['promisedDate'] == null
                                    ? 'Set Promise Date'
                                    : 'Change Promise Date',
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: primaryPink,
                                side: const BorderSide(color: borderPink),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 18),


                  const Text(
                    'Payment History',

                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  if ((debt['payments']
                          as List)
                      .isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        vertical: 15,
                      ),

                      child: Text(
                        'No payments recorded yet.',

                        style: TextStyle(
                          color:
                              Colors.black54,
                        ),
                      ),
                    )
                  else
                    ...List.generate(
                      (debt['payments']
                              as List)
                          .length,
                      (index) {
                        final payment =
                            debt['payments']
                                [index];

                        return ListTile(
                          contentPadding:
                              EdgeInsets.zero,

                          leading:
                              const CircleAvatar(
                            backgroundColor:
                                Color(
                              0xFFE8F7F0,
                            ),

                            child: Icon(
                              Icons.check,
                              color: green,
                            ),
                          ),

                          title: Text(
                            '₱${(payment['amount'] as num).toDouble().toStringAsFixed(2)}',

                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          subtitle:
                              Text(
                            payment['date'],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(
                          sheetContext,
                        );

                        _showAddDebtForDebtorDialog(
                          debt,
                        );
                      },
                      icon: const Icon(
                        Icons.add_circle_outline_rounded,
                        size: 18,
                      ),
                      label: const Text(
                        'Add Debt',
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: primaryPink,
                        side: const BorderSide(
                          color: borderPink,
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            14,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  if (!completed)
                    SizedBox(
                      width:
                          double.infinity,

                      child:
                          ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(
                            sheetContext,
                          );

                          _showPaymentDialog(
                            debt,
                          );
                        },

                        icon: const Icon(
                          Icons.payments,
                        ),

                        label: const Text(
                          'Pay Debt',
                        ),

                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              primaryPink,

                          foregroundColor:
                              Colors.white,

                          padding:
                              const EdgeInsets
                                  .symmetric(
                            vertical: 14,
                          ),

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                        ),
                      ),
                    ),

                  const SizedBox(height: 8),


                  SizedBox(
                    width:
                        double.infinity,

                    child:
                        TextButton.icon(
                      onPressed: () {
                        Navigator.pop(
                          sheetContext,
                        );

                        _confirmDeleteDebt(
                          debt,
                        );
                      },

                      icon: const Icon(
                        Icons
                            .delete_outline_rounded,
                        color: Colors.red,
                        size: 18,
                      ),

                      label: const Text(
                        'Delete Person',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _detailRow(
    String title,
    String value,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        vertical: 6,
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

        children: [
          Text(
            title,

            style: const TextStyle(
              color: Colors.black54,
            ),
          ),

          Flexible(
            child: Text(
              value,

              textAlign:
                  TextAlign.right,

              style:
                  const TextStyle(
                fontWeight:
                    FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Future<void> _setPromiseDate(
    Map<String, dynamic> debt,
  ) async {
    final double total =
        (debt['total'] as num).toDouble();
    final double paid =
        (debt['paid'] as num).toDouble();
    final double remaining =
        total - paid;

    if (remaining <= 0 || debt['status'] == 'Paid') {
      setState(() {
        debt['promisedDate'] = null;
      });
      if (debts.contains(debt)) {
        _archivePaidPerson(debt);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${debt['name']} has already paid all their debt. Cannot set a promised date.',
          ),
          backgroundColor: Colors.orange.shade800,
        ),
      );
      return;
    }

    final DateTime now =
        DateTime.now();

    DateTime initialDate = now;

    if (debt['promisedDate'] != null) {
      final parsed =
          DateTime.tryParse(
        debt['promisedDate']
            .toString(),
      );

      if (parsed != null &&
          !parsed.isBefore(now)) {
        initialDate = parsed;
      }
    }

    final DateTime? selectedDate =
        await showDatePicker(
      context: context,

      initialDate: initialDate,

      firstDate: now,

      lastDate: DateTime(
        now.year + 10,
        12,
        31,
      ),

      helpText:
          'Select promised payment date',

      cancelText: 'Cancel',

      confirmText: 'Set Date',

      builder:
          (context, child) {
        return Theme(
          data: Theme.of(context)
              .copyWith(
            colorScheme:
                const ColorScheme.light(
              primary: primaryPink,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),

          child: child!,
        );
      },
    );

    if (selectedDate == null) {
      return;
    }

    final formattedDate =
        _formatDate(selectedDate);

    setState(() {
      debt['promisedDate'] =
          formattedDate;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          '${debt['name']} promised to pay on $formattedDate.',
        ),
      ),
    );
  }


  String _formatDate(
    DateTime date,
  ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
  }


  void _showPaymentDialog(
    Map<String, dynamic> debt,
  ) {
    final controller =
        TextEditingController();

    final double total =
        (debt['total'] as num)
            .toDouble();

    final double paid =
        (debt['paid'] as num)
            .toDouble();

    final double remaining =
        total - paid;

    if (remaining <= 0 || debt['status'] == 'Paid') {
      _archivePaidPerson(debt);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${debt['name']} has already paid all their debt.'),
        ),
      );
      return;
    }

    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Payment for ${debt['name']}',
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,

            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [
              Text(
                'Remaining balance: ₱${remaining.toStringAsFixed(2)}',

                style:
                    const TextStyle(
                  color: primaryPink,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                controller: controller,

                keyboardType:
                    const TextInputType
                        .numberWithOptions(
                  decimal: true,
                ),

                decoration:
                    InputDecoration(
                  labelText:
                      'Payment Amount',

                  prefixText: '₱ ',

                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'You can enter a partial payment.',

                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.black54,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final amount =
                    double.tryParse(
                  controller.text,
                );

                if (amount == null ||
                    amount <= 0 ||
                    amount > remaining) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a valid payment amount.',
                      ),
                    ),
                  );

                  return;
                }

                setState(() {
                  debt['paid'] =
                      paid + amount;

                  debt['payments']
                      .add({
                    'amount': amount,
                    'date':
                        _currentDate(),
                  });

                  if (debt['paid'] >=
                      debt['total']) {
                    debt['paid'] =
                        debt['total'];

                    debt['status'] =
                        'Paid';

                    debt['promisedDate'] =
                        null;
                  }
                });

                Navigator.pop(
                  dialogContext,
                );

                if ((debt['paid'] as num)
                        .toDouble() >=
                    (debt['total'] as num)
                        .toDouble()) {
                  _archivePaidPerson(
                    debt,
                  );
                }

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      '₱${amount.toStringAsFixed(2)} payment recorded.',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryPink,

                foregroundColor:
                    Colors.white,
              ),

              child: const Text(
                'Record Payment',
              ),
            ),
          ],
        );
      },
    );
  }


  void _showAddDebtForDebtorDialog(Map<String, dynamic> debt) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Add Debt for ${debt['name']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: lightPink,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderPink),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: primaryPink,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              debt['name']?.toString() ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Current remaining: ₱${((debt['total'] as num).toDouble() - (debt['paid'] as num).toDouble()).toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Additional Debt Amount',
                    prefixText: '₱ ',
                    prefixIcon: const Icon(Icons.payments),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Reason / Note (optional)',
                    hintText: 'e.g. Groceries, Lunch, Emergency loan',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount greater than 0.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                final desc = descriptionController.text.trim();
                setState(() {
                  debt['total'] = (debt['total'] as num).toDouble() + amount;
                  if (desc.isNotEmpty) {
                    debt['description'] = desc;
                  }
                  debt['status'] = 'Active';
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added ₱${amount.toStringAsFixed(2)} debt to ${debt['name']}.',
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Debt'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDebtDialog({
    String? initialName,
    String? initialDescription,
    double? initialAmount,
  }) {
    final nameController =
        TextEditingController(text: initialName ?? '');

    final amountController = TextEditingController(
      text: initialAmount != null ? initialAmount.toStringAsFixed(2) : '',
    );

    final descriptionController =
        TextEditingController(text: initialDescription ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Add New Debt',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (serviceCatalog.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Templates from Catalog:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(dialogContext);
                          _openServiceCatalog();
                        },
                        child: const Text(
                          'View Catalog >',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: primaryPink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: serviceCatalog.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ActionChip(
                            avatar: Icon(
                              item['icon'] as IconData? ?? Icons.design_services_rounded,
                              size: 14,
                              color: primaryPink,
                            ),
                            label: Text(
                              '${item['title']} (₱${(item['defaultAmount'] as num).toStringAsFixed(0)})',
                              style: const TextStyle(fontSize: 11),
                            ),
                            backgroundColor: lightPink,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: borderPink),
                            ),
                            onPressed: () {
                              amountController.text =
                                  (item['defaultAmount'] as num).toStringAsFixed(2);
                              descriptionController.text =
                                  item['title'] as String;
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Person Name',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Debt Amount',
                    prefixText: '₱ ',
                    prefixIcon: const Icon(Icons.payments),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                final name =
                    nameController.text
                        .trim();

                final amount =
                    double.tryParse(
                  amountController.text,
                );

                final description =
                    descriptionController
                        .text
                        .trim();

                if (name.isEmpty ||
                    amount == null ||
                    amount <= 0) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Enter a valid name and amount.',
                      ),
                    ),
                  );

                  return;
                }


                final existingIndex =
                    debts.indexWhere(
                  (debt) =>
                      debt['name']
                          .toString()
                          .toLowerCase() ==
                      name.toLowerCase(),
                );

                setState(() {
                  if (existingIndex >=
                      0) {

                    final existing =
                        debts[
                            existingIndex];

                    existing['total'] =
                        (existing['total']
                                as num)
                            .toDouble() +
                            amount;

                    existing['description'] =
                        description.isEmpty
                            ? existing[
                                'description']
                            : description;

                    existing['status'] =
                        'Active';


                  } else {

                    debts.add({
                      'name': name,

                      'description':
                          description.isEmpty
                              ? 'Personal debt'
                              : description,

                      'total': amount,

                      'paid': 0.0,

                      'dueDate':
                          'Not set',

                      'promisedDate':
                          null,

                      'status':
                          'Active',

                      'payments': [],
                    });
                  }
                });

                paidPeople.removeWhere(
                  (person) =>
                      person['name']
                          .toString()
                          .toLowerCase() ==
                      name.toLowerCase(),
                );

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  SnackBar(
                    content: Text(
                      existingIndex >= 0
                          ? 'New debt added to $name.'
                          : 'New debt added for $name.',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryPink,

                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Add Debt'),
            ),
          ],
        );
      },
    );
  }


  void _archivePaidPerson(
    Map<String, dynamic> debt,
  ) {
    debt['promisedDate'] = null;
    debt['status'] = 'Paid';

    final existing =
        paidPeople.indexWhere(
      (person) =>
          person['name']
              .toString()
              .toLowerCase() ==
          debt['name']
              .toString()
              .toLowerCase(),
    );

    if (existing >= 0) {
      paidPeople[existing] = {
        ...debt,
      };
    } else {
      paidPeople.add({
        ...debt,
      });
    }

    debts.remove(debt);

    setState(() {});
  }


  void _confirmDeleteDebt(
    Map<String, dynamic> debt,
  ) {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Person?',
          ),

          content: Text(
            'This will remove ${debt['name']} and their active debt record from your collectibles.',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  debts.remove(debt);
                });

                Navigator.pop(
                  dialogContext,
                );

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Person removed from collectibles.',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.red,

                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );
  }


  Widget _recentPayments() {
    final List<Map<String, dynamic>>
        payments = [];

    for (final debt in debts) {
      for (final payment
          in debt['payments']) {
        payments.add({
          'name': debt['name'],
          'amount':
              (payment['amount'] as num)
                  .toDouble(),
          'date': payment['date'],
        });
      }
    }

    for (final person in paidPeople) {
      for (final payment
          in person['payments']) {
        payments.add({
          'name': person['name'],
          'amount':
              (payment['amount'] as num)
                  .toDouble(),
          'date': payment['date'],
        });
      }
    }

    if (payments.isEmpty) {
      return Container(
        width: double.infinity,

        padding:
            const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius:
              BorderRadius.circular(16),

          border:
              Border.all(
            color: borderPink,
          ),
        ),

        child: const Center(
          child: Text(
            'No payment history yet.',

            style: TextStyle(
              color: Colors.black54,
            ),
          ),
        ),
      );
    }

    payments.sort(
      (a, b) => b['date']
          .toString()
          .compareTo(
            a['date'].toString(),
          ),
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(16),

        border:
            Border.all(
          color: borderPink,
        ),
      ),

      child: Column(
        children: payments
            .take(5)
            .map(
              (payment) {
                return ListTile(
                  leading:
                      const CircleAvatar(
                    backgroundColor:
                        Color(0xFFE8F7F0),

                    child: Icon(
                      Icons
                          .arrow_downward_rounded,
                      color: green,
                    ),
                  ),

                  title: Text(
                    payment['name'],

                    style:
                        const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),

                  subtitle:
                      Text(
                    payment['date'],
                  ),

                  trailing:
                      Text(
                    '+₱${payment['amount'].toStringAsFixed(2)}',

                    style:
                        const TextStyle(
                      color: green,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                );
              },
            )
            .toList(),
      ),
    );
  }


  void _showAllHistory() {
    showModalBottomSheet(
      context: context,

      isScrollControlled: true,

      builder: (sheetContext) {
        return SafeArea(
          child: SizedBox(
            height:
                MediaQuery.of(
                      sheetContext,
                    ).size.height *
                    0.85,

            child: Padding(
              padding:
                  const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Payment History',

                    style:
                        TextStyle(
                      fontSize: 21,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    'All recorded payments',

                    style:
                        TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(
                      height: 15),

                  Expanded(
                    child:
                        ListView(
                      children: [
                        ...debts.map(
                          (debt) =>
                              _historyPerson(
                            debt,
                          ),
                        ),

                        ...paidPeople.map(
                          (person) =>
                              _historyPerson(
                            person,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _historyPerson(
    Map<String, dynamic> person,
  ) {
    final payments =
        person['payments'] as List;

    return ExpansionTile(
      leading:
          const CircleAvatar(
        backgroundColor:
            lightPink,

        child: Icon(
          Icons.person,
          color: primaryPink,
        ),
      ),

      title: Text(
        person['name'],
      ),

      subtitle: Text(
        '₱${(person['paid'] as num).toDouble().toStringAsFixed(2)} paid',
      ),

      children: payments.isEmpty
          ? [
              const ListTile(
                title: Text(
                  'No payments recorded.',
                ),
              ),
            ]
          : payments.map(
              (payment) {
                return ListTile(
                  leading:
                      const Icon(
                    Icons
                        .check_circle,
                    color: green,
                  ),

                  title: Text(
                    '₱${(payment['amount'] as num).toDouble().toStringAsFixed(2)}',
                  ),

                  subtitle:
                      Text(
                    payment['date'],
                  ),
                );
              },
            ).toList(),
    );
  }


  void _showPaymentRequest() {
    showDialog(
      context: context,

      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Payment Request',
          ),

          content: Column(
            mainAxisSize:
                MainAxisSize.min,

            children: [
              const Icon(
                Icons.qr_code_2_rounded,

                size: 120,

                color: Colors.black87,
              ),

              const SizedBox(height: 10),

              const Text(
                'Your payment request can generate a shareable image with your QR code and payment details.',

                textAlign:
                    TextAlign.center,

                style: TextStyle(
                  color:
                      Colors.black54,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child:
                  const Text('Close'),
            ),

            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Payment image generation can be connected here.',
                    ),
                  ),
                );
              },

              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    primaryPink,

                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Generate'),
            ),
          ],
        );
      },
    );
  }


  void _showNotifications() {
    final promised =
        debts.where(
      (debt) =>
          debt['promisedDate'] !=
          null &&
          (debt['total'] as num).toDouble() >
              (debt['paid'] as num).toDouble(),
    );

    showModalBottomSheet(
      context: context,

      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(20),

            child: Column(
              mainAxisSize:
                  MainAxisSize.min,

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                const Text(
                  'Payment Reminders',

                  style:
                      TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 15),

                if (promised.isEmpty)
                  const ListTile(
                    leading: Icon(
                      Icons
                          .notifications_none,
                      color: primaryPink,
                    ),

                    title: Text(
                      'No promised payments',
                    ),

                    subtitle: Text(
                      'Promised payment dates will appear here.',
                    ),
                  )
                else
                  ...promised.map(
                    (debt) {
                      return ListTile(
                        leading:
                            const Icon(
                          Icons.alarm,
                          color: orange,
                        ),

                        title: Text(
                          debt['name'],
                        ),

                        subtitle: Text(
                          'Promised to pay on ${debt['promisedDate']}',
                        ),
                      );
                    },
                  ),

                const ListTile(
                  leading: Icon(
                    Icons
                        .notifications_active,
                    color: primaryPink,
                  ),

                  title: Text(
                    'Reminder system',
                  ),

                  subtitle: Text(
                    'Payment reminders will appear here.',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _addNewDebtToPaidPerson(
    Map<String, dynamic> person,
    double amount,
    String description,
  ) {
    final name = person['name'].toString();
    setState(() {
      paidPeople.remove(person);

      final existingIndex = debts.indexWhere(
        (debt) =>
            debt['name'].toString().toLowerCase() == name.toLowerCase(),
      );

      if (existingIndex >= 0) {
        final existing = debts[existingIndex];
        existing['total'] = (existing['total'] as num).toDouble() + amount;
        existing['description'] =
            description.isEmpty ? existing['description'] : description;
        existing['status'] = 'Active';
        existing['promisedDate'] = null;
      } else {
        debts.add({
          'name': name,
          'description':
              description.isEmpty ? 'Personal debt' : description,
          'total': amount,
          'paid': 0.0,
          'dueDate': 'Not set',
          'promisedDate': null,
          'status': 'Active',
          'payments': [],
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Added ₱${amount.toStringAsFixed(2)} debt for $name.',
        ),
      ),
    );
  }


  void _deletePaidPerson(
    Map<String, dynamic> person,
  ) {
    setState(() {
      paidPeople.remove(person);
    });
  }


  String _currentDate() {
    final now =
        DateTime.now();

    return _formatDate(now);
  }
}


class PaidPeoplePage
    extends StatefulWidget {
  final List<Map<String, dynamic>>
      paidPeople;

  final void Function(
    Map<String, dynamic> person,
    double amount,
    String description,
  ) onAddNewDebt;

  final Function(
    Map<String, dynamic>,
  ) onDelete;

  const PaidPeoplePage({
    super.key,

    required this.paidPeople,

    required this.onAddNewDebt,

    required this.onDelete,
  });

  @override
  State<PaidPeoplePage> createState() =>
      _PaidPeoplePageState();
}

class _PaidPeoplePageState
    extends State<PaidPeoplePage> {
  static const Color primaryPink =
      Color(0xFFFF2D75);

  static const Color backgroundColor =
      Color(0xFFFFF5F7);

  static const Color lightPink =
      Color(0xFFFFE8EF);

  static const Color borderPink =
      Color(0xFFF8BBD0);

  static const Color green =
      Color(0xFF22A06B);

  final TextEditingController _paidSearchController =
      TextEditingController();

  @override
  void dispose() {
    _paidSearchController.dispose();
    super.dispose();
  }

  void _showAddDebtDialog(Map<String, dynamic> person) {
    final amountController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            'Add Debt for ${person['name']}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: lightPink,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderPink),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: primaryPink,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          person['name']?.toString() ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: amountController,
                  autofocus: true,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Debt Amount',
                    prefixText: '₱ ',
                    prefixIcon: const Icon(Icons.payments),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description (optional)',
                    prefixIcon: const Icon(Icons.notes),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text.trim());
                if (amount == null || amount <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount greater than 0.'),
                    ),
                  );
                  return;
                }

                Navigator.pop(dialogContext);

                widget.onAddNewDebt(
                  person,
                  amount,
                  descriptionController.text.trim(),
                );

                setState(() {});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryPink,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Debt'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final query = _paidSearchController.text.trim().toLowerCase();
    final filteredPaid = widget.paidPeople.where((p) {
      final name = (p['name'] ?? '').toString().toLowerCase();
      final desc = (p['description'] ?? '').toString().toLowerCase();
      return query.isEmpty || name.contains(query) || desc.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor:
          backgroundColor,

      appBar: AppBar(
        backgroundColor:
            primaryPink,

        foregroundColor:
            Colors.white,

        title: const Text(
          'Paid People',
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: widget.paidPeople.isEmpty
          ? _empty()
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(16),
                      border: Border.all(color: borderPink),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _paidSearchController,
                      onChanged: (val) {
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        hintText: 'Search paid people...',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: green,
                        ),
                        suffixIcon: _paidSearchController
                                .text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close_rounded,
                                  size: 18,
                                  color: Colors.black45,
                                ),
                                onPressed: () {
                                  _paidSearchController
                                      .clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredPaid.isEmpty
                      ? Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.all(30),
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color:
                                      Colors.grey.shade400,
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'No matching people found',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'No one matches "${_paidSearchController.text}".',
                                  style: const TextStyle(
                                    color: Colors.black54,
                                    fontSize: 12,
                                  ),
                                  textAlign:
                                      TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filteredPaid.length,
                          itemBuilder: (context, index) {
                            final person =
                                filteredPaid[index];
                            return _personCard(person);
                          },
                        ),
                ),
              ],
            ),
    );
  }


  Widget _personCard(
    Map<String, dynamic> person,
  ) {
    final double total =
        (person['total'] as num)
            .toDouble();

    final double paid =
        (person['paid'] as num)
            .toDouble();

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border:
            Border.all(
          color:
              Colors.green.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.04),

            blurRadius: 8,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,

                backgroundColor:
                    Colors.green.shade50,

                child: Text(
                  person['name']
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),

                  style:
                      const TextStyle(
                    color: green,
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      person['name'],

                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 3),

                    const Text(
                      'Fully paid',

                      style:
                          TextStyle(
                        color: green,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .check_circle,
                color: green,
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .spaceBetween,

            children: [
              const Text(
                'Total Paid',

                style:
                    TextStyle(
                  color:
                      Colors.black54,
                ),
              ),

              Text(
                '₱${paid.toStringAsFixed(2)}',

                style:
                    const TextStyle(
                  color: green,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed: () {
                    _showAddDebtDialog(
                      person,
                    );
                  },

                  icon: const Icon(
                    Icons
                        .add_circle_outline,
                    size: 17,
                  ),

                  label:
                      const Text(
                    'Add Debt',
                  ),

                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        primaryPink,

                    side:
                        const BorderSide(
                      color:
                          borderPink,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              IconButton(
                onPressed: () {
                  _confirmDelete(
                    person,
                  );
                },

                icon:
                    const Icon(
                  Icons
                      .delete_outline,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _empty() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [
            Icon(
              Icons
                  .verified_user_outlined,

              size: 75,

              color: green
                  .withValues(alpha: 0.6),
            ),

            const SizedBox(height: 15),

            const Text(
              'No Paid People Yet',

              style: TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'People who completely pay their debts can be found here.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color:
                    Colors.black54,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }


  void _confirmDelete(
    Map<String, dynamic> person,
  ) {
    showDialog(
      context: context,

      builder:
          (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Record?',
          ),

          content: Text(
            'Remove ${person['name']} from Paid People?',
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },

              child:
                  const Text('Cancel'),
            ),

            ElevatedButton(
              onPressed: () {
                widget.onDelete(
                  person,
                );

                Navigator.pop(
                  dialogContext,
                );

                setState(() {});
              },

              style:
                  ElevatedButton
                      .styleFrom(
                backgroundColor:
                    Colors.red,

                foregroundColor:
                    Colors.white,
              ),

              child:
                  const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}


class PromissoryVaultPage
    extends StatefulWidget {
  final List<Map<String, dynamic>>
      debts;

  final Future<void> Function(
    Map<String, dynamic>,
  ) onSetPromiseDate;

  final void Function(
    Map<String, dynamic>,
  ) onPayDebt;

  const PromissoryVaultPage({
    super.key,

    required this.debts,

    required this.onSetPromiseDate,

    required this.onPayDebt,
  });

  @override
  State<PromissoryVaultPage>
      createState() =>
          _PromissoryVaultPageState();
}

class _PromissoryVaultPageState
    extends State<
        PromissoryVaultPage> {
  static const Color primaryPink =
      Color(0xFFFF2D75);

  static const Color backgroundColor =
      Color(0xFFFFF5F7);

  static const Color lightPink =
      Color(0xFFFFE8EF);

  static const Color borderPink =
      Color(0xFFF8BBD0);

  static const Color green =
      Color(0xFF22A06B);

  final TextEditingController _vaultSearchController =
      TextEditingController();

  @override
  void dispose() {
    _vaultSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final promisedDebts =
        widget.debts.where(
      (debt) =>
          debt['promisedDate'] !=
          null &&
          (debt['total'] as num)
                  .toDouble() >
              (debt['paid'] as num)
                  .toDouble(),
    ).toList();

    final String query = _vaultSearchController.text.trim().toLowerCase();
    final filteredPromised = promisedDebts.where((debt) {
      final name = (debt['name'] ?? '').toString().toLowerCase();
      final desc = (debt['description'] ?? '').toString().toLowerCase();
      return query.isEmpty || name.contains(query) || desc.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor:
          backgroundColor,

      appBar: AppBar(
        backgroundColor:
            primaryPink,

        foregroundColor:
            Colors.white,

        elevation: 0,

        title: const Text(
          'Promissory Vault',

          style: TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ),

      body: promisedDebts.isEmpty
          ? _emptyVault()
          : ListView(
              padding:
                  const EdgeInsets.all(
                16,
              ),

              children: [
                Container(
                  width:
                      double.infinity,

                  padding:
                      const EdgeInsets.all(
                    20,
                  ),

                  decoration:
                      BoxDecoration(
                    gradient:
                        const LinearGradient(
                      colors: [
                        primaryPink,
                        Color(
                          0xFFFF4F8A,
                        ),
                      ],
                    ),

                    borderRadius:
                        BorderRadius
                            .circular(
                      20,
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: primaryPink
                            .withValues(
                          alpha: 0.20,
                        ),

                        blurRadius: 10,

                        offset:
                            const Offset(
                          0,
                          5,
                        ),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Icon(
                        Icons
                            .handshake_rounded,

                        color:
                            Colors.white,

                        size: 35,
                      ),

                      const SizedBox(
                          height: 10),

                      const Text(
                        'Promised Payments',

                        style:
                            TextStyle(
                          color:
                              Colors.white,

                          fontSize: 20,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 5),

                      Text(
                        '${promisedDebts.length} person(s) have a promised payment date.',

                        style:
                            const TextStyle(
                          color:
                              Colors.white70,

                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                    height: 20),

                ...promisedDebts.map(
                  (debt) =>
                      _promiseCard(
                    debt,
                  ),
                ),
              ],
            ),
    );
  }


  Widget _promiseCard(
    Map<String, dynamic> debt,
  ) {
    final double total =
        (debt['total'] as num)
            .toDouble();

    final double paid =
        (debt['paid'] as num)
            .toDouble();

    final double remaining =
        total - paid;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      padding:
          const EdgeInsets.all(16),

      decoration:
          BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(
          18,
        ),

        border:
            Border.all(
          color: borderPink,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.04),

            blurRadius: 8,

            offset:
                const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,

                backgroundColor:
                    lightPink,

                child: Text(
                  debt['name']
                      .toString()
                      .substring(0, 1)
                      .toUpperCase(),

                  style:
                      const TextStyle(
                    color:
                        primaryPink,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 18,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [
                    Text(
                      debt['name'],

                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 3),

                    Text(
                      'Remaining: ₱${remaining.toStringAsFixed(2)}',

                      style:
                          const TextStyle(
                        fontSize: 12,
                        color:
                            primaryPink,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons
                    .event_available_rounded,

                color:
                    primaryPink,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            width:
                double.infinity,

            padding:
                const EdgeInsets.all(
              13,
            ),

            decoration:
                BoxDecoration(
              color: lightPink,

              borderRadius:
                  BorderRadius.circular(
                12,
              ),

              border:
                  Border.all(
                color: borderPink,
              ),
            ),

            child: Row(
              children: [
                const Icon(
                  Icons
                      .calendar_month_rounded,

                  color:
                      primaryPink,
                ),

                const SizedBox(
                    width: 10),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [
                      const Text(
                        'Promised to Pay On',

                        style:
                            TextStyle(
                          fontSize: 11,
                          color:
                              Colors.black54,
                        ),
                      ),

                      const SizedBox(
                          height: 3),

                      Text(
                        debt['promisedDate']
                            .toString(),

                        style:
                            const TextStyle(
                          color:
                              primaryPink,

                          fontSize: 15,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child:
                    OutlinedButton.icon(
                  onPressed:
                      () async {
                    await widget
                        .onSetPromiseDate(
                      debt,
                    );

                    if (mounted) {
                      setState(() {});
                    }
                  },

                  icon:
                      const Icon(
                    Icons
                        .edit_calendar_rounded,

                    size: 17,
                  ),

                  label:
                      const Text(
                    'Change Date',
                  ),

                  style:
                      OutlinedButton
                          .styleFrom(
                    foregroundColor:
                        primaryPink,

                    side:
                        const BorderSide(
                      color:
                          borderPink,
                    ),

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child:
                    ElevatedButton.icon(
                  onPressed: () {
                    widget.onPayDebt(
                      debt,
                    );

                    Navigator.pop(
                      context,
                    );
                  },

                  icon:
                      const Icon(
                    Icons
                        .payments_outlined,

                    size: 17,
                  ),

                  label:
                      const Text(
                    'Pay Debt',
                  ),

                  style:
                      ElevatedButton
                          .styleFrom(
                    backgroundColor:
                        primaryPink,

                    foregroundColor:
                        Colors.white,

                    elevation: 0,

                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _emptyVault() {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          30,
        ),

        child: Column(
          mainAxisAlignment:
              MainAxisAlignment
                  .center,

          children: [
            Icon(
              Icons
                  .handshake_outlined,

              size: 75,

              color: primaryPink
                  .withValues(alpha: 0.6),
            ),

            const SizedBox(
                height: 15),

            const Text(
              'No Promises Yet',

              style:
                  TextStyle(
                fontSize: 21,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
                height: 8),

            const Text(
              'When a debtor promises a date to pay, their commitment will appear here.',

              textAlign:
                  TextAlign.center,

              style:
                  TextStyle(
                color:
                    Colors.black54,

                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
