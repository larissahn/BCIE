# =========================================================
# 01_preparacion_datos.R
# Caracterización del universo y construcción del pool analítico
# =========================================================

library(tidyverse)
library(janitor)
library(lubridate)
library(scales)

# ---------------------------------------------------------
# 0. Carpetas
# ---------------------------------------------------------

dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
dir.create("output/tablas", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------
# 1. Importar y limpiar
# ---------------------------------------------------------

impacto_raw <- read_csv(
  "data/raw/operaciones_indicadores_producto_efecto.csv",
  show_col_types = FALSE
)

impacto_clean <- impacto_raw %>%
  clean_names()

cat("\nUniverso inicial:", nrow(impacto_clean), "proyectos\n")

# ---------------------------------------------------------
# 2. Caracterización del universo
# ---------------------------------------------------------

resumen_universo <- impacto_clean %>%
  summarise(
    proyectos = n(),
    monto_total = sum(monto_aprobado, na.rm = TRUE),
    periodo_min = min(periodo_aprobacion, na.rm = TRUE),
    periodo_max = max(periodo_aprobacion, na.rm = TRUE)
  )

print(resumen_universo)

cat(
  "\nMonto total aprobado (USD):",
  scales::comma(resumen_universo$monto_total),
  "\n"
)

distribucion_pais <- impacto_clean %>%
  count(pais, sort = TRUE) %>%
  mutate(porcentaje = round(n / sum(n) * 100, 1))

print(distribucion_pais)

distribucion_sector <- impacto_clean %>%
  count(sector_ibcie, sort = TRUE) %>%
  mutate(porcentaje = round(n / sum(n) * 100, 1))

print(distribucion_sector)

write_csv(distribucion_pais, "output/tablas/distribucion_pais.csv")
write_csv(distribucion_sector, "output/tablas/distribucion_sector.csv")

# ---------------------------------------------------------
# 3. Filtros secuenciales
# ---------------------------------------------------------

f1 <- impacto_clean %>%
  filter(monto_desembolsado > 0)

cat("\nTras eliminar monto desembolsado = 0:", nrow(f1), "\n")

f2 <- f1 %>%
  filter(!is.na(fecha_primer_desembolso),
         !is.na(fecha_ultimo_desembolso))

cat("Tras eliminar sin fechas válidas:", nrow(f2), "\n")

f3 <- f2 %>%
  filter(!stringr::str_detect(etapa_estado, "Desobligación Total"))

cat("Tras eliminar desobligaciones:", nrow(f3), "\n")

f4 <- f3 %>%
  filter(sector_ibcie != "Financiero")

cat("Tras eliminar sector financiero:", nrow(f4), "\n")

impacto_analisis <- f4 %>%
  filter(!stringr::str_detect(tipo_operacion, "Línea Global de Crédito"))

cat("Universo analítico final:", nrow(impacto_analisis), "\n")

cat(
  "\nFlujo de depuración:",
  "\n", nrow(impacto_clean), "→", nrow(f1),
  "→", nrow(f2),
  "→", nrow(f3),
  "→", nrow(f4),
  "→", nrow(impacto_analisis), "\n"
)

# ---------------------------------------------------------
# 4. Reclasificación sectorial
# ---------------------------------------------------------

impacto_analisis <- impacto_analisis %>%
  mutate(
    sector_ibcie = ifelse(
      stringr::str_detect(sector_ibcie, "Infraestructura Fondo de Emergencia"),
      "Infraestructura",
      sector_ibcie
    )
  )

# ---------------------------------------------------------
# 5. Variables derivadas
# ---------------------------------------------------------

impacto_analisis <- impacto_analisis %>%
  mutate(
    duracion_dias = as.numeric(
      fecha_ultimo_desembolso - fecha_primer_desembolso
    ),
    duracion_anios = duracion_dias / 365,
    
    tamano_proyecto = case_when(
      monto_desembolsado < 5e6  ~ "<5M",
      monto_desembolsado < 15e6 ~ "5-15M",
      monto_desembolsado < 50e6 ~ "15-50M",
      TRUE ~ ">50M"
    )
  )

# ---------------------------------------------------------
# 6. Indicadores válidos por proyecto
# ---------------------------------------------------------

impacto_calidad <- impacto_analisis %>%
  rowwise() %>%
  mutate(
    n_indicadores_validos = sum(
      c_across(matches("^evaluacion_ex_ante_\\d+")) > 0 &
        c_across(matches("^ultimo_valor_observado_\\d+")) > 0,
      na.rm = TRUE
    )
  ) %>%
  ungroup()

# ---------------------------------------------------------
# 7. Resumen de calidad
# ---------------------------------------------------------

resumen_calidad <- impacto_calidad %>%
  summarise(
    proyectos = n(),
    con_1_ind = sum(n_indicadores_validos >= 1),
    con_3_ind = sum(n_indicadores_validos >= 3),
    max_ind = max(n_indicadores_validos, na.rm = TRUE)
  )

cat("\nResumen de calidad:\n")
print(resumen_calidad)

write_csv(resumen_calidad, "output/tablas/resumen_calidad.csv")

# ---------------------------------------------------------
# 8. Pool analítico
# ---------------------------------------------------------

pool_candidatos <- impacto_calidad %>%
  filter(n_indicadores_validos >= 3) %>%
  arrange(desc(n_indicadores_validos),
          desc(monto_desembolsado))

cat("\nPool analítico final:", nrow(pool_candidatos), "proyectos\n")

# ---------------------------------------------------------
# 8.1 Distribución sectorial del pool
# ---------------------------------------------------------

pool_sector <- pool_candidatos %>%
  count(sector_ibcie, sort = TRUE) %>%
  mutate(porcentaje = round(n / sum(n) * 100, 1))

print(pool_sector)
write_csv(pool_sector, "output/tablas/pool_sector.csv")

# ---------------------------------------------------------
# 8.2 Distribución geográfica del pool
# ---------------------------------------------------------

pool_pais <- pool_candidatos %>%
  count(pais, sort = TRUE) %>%
  mutate(porcentaje = round(n / sum(n) * 100, 1))

print(pool_pais)
write_csv(pool_pais, "output/tablas/pool_pais.csv")

# ---------------------------------------------------------
# 9. Guardar outputs
# ---------------------------------------------------------

saveRDS(impacto_calidad, "data/processed/impacto_calidad.rds")
saveRDS(pool_candidatos, "data/processed/pool_candidatos.rds")

cat("\nArchivos guardados en data/processed y output/tablas\n")
