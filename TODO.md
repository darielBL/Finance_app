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
