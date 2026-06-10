# Finances App

Aplicación web de finanzas personales construida con Ruby on Rails 8.0.

## Stack

- **Ruby** 3.3.0
- **Rails** 8.0
- **PostgreSQL**
- **Devise** (autenticación)
- **Bootstrap 5** (frontend)
- **Chartkick + Groupdate** (gráficos)
- **money-rails** (manejo de montos)
- **Hotwire** (Turbo + Stimulus)
- **Solid Queue / Solid Cache / Solid Cable** (producción)

## Funcionalidades

- **Dashboard** con gráfico de barras de ingresos vs gastos por fuente
- **Ingresos** únicos y recurrentes, con registro mensual de montos reales
- **Gastos** únicos y recurrentes, con registro mensual de pagos
- **Categorías** para clasificar gastos
- **Metas de ahorro** con seguimiento de progreso y aportes
- **Deudas** para llevar control de cuentas por pagar/cobrar
- **Inversiones**
- **Transferencias entre fuentes** de ingreso
- **Notificaciones** de ingresos/gastos pendientes
- **Múltiples monedas** (CUP, USD, EUR, MXN)

## Requisitos

- Ruby 3.3.0
- PostgreSQL
- Bundler

## Setup

```bash
# Instalar dependencias
bundle install

# Crear y migrar base de datos
rails db:create
rails db:migrate
rails db:seed

# Iniciar servidor
rails server
```

## Tests

```bash
rails test
```

## Modelos principales

| Modelo | Descripción |
|--------|-------------|
| `User` | Usuario con Devise |
| `Income` | Fuente de ingreso (único o recurrente) |
| `IncomeRecord` | Registro mensual de ingreso real |
| `Expense` | Gasto (único o recurrente) |
| `ExpenseRecord` | Registro mensual de pago real |
| `Category` | Categoría de gasto |
| `Goal` | Meta de ahorro |
| `GoalContribution` | Aporte a una meta |
| `Debt` | Deuda a pagar o cobrar |
| `Investment` | Inversión registrada |
| `SourceTransfer` | Transferencia entre fuentes |
| `Notification` | Notificación de pendientes |
