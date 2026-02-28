# =========================================================
# 02_seleccion_estudios_caso.R
# Construcción del universo elegible y selección final
# =========================================================

library(tidyverse)

# ---------------------------------------------------------
# 0. Carpetas
# ---------------------------------------------------------

dir.create("output/tablas", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------
# 1. Validar insumo del Script 01
# ---------------------------------------------------------

if (!file.exists("data/processed/pool_candidatos.rds")) {
  stop("No existe data/processed/pool_candidatos.rds. Ejecuta primero el Script 01.")
}

pool_candidatos <- readRDS("data/processed/pool_candidatos.rds")

cat("\nPool analítico cargado:", nrow(pool_candidatos), "proyectos\n")

# ---------------------------------------------------------
# 2. Construir universo elegible
# ---------------------------------------------------------
# Criterio: ≥ 4 indicadores válidos

casos_resumen <- pool_candidatos %>%
  mutate(
    nivel_monitoreo = case_when(
      n_indicadores_validos >= 7 ~ "Alto",
      n_indicadores_validos >= 5 ~ "Medio",
      TRUE ~ "Bajo"
    ),
    
    duracion_tipo = case_when(
      duracion_anios < 2 ~ "Corta",
      duracion_anios < 5 ~ "Media",
      TRUE ~ "Larga"
    ),
    
    nivel_monitoreo = factor(nivel_monitoreo,
                             levels = c("Bajo", "Medio", "Alto")),
    
    duracion_tipo = factor(duracion_tipo,
                           levels = c("Corta", "Media", "Larga"))
  )

candidatos_elegibles <- casos_resumen %>%
  filter(n_indicadores_validos >= 4)

cat("Proyectos elegibles para revisión experta:", nrow(candidatos_elegibles), "\n")

# ---------------------------------------------------------
# 3. Exportar para revisión experta
# ---------------------------------------------------------

write_csv(
  candidatos_elegibles,
  "output/tablas/candidatos_estudios_caso.csv"
)

cat("Archivo exportado: candidatos_estudios_caso.csv\n")

# ---------------------------------------------------------
# 4. Importar selección final
# ---------------------------------------------------------

if (!file.exists("data/processed/casos_seleccionados.csv")) {
  stop("Falta el archivo: data/processed/casos_seleccionados.csv")
}

llaves_seleccionadas <- read_csv(
  "data/processed/casos_seleccionados.csv",
  show_col_types = FALSE
)

cat("Llaves cargadas:", nrow(llaves_seleccionadas), "\n")

casos_finales <- casos_resumen %>%
  filter(llave_op %in% llaves_seleccionadas$llave_op)

if (nrow(casos_finales) != nrow(llaves_seleccionadas)) {
  warning("Algunas llaves no coinciden con el pool analítico")
}

casos_finales <- casos_finales %>%
  arrange(desc(n_indicadores_validos),
          desc(monto_desembolsado))

cat("Casos seleccionados:", nrow(casos_finales), "\n")

# ---------------------------------------------------------
# 5. Guardar outputs
# ---------------------------------------------------------

saveRDS(casos_finales, "data/processed/casos_finales.rds")

write_csv(
  casos_finales,
  "output/tablas/casos_finales.csv"
)

cat("Outputs guardados correctamente.\n")
