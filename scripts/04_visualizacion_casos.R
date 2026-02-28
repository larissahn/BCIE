# =========================================================
# 04_visualizacion_casos.R
# Visualización individual y métricas por estudio de caso
# =========================================================

library(tidyverse)
library(scales)

source("R/funciones_metricas.R")
source("R/temas_graficos.R")

dir.create("output/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tablas", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------
# Validar insumo
# ---------------------------------------------------------

if(!file.exists("data/processed/impacto_calidad.rds")){
  stop("impacto_calidad.rds not found. Run Script 01 first.")
}

impacto_calidad <- readRDS("data/processed/impacto_calidad.rds")

# ---------------------------------------------------------
# Llaves de los casos 
# ---------------------------------------------------------

llaves_casos <- c(
  ICE = "2014-11-25-DI-119/2014-302460-2151",
  AGUA = "2013-07-30-DI-75/2013-302351-2122",
  CHOROTEGA = "2015-05-26-DI-49/2015-500023-2157",
  CHAPARRAL = "2017-07-25-DI-60/2017-302428-2143",
  CARRETERAS = "2011-06-28-DI-82/2011-302123-2074",
  VACUNAS = "2021-03-11-DI-30/2021-500692-2271"
)

# ---------------------------------------------------------
# Funciones auxiliares
# ---------------------------------------------------------

resumen_indicadores <- function(df){
  df %>%
    summarise(
      n_indicadores = n(),
      cumplimiento_promedio = mean(cumplimiento, na.rm = TRUE),
      cumplimiento_mediana = median(cumplimiento, na.rm = TRUE),
      porcentaje_supera_meta = mean(cumplimiento >= 1, na.rm = TRUE)
    )
}

detectar_outliers <- function(df){
  
  q1 <- quantile(df$cumplimiento, 0.25, na.rm = TRUE)
  q3 <- quantile(df$cumplimiento, 0.75, na.rm = TRUE)
  iqr <- q3 - q1
  limite_superior <- q3 + 1.5 * iqr
  
  df %>%
    filter(cumplimiento > limite_superior) %>%
    arrange(desc(cumplimiento))
}

# =========================================================
# CASO 1 – ICE COSTA RICA
# =========================================================

cat("\n================ CASO 1 – ICE =================\n")

stopifnot(llaves_casos["ICE"] %in% impacto_calidad$llave_op)

indicadores_ice <- extraer_indicadores_validos(impacto_calidad, llaves_casos["ICE"])

resumen_ice <- resumen_indicadores(indicadores_ice)
print(resumen_ice)
write_csv(resumen_ice, "output/tablas/resumen_ice.csv")

outliers_ice <- detectar_outliers(indicadores_ice)
print(outliers_ice)
write_csv(outliers_ice, "output/tablas/outliers_ice.csv")

indicadores_ice_ajustado <- indicadores_ice %>%
  filter(meta > 1, cumplimiento < 10)

resumen_ice_ajustado <- resumen_indicadores(indicadores_ice_ajustado)
print(resumen_ice_ajustado)
write_csv(resumen_ice_ajustado, "output/tablas/resumen_ice_ajustado.csv")

figura_2 <- graficar_cumplimiento(
  indicadores_ice,
  "Programa de Desarrollo Eléctrico ICE 2014–2016"
)

print(figura_2)

ggsave("output/figuras/figura_2_ice_indicadores.png",
       figura_2, width = 10, height = 6, dpi = 300, bg = "white")

# =========================================================
# CASO 2 – AGUA NICARAGUA
# =========================================================

cat("\n================ CASO 2 – AGUA =================\n")

stopifnot(llaves_casos["AGUA"] %in% impacto_calidad$llave_op)

indicadores_agua <- extraer_indicadores_validos(impacto_calidad, llaves_casos["AGUA"])

resumen_agua <- resumen_indicadores(indicadores_agua)
print(resumen_agua)
write_csv(resumen_agua, "output/tablas/resumen_agua.csv")

outliers_agua <- detectar_outliers(indicadores_agua)
print(outliers_agua)
write_csv(outliers_agua, "output/tablas/outliers_agua.csv")

figura_3 <- graficar_cumplimiento(
  indicadores_agua,
  "Proyecto Agua y Saneamiento Nicaragua"
)

print(figura_3)

ggsave("output/figuras/figura_3_agua_indicadores.png",
       figura_3, width = 10, height = 6, dpi = 300, bg = "white")

# =========================================================
# CASO 3 – CHOROTEGA COSTA RICA
# =========================================================

cat("\n================ CASO 3 – CHOROTEGA =================\n")

stopifnot(llaves_casos["CHOROTEGA"] %in% impacto_calidad$llave_op)

indicadores_chorotega <- extraer_indicadores_validos(impacto_calidad, llaves_casos["CHOROTEGA"])

resumen_chorotega <- resumen_indicadores(indicadores_chorotega)
print(resumen_chorotega)
write_csv(resumen_chorotega, "output/tablas/resumen_chorotega.csv")

outliers_chorotega <- detectar_outliers(indicadores_chorotega)
print(outliers_chorotega)
write_csv(outliers_chorotega, "output/tablas/outliers_chorotega.csv")

indicadores_chorotega_ajustado <- indicadores_chorotega %>%
  filter(meta > 1, cumplimiento < 10)

resumen_chorotega_ajustado <- resumen_indicadores(indicadores_chorotega_ajustado)
print(resumen_chorotega_ajustado)
write_csv(resumen_chorotega_ajustado,
          "output/tablas/resumen_chorotega_ajustado.csv")

figura_4 <- graficar_cumplimiento(
  indicadores_chorotega,
  "Mercado Regional Mayorista Región Chorotega"
)

print(figura_4)

ggsave("output/figuras/figura_4_chorotega_indicadores.png",
       figura_4, width = 10, height = 6, dpi = 300, bg = "white")

# =========================================================
# CASO 4 – EL CHAPARRAL EL SALVADOR
# =========================================================

cat("\n================ CASO 4 – CHAPARRAL =================\n")

stopifnot(llaves_casos["CHAPARRAL"] %in% impacto_calidad$llave_op)

indicadores_chaparral <- extraer_indicadores_validos(impacto_calidad, llaves_casos["CHAPARRAL"])

resumen_chaparral <- resumen_indicadores(indicadores_chaparral)
print(resumen_chaparral)
write_csv(resumen_chaparral, "output/tablas/resumen_chaparral.csv")

outliers_chaparral <- detectar_outliers(indicadores_chaparral)
print(outliers_chaparral)
write_csv(outliers_chaparral, "output/tablas/outliers_chaparral.csv")

figura_5 <- graficar_cumplimiento(
  indicadores_chaparral,
  "Central Hidroeléctrica El Chaparral"
)

print(figura_5)

ggsave("output/figuras/figura_5_chaparral_indicadores.png",
       figura_5, width = 10, height = 6, dpi = 300, bg = "white")

# =========================================================
# CASO 5 – CARRETERAS NICARAGUA
# =========================================================

cat("\n================ CASO 5 – CARRETERAS =================\n")

stopifnot(llaves_casos["CARRETERAS"] %in% impacto_calidad$llave_op)

indicadores_carreteras <- extraer_indicadores_validos(impacto_calidad, llaves_casos["CARRETERAS"])

resumen_carreteras <- resumen_indicadores(indicadores_carreteras)
print(resumen_carreteras)
write_csv(resumen_carreteras, "output/tablas/resumen_carreteras.csv")

outliers_carreteras <- detectar_outliers(indicadores_carreteras)
print(outliers_carreteras)
write_csv(outliers_carreteras, "output/tablas/outliers_carreteras.csv")

figura_6 <- graficar_cumplimiento(
  indicadores_carreteras,
  "IV Proyecto Carreteras Nicaragua"
)

print(figura_6)

ggsave("output/figuras/figura_6_carreteras_indicadores.png",
       figura_6, width = 10, height = 6, dpi = 300, bg = "white")

# =========================================================
# CASO 6 – VACUNAS HONDURAS
# =========================================================

cat("\n================ CASO 6 – VACUNAS =================\n")

stopifnot(llaves_casos["VACUNAS"] %in% impacto_calidad$llave_op)

indicadores_vacunas <- extraer_indicadores_validos(impacto_calidad, llaves_casos["VACUNAS"])

resumen_vacunas <- resumen_indicadores(indicadores_vacunas)
print(resumen_vacunas)
write_csv(resumen_vacunas, "output/tablas/resumen_vacunas.csv")

outliers_vacunas <- detectar_outliers(indicadores_vacunas)
print(outliers_vacunas)
write_csv(outliers_vacunas, "output/tablas/outliers_vacunas.csv")

figura_7 <- graficar_cumplimiento(
  indicadores_vacunas,
  "Plan Nacional Vacuna COVID-19 Honduras"
)

print(figura_7)

ggsave("output/figuras/figura_7_vacunas_indicadores.png",
       figura_7, width = 10, height = 6, dpi = 300, bg = "white")