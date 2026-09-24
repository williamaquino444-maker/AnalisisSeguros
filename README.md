## Análisis Exploratorio de Pólizas de Seguros y Detección de Fraude

## Descripción del Proyecto
Este proyecto analiza un conjunto de datos del sector asegurador para identificar los patrones clave detrás de las pérdidas económicas de la compañía. 

A través de un enfoque de **pensamiento crítico de negocio**, el análisis pasó de una visión general de pagos a enfocar directamente las **pólizas liquidadas con indicadores de sospecha de fraude (`fraud_flag = 1`)**, logrando aislar el verdadero punto de fuga financiero.

---

##  Herramientas y Tecnologías
* **Motor de Consultas:** SQL / Google BigQuery
* **Visualización (próximamente):** Power BI
* **Datasets:** Archivos en formato CSV (`customers.csv`, `policies.csv`, `claims.csv`, `fraud_indicators.csv`, `cyber_incidents.csv`, `weather_data.csv`)

---

## 🔍 Hallazgos Clave

1. **Magnitud del Fraude Identificado:**
   * Se identificaron **61.38 millones** entregados en reclamos liquidados (*Settled*) que contenían marcas de fraude (`fraud_flag = 1`).
   
2. **Líneas de Negocio Más Afectadas:**
   * **Auto (*Motor*):** Concentra la mayor pérdida por fraude (~$28.18 M).
   * **Salud (*Health*):** Ocupa el segundo lugar en impacto por fraude (~$24.02 M).

3. **Tendencia Temporal:**
   * El impacto económico de los reclamos con sospecha de fraude alcanzó su punto más alto en el año **2025** (~$25.95 M).

---

## 📁 Archivos en el Repositorio
* `Analisis de seguros.sql`: Script con las consultas SQL utilizadas para el filtrado, joins y agregaciones de datos.
* Datasets en formato `.csv`: Tablas de soporte con datos de clientes, pólizas, reclamos y factores de riesgo.

---

## 🚀 Próximos Pasos
* Implementación de un tablero interactivo en **Power BI** para visualizar las tendencias por tipo de póliza y perfiles de cliente.
* Creación de métricas en **DAX** para el monitoreo de reclamos en tiempo real.
