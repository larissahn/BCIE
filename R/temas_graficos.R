# =========================================================
# temas_graficos.R
# Colores y tema gráfico del proyecto BCIE
# Debe cargarse antes de cualquier función de visualización
# =========================================================

library(ggplot2)

# ---------------------------------------------------------
# 1. PALETA DE COLORES
# ---------------------------------------------------------

color_principal  <- "#0056A3"   # Azul BCIE
color_secundario <- "#BDBDBD"   # Gris neutro
color_meta       <- "#D32F2F"   # Línea de meta (rojo)

color_texto      <- "#2E2E2E"
color_grid       <- "#E6E6E6"

# ---------------------------------------------------------
# 2. TEMA GENERAL
# ---------------------------------------------------------

theme_bcie <- function(base_size = 12, base_family = "sans"){
  
  theme_minimal(base_size = base_size, base_family = base_family) +
    
    theme(
      
      # TÍTULOS
      plot.title = element_text(
        face = "bold",
        size = rel(1.2),
        color = color_texto,
        hjust = 0
      ),
      
      plot.subtitle = element_text(
        size = rel(1),
        color = color_texto,
        hjust = 0
      ),
      
      # EJES
      axis.title = element_text(
        face = "bold",
        color = color_texto
      ),
      
      axis.text = element_text(
        color = color_texto
      ),
      
      # GRILLA
      panel.grid.major.y = element_line(color = color_grid),
      panel.grid.major.x = element_line(color = color_grid, linewidth = 0.2),
      panel.grid.minor = element_blank(),
      
      # LEYENDA
      legend.position = "bottom",
      legend.text = element_text(size = rel(0.9)),
      legend.title = element_text(size = rel(0.9), face = "bold"),
      
      # CAPTION
      plot.caption = element_text(
        size = rel(0.8),
        color = "gray40",
        hjust = 0
      ),
      
      # MÁRGENES
      plot.margin = margin(15, 15, 15, 15)
    )
}
