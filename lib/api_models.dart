/// DTOs mirroring nexalink-api's response records (see
/// product/api/dto, order/api/dto, customer/api/dto in that repo).
library;

class ProductDetail {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final int? warrantyMonths;
  final Map<String, String> specifications;

  ProductDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    this.warrantyMonths,
    required this.specifications,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        price: double.parse(json['price'].toString()),
        currency: json['currency'] as String? ?? 'INR',
        warrantyMonths: json['warrantyMonths'] as int?,
        specifications: (json['specifications'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, v.toString())) ?? {},
      );
}

class ProductSummary {
  final String id;
  final String name;
  final double price;

  ProductSummary({required this.id, required this.name, required this.price});

  factory ProductSummary.fromJson(Map<String, dynamic> json) => ProductSummary(
        id: json['id'] as String,
        name: json['name'] as String,
        price: double.parse(json['price'].toString()),
      );
}

class OrderItem {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  OrderItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json['id'] as String,
        productId: json['productId'] as String,
        productName: json['productName'] as String,
        quantity: json['quantity'] as int,
        unitPrice: double.parse(json['unitPrice'].toString()),
        subtotal: double.parse(json['subtotal'].toString()),
      );
}

/// An `orders` row — a DRAFT one *is* the cart (see nexalink-api's
/// order/domain/Order doc comment: no separate cart table).
class OrderDto {
  final String id;
  final String status;
  final List<OrderItem> items;
  final double totalAmount;
  final String? shippingAddressId;
  final String? paymentMethod;
  final String? trackingNumber;
  final String? invoiceNumber;

  OrderDto({
    required this.id,
    required this.status,
    required this.items,
    required this.totalAmount,
    this.shippingAddressId,
    this.paymentMethod,
    this.trackingNumber,
    this.invoiceNumber,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) => OrderDto(
        id: json['id'] as String,
        status: json['status'] as String,
        items: (json['items'] as List<dynamic>? ?? []).map((e) => OrderItem.fromJson(e as Map<String, dynamic>)).toList(),
        totalAmount: double.parse((json['totalAmount'] ?? 0).toString()),
        shippingAddressId: json['shippingAddressId'] as String?,
        paymentMethod: json['paymentMethod'] as String?,
        trackingNumber: json['trackingNumber'] as String?,
        invoiceNumber: json['invoiceNumber'] as String?,
      );
}

class Address {
  final String id;
  final String type;
  final String line1;
  final String? line2;
  final String city;
  final String state;
  final String postalCode;
  final bool isDefault;

  Address({
    required this.id,
    required this.type,
    required this.line1,
    this.line2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.isDefault,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json['id'] as String,
        type: json['type'] as String,
        line1: json['line1'] as String,
        line2: json['line2'] as String?,
        city: json['city'] as String,
        state: json['state'] as String,
        postalCode: json['postalCode'] as String,
        isDefault: json['isDefault'] as bool? ?? false,
      );

  String get displayLine => [line1, if (line2 != null && line2!.isNotEmpty) line2, city, state, postalCode].join(', ');
}

class WalletBalance {
  final double balance;
  final String currency;

  WalletBalance({required this.balance, required this.currency});

  factory WalletBalance.fromJson(Map<String, dynamic> json) => WalletBalance(
        balance: double.parse(json['balance'].toString()),
        currency: json['currency'] as String? ?? 'INR',
      );
}

class WalletTransactionEntry {
  final String id;
  final String type;
  final String reason;
  final double amount;
  final DateTime createdAt;

  WalletTransactionEntry({
    required this.id,
    required this.type,
    required this.reason,
    required this.amount,
    required this.createdAt,
  });

  factory WalletTransactionEntry.fromJson(Map<String, dynamic> json) => WalletTransactionEntry(
        id: json['id'] as String,
        type: json['type'] as String,
        reason: json['reason'] as String,
        amount: double.parse(json['amount'].toString()),
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class Referee {
  final String customerId;
  final String? firstName;
  final String? lastName;
  final DateTime referredAt;

  Referee({required this.customerId, this.firstName, this.lastName, required this.referredAt});

  factory Referee.fromJson(Map<String, dynamic> json) => Referee(
        customerId: json['customerId'] as String,
        firstName: json['firstName'] as String?,
        lastName: json['lastName'] as String?,
        referredAt: DateTime.parse(json['referredAt'] as String),
      );

  String get displayName {
    final name = [firstName, lastName].where((s) => s != null && s.isNotEmpty).join(' ');
    return name.isEmpty ? 'Member ${customerId.substring(0, 6)}' : name;
  }
}

class ReferralSummary {
  final String referralCode;
  final int maxReferrals;
  final int referredCount;
  final double totalCommissionEarned;
  final List<Referee> referees;

  ReferralSummary({
    required this.referralCode,
    required this.maxReferrals,
    required this.referredCount,
    required this.totalCommissionEarned,
    required this.referees,
  });

  factory ReferralSummary.fromJson(Map<String, dynamic> json) => ReferralSummary(
        referralCode: json['referralCode'] as String? ?? '',
        maxReferrals: json['maxReferrals'] as int,
        referredCount: json['referredCount'] as int,
        totalCommissionEarned: double.parse((json['totalCommissionEarned'] ?? 0).toString()),
        referees: (json['referees'] as List<dynamic>? ?? []).map((e) => Referee.fromJson(e as Map<String, dynamic>)).toList(),
      );
}
