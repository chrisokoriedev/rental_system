import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/rental_model.dart';

final rentalSearchQueryProvider = StateProvider<String>((ref) => '');

final rentalsProvider = Provider<List<RentalModel>>((ref) {
	return const [
		RentalModel(
			id: 'r1',
			title: 'Ocean View Apartment',
			location: 'Lekki, Lagos',
			pricePerNight: 80,
			rating: 4.8,
			imageUrl:
					'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=1200',
			description:
					'A premium apartment with wifi, kitchen, and sea-facing balcony.',
			amenities: ['Wifi', 'Kitchen', 'Parking'],
		),
		RentalModel(
			id: 'r2',
			title: 'Modern Duplex',
			location: 'Ikeja, Lagos',
			pricePerNight: 120,
			rating: 4.7,
			imageUrl:
					'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=1200',
			description: 'Spacious duplex with stylish interior and city access.',
			amenities: ['Wifi', 'Workspace', 'Laundry'],
		),
		RentalModel(
			id: 'r3',
			title: 'City Loft',
			location: 'Abuja',
			pricePerNight: 95,
			rating: 4.6,
			imageUrl:
					'https://images.unsplash.com/photo-1493666438817-866a91353ca9?w=1200',
			description: 'Minimalist loft for short stays and business travel.',
			amenities: ['Wifi', 'Gym', 'Pool'],
		),
		RentalModel(
			id: 'r4',
			title: 'Luxury Studio',
			location: 'Victoria Island, Lagos',
			pricePerNight: 65,
			rating: 4.5,
			imageUrl:
					'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=1200',
			description: 'Compact luxury studio perfect for solo travelers.',
			amenities: ['Wifi', 'Kitchen', 'AC'],
		),
		RentalModel(
			id: 'r5',
			title: 'Heritage Apartment',
			location: 'Ibadan, Oyo',
			pricePerNight: 55,
			rating: 4.4,
			imageUrl:
					'https://images.unsplash.com/photo-1484154218962-a197022b5858?w=1200',
			description: 'Cozy apartment blending old-world charm with modern comfort.',
			amenities: ['Wifi', 'Parking', 'Balcony'],
		),
		RentalModel(
			id: 'r6',
			title: 'Executive Villa',
			location: 'Maitama, Abuja',
			pricePerNight: 200,
			rating: 4.9,
			imageUrl:
					'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200',
			description: 'Premium villa with private pool for corporate retreats.',
			amenities: ['Pool', 'Gym', 'Wifi', 'Security'],
		),
	];
});

final selectedRentalIdProvider = StateProvider<String?>((ref) => null);

final featuredRentalsProvider = Provider<List<RentalModel>>((ref) {
	return ref.watch(rentalsProvider).take(2).toList();
});

final filteredRentalsProvider = Provider<List<RentalModel>>((ref) {
	final query = ref.watch(rentalSearchQueryProvider).trim().toLowerCase();
	final rentals = ref.watch(rentalsProvider);

	if (query.isEmpty) {
		return rentals;
	}

	return rentals
			.where(
				(r) =>
						r.title.toLowerCase().contains(query) ||
						r.location.toLowerCase().contains(query),
			)
			.toList();
});

final selectedRentalProvider = Provider<RentalModel?>((ref) {
	final selectedId = ref.watch(selectedRentalIdProvider);
	if (selectedId == null) {
		return null;
	}

	final rentals = ref.watch(rentalsProvider);
	for (final rental in rentals) {
		if (rental.id == selectedId) {
			return rental;
		}
	}
	return null;
});
