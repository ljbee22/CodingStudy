// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveClass.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduleClassAdapter extends TypeAdapter<ScheduleClass> {
  @override
  final int typeId = 1;

  @override
  ScheduleClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduleClass(
      name: fields[0] as String,
      memo: fields[1] as String,
      date: fields[2] as DateTime,
      btime: fields[3] as bool,
      done: fields[4] as bool,
      alarm: fields[5] as bool,
      colorIdx: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleClass obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.memo)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.btime)
      ..writeByte(4)
      ..write(obj.done)
      ..writeByte(5)
      ..write(obj.alarm)
      ..writeByte(6)
      ..write(obj.colorIdx);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduleClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SettingClassAdapter extends TypeAdapter<SettingClass> {
  @override
  final int typeId = 2;

  @override
  SettingClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingClass(
      isSunday: fields[0] as bool,
      themeIdx: fields[1] as int,
      fontIdx: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, SettingClass obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.isSunday)
      ..writeByte(1)
      ..write(obj.themeIdx)
      ..writeByte(2)
      ..write(obj.fontIdx);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyControllerAdapter extends TypeAdapter<DailyController> {
  @override
  final int typeId = 3;

  @override
  DailyController read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyController(
      doneCount: fields[0] as int,
      emoticon: fields[1] as String,
      dailyComment: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyController obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.doneCount)
      ..writeByte(1)
      ..write(obj.emoticon)
      ..writeByte(2)
      ..write(obj.dailyComment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyControllerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
