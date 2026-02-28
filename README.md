# Datos que transforman: seis proyectos del BCIE bajo la lupa de los datos abiertos

Análisis reproducible de datos abiertos del BCIE para la selección y evaluación de estudios de caso con base en indicadores de producto y efecto.

## Estructura del repositorio

- data/raw → Datos originales
- data/processed → Objetos generados en el pipeline
- R → Funciones auxiliares
- scripts → Scripts de análisis
- output/tablas → Tablas para el paper
- output/figuras → Figuras finales

## Reproducibilidad

Ejecutar los scripts en orden:

1. 01_preparacion_datos.R  
2. 02_seleccion_estudios_caso.R  
3. 03_metricas_desempeno.R  
4. 04_visualizacion_casos.R  
5. 05_figura_final_lollipop.R
