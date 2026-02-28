# =========================================================
# 06_figura_1_matriz_casos.R
# Figura 1 – Comparación de los seis estudios de caso
# =========================================================

library(tidyverse)
library(scales)

source("R/temas_graficos.R")

dir.create("output/figuras", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------
# Validar insumo
# ---------------------------------------------------------

if(!file.exists("data/processed/casos_finales.rds")){
  stop("No existe casos_finales.rds. Ejecuta primero el Script 02.")
}

# ---------------------------------------------------------
# Cargar datos
# ---------------------------------------------------------

casos_finales <- readRDS("data/processed/casos_finales.rds")

# ---------------------------------------------------------
# Preparar datos
# ---------------------------------------------------------

figura_1_df <- casos_finales %>%
  mutate(
    monto_millones = monto_desembolsado / 1e6
  )

# ---------------------------------------------------------
# Figura
# ---------------------------------------------------------

figura_1 <- ggplot(figura_1_df,
                   aes(x = duracion_anios,
                       y = n_indicadores_validos,
                       size = monto_millones,
                       color = sector_ibcie)) +
  
  geom_point(alpha = 0.85) +
  
  scale_size_continuous(
    name = "Monto desembolsado\n(USD millones)",
    labels = label_number(accuracy = 1)
  ) +
  
  labs(
    title = "Comparación de los seis estudios de caso seleccionados",
    x = "Duración del proyecto (años)",
    y = "Número de indicadores válidos",
    color = "Sector",
    caption = paste(
      "Cada punto representa un proyecto.",
      "El eje vertical muestra el número de indicadores válidos.",
      "\nFuente: Elaboración propia con base en datos abiertos del BCIE (2026)."
    )
  ) +
  
  theme_bcie()

figura_1

# ---------------------------------------------------------
# Guardar figura
# ---------------------------------------------------------

ggsave(
  "output/figuras/figura_1_matriz_casos.png",
  figura_1,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white"
)
