# TODO

## Navigation y scroll

Al cambiar el rango de fechas en el gráfico de tasas de cambio, la página se recarga
completamente y se pierde el scroll. Se intentó con Turbo Frames y con fetch + JS pero
ambos fallaron (Turbo no está cargado en el JS; fetch no renderizaba el gráfico).

**Solución actual**: usar `anchor: 'exchange_rates_chart'` en los links para que el
navegador scrollee automáticamente al chart tras la recarga (comportamiento nativo de
hash anchors).

**Posible mejora futura**: Implementar con AJAX + re-inicialización de Chartkick,
o cargar Turbo Frames correctamente.

## Calculadora de divisas

Crear una calculadora in-app que convierta entre las divisas que maneja la app
(CUP, USD, EUR, CLA, ZELLE) usando la tasa de cambio de elTOQUE (`ExchangeRate`)
como referencia.
- Modal o sección en el dashboard con campos: monto, moneda origen, moneda destino
- Tomar la tasa más reciente de la BD
- Mostrar el resultado en tiempo real con JS

## Transferencias entre fuentes de diferente moneda

Permitir `SourceTransfer` entre ingresos en distintas monedas, usando la tasa
de elTOQUE para la conversión. Ej: transferir USD → CUP.
- Modificar `SourceTransfer` para aceptar moneda origen y destino diferentes
- Agregar `exchange_rate_id` o almacenar el rate usado en el momento
- Mostrar la tasa aplicada y el monto convertido en la UI
