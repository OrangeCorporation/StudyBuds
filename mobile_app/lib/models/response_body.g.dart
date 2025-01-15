// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response_body.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ResponseBodyAdapter extends TypeAdapter<ResponseBody> {
  @override
  final int typeId = 0;

  @override
  ResponseBody read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ResponseBody(
      id: fields[0] as String,
      data: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ResponseBody obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponseBodyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
