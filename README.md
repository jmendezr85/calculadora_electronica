# Calculadora Electrónica

Aplicación Flutter con herramientas para estudiantes y profesionales de electrónica.

## Laboratorio BLE

La sección **Laboratorio** agrupa las utilidades que se comunican con periféricos Bluetooth Low Energy (BLE) compatibles con el servicio Nordic UART (UUID `6e400001-b5a3-f393-e0a9-e50e24dcca9e`).

### Escanear y conectar

1. Abre el menú lateral (icono ☰ en la pantalla principal) y elige **Laboratorio**.
2. Presiona **Escanear** en la herramienta deseada para iniciar la búsqueda de dispositivos BLE que anuncian el servicio NUS.
3. Selecciona el periférico en el desplegable; la app solicitará los permisos necesarios (Bluetooth y ubicación en Android) y establecerá la conexión.

### Servos (BLE)

- Tras conectar, ajusta el control deslizante (0°–180°). Cada movimiento envía el comando `A:<ángulo>\n` a través del canal RX del periférico.
- En la parte inferior se muestra el registro de mensajes recibidos mediante el canal TX (una línea por cada mensaje terminado en `\n`).

### Data Logger (BLE)

- Cada línea recibida debe ser un objeto JSON con las claves `t`, `rh` y `lux` (por ejemplo: `{ "t": 24.1, "rh": 52, "lux": 310 }`).
- Los valores se grafican en tiempo real y se almacenan en memoria. Las tarjetas superiores muestran la última lectura disponible para temperatura (°C), humedad relativa (%) e iluminancia (lux).
- Usa el botón **Exportar CSV** en la barra de la aplicación para generar un archivo temporal con encabezado `timestamp,t_C,rh_pct,lux` y compartirlo mediante el sistema operativo.

## Ejecución

1. Instala dependencias: `flutter pub get`.
2. Ejecuta la app: `flutter run` (dispositivo físico recomendado para pruebas BLE).
3. Asegúrate de conceder permisos de Bluetooth y ubicación cuando se soliciten.

## Análisis de código

Antes de enviar cambios ejecuta `flutter analyze` para garantizar que no existan errores ni advertencias relevantes.
