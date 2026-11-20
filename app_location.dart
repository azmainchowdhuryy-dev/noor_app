/// ব্যবহারকারীর লোকেশন। পাওয়া না গেলে isFallback = true (ঢাকা)।
class AppLocation {
  final double latitude;
  final double longitude;
  final String? name;
  final bool isFallback;

  const AppLocation({
    required this.latitude,
    required this.longitude,
    this.name,
    this.isFallback = false,
  });
}
