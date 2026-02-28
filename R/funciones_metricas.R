# =========================================================
# funciones_metricas.R
# Funciones para extracción, resumen y visualización
# =========================================================

library(tidyverse)

# ---------------------------------------------------------
# EXTRAER INDICADORES VÁLIDOS POR PROYECTO
# ---------------------------------------------------------

extraer_indicadores_validos <- function(data, llave){
  
  base <- data %>% filter(llave_op == llave)
  
  # Validar que la llave exista
  if(nrow(base) == 0){
    stop("La llave no existe en la base de datos")
  }
  
  nombres <- base %>%
    select(llave_op, starts_with("nombre_indicador_producto_")) %>%
    pivot_longer(-llave_op,
                 names_to = "indicador",
                 values_to = "nombre_indicador_producto")
  
  metas <- base %>%
    select(llave_op, starts_with("evaluacion_ex_ante_")) %>%
    pivot_longer(-llave_op,
                 names_to = "indicador",
                 values_to = "meta")
  
  observados <- base %>%
    select(llave_op, starts_with("ultimo_valor_observado_")) %>%
    pivot_longer(-llave_op,
                 names_to = "indicador",
                 values_to = "observado")
  
  nombres$indicador    <- str_extract(nombres$indicador, "\\d+")
  metas$indicador      <- str_extract(metas$indicador, "\\d+")
  observados$indicador <- str_extract(observados$indicador, "\\d+")
  
  indicadores <- nombres %>%
    left_join(metas, by = c("llave_op", "indicador")) %>%
    left_join(observados, by = c("llave_op", "indicador"))
  
  indicadores %>%
    filter(meta > 0, observado > 0) %>%
    mutate(cumplimiento = observado / meta)
}

# ---------------------------------------------------------
# RESUMEN DE CUMPLIMIENTO
# ---------------------------------------------------------

resumen_cumplimiento <- function(indicadores){
  
  indicadores %>%
    summarise(
      n_indicadores = n(),
      cumplimiento_promedio = mean(cumplimiento, na.rm = TRUE),
      cumplimiento_mediana  = median(cumplimiento, na.rm = TRUE),
      prop_meta_cumplida    = mean(cumplimiento >= 1, na.rm = TRUE)
    )
}

# ---------------------------------------------------------
# FUNCIÓN DE GRÁFICO
# Requiere: colores y theme definidos en R/temas_graficos.R
# ---------------------------------------------------------

graficar_cumplimiento <- function(indicadores_df, titulo){
  
  indicadores_df %>%
    mutate(
      nombre_limpio = str_to_sentence(nombre_indicador_producto),
      nombre_limpio = str_wrap(nombre_limpio, 40),
      cumplimiento_acotado = pmin(cumplimiento, 2),
      supera_meta = cumplimiento >= 1
    ) %>%
    
    ggplot(aes(
      x = reorder(nombre_limpio, cumplimiento),
      y = cumplimiento_acotado,
      fill = supera_meta
    )) +
    
    geom_col(width = 0.7) +
    
    geom_hline(
      yintercept = 1,
      linetype = "dashed",
      color = color_meta,
      linewidth = 0.8
    ) +
    
    coord_flip() +
    
    scale_y_continuous(
      labels = scales::percent_format(accuracy = 1),
      limits = c(0, 2)
    ) +
    
    scale_fill_manual(
      values = c("TRUE" = color_principal,
                 "FALSE" = color_secundario),
      labels = c("No alcanza meta", "Alcanza o supera meta")
    ) +
    
    labs(
      title = titulo,
      x = "",
      y = "Cumplimiento respecto a meta ex ante",
      fill = "",
      caption = "Nota: Valores superiores a 200% fueron acotados para facilitar la comparación visual."
    ) +
    
    theme_bcie()
}
