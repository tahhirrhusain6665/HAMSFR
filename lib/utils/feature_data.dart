class VehicleOption {
  final String name;
  final String icon;
  final String subtitle;
  final int baseFare;
  const VehicleOption(this.name, this.icon, this.subtitle, this.baseFare);
}

const vehicles = [
  VehicleOption('Bike', '🏍️', 'Best for single rider', 12),
  VehicleOption('Auto', '🛺', 'Economical', 28),
  VehicleOption('Cab', '🚕', 'Comfortable', 48),
];

const whyHumsafar = [
  ('✓', 'Verified Drivers'),
  ('⌖', 'Live Tracking'),
  ('₹', 'Transparent Fare'),
  ('24', '24/7 Support'),
];
