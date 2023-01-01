// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduleClass.dart';

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
      alarm: fields[1] as bool,
      date: fields[2] as DateTime,
      btime: fields[3] as bool,
      done: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduleClass obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.alarm)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.btime)
      ..writeByte(4)
      ..write(obj.done);
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
