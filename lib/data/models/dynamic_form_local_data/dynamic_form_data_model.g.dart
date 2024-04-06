// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dynamic_form_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DynamicFormDataModelAdapter extends TypeAdapter<DynamicFormDataModel> {
  @override
  final int typeId = 0;

  @override
  DynamicFormDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DynamicFormDataModel(
      name: fields[0] as String,
      mobileNumber: fields[1] as String,
      consumerStatus: (fields[2] as List).cast<String>(),
      meterStatus: fields[3] as String,
      phaseType: fields[4] as String,
      meterValidationStatus: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DynamicFormDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.mobileNumber)
      ..writeByte(2)
      ..write(obj.consumerStatus)
      ..writeByte(3)
      ..write(obj.meterStatus)
      ..writeByte(4)
      ..write(obj.phaseType)
      ..writeByte(5)
      ..write(obj.meterValidationStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DynamicFormDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
