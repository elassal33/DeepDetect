class Customer {
  final int? id;
  final String firstName;
  final String lastName;
  final String signatureUrl;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? createdAt;
  final String? updatedAt;

  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.signatureUrl,
    this.email,
    this.phoneNumber,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  Customer copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? signatureUrl,
    String? email,
    String? phoneNumber,
    String? address,
    String? createdAt,
    String? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      signatureUrl: signatureUrl ?? this.signatureUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      signatureUrl: json['signatureUrl'] ?? '',
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (id != null) data['id'] = id;
    if (firstName.isNotEmpty) data['firstName'] = firstName;
    if (lastName.isNotEmpty) data['lastName'] = lastName;
    if (signatureUrl.isNotEmpty) data['signatureUrl'] = signatureUrl;
    if (email != null && email!.isNotEmpty) data['email'] = email;
    if (phoneNumber != null && phoneNumber!.isNotEmpty)
      data['phoneNumber'] = phoneNumber;
    if (address != null && address!.isNotEmpty) data['address'] = address;
    if (createdAt != null && createdAt!.isNotEmpty)
      data['createdAt'] = createdAt;
    if (updatedAt != null && updatedAt!.isNotEmpty)
      data['updatedAt'] = updatedAt;

    return data;
  }
}
