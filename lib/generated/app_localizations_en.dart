// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class SEn extends S {
  SEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Nexa Link';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle =>
      'Login to continue with your wallet, rewards, and referrals.';

  @override
  String get phoneOrEmailLabel => 'Phone or email';

  @override
  String get phoneOrEmailHint => 'Enter mobile number or email';

  @override
  String get loginButton => 'Login';

  @override
  String get loginOr => 'or';

  @override
  String get biometricLabel => 'Use biometric login';

  @override
  String get biometricDescription =>
      'Use your registered mobile number or email to get a secure OTP instantly.';

  @override
  String get invalidLoginInput =>
      'Enter a valid Indian mobile number or email.';

  @override
  String get sendOtpButton => 'Send OTP';

  @override
  String otpSentSubtitle(String identifier) {
    return 'Enter the 6-digit code sent to $identifier';
  }

  @override
  String get otpHint => '6-digit OTP';

  @override
  String get verifyOtpButton => 'Verify & Continue';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get changeNumberLabel => 'Change';

  @override
  String get otpRequestFailed => 'Could not send OTP. Please try again.';

  @override
  String get otpVerifyFailed => 'Invalid or expired OTP.';

  @override
  String get loadingProduct => 'Loading product…';

  @override
  String get productLoadFailed => 'Could not load product. Please try again.';

  @override
  String get retryLabel => 'Retry';

  @override
  String get addAddressTitle => 'Add Delivery Address';

  @override
  String get addressLine1Hint => 'House no., street';

  @override
  String get addressLine2Hint => 'Landmark (optional)';

  @override
  String get cityHint => 'City';

  @override
  String get stateHint => 'State';

  @override
  String get postalCodeHint => 'Postal code';

  @override
  String get saveAddressButton => 'Save Address';

  @override
  String get noAddressSaved => 'No saved address yet — add one to continue';

  @override
  String get placingOrder => 'Placing your order…';

  @override
  String get checkoutFailed => 'Could not place order. Please try again.';

  @override
  String get genericErrorMessage => 'Something went wrong. Please try again.';

  @override
  String get referralCodeHint => 'Referral code (optional)';

  @override
  String get myReferralCode => 'Your referral code';

  @override
  String get shareCode => 'Share';

  @override
  String get referralCodeCopied => 'Referral code copied';

  @override
  String referralsUsed(int used, int max) {
    return '$used/$max referrals used';
  }

  @override
  String get commissionEarned => 'Commission earned';

  @override
  String get noReferralsYet =>
      'No referrals yet — share your code to start earning';

  @override
  String get walletFullyCoversOrder => 'Paying fully from wallet balance';

  @override
  String get home => 'Home';

  @override
  String get shop => 'Shop';

  @override
  String get teams => 'Teams';

  @override
  String get earnings => 'Earnings';

  @override
  String get profile => 'Profile';

  @override
  String get shopComingSoon => 'Shop coming soon';

  @override
  String get earningsComingSoon => 'Earnings details coming soon';

  @override
  String greeting(Object name) {
    return 'Hi, $name 👋';
  }

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get totalWalletBalance => 'Total Wallet Balance';

  @override
  String get addMoney => 'Add Money';

  @override
  String get walletBalance => '₹ 12,450.50';

  @override
  String get totalEarnings => 'Total Earnings';

  @override
  String get thisMonth => 'This Month';

  @override
  String get pendingPayout => 'Pending Payout';

  @override
  String get myOrders => 'My Orders';

  @override
  String get myTeam => 'My Team';

  @override
  String get walletLabel => 'Wallet';

  @override
  String get rewards => 'Rewards';

  @override
  String get megaOffer => 'Mega Offer';

  @override
  String get offerProduct => '55\" 4K LED TV';

  @override
  String get offerStartingAt => 'Starting at ₹ 29,999';

  @override
  String get shopNow => 'Shop Now';

  @override
  String get topCategories => 'Top Categories';

  @override
  String get viewAll => 'View All';

  @override
  String get televisions => 'Televisions';

  @override
  String get mobiles => 'Mobiles';

  @override
  String get appliances => 'Appliances';

  @override
  String get accessories => 'Accessories';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileSubtitle => 'Manage your account details';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get kycVerification => 'KYC Verification';

  @override
  String get verified => 'Verified';

  @override
  String get bankDetails => 'Bank Details';

  @override
  String get changePassword => 'Change Password';

  @override
  String get addressBook => 'Address Book';

  @override
  String get supportHelp => 'Support & Help';

  @override
  String get logout => 'Logout';

  @override
  String get languageLabel => 'Language';

  @override
  String get english => 'English';

  @override
  String get telugu => 'Telugu';

  @override
  String get myTeamTitle => 'My Team';

  @override
  String get teamTreeSubtitle => 'Tree view of your referred users';

  @override
  String get currentUser => 'Current User';

  @override
  String get active => 'Active';

  @override
  String get totalTeam => 'Total Team';

  @override
  String get activeTeam => 'Active Team';

  @override
  String get businessVolume => 'Business Volume';

  @override
  String get teamSize => '32';

  @override
  String get activeTeamCount => '18';

  @override
  String get businessVolumeValue => '₹ 2,45,000';

  @override
  String get nameShanmukhan => 'Shanmukhan';

  @override
  String get emailAddress => 'shanmukhan.b@gmail.com';

  @override
  String get phoneNumber => '9160151567';

  @override
  String get productName => '55\" 4K Ultra HD Smart LED TV';

  @override
  String get productRating => '4.6 (2,340 ratings)';

  @override
  String get specifications => 'Specifications';

  @override
  String get specScreen => '55\" 4K Ultra HD Display';

  @override
  String get specSound => 'Dolby Audio, 24W Speakers';

  @override
  String get specConnectivity => '3x HDMI, 2x USB, Wi-Fi';

  @override
  String get specOs => 'Smart OS with built-in apps';

  @override
  String get warrantyTitle => 'Warranty';

  @override
  String get warrantyText =>
      '1 year comprehensive warranty + 1 year additional on panel';

  @override
  String get cashbackEligibility => 'Cashback Eligibility';

  @override
  String get cashbackText =>
      'Earn 2% instant cashback to your Nexa wallet on this order';

  @override
  String get referralPolicy => 'Referral Policy';

  @override
  String get referralPolicyText =>
      'Refer a friend and earn ₹500 commission when they purchase this product';

  @override
  String get similarProducts => 'Similar Products';

  @override
  String get similarProductsComingSoon => 'More products coming soon';

  @override
  String get addToCart => 'Add to Cart';

  @override
  String get buyNow => 'Buy Now';

  @override
  String get cartTitle => 'My Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptySubtitle => 'Add products to see them here';

  @override
  String get browseProducts => 'Browse Products';

  @override
  String get quantityLabel => 'Quantity';

  @override
  String get couponCodeLabel => 'Coupon Code';

  @override
  String get couponCodeHint => 'Enter coupon code';

  @override
  String get applyCoupon => 'Apply';

  @override
  String get couponApplied => 'Coupon applied successfully';

  @override
  String get invalidCoupon => 'Invalid coupon code';

  @override
  String get useWalletBalance => 'Use Wallet Balance';

  @override
  String walletAvailable(String amount) {
    return '₹ $amount available';
  }

  @override
  String get orderSummary => 'Order Summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get couponDiscountLabel => 'Coupon Discount';

  @override
  String get walletApplied => 'Wallet Applied';

  @override
  String get estimatedCashbackLabel => 'Estimated Cashback';

  @override
  String get totalLabel => 'Total';

  @override
  String get proceedToCheckout => 'Proceed to Checkout';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get deliveryAddress => 'Delivery Address';

  @override
  String get changeAddress => 'Change';

  @override
  String get defaultAddressName => 'Shanmukhan';

  @override
  String get defaultAddressLine =>
      '12-3-45, Green Valley Apartments, Madhapur, Hyderabad, Telangana - 500081';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get paymentUpi => 'UPI';

  @override
  String get paymentCard => 'Debit / Credit Card';

  @override
  String get paymentCod => 'Cash on Delivery';

  @override
  String get gstInvoice => 'Need GST Invoice';

  @override
  String get gstinLabel => 'GSTIN';

  @override
  String get gstinHint => 'Enter your GSTIN';

  @override
  String get placeOrder => 'Place Order';

  @override
  String get orderPlacedTitle => 'Order Placed!';

  @override
  String get orderPlacedSubtitle => 'Your order has been placed successfully';

  @override
  String orderIdLabel(String id) {
    return 'Order ID: $id';
  }

  @override
  String get statusPlaced => 'Placed';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusPacked => 'Packed';

  @override
  String get statusShipped => 'Shipped';

  @override
  String get statusDelivered => 'Delivered';

  @override
  String get continueShopping => 'Continue Shopping';

  @override
  String get backToHome => 'Back to Home';
}
