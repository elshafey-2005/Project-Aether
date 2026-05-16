class RaidStatus {
  final int currentPlayers;
  final int maxPlayers;
  final bool isJoined;
  final bool isLoading;
  final String? error;

  const RaidStatus({
    required this.currentPlayers,
    required this.maxPlayers,
    this.isJoined = false,
    this.isLoading = false,
    this.error,
  });

  RaidStatus copyWith({
    int? currentPlayers,
    int? maxPlayers,
    bool? isJoined,
    bool? isLoading,
    String? error,
  }) {
    return RaidStatus(
      currentPlayers: currentPlayers ?? this.currentPlayers,
      maxPlayers: maxPlayers ?? this.maxPlayers,
      isJoined: isJoined ?? this.isJoined,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
