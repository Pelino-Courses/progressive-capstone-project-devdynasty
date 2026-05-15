// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      priceInRwf: fields[3] as int,
      category: fields[4] as String,
      condition: fields[5] as String,
      sellerId: fields[6] as String,
      sellerName: fields[7] as String,
      location: fields[8] as String,
      imageUrl: fields[9] as String?,
      isAvailable: fields[10] as bool,
      imageBytes: (fields[11] as List?)?.cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priceInRwf)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.condition)
      ..writeByte(6)
      ..write(obj.sellerId)
      ..writeByte(7)
      ..write(obj.sellerName)
      ..writeByte(8)
      ..write(obj.location)
      ..writeByte(9)
      ..write(obj.imageUrl)
      ..writeByte(10)
      ..write(obj.isAvailable)
      ..writeByte(11)
      ..write(obj.imageBytes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
