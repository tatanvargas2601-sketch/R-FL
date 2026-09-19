import 'dart:typed_data';

import 'package:dio/dio.dart';
import '../core/api/api_client.dart';
import '../models/prenda.dart';

class PrendaService {
  final _client = ApiClient.instance;
  static const _base = '/api/prendas';

  Future<List<Prenda>> getAll({int? idCategoria}) => _client.unwrap<List<Prenda>>(
        () => _client.dio.get(_base, queryParameters: {
          if (idCategoria != null) 'idCategoria': idCategoria,
        }),
        (data) => (data as List).map((e) => Prenda.fromJson(e)).toList(),
      );

  Future<Prenda> getById(int id) => _client.unwrap<Prenda>(
        () => _client.dio.get('$_base/$id'),
        (data) => Prenda.fromJson(data),
      );

  Future<Prenda> create(Prenda prenda) => _client.unwrap<Prenda>(
        () => _client.dio.post(_base, data: prenda.toJson()),
        (data) => Prenda.fromJson(data),
      );

  Future<Prenda> update(int id, Prenda prenda) => _client.unwrap<Prenda>(
        () => _client.dio.put('$_base/$id', data: prenda.toJson()),
        (data) => Prenda.fromJson(data),
      );

  Future<void> delete(int id) => _client.unwrap<void>(
        () => _client.dio.delete('$_base/$id'),
        (_) {},
      );

  
  
  
  Future<void> uploadImagen(int idPrenda, Uint8List bytes, {String? filename}) async {
    final formData = FormData.fromMap({
      'images': MultipartFile.fromBytes(
        bytes,
        filename: filename ?? 'imagen.jpg',
      ),
    });
    await _client.unwrap<void>(
      () => _client.dio.put('$_base/$idPrenda', data: formData),
      (_) {},
    );
  }

  Future<void> uploadImagenes(int idPrenda, List<Uint8List> bytesList, {List<String>? filenames}) async {
    final formData = FormData();
    final files = await Future.wait(bytesList.asMap().entries.map((entry) async {
      return MultipartFile.fromBytes(
        entry.value,
        filename: filenames?[entry.key] ?? 'imagen.jpg',
      );
    }));
    for (final file in files) {
      formData.files.add(MapEntry('images', file));
    }
    await _client.unwrap<void>(
      () => _client.dio.put('$_base/$idPrenda', data: formData),
      (_) {},
    );
  }
}
