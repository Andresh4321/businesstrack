class ShakeDetectorState {
  final bool isShaking;
  final DateTime? lastShakeTime;
  final int shakeCount;
  final bool isActive;

  ShakeDetectorState({
    required this.isShaking,
    this.lastShakeTime,
    required this.shakeCount,
    required this.isActive,
  });

  factory ShakeDetectorState.initial() {
    return ShakeDetectorState(
      isShaking: false,
      lastShakeTime: null,
      shakeCount: 0,
      isActive: false,
    );
  }

  ShakeDetectorState copyWith({
    bool? isShaking,
    DateTime? lastShakeTime,
    int? shakeCount,
    bool? isActive,
  }) {
    return ShakeDetectorState(
      isShaking: isShaking ?? this.isShaking,
      lastShakeTime: lastShakeTime ?? this.lastShakeTime,
      shakeCount: shakeCount ?? this.shakeCount,
      isActive: isActive ?? this.isActive,
    );
  }
}
