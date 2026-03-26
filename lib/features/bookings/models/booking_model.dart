class BookingModel {
  const BookingModel({
    required this.id,
    required this.rentalId,
    required this.rentalTitle,
    required this.rentalLocation,
    required this.nights,
    required this.subtotal,
    required this.serviceFee,
    required this.total,
    required this.status,
  });

  final String id;
  final String rentalId;
  final String rentalTitle;
  final String rentalLocation;
  final int nights;
  final double subtotal;
  final double serviceFee;
  final double total;
  final String status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rentalId': rentalId,
      'rentalTitle': rentalTitle,
      'rentalLocation': rentalLocation,
      'nights': nights,
      'subtotal': subtotal,
      'serviceFee': serviceFee,
      'total': total,
      'status': status,
    };
  }

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] as String,
      rentalId: json['rentalId'] as String,
      rentalTitle: json['rentalTitle'] as String,
      rentalLocation: json['rentalLocation'] as String,
      nights: json['nights'] as int,
      subtotal: (json['subtotal'] as num).toDouble(),
      serviceFee: (json['serviceFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
    );
  }
}
