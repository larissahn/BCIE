# Datos que transforman: seis proyectos del BCIE bajo la lupa de los datos abiertos

Análisis reproducible de datos abiertos del Banco Centroamericano de Integración Económica (BCIE) para la selección y evaluación de estudios de caso con base en indicadores de producto y efecto.

Este repositorio contiene el pipeline completo de limpieza, construcción del universo analítico, selección de casos y cálculo de métricas de desempeño, así como las visualizaciones utilizadas en el artículo.

---

## Estructura del repositorio

data/raw → Datos originales (no incluidos en el repositorio)  
data/processed → Objetos generados en el pipeline  
R → Funciones auxiliares y temas gráficos  
scripts → Scripts de análisis  
output/tablas → Tablas para el artículo  
output/figuras → Figuras generadas  

---

## Fuente de datos

Plataforma de Datos Abiertos del BCIE  
Archivo utilizado: `Operaciones_Indicadores_Producto_Efecto.csv`  
Descarga: febrero de 2026  

Debido a políticas de tamaño y reproducibilidad responsable, los datos no se incluyen en el repositorio.  
El usuario debe descargarlos desde la plataforma oficial y colocarlos en:

data/raw/

---

## Reproducibilidad

Ejecutar los scripts en el siguiente orden:

1. `01_preparacion_datos.R`  
   Limpieza, construcción del universo analítico y pool de proyectos.

2. `02_seleccion_estudios_caso.R`  
   Construcción del universo elegible y selección final de los casos.

3. `03_metricas_desempeno.R`  
   Cálculo del cumplimiento de indicadores por proyecto.

4. `04_visualizacion_casos.R`  
   Resúmenes, detección de outliers y visualización individual de cada estudio de caso.

5. `05_figura_final_lollipop.R`  
   Mediana de cumplimiento por proyecto.

6. `06_figura_1_burbujas.R`  
   Comparación de los seis estudios de caso según duración, monitoreo, monto y sector.

---

## Requisitos

R ≥ 4.2  

Paquetes principales:

tidyverse  
janitor  
lubridate  
scales  
stringr  
ggplot2  

---

## Artículo asociado

El repositorio acompaña el manuscrito:

“Datos que transforman: seis proyectos del BCIE bajo la lupa de los datos abiertos”.

---

## Licencia

Este proyecto se distribuye bajo la licencia:

Creative Commons Attribution 4.0 International (CC BY 4.0)

Esto permite compartir y adaptar el material siempre que se otorgue el crédito correspondiente.

---

## Autoría

Larissa Geraldina Acosta Salgado  
Honduras  

---

## Cómo citar este repositorio

La cita será actualizada cuando se genere el DOI mediante Zenodo.
