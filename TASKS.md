# Tareas Pendientes

## Alta Prioridad
- [ ] Limpiar rutas obsoletas en `config/routes.rb` (líneas 2-25: rutas GET de scaffold que duplican a `resources`)
- [ ] Sincronizar SourceTransfer ↔ GoalContribution: al actualizar/eliminar una transferencia ligada a una meta, la contribución debe reflejar los cambios
- [ ] Integrar FinancialAccount en Ingresos y Gastos (definir qué cuentas asociar)

## Media Prioridad
- [ ] Eliminar vistas placeholder: `app/views/investments/{create,update,destroy}.html.erb` y `home/index.html.erb`
- [ ] Auto-completar meta cuando `current_amount >= target_amount`

## Baja Prioridad
- [ ] Crear modelo ExchangeRate (tabla existe en BD pero sin modelo)
- [ ] Poblar seeds con datos demo (metas, cuentas, transferencias, etc.)
