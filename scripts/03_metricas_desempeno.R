# =========================================================
# 03_metricas_desempeno.R
# Cálculo de cumplimiento de indicadores
# =========================================================

library(tidyverse)
library(scales)
library(stringr)

# ---------------------------------------------------------
# 0. Carpetas
# ---------------------------------------------------------

dir.create("output/tablas", recursive = TRUE, showWarnings = FALSE)
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------
# 1. Verificar insumo
# ---------------------------------------------------------

if (!file.exists("data/processed/casos_finales.rds")) {
  stop("Falta el archivo: data/processed/casos_finales.rds")
}

# ---------------------------------------------------------
# 2. Cargar datos
# ---------------------------------------------------------

casos_finales <- readRDS("data/processed/casos_finales.rds")

cat("\nCasos cargados:", nrow(casos_finales), "\n")

# ---------------------------------------------------------
# 3. Pasar a formato largo
# ---------------------------------------------------------

metas <- casos_finales %>%
  select(llave_op, starts_with("evaluacion_ex_ante_")) %>%
  pivot_longer(
    -llave_op,
    names_to = "indicador",
    values_to = "meta"
  )

observados <- casos_finales %>%
  select(llave_op, starts_with("ultimo_valor_observado_")) %>%
  pivot_longer(
    -llave_op,
    names_to = "indicador",
    values_to = "observado"
  )

metas$indicador <- str_extract(metas$indicador, "\\d+")
observados$indicador <- str_extract(observados$indicador, "\\d+")

indicadores <- left_join(
  metas,
  observados,
  by = c("llave_op", "indicador")
)

# ---------------------------------------------------------
# 4. Filtrar indicadores válidos
# ---------------------------------------------------------

indicadores_validos <- indicadores %>%
  filter(meta > 0, observado > 0)

cat("Indicadores válidos:", nrow(indicadores_validos), "\n")

# ---------------------------------------------------------
# 5. Calcular cumplimiento
# ---------------------------------------------------------

indicadores_validos <- indicadores_validos %>%
  mutate(
    cumplimiento = observado / meta,
    cumplimiento_truncado = pmin(cumplimiento, 2)
  )

# ---------------------------------------------------------
# 6. Métricas por proyecto
# ---------------------------------------------------------

metricas_proyecto <- indicadores_validos %>%
  group_by(llave_op) %>%
  summarise(
    n_indicadores = n(),
    cumplimiento_promedio = mean(cumplimiento, na.rm = TRUE),
    cumplimiento_mediana = median(cumplimiento, na.rm = TRUE),
    prop_meta_cumplida = mean(cumplimiento >= 1, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  arrange(desc(cumplimiento_mediana))

# ---------------------------------------------------------
# 7. Unir características del proyecto
# ---------------------------------------------------------

metricas_proyecto <- casos_finales %>%
  left_join(metricas_proyecto, by = "llave_op")

cat("Métricas calculadas para", nrow(metricas_proyecto), "proyectos\n")

# ---------------------------------------------------------
# 8. Guardar outputs
# ---------------------------------------------------------

saveRDS(
  indicadores_validos,
  "data/processed/indicadores_validos.rds"
)

saveRDS(
  metricas_proyecto,
  "data/processed/metricas_proyecto.rds"
)

write_csv(
  metricas_proyecto,
  "output/tablas/metricas_proyecto.csv"
)
