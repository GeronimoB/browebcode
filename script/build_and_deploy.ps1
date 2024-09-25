# Cambiar directorio al proyecto Flutter
Write-Output "Ejecutando flutter build web..."
cd "C:\Users\alejo\OneDrive\Escritorio\DW\WORKANA\proyecto_bro\browebcode"

# Ejecutar el build de Flutter para web
flutter build web

# Verificar si el build fue exitoso
if ($LASTEXITCODE -ne 0) {
    Write-Output "El build falló. Saliendo del script..."
    exit $LASTEXITCODE
}

Write-Output "Build completado. Copiando archivos..."

# Copiar archivos al directorio de destino, sobrescribiendo los existentes
Copy-Item -Path "C:\Users\alejo\OneDrive\Escritorio\DW\WORKANA\proyecto_bro\browebcode\build\web\*" `
          -Destination "C:\Users\alejo\OneDrive\Escritorio\DW\WORKANA\proyecto_bro\webappbuild" `
          -Recurse -Force

if ($LASTEXITCODE -ne 0) {
    Write-Output "Error al copiar archivos. Saliendo del script..."
    exit $LASTEXITCODE
}

Write-Output "Archivos copiados. Preparando Git..."

# Cambiar directorio donde se hará el commit de Git
cd "C:\Users\alejo\OneDrive\Escritorio\DW\WORKANA\proyecto_bro\webappbuild"

# Ejecutar Git add, commit y push
git add .
git commit -m "Actualizacion automatica de archivos del build"
git push

if ($LASTEXITCODE -ne 0) {
    Write-Output "Error al hacer push. Saliendo del script..."
    exit $LASTEXITCODE
}

Write-Output "Proceso completado exitosamente."


# Volver a la ruta inicial
cd "C:\Users\alejo\OneDrive\Escritorio\DW\WORKANA\proyecto_bro\browebcode"
Write-Output "Regresado a la ruta inicial."