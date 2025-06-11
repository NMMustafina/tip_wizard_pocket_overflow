// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'check_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckModelAdapter extends TypeAdapter<CheckModel> {
  @override
  final int typeId = 0;

  @override
  CheckModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CheckModel(
      placeName: fields[0] as String,
      positions: (fields[1] as List)
          .map((dynamic e) => (e as Map).cast<String, String>())
          .toList(),
      tax: fields[2] as double?,
      imagesPaths: (fields[3] as List).cast<String>(),
      placeAddress: fields[4] as String?,
      personalAssessment: fields[5] as String?,
      date: fields[6] as String,
      tipPercentage: fields[7] as double?,
      splitCount: fields[8] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CheckModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.placeName)
      ..writeByte(1)
      ..write(obj.positions)
      ..writeByte(2)
      ..write(obj.tax)
      ..writeByte(3)
      ..write(obj.imagesPaths)
      ..writeByte(4)
      ..write(obj.placeAddress)
      ..writeByte(5)
      ..write(obj.personalAssessment)
      ..writeByte(6)
      ..write(obj.date)
      ..writeByte(7)
      ..write(obj.tipPercentage)
      ..writeByte(8)
      ..write(obj.splitCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
