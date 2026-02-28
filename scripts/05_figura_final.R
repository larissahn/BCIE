# =========================================================
# 05_figura_final_lollipop.R
# Figura 8 – Mediana de cumplimiento por proyecto
# =========================================================

library(tidyverse)
library(scales)

source("R/temas_graficos.R")

dir.create("output/figuras", recursive = TRUE, showWarnings = FALSE)

# ---------------------------------------------------------
# 1. Tabla final del paper
# ---------------------------------------------------------

figura_8_df <- tribble(
  ~proyecto, ~mediana, ~mediana_label, ~porc_meta, ~monitoreo,
  "Carreteras Nicaragua", 6.31,  "631%",        "100%", "Bajo",
  "El Chaparral",         3.66,  "366%",        "75%",  "Bajo",
  "Agua Nicaragua",       1.30,  "130%",        "67%",  "Medio",
  "Vacunas Honduras",     1.14,  "114%",        "67%",  "Medio",
  "ICE Costa Rica",       0.75,  "75% (100%)",  "43%",  "Alto",
  "Mercado Chorotega",    0.735, "73.5% (169%)","25%",  "Alto"
)

# Orden narrativo: menor → mayor
figura_8_df <- figura_8_df %>%
  arrange(mediana) %>%
  mutate(proyecto = factor(proyecto, levels = proyecto))

# ---------------------------------------------------------
# 2. Colores monitoreo
# ---------------------------------------------------------

colores_monitoreo <- c(
  "Bajo"  = "#E31A1C",
  "Medio" = "#FDBF00",
  "Alto"  = "#33A02C"
)

# ---------------------------------------------------------
# 3. Lollipop plot
# ---------------------------------------------------------

figura_8 <- ggplot(figura_8_df,
                   aes(x = mediana,
                       y = proyecto,
                       color = monitoreo)) +
  
  geom_segment(aes(x = 0, xend = mediana,
                   y = proyecto, yend = proyecto),
               linewidth = 1) +
  
  geom_point(size = 5) +
  
  geom_text(aes(label = porc_meta),
            hjust = -0.3,
            size = 4.2,
            fontface = "bold") +
  
  scale_color_manual(values = colores_monitoreo) +
  
  scale_x_continuous(
    labels = percent_format(accuracy = 1),
    limits = c(0, 7)
  ) +
  
  labs(
    title = "Mediana de cumplimiento por proyecto",
    x = "Mediana de cumplimiento",
    y = NULL,
    color = "Nivel de monitoreo"
  ) +
  
  theme_bcie()

figura_8

# ---------------------------------------------------------
# 4. Guardar figura
# ---------------------------------------------------------

ggsave(
  "output/figuras/figura_8_mediana_cumplimiento.png",
  figura_8,
  width = 10,
  height = 6,
  dpi = 300,
  bg = "white",
  device = "png"
)
