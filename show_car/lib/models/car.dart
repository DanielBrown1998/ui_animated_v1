enum EngineType {
  v6,
  v6TwinTurbo,
  v8,
  v8TwinTurbo,
  v8Supercharged,
  v12,
  v12Hybrid,
  i4,
  i4Turbo,
  i6,
  i6TwinTurbo,
  h6TwinTurbo,
  electric,
}

extension EngineTypeExtension on EngineType {
  String get name {
    switch (this) {
      case EngineType.v6:
        return 'V6';
      case EngineType.v6TwinTurbo:
        return 'V6 Twin Turbo';
      case EngineType.v8:
        return 'V8';
      case EngineType.v8TwinTurbo:
        return 'V8 Twin Turbo';
      case EngineType.v8Supercharged:
        return 'V8 Supercharged';
      case EngineType.v12:
        return 'V12';
      case EngineType.v12Hybrid:
        return 'V12 Hybrid';
      case EngineType.i4:
        return 'I4';
      case EngineType.i4Turbo:
        return 'I4 Turbo';
      case EngineType.i6:
        return 'I6';
      case EngineType.i6TwinTurbo:
        return 'I6 Twin Turbo';
      case EngineType.h6TwinTurbo:
        return 'H6 Twin Turbo';
      case EngineType.electric:
        return 'Electric';
    }
  }
}

enum CarType {
  sedan,
  sedanSport,
  coupeSport,
  coupeMuscle,
  coupeTrack,
  coupeRace,
  suv,
  hatchback,
  convertible,
  gt3,
  truck,
}

extension CarTypeExtension on CarType {
  String get name {
    switch (this) {
      case CarType.sedan:
        return 'Sedan';
      case CarType.sedanSport:
        return 'Sedan Sport';
      case CarType.coupeSport:
        return 'Coupe Sport';
      case CarType.coupeMuscle:
        return 'Coupe Muscle';
      case CarType.coupeTrack:
        return 'Coupe Track';
      case CarType.coupeRace:
        return 'Coupe Race';
      case CarType.suv:
        return 'SUV';
      case CarType.hatchback:
        return 'Hatchback';
      case CarType.gt3:
        return 'GT3';
      case CarType.convertible:
        return 'Convertible';
      case CarType.truck:
        return 'Truck';
    }
  }
}

enum CarAttrs {
  name,
  marca,
  year,
  asset,
  horsePower,
  torque,
  zeroToHundred,
  topSpeed,
  engineType,
  doors,
  carType,
}

extension CarAttrsExtension on CarAttrs {
  String get getAttrName {
    switch (this) {
      case CarAttrs.name:
        return 'Name';
      case CarAttrs.marca:
        return 'Marca';
      case CarAttrs.asset:
        return 'Asset';
      case CarAttrs.horsePower:
        return 'Horse Power';
      case CarAttrs.torque:
        return 'Torque';
      case CarAttrs.zeroToHundred:
        return '0-100 km/h';
      case CarAttrs.topSpeed:
        return 'Top Speed';
      case CarAttrs.engineType:
        return 'Engine Type';
      case CarAttrs.doors:
        return 'Doors';
      case CarAttrs.carType:
        return 'Car Type';
      case CarAttrs.year:
        return 'Year';
    }
  }
}

enum CarInteraction {
  favorite,
  power,
  ecu,
  remap,
  getLocalization,
  openDoors,
  openWindows,
  tiresStatus,
  engineStatus,
  brakeStatus,
}

extension CarInteractionExtension on CarInteraction {
  String get name {
    switch (this) {
      case CarInteraction.favorite:
        return 'Favorite';
      case CarInteraction.power:
        return 'Power';
      case CarInteraction.ecu:
        return 'ECU';
      case CarInteraction.remap:
        return 'Remap';
      case CarInteraction.getLocalization:
        return 'Get Localization';
      case CarInteraction.openDoors:
        return 'Open Doors';
      case CarInteraction.openWindows:
        return 'Open Windows';
      case CarInteraction.tiresStatus:
        return 'Tires Status';
      case CarInteraction.engineStatus:
        return 'Engine Status';
      case CarInteraction.brakeStatus:
        return 'Brake Status';
    }
  }
}

class Car {
  final String name;
  final String marca;
  final String asset;
  final String horsePower;
  final String torque;
  final String zeroToHundred;
  final String topSpeed;
  final EngineType engineType;
  final int doors;
  final CarType carType;
  final int year;

  List<CarAttrs> get attrs => CarAttrs.values;
  List<CarInteraction> get interactions => CarInteraction.values;

  dynamic getAttrValue(CarAttrs attr) {
    switch (attr) {
      case CarAttrs.name:
        return name;
      case CarAttrs.marca:
        return marca;
      case CarAttrs.asset:
        return asset;
      case CarAttrs.horsePower:
        return horsePower;
      case CarAttrs.torque:
        return torque;
      case CarAttrs.zeroToHundred:
        return zeroToHundred;
      case CarAttrs.topSpeed:
        return topSpeed;
      case CarAttrs.engineType:
        return engineType.name;
      case CarAttrs.doors:
        return doors.toString();
      case CarAttrs.carType:
        return carType.name;
      case CarAttrs.year:
        return year.toString();
    }
  }

  Car({
    required this.name,
    required this.marca,
    required this.year,
    required this.asset,
    required this.horsePower,
    required this.torque,
    required this.zeroToHundred,
    required this.topSpeed,
    required this.engineType,
    required this.doors,
    required this.carType,
  });
}
