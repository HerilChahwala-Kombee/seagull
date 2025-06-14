import 'package:flutter/material.dart';
import 'widgets/service_details_header.dart';
import 'widgets/service_details_info.dart';
import 'widgets/service_details_tab_section.dart';
import 'widgets/service_details_features.dart';
import 'widgets/service_details_description.dart';
import 'widgets/service_details_coverage.dart';
import 'widgets/service_details_booking_section.dart';
import 'widgets/service_details_pricing_section.dart';
import 'widgets/service_details_bottom_button.dart';

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({super.key});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedDateIndex = 14; // 15th selected
  String _selectedTime = '10:30 AM';
  int _numberOfSessions = 1;

  final List<String> _timeSlots = [
    '9:00 AM',
    '10:30 AM',
    '12:00 PM',
    '1:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ServiceDetailsHeader(onBack: () => Navigator.pop(context)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ServiceDetailsInfo(),
                  ServiceDetailsTabSection(tabController: _tabController),
                  ServiceDetailsFeatures(),
                  ServiceDetailsDescription(),
                  ServiceDetailsCoverage(),
                  ServiceDetailsBookingSection(
                    selectedDateIndex: _selectedDateIndex,
                    onDateSelected: (index) {
                      setState(() {
                        _selectedDateIndex = index;
                      });
                    },
                    selectedTime: _selectedTime,
                    onTimeSelected: (time) {
                      setState(() {
                        _selectedTime = time;
                      });
                    },
                    timeSlots: _timeSlots,
                    numberOfSessions: _numberOfSessions,
                    onSessionChanged: (count) {
                      setState(() {
                        _numberOfSessions = count;
                      });
                    },
                  ),
                  ServiceDetailsPricingSection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          ServiceDetailsBottomButton(),
        ],
      ),
    );
  }
}
