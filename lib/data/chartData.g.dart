// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chartData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChartDataAdapter extends TypeAdapter<ChartData> {
  @override
  final int typeId = 0;

  @override
  ChartData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartData(
      fields[0] as double,
      fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ChartData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.x)
      ..writeByte(1)
      ..write(obj.y);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
