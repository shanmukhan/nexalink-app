import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of S
/// returned by `S.of(context)`.
///
/// Applications need to include `S.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: S.localizationsDelegates,
///   supportedLocales: S.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the S.supportedLocales
/// property.
abstract class S {
  S(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static S? of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('te'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Nexa Link'**
  String get appTitle;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Login to continue with your wallet, rewards, and referrals.'**
  String get loginSubtitle;

  /// No description provided for @phoneOrEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone or email'**
  String get phoneOrEmailLabel;

  /// No description provided for @phoneOrEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number or email'**
  String get phoneOrEmailHint;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @loginOr.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get loginOr;

  /// No description provided for @biometricLabel.
  ///
  /// In en, this message translates to:
  /// **'Use biometric login'**
  String get biometricLabel;

  /// No description provided for @biometricDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your registered mobile number or email to get a secure OTP instantly.'**
  String get biometricDescription;

  /// No description provided for @invalidLoginInput.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid Indian mobile number or email.'**
  String get invalidLoginInput;

  /// No description provided for @sendOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtpButton;

  /// No description provided for @otpSentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to {identifier}'**
  String otpSentSubtitle(String identifier);

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'6-digit OTP'**
  String get otpHint;

  /// No description provided for @verifyOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Verify & Continue'**
  String get verifyOtpButton;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @changeNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeNumberLabel;

  /// No description provided for @otpRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not send OTP. Please try again.'**
  String get otpRequestFailed;

  /// No description provided for @otpVerifyFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired OTP.'**
  String get otpVerifyFailed;

  /// No description provided for @loadingProduct.
  ///
  /// In en, this message translates to:
  /// **'Loading product…'**
  String get loadingProduct;

  /// No description provided for @productLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load product. Please try again.'**
  String get productLoadFailed;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @addAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Delivery Address'**
  String get addAddressTitle;

  /// No description provided for @addressLine1Hint.
  ///
  /// In en, this message translates to:
  /// **'House no., street'**
  String get addressLine1Hint;

  /// No description provided for @addressLine2Hint.
  ///
  /// In en, this message translates to:
  /// **'Landmark (optional)'**
  String get addressLine2Hint;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityHint;

  /// No description provided for @stateHint.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get stateHint;

  /// No description provided for @postalCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get postalCodeHint;

  /// No description provided for @saveAddressButton.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddressButton;

  /// No description provided for @noAddressSaved.
  ///
  /// In en, this message translates to:
  /// **'No saved address yet — add one to continue'**
  String get noAddressSaved;

  /// No description provided for @placingOrder.
  ///
  /// In en, this message translates to:
  /// **'Placing your order…'**
  String get placingOrder;

  /// No description provided for @checkoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not place order. Please try again.'**
  String get checkoutFailed;

  /// No description provided for @genericErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get genericErrorMessage;

  /// No description provided for @referralCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Referral code (optional)'**
  String get referralCodeHint;

  /// No description provided for @myReferralCode.
  ///
  /// In en, this message translates to:
  /// **'Your referral code'**
  String get myReferralCode;

  /// No description provided for @shareCode.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareCode;

  /// No description provided for @referralCodeCopied.
  ///
  /// In en, this message translates to:
  /// **'Referral code copied'**
  String get referralCodeCopied;

  /// No description provided for @referralsUsed.
  ///
  /// In en, this message translates to:
  /// **'{used}/{max} referrals used'**
  String referralsUsed(int used, int max);

  /// No description provided for @commissionEarned.
  ///
  /// In en, this message translates to:
  /// **'Commission earned'**
  String get commissionEarned;

  /// No description provided for @noReferralsYet.
  ///
  /// In en, this message translates to:
  /// **'No referrals yet — share your code to start earning'**
  String get noReferralsYet;

  /// No description provided for @walletFullyCoversOrder.
  ///
  /// In en, this message translates to:
  /// **'Paying fully from wallet balance'**
  String get walletFullyCoversOrder;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @shopComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Shop coming soon'**
  String get shopComingSoon;

  /// No description provided for @earningsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Earnings details coming soon'**
  String get earningsComingSoon;

  /// No description provided for @greeting.
  ///
  /// In en, this message translates to:
  /// **'Hi, {name} 👋'**
  String greeting(Object name);

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @totalWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Wallet Balance'**
  String get totalWalletBalance;

  /// No description provided for @addMoney.
  ///
  /// In en, this message translates to:
  /// **'Add Money'**
  String get addMoney;

  /// No description provided for @walletBalance.
  ///
  /// In en, this message translates to:
  /// **'₹ 12,450.50'**
  String get walletBalance;

  /// No description provided for @totalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get totalEarnings;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @pendingPayout.
  ///
  /// In en, this message translates to:
  /// **'Pending Payout'**
  String get pendingPayout;

  /// No description provided for @myOrders.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// No description provided for @myTeam.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get myTeam;

  /// No description provided for @walletLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get walletLabel;

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @megaOffer.
  ///
  /// In en, this message translates to:
  /// **'Mega Offer'**
  String get megaOffer;

  /// No description provided for @offerProduct.
  ///
  /// In en, this message translates to:
  /// **'55\" 4K LED TV'**
  String get offerProduct;

  /// No description provided for @offerStartingAt.
  ///
  /// In en, this message translates to:
  /// **'Starting at ₹ 29,999'**
  String get offerStartingAt;

  /// No description provided for @shopNow.
  ///
  /// In en, this message translates to:
  /// **'Shop Now'**
  String get shopNow;

  /// No description provided for @topCategories.
  ///
  /// In en, this message translates to:
  /// **'Top Categories'**
  String get topCategories;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @televisions.
  ///
  /// In en, this message translates to:
  /// **'Televisions'**
  String get televisions;

  /// No description provided for @mobiles.
  ///
  /// In en, this message translates to:
  /// **'Mobiles'**
  String get mobiles;

  /// No description provided for @appliances.
  ///
  /// In en, this message translates to:
  /// **'Appliances'**
  String get appliances;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @profileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your account details'**
  String get profileSubtitle;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @kycVerification.
  ///
  /// In en, this message translates to:
  /// **'KYC Verification'**
  String get kycVerification;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @bankDetails.
  ///
  /// In en, this message translates to:
  /// **'Bank Details'**
  String get bankDetails;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @addressBook.
  ///
  /// In en, this message translates to:
  /// **'Address Book'**
  String get addressBook;

  /// No description provided for @supportHelp.
  ///
  /// In en, this message translates to:
  /// **'Support & Help'**
  String get supportHelp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'Telugu'**
  String get telugu;

  /// No description provided for @myTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'My Team'**
  String get myTeamTitle;

  /// No description provided for @teamTreeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tree view of your referred users'**
  String get teamTreeSubtitle;

  /// No description provided for @currentUser.
  ///
  /// In en, this message translates to:
  /// **'Current User'**
  String get currentUser;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @totalTeam.
  ///
  /// In en, this message translates to:
  /// **'Total Team'**
  String get totalTeam;

  /// No description provided for @activeTeam.
  ///
  /// In en, this message translates to:
  /// **'Active Team'**
  String get activeTeam;

  /// No description provided for @businessVolume.
  ///
  /// In en, this message translates to:
  /// **'Business Volume'**
  String get businessVolume;

  /// No description provided for @teamSize.
  ///
  /// In en, this message translates to:
  /// **'32'**
  String get teamSize;

  /// No description provided for @activeTeamCount.
  ///
  /// In en, this message translates to:
  /// **'18'**
  String get activeTeamCount;

  /// No description provided for @businessVolumeValue.
  ///
  /// In en, this message translates to:
  /// **'₹ 2,45,000'**
  String get businessVolumeValue;

  /// No description provided for @nameShanmukhan.
  ///
  /// In en, this message translates to:
  /// **'Shanmukhan'**
  String get nameShanmukhan;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'shanmukhan.b@gmail.com'**
  String get emailAddress;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'9160151567'**
  String get phoneNumber;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'55\" 4K Ultra HD Smart LED TV'**
  String get productName;

  /// No description provided for @productRating.
  ///
  /// In en, this message translates to:
  /// **'4.6 (2,340 ratings)'**
  String get productRating;

  /// No description provided for @specifications.
  ///
  /// In en, this message translates to:
  /// **'Specifications'**
  String get specifications;

  /// No description provided for @specScreen.
  ///
  /// In en, this message translates to:
  /// **'55\" 4K Ultra HD Display'**
  String get specScreen;

  /// No description provided for @specSound.
  ///
  /// In en, this message translates to:
  /// **'Dolby Audio, 24W Speakers'**
  String get specSound;

  /// No description provided for @specConnectivity.
  ///
  /// In en, this message translates to:
  /// **'3x HDMI, 2x USB, Wi-Fi'**
  String get specConnectivity;

  /// No description provided for @specOs.
  ///
  /// In en, this message translates to:
  /// **'Smart OS with built-in apps'**
  String get specOs;

  /// No description provided for @warrantyTitle.
  ///
  /// In en, this message translates to:
  /// **'Warranty'**
  String get warrantyTitle;

  /// No description provided for @warrantyText.
  ///
  /// In en, this message translates to:
  /// **'1 year comprehensive warranty + 1 year additional on panel'**
  String get warrantyText;

  /// No description provided for @cashbackEligibility.
  ///
  /// In en, this message translates to:
  /// **'Cashback Eligibility'**
  String get cashbackEligibility;

  /// No description provided for @cashbackText.
  ///
  /// In en, this message translates to:
  /// **'Earn 2% instant cashback to your Nexa wallet on this order'**
  String get cashbackText;

  /// No description provided for @referralPolicy.
  ///
  /// In en, this message translates to:
  /// **'Referral Policy'**
  String get referralPolicy;

  /// No description provided for @referralPolicyText.
  ///
  /// In en, this message translates to:
  /// **'Refer a friend and earn ₹500 commission when they purchase this product'**
  String get referralPolicyText;

  /// No description provided for @similarProducts.
  ///
  /// In en, this message translates to:
  /// **'Similar Products'**
  String get similarProducts;

  /// No description provided for @similarProductsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More products coming soon'**
  String get similarProductsComingSoon;

  /// No description provided for @addToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'My Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add products to see them here'**
  String get cartEmptySubtitle;

  /// No description provided for @browseProducts.
  ///
  /// In en, this message translates to:
  /// **'Browse Products'**
  String get browseProducts;

  /// No description provided for @quantityLabel.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantityLabel;

  /// No description provided for @couponCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCodeLabel;

  /// No description provided for @couponCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get couponCodeHint;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyCoupon;

  /// No description provided for @couponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon applied successfully'**
  String get couponApplied;

  /// No description provided for @invalidCoupon.
  ///
  /// In en, this message translates to:
  /// **'Invalid coupon code'**
  String get invalidCoupon;

  /// No description provided for @useWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Use Wallet Balance'**
  String get useWalletBalance;

  /// No description provided for @walletAvailable.
  ///
  /// In en, this message translates to:
  /// **'₹ {amount} available'**
  String walletAvailable(String amount);

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @couponDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Coupon Discount'**
  String get couponDiscountLabel;

  /// No description provided for @walletApplied.
  ///
  /// In en, this message translates to:
  /// **'Wallet Applied'**
  String get walletApplied;

  /// No description provided for @estimatedCashbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cashback'**
  String get estimatedCashbackLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @proceedToCheckout.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// No description provided for @changeAddress.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeAddress;

  /// No description provided for @defaultAddressName.
  ///
  /// In en, this message translates to:
  /// **'Shanmukhan'**
  String get defaultAddressName;

  /// No description provided for @defaultAddressLine.
  ///
  /// In en, this message translates to:
  /// **'12-3-45, Green Valley Apartments, Madhapur, Hyderabad, Telangana - 500081'**
  String get defaultAddressLine;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @paymentUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentUpi;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Debit / Credit Card'**
  String get paymentCard;

  /// No description provided for @paymentCod.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get paymentCod;

  /// No description provided for @gstInvoice.
  ///
  /// In en, this message translates to:
  /// **'Need GST Invoice'**
  String get gstInvoice;

  /// No description provided for @gstinLabel.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get gstinLabel;

  /// No description provided for @gstinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your GSTIN'**
  String get gstinHint;

  /// No description provided for @placeOrder.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get placeOrder;

  /// No description provided for @orderPlacedTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Placed!'**
  String get orderPlacedTitle;

  /// No description provided for @orderPlacedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your order has been placed successfully'**
  String get orderPlacedSubtitle;

  /// No description provided for @orderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order ID: {id}'**
  String orderIdLabel(String id);

  /// No description provided for @statusPlaced.
  ///
  /// In en, this message translates to:
  /// **'Placed'**
  String get statusPlaced;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusPacked.
  ///
  /// In en, this message translates to:
  /// **'Packed'**
  String get statusPacked;

  /// No description provided for @statusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get statusShipped;

  /// No description provided for @statusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get statusDelivered;

  /// No description provided for @continueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get continueShopping;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  Future<S> load(Locale locale) {
    return SynchronousFuture<S>(lookupS(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_SDelegate old) => false;
}

S lookupS(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return SEn();
    case 'te':
      return STe();
  }

  throw FlutterError(
    'S.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
