# Plan de Módulos - Finances App

## Estado Actual de los Sprints

| Sprint | Contenido | Estado |
|--------|-----------|--------|
| Sprint 0 | Setup inicial | ✅ Completo |
| Sprint 1 | Autenticación | ✅ Completo |
| Sprint 2 | CRUD de categorías | ✅ Completo |
| Sprint 3 | CRUD de ingresos (únicos y recurrentes) | ✅ Completo |
| Sprint 4 | CRUD de gastos (únicos y recurrentes) | ✅ Completo |
| Sprint 5 | Dashboard con gráficos | ✅ Completo |
| Sprint 6 | Inversiones | ✅ Completo |
| Sprint 7 | Mejoras de UX (sidebar responsiva) | ✅ Completo |
| Sprint 8 | Despliegue | ⏳ Pendiente |

## Próximas Tareas (Pendientes)

### Pendiente 1: Unificar ingresos en una sola tabla
- Objetivo: Simplificar la arquitectura actual
- Tablas: `incomes` (únicos + recurrentes) + `income_records` (registros mensuales)
- Estimación: 4-5 horas

### Pendiente 2: Unificar gastos en una sola tabla
- Objetivo: Simplificar la arquitectura actual
- Tablas: `expenses` (únicos + recurrentes) + `expense_records` (registros mensuales)
- Estimación: 4-5 horas

### Pendiente 3: Mejorar estilo de login
- Objetivo: Diseño independiente para páginas de Devise
- Características: Layout sin navbar, card centrada, fondo con gradiente
- Estimación: 2 horas

### Pendiente 4: Gráfico de barras (ingresos vs gastos por origen)
- Objetivo: Reemplazar gráfico actual
- Características: Pares de barras por origen (ingresado vs gastado)
- Estimación: 4 horas

### Pendiente 5: Sistema de notificaciones
- Objetivo: Notificar al usuario sobre ingresos/gastos recurrentes pendientes
- Características: Modelo Notification, badge en navbar, job diario
- Estimación: 6 horas

### Pendiente 6: Reportes (exportar CSV)
- Objetivo: Exportar gastos e ingresos a CSV
- Estimación: 3 horas

### Pendiente 7: Módulo de deudas
- Objetivo: Registrar y hacer seguimiento de deudas
- Estimación: 5 horas

## Prioridad Recomendada
1. Unificar ingresos y gastos (limpiar arquitectura)
2. Mejorar estilo de login
3. Gráfico de barras
4. Sistema de notificaciones
5. Reportes
6. Deudas
