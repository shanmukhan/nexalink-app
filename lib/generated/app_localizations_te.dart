// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class STe extends S {
  STe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'నెక్సా లింక్';

  @override
  String get loginTitle => 'తదుపరి దశకు స్వాగతం';

  @override
  String get loginSubtitle =>
      'మీ వాలెట్, రివార్డ్స్ మరియు రిఫరల్స్ తో కొనసాగించడానికి లాగిన్ చేయండి.';

  @override
  String get phoneOrEmailLabel => 'ఫోన్ లేదా ఇమెయిల్';

  @override
  String get phoneOrEmailHint => 'మొబైల్ నంబర్ లేదా ఇమెయిల్ నమోదు చేయండి';

  @override
  String get loginButton => 'లాగిన్';

  @override
  String get loginOr => 'లేదా';

  @override
  String get biometricLabel => 'బయోమెట్రిక్ లాగిన్ ఉపయోగించండి';

  @override
  String get biometricDescription =>
      'సురక్షిత OTP కోసం మీ నమోదు చేయబడిన మొబైల్ నంబర్ లేదా ఇమెయిల్ ఉపయోగించండి.';

  @override
  String get invalidLoginInput =>
      'సరైన భారతీయ మొబైల్ నంబర్ లేదా ఇమెయిల్ నమోదు చేయండి.';

  @override
  String get sendOtpButton => 'OTP పంపండి';

  @override
  String otpSentSubtitle(String identifier) {
    return '$identifierకి పంపిన 6-అంకెల కోడ్‌ను నమోదు చేయండి';
  }

  @override
  String get otpHint => '6-అంకెల OTP';

  @override
  String get verifyOtpButton => 'ధృవీకరించి కొనసాగించండి';

  @override
  String get resendOtp => 'OTP మళ్లీ పంపండి';

  @override
  String get changeNumberLabel => 'మార్చు';

  @override
  String get otpRequestFailed =>
      'OTP పంపడం సాధ్యం కాలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String get otpVerifyFailed => 'చెల్లని లేదా గడువు ముగిసిన OTP.';

  @override
  String get loadingProduct => 'ఉత్పత్తి లోడ్ అవుతోంది…';

  @override
  String get productLoadFailed =>
      'ఉత్పత్తిని లోడ్ చేయలేకపోయాము. మళ్లీ ప్రయత్నించండి.';

  @override
  String get retryLabel => 'మళ్లీ ప్రయత్నించు';

  @override
  String get addAddressTitle => 'డెలివరీ చిరునామా జోడించండి';

  @override
  String get addressLine1Hint => 'ఇంటి నంబర్, వీధి';

  @override
  String get addressLine2Hint => 'ల్యాండ్‌మార్క్ (ఐచ్ఛికం)';

  @override
  String get cityHint => 'నగరం';

  @override
  String get stateHint => 'రాష్ట్రం';

  @override
  String get postalCodeHint => 'పోస్టల్ కోడ్';

  @override
  String get saveAddressButton => 'చిరునామా సేవ్ చేయండి';

  @override
  String get noAddressSaved =>
      'ఇంకా చిరునామా సేవ్ చేయలేదు — కొనసాగించడానికి ఒకటి జోడించండి';

  @override
  String get placingOrder => 'మీ ఆర్డర్ చేయబడుతోంది…';

  @override
  String get checkoutFailed =>
      'ఆర్డర్ చేయడం సాధ్యం కాలేదు. మళ్లీ ప్రయత్నించండి.';

  @override
  String get genericErrorMessage => 'ఏదో తప్పు జరిగింది. మళ్లీ ప్రయత్నించండి.';

  @override
  String get referralCodeHint => 'రిఫరల్ కోడ్ (ఐచ్ఛికం)';

  @override
  String get haveReferralCode => 'మీ వద్ద రిఫరల్ కోడ్ ఉందా?';

  @override
  String get myReferralCode => 'మీ రిఫరల్ కోడ్';

  @override
  String get shareCode => 'షేర్ చేయండి';

  @override
  String get referralCodeCopied => 'రిఫరల్ కోడ్ కాపీ చేయబడింది';

  @override
  String referralsUsed(int used, int max) {
    return '$used/$max రిఫరల్స్ ఉపయోగించబడ్డాయి';
  }

  @override
  String get commissionEarned => 'సంపాదించిన కమిషన్';

  @override
  String get noReferralsYet =>
      'ఇంకా రిఫరల్స్ లేవు — సంపాదించడం ప్రారంభించడానికి మీ కోడ్‌ను షేర్ చేయండి';

  @override
  String get walletFullyCoversOrder =>
      'వాలెట్ బ్యాలెన్స్ నుండి పూర్తిగా చెల్లిస్తున్నారు';

  @override
  String get home => 'హోమ్';

  @override
  String get shop => 'షాప్';

  @override
  String get teams => 'టీమ్స్';

  @override
  String get earnings => 'అర్జన';

  @override
  String get profile => 'ప్రొఫైల్';

  @override
  String get shopComingSoon => 'షాప్ త్వరలో వస్తోంది';

  @override
  String get earningsComingSoon => 'అర్జన వివరాలు త్వరలో వస్తాయి';

  @override
  String greeting(Object name) {
    return 'హాయ్, $name 👋';
  }

  @override
  String get welcomeBack => 'మళ్లీ స్వాగతం';

  @override
  String get totalWalletBalance => 'మొత్తం వాలెట్ బ్యాలెన్స్';

  @override
  String get addMoney => 'పணம் జోడించు';

  @override
  String get walletBalance => '₹ 12,450.50';

  @override
  String get totalEarnings => 'మొత్తం అర్జన';

  @override
  String get thisMonth => 'ఈ నెల';

  @override
  String get pendingPayout => 'పెండింగ్ చెల్లింపు';

  @override
  String get myOrders => 'నా ఆర్డర్లు';

  @override
  String get myTeam => 'నా టీమ్';

  @override
  String get walletLabel => 'వాలెట్';

  @override
  String get rewards => 'రీవార్డ్స్';

  @override
  String get megaOffer => 'మెగా ఆఫర్';

  @override
  String get offerProduct => '55\" 4K LED TV';

  @override
  String get offerStartingAt => '₹ 29,999 నుంచి ప్రారంభం';

  @override
  String get shopNow => 'ఇప్పుడు షాప్ చేయండి';

  @override
  String get topCategories => 'ప్రముఖ వర్గాలు';

  @override
  String get viewAll => 'అన్నీ వీక్షించండి';

  @override
  String get televisions => 'టెలివిజన్లు';

  @override
  String get mobiles => 'మొబైల్స్';

  @override
  String get appliances => 'ఉపకరణాలు';

  @override
  String get accessories => 'యాక్సెసరీస్';

  @override
  String get profileTitle => 'ప్రొఫైల్';

  @override
  String get profileSubtitle => 'మీ ఖాతా వివరాలను నిర్వహించండి';

  @override
  String get personalInformation => 'వ్యక్తిగత సమాచారం';

  @override
  String get kycVerification => 'KYC ధృవీకరణ';

  @override
  String get verified => 'ధృవీకరించబడింది';

  @override
  String get bankDetails => 'బ్యాంక్ వివరాలు';

  @override
  String get changePassword => 'పాస్‌వర్డ్ మార్చు';

  @override
  String get addressBook => 'చిరునామా పుస్తకం';

  @override
  String get supportHelp => 'సపోర్ట్ & సహాయం';

  @override
  String get logout => 'లాగ్ అవుట్';

  @override
  String get languageLabel => 'భాష';

  @override
  String get english => 'English';

  @override
  String get telugu => 'తెలుగు';

  @override
  String get myTeamTitle => 'నా టీమ్';

  @override
  String get teamTreeSubtitle => 'మీ సూచించిన వినియోగదారుల యొక్క వృక్ష వీక్షణ';

  @override
  String get currentUser => 'ప్రస్తుతం వినియోగదారు';

  @override
  String get active => 'యాక్టివ్';

  @override
  String get totalTeam => 'మొత్తం టీమ్';

  @override
  String get activeTeam => 'యాక్టివ్ టీమ్';

  @override
  String get businessVolume => 'వ్యాపార వాల్యూమ్';

  @override
  String get teamSize => '32';

  @override
  String get activeTeamCount => '18';

  @override
  String get businessVolumeValue => '₹ 2,45,000';

  @override
  String get nameShanmukhan => 'శన్ముఖన్';

  @override
  String get emailAddress => 'shanmukhan.b@gmail.com';

  @override
  String get phoneNumber => '9160151567';

  @override
  String get productName => '55\" 4K అల్ట్రా HD స్మార్ట్ LED TV';

  @override
  String get productRating => '4.6 (2,340 రేటింగ్‌లు)';

  @override
  String get specifications => 'స్పెసిఫికేషన్లు';

  @override
  String get specScreen => '55\" 4K అల్ట్రా HD డిస్‌ప్లే';

  @override
  String get specSound => 'డాల్బీ ఆడియో, 24W స్పీకర్లు';

  @override
  String get specConnectivity => '3x HDMI, 2x USB, Wi-Fi';

  @override
  String get specOs => 'బిల్ట్-ఇన్ యాప్‌లతో స్మార్ట్ OS';

  @override
  String get warrantyTitle => 'వారంటీ';

  @override
  String get warrantyText =>
      '1 సంవత్సరం సమగ్ర వారంటీ + ప్యానెల్‌పై అదనంగా 1 సంవత్సరం';

  @override
  String get cashbackEligibility => 'క్యాష్‌బ్యాక్ అర్హత';

  @override
  String get cashbackText =>
      'ఈ ఆర్డర్‌పై మీ నెక్సా వాలెట్‌కు 2% తక్షణ క్యాష్‌బ్యాక్ పొందండి';

  @override
  String get referralPolicy => 'రిఫరల్ పాలసీ';

  @override
  String get referralPolicyText =>
      'స్నేహితుడిని రిఫర్ చేయండి, వారు ఈ ఉత్పత్తిని కొనుగోలు చేసినప్పుడు ₹500 కమిషన్ పొందండి';

  @override
  String get similarProducts => 'సారూప్య ఉత్పత్తులు';

  @override
  String get similarProductsComingSoon => 'మరిన్ని ఉత్పత్తులు త్వరలో వస్తాయి';

  @override
  String get addToCart => 'కార్ట్‌కు జోడించు';

  @override
  String get buyNow => 'ఇప్పుడే కొనండి';

  @override
  String get cartTitle => 'నా కార్ట్';

  @override
  String get cartEmptyTitle => 'మీ కార్ట్ ఖాళీగా ఉంది';

  @override
  String get cartEmptySubtitle => 'ఉత్పత్తులను ఇక్కడ చూడటానికి జోడించండి';

  @override
  String get browseProducts => 'ఉత్పత్తులను చూడండి';

  @override
  String get quantityLabel => 'పరిమాణం';

  @override
  String get couponCodeLabel => 'కూపన్ కోడ్';

  @override
  String get couponCodeHint => 'కూపన్ కోడ్ నమోదు చేయండి';

  @override
  String get applyCoupon => 'వర్తింపజేయి';

  @override
  String get couponApplied => 'కూపన్ విజయవంతంగా వర్తింపజేయబడింది';

  @override
  String get invalidCoupon => 'చెల్లని కూపన్ కోడ్';

  @override
  String get useWalletBalance => 'వాలెట్ బ్యాలెన్స్ ఉపయోగించండి';

  @override
  String walletAvailable(String amount) {
    return '₹ $amount అందుబాటులో ఉంది';
  }

  @override
  String get orderSummary => 'ఆర్డర్ సారాంశం';

  @override
  String get subtotal => 'ఉప మొత్తం';

  @override
  String get couponDiscountLabel => 'కూపన్ డిస్కౌంట్';

  @override
  String get walletApplied => 'వాలెట్ వర్తింపజేయబడింది';

  @override
  String get estimatedCashbackLabel => 'అంచనా క్యాష్‌బ్యాక్';

  @override
  String get totalLabel => 'మొత్తం';

  @override
  String get proceedToCheckout => 'చెక్అవుట్‌కు కొనసాగండి';

  @override
  String get checkoutTitle => 'చెక్అవుట్';

  @override
  String get deliveryAddress => 'డెలివరీ చిరునామా';

  @override
  String get changeAddress => 'మార్చు';

  @override
  String get defaultAddressName => 'శన్ముఖన్';

  @override
  String get defaultAddressLine =>
      '12-3-45, గ్రీన్ వ్యాలీ అపార్ట్‌మెంట్స్, మాదాపూర్, హైదరాబాద్, తెలంగాణ - 500081';

  @override
  String get paymentMethod => 'చెల్లింపు విధానం';

  @override
  String get paymentUpi => 'UPI';

  @override
  String get paymentCard => 'డెబిట్ / క్రెడిట్ కార్డ్';

  @override
  String get paymentCod => 'డెలివరీ సమయంలో నగదు';

  @override
  String get gstInvoice => 'GST ఇన్‌వాయిస్ కావాలి';

  @override
  String get gstinLabel => 'GSTIN';

  @override
  String get gstinHint => 'మీ GSTIN నమోదు చేయండి';

  @override
  String get placeOrder => 'ఆర్డర్ చేయండి';

  @override
  String get orderPlacedTitle => 'ఆర్డర్ చేయబడింది!';

  @override
  String get orderPlacedSubtitle => 'మీ ఆర్డర్ విజయవంతంగా చేయబడింది';

  @override
  String orderIdLabel(String id) {
    return 'ఆర్డర్ ID: $id';
  }

  @override
  String get statusPlaced => 'ప్లేస్ చేయబడింది';

  @override
  String get statusPaid => 'చెల్లించారు';

  @override
  String get statusPacked => 'ప్యాక్ చేయబడింది';

  @override
  String get statusShipped => 'పంపబడింది';

  @override
  String get statusDelivered => 'డెలివరీ చేయబడింది';

  @override
  String get continueShopping => 'షాపింగ్ కొనసాగించండి';

  @override
  String get backToHome => 'హోమ్‌కు తిరిగి వెళ్లండి';
}
