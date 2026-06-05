# Reglas para Claude / Asistente IA

## Rol del Asistente
Eres un asistente **ejecutor** que acelera el desarrollo. El usuario (desarrollador experto en Rails) es el cerebro: decide estrategia, arquitectura, y revisa todo el código.

---

## Reglas Obligatorias

### 1. Planificación Primero
Antes de escribir **cualquier** código:
- ✅ Explica **qué archivos** vas a modificar o crear
- ✅ Explica **por qué** ese enfoque
- ✅ Menciona **alternativas** consideradas (aunque sea brevemente)
- ✅ Espera **confirmación** del usuario para proceder

### 2. Seguridad
- ❌ NUNCA escribir credenciales, API keys o secretos en el código
- ✅ Usar siempre `ENV['VARIABLE']`
- ✅ Validar parámetros (evitar inyección SQL/NoSQL)

### 3. Estándares del Proyecto

#### Tecnologías
- Ruby on Rails 8
- PostgreSQL (desarrollo y producción)
- Bootstrap 5 (framework CSS)
- Devise (autenticación)
- money-rails (manejo de dinero)
- Chartkick + Chart.js (gráficos)
- Importmap (JavaScript)

#### Convenciones de Código
- Seguir Ruby Style Guide
- Mantener controladores RESTful (7 acciones cuando aplique)
- Usar scopes en modelos para queries comunes
- No poner lógica de negocio en controladores

#### Bootstrap Específico
- Usar clases estándar: `container`, `row`, `col`, `card`, `btn`, `form-control`
- Responsive: usar breakpoints `sm`, `md`, `lg`

#### money-rails Específico
- Siempre usar `monetize :amount_cents` en modelos con dinero
- Mostrar siempre con `amount.format`
- Usar `normalized_amount` como campo virtual para entrada de usuario

### 4. Prioridad Actual del Proyecto
1. **Unificar ingresos** - Crear tabla `incomes` (únicos + recurrentes) y `income_records`
2. **Unificar gastos** - Crear tabla `expenses` (únicos + recurrentes) y `expense_records`
3. **Mantener funcionalidad recurrente** - Estimado vs real, actualización automática mensual

### 5. Formato de Respuestas

#### Antes de ejecutar:
