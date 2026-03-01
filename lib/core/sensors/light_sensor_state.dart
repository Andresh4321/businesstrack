class LightSensorState {
  final double lightLevel;
  final bool isDarkMode;
  final String lightCondition;
  final bool isActive;

  LightSensorState({
    required this.lightLevel,
    required this.isDarkMode,
    required this.lightCondition,
    required this.isActive,
  });

  factory LightSensorState.initial() {
    return LightSensorState(
      lightLevel: 500.0,
      isDarkMode: false,
      lightCondition: 'Normal',
      isActive: false,
    );
  }

  LightSensorState copyWith({
    double? lightLevel,
    bool? isDarkMode,
    String? lightCondition,
    bool? isActive,
  }) {
    return LightSensorState(
      lightLevel: lightLevel ?? this.lightLevel,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      lightCondition: lightCondition ?? this.lightCondition,
      isActive: isActive ?? this.isActive,
    );
  }

  String getLightDescription() {
    if (lightLevel < 100) {
      return 'Very Dark';
    } else if (lightLevel < 200) {
      return 'Dark';
    } else if (lightLevel < 500) {
      return 'Dim';
    } else if (lightLevel < 800) {
      return 'Normal';
    } else {
      return 'Bright';
    }
  }
}
