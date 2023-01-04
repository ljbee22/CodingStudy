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
      memo: fields[1] as String,
      date: fields[2] as DateTime,
      btime: fields[3] as bool,
      time: fields[4] as String,
      done: fields[5] as bool,
      alarm: fields[6] as bool,
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
      ..write(obj.time)
      ..writeByte(5)
      ..write(obj.done)
      ..writeByte(6)
      ..write(obj.alarm);
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
