// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_enum.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 3;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.TODO;
      case 1:
        return TaskStatus.DOING;
      case 2:
        return TaskStatus.DONE;
      case 4:
        return TaskStatus.UNDONE;
      default:
        return TaskStatus.TODO;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.TODO:
        writer.writeByte(0);
        break;
      case TaskStatus.DOING:
        writer.writeByte(1);
        break;
      case TaskStatus.DONE:
        writer.writeByte(2);
        break;
      case TaskStatus.UNDONE:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RepeatTypeAdapter extends TypeAdapter<RepeatType> {
  @override
  final int typeId = 4;

  @override
  RepeatType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return RepeatType.Daily;
      case 1:
        return RepeatType.Weekly;
      case 2:
        return RepeatType.Monthly;
      case 4:
        return RepeatType.Yearly;
      case 5:
        return RepeatType.None;
      default:
        return RepeatType.Daily;
    }
  }

  @override
  void write(BinaryWriter writer, RepeatType obj) {
    switch (obj) {
      case RepeatType.Daily:
        writer.writeByte(0);
        break;
      case RepeatType.Weekly:
        writer.writeByte(1);
        break;
      case RepeatType.Monthly:
        writer.writeByte(2);
        break;
      case RepeatType.Yearly:
        writer.writeByte(4);
        break;
      case RepeatType.None:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RepeatTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
