class Plan {
  String nombre;
  String idPlan;
  String precio;
  String descripcion;
  String descripcionLarga;
  List<String> cualidades; 
  bool isExpanded;

  Plan({
    required this.idPlan,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.descripcionLarga,
    this.isExpanded = false,
    required this.cualidades, 
  });
}
