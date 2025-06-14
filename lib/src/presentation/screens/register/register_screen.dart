import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:seagull/src/core/routers/my_app_route_constant.dart';
import 'package:seagull/src/core/routers/routes.dart';
import 'package:seagull/src/core/utils/utility.dart';
import 'package:seagull/src/core/utils/widgets/common_button_widget.dart';
import 'package:seagull/src/core/utils/widgets/common_textfield_widget.dart';
import 'package:seagull/src/presentation/screens/otp/otp_screen.dart';
import 'package:seagull/src/presentation/screens/register/widget/social_button_widget.dart';

enum SignInType { email, mobile }

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _inputController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  SignInType _currentType = SignInType.email;
  bool _isInputValid = false;
  String _selectedCountryCode = '+91';

  // Country codes list
  static const List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+61', 'country': 'AU'},
    {'code': '+86', 'country': 'CN'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _inputController.addListener(_validateInput);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _inputController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentType = _tabController.index == 0 ? SignInType.email : SignInType.mobile;
        _inputController.clear();
        _isInputValid = false;
      });
    }
  }

  void _validateInput() {
    final input = _inputController.text.trim();
    bool isValid = false;

    switch (_currentType) {
      case SignInType.email:
        isValid = Utility().validateEmail(input);
        break;
      case SignInType.mobile:
        isValid = Utility().validateMobile(input);
        break;
    }

    if (_isInputValid != isValid) {
      setState(() {
        _isInputValid = isValid;
      });
    }
  }

  void _handleContinue() {
    if (!_isInputValid) {
      final errorMessage = _currentType == SignInType.email
          ? 'Invalid email format\nPlease enter a valid email address'
          : 'Invalid mobile number\nPlease enter a valid 10-digit mobile number';
      Utility().showToast(errorMessage, context);
      return;
    }

    // Mock authentication success
    Utility().showToast('Verification code sent successfully!', context, isError: false);

    // Navigate to OTP screen after a short delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        AppRouter.goRouter.push(Routes.otp);
      }
    });
  }

  String get _inputLabel => _currentType == SignInType.email ? 'Email address' : 'Mobile number';

  String get _inputHint => _currentType == SignInType.email ? 'user@example.com' : '1234567890';

  String get _validationMessage => _currentType == SignInType.email ? 'Valid email format' : 'Valid mobile format';

  TextInputType get _keyboardType =>
      _currentType == SignInType.email ? TextInputType.emailAddress : TextInputType.phone;

  List<TextInputFormatter> get _inputFormatters =>
      _currentType == SignInType.mobile ? [FilteringTextInputFormatter.digitsOnly] : [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          ),
        ),
        child: SafeArea(child: Column(children: [_buildHeader(), _buildLogo(), _buildSignInForm()])),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Skip', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 40),
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: const Center(
        child: Text(
          'A',
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5)),
        ),
      ),
    );
  }

  Widget _buildSignInForm() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sign in or create account',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 24),
                  _buildTabBar(),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel(),
                        const SizedBox(height: 8),
                        _currentType == SignInType.mobile ? _buildMobileInputField() : _buildEmailInputField(),
                        _buildValidationFeedback(),
                        const Spacer(),
                        _buildBottomSection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(8)),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Email'),
          Tab(text: 'Mobile'),
        ],
      ),
    );
  }

  Widget _buildInputLabel() {
    return Text(
      _inputLabel,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey),
    );
  }

  Widget _buildEmailInputField() {
    return CommonTextfieldWidget(
      keyboardType: _keyboardType,
      controller: _inputController,
      inputFormatters: _inputFormatters,
      isInputValid: _isInputValid,
      hintText: _inputHint,
    );
  }

  Widget _buildMobileInputField() {
    return Row(
      children: [
        _buildCountryCodeDropdown(),
        const SizedBox(width: 12),
        Expanded(
          child: CommonTextfieldWidget(
            controller: _inputController,
            inputFormatters: _inputFormatters,
            keyboardType: _keyboardType,
            isInputValid: _isInputValid,
            hintText: _inputHint,
          ),
        ),
      ],
    );
  }

  Widget _buildCountryCodeDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountryCode,
          items: _countryCodes.map((country) {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Text('${country['country']} ${country['code']}', style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedCountryCode = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildValidationFeedback() {
    if (!_isInputValid) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 16),
          const SizedBox(width: 8),
          Text(_validationMessage, style: const TextStyle(color: Colors.green, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Column(
      children: [
        CommonButtonWidget(title: 'Continue', callback: _handleContinue),
        const SizedBox(height: 24),
        _buildOrDivider(),
        const SizedBox(height: 24),
        SocialButtonWidget(),
        const SizedBox(height: 24),
        _buildTermsAndPrivacy(),
      ],
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey[300])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('or', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ),
        Expanded(child: Divider(color: Colors.grey[300])),
      ],
    );
  }

  Widget _buildTermsAndPrivacy() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'By continuing, you agree to our ',
        style: TextStyle(color: Colors.grey[600], fontSize: 12),
        children: [
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w500,
              decoration: TextDecoration.underline,
            ),
          ),
        ],
      ),
    );
  }
}
