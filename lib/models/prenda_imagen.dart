class PrendaImagen {
  final int idImagen;
  final int idPrenda;

  
  
  final String url;

  PrendaImagen({required this.idImagen, required this.idPrenda, required this.url});

  factory PrendaImagen.fromJson(Map<String, dynamic> json) => PrendaImagen(
        idImagen: json['idImagen'] ?? 0,
        idPrenda: json['idPrenda'] ?? 0,
        url: json['url'] ?? json['filename'] ?? '',
      );
}
