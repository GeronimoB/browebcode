class Plan {
  String nombre;
  String idPlan;
  String precio;
  String descripcion;
  String descripcionLarga;
  List<String> cualidades; // Declaración de la propiedad como una lista de strings
  bool isExpanded;

  Plan({
    required this.idPlan,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.descripcionLarga,
    this.isExpanded = false,
    required this.cualidades, // Inicialización de la propiedad como una lista
  });
}
