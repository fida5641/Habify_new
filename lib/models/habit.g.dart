// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 1;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      name: fields[0] as String,
      isCompleted: fields[1] as bool,
      target: fields[2] as int,
      status: fields[3] as String,
      image: fields[4] as String,
      days: (fields[5] as List).cast<String>(),
      segment: fields[6] as int,
      selectedNumber: fields[7] as int,
      selectedOptions: fields[8] as String,
      currentSwipeCount: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isCompleted)
      ..writeByte(2)
      ..write(obj.target)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.days)
      ..writeByte(6)
      ..write(obj.segment)
      ..writeByte(7)
      ..write(obj.selectedNumber)
      ..writeByte(8)
      ..write(obj.selectedOptions)
      ..writeByte(9)
      ..write(obj.currentSwipeCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
