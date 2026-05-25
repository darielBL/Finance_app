# Bitácora de Decisiones - Finances App

## Decisión 001: Online-only para MVP
- **Alternativas**: Offline-first, Híbrido
- **Decisión**: Online-only
- **Justificación**: La complejidad de sincronización offline-online agregaría 2-3 semanas de desarrollo
- **Consecuencias**: No se requiere lógica de detección de conexión ni almacenamiento local

## Decisión 002: Manejo de dinero con money gem
- **Alternativas**: Float, Integer manual
- **Decisión**: `money` + `money-rails`
- **Justificación**: Evita errores de floating point, formateo automático, multi-moneda nativo

## Decisión 003: Gráficos con Chartkick + Chart.js
- **Alternativas**: Chart.js puro, Gruff
- **Decisión**: Chartkick + Chart.js
- **Justificación**: Reduce código gráfico ~90%, integración directa con ActiveRecord

## Decisión 004: Autenticación con Devise
- **Alternativas**: Sorcery, Auth0
- **Decisión**: Devise
- **Justificación**: Estándar en Rails, maneja todo, integración probada

## Decisión 005: Bootstrap 5 como framework CSS
- **Alternativas**: Tailwind CSS
- **Decisión**: Bootstrap 5
- **Justificación**: Familiaridad del desarrollador

## Decisión 006: Sidebar colapsable con botón flotante
- **Decisión**: Sidebar lateral fijo, colapsable a iconos en desktop, off-canvas en móvil
- **Justificación**: Mejor uso del espacio horizontal, experiencia moderna

## Decisión 007: Unificación de ingresos y gastos (pendiente)
- **Estado**: Por implementar
- **Objetivo**: Simplificar la arquitectura
- **Nuevas tablas**: `incomes`, `income_records`, `expenses`, `expense_records`
