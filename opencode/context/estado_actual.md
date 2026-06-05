# Estado Actual de la Aplicación

## ¿Qué funciona correctamente?
- ✅ Autenticación (registro, login, logout, edición de perfil)
- ✅ CRUD de categorías (base + personalizadas, soft delete)
- ✅ CRUD de ingresos únicos (`income_sources`)
- ✅ CRUD de ingresos recurrentes (`recurring_incomes` + `recurring_income_records`)
- ✅ CRUD de gastos únicos (`expenses`)
- ✅ CRUD de gastos recurrentes (`recurring_expenses` + `recurring_expense_records`)
- ✅ CRUD de inversiones (`investments`)
- ✅ Dashboard con gráficos, filtros, cards de resumen
- ✅ Sidebar colapsable (desktop: reduce a iconos; móvil: off-canvas)
- ✅ Paleta de colores personalizada
- ✅ Despliegue en Koyeb con Supabase

## ¿Qué problemas existen actualmente?
- ❌ La lógica está fragmentada (tablas separadas para únicos y recurrentes)
- ❌ Llaves foráneas complicadas (`income_source_id` + `recurring_income_id`)
- ❌ Consultas complejas en el dashboard
- ❌ Mantenimiento difícil (cambios afectan múltiples archivos)

## ¿Qué se decidió hacer?
**Unificar ingresos y gastos en tablas únicas**

### Nueva estructura propuesta:
```yaml
incomes:
  - Para ingresos únicos (recurring: false)
  - Para plantillas de ingresos recurrentes (recurring: true)
  - Campos comunes + específicos por tipo

income_records:
  - Registros mensuales de ingresos recurrentes
  - Almacena el monto real cobrado cada mes

expenses:
  - Para gastos únicos (recurring: false)
  - Para plantillas de gastos recurrentes (recurring: true)

expense_records:
  - Registros mensuales de gastos recurrentes
  - Almacena el monto real pagado cada mes
