class DetalleReserva {
  final int idDetalleReserva;
  final int idReserva;
  final int idInventario;
  final int cantidad;
  final double subtotal;
  final String? nombrePrenda;
  final String? codigoInterno;
  final String? talla;

  DetalleReserva({
    required this.idDetalleReserva,
    required this.idReserva,
    required this.idInventario,
    required this.cantidad,
    required this.subtotal,
    this.nombrePrenda,
    this.codigoInterno,
    this.talla,
  });

  factory DetalleReserva.fromJson(Map<String, dynamic> json) => DetalleReserva(
        idDetalleReserva: json['idDetalle_Reserva'],
        idReserva: json['idReserva'],
        idInventario: json['idInventario'],
        cantidad: json['cantidad'] ?? 1,
        subtotal: double.tryParse(json['subtotal'].toString()) ?? 0,
        nombrePrenda: json['nombre_prenda'],
        codigoInterno: json['codigo_interno'],
        talla: json['talla'],
      );

  Map<String, dynamic> toJson() => {
        'idInventario': idInventario,
        'cantidad': cantidad,
      };
}
