# Datos que transforman:  
## Lo que los datos abiertos revelan sobre cómo el BCIE convierte financiamiento en desarrollo

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.18829251.svg)](https://doi.org/10.5281/zenodo.18829251)

Pipeline reproducible para la selección y evaluación de estudios de caso del Banco Centroamericano de Integración Económica (BCIE), utilizando indicadores de producto y efecto provenientes de su Plataforma de Datos Abiertos.

## Estructura

data/raw → Datos originales (no incluidos)  
data/processed → Objetos generados durante el análisis  
R → Funciones auxiliares y temas gráficos  
scripts → Scripts del pipeline  
output/tablas → Tablas del artículo  
output/figuras → Figuras del artículo  

## Fuente de datos

Plataforma de Datos Abiertos del BCIE  
Archivo: Operaciones_Indicadores_Producto_Efecto.csv  
Descarga: febrero 2026  

Colocar el archivo en:

data/raw/

## Reproducibilidad

Ejecutar en orden:

01_preparacion_datos.R  
02_seleccion_estudios_caso.R  
03_metricas_desempeno.R  
04_visualizacion_casos.R  
05_figura_final_lollipop.R  
06_figura_1_burbujas.R  

Los archivos `.rds` se generan automáticamente durante la ejecución.

## Requisitos

R ≥ 4.2  
tidyverse · janitor · lubridate · scales · stringr · ggplot2  

## Artículo asociado

“Datos que transforman: Lo que los datos abiertos revelan sobre cómo el BCIE convierte financiamiento en desarrollo”.

## Cómo citar

Acosta Salgado, L. G. (2026).  
Datos que transforman: Lo que los datos abiertos revelan sobre cómo el BCIE convierte financiamiento en desarrollo.  
Zenodo. https://doi.org/10.5281/zenodo.18829251

## Licencia

Creative Commons Attribution 4.0 International (CC BY 4.0)

## Autoría

Larissa Geraldina Acosta Salgado – Honduras
