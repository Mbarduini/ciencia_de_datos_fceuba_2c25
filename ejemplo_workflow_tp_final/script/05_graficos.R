# ============================================================================
# Script: Visualización de la industrialización asiática
# Output: 4 graficos 
# ============================================================================

# ACLARACION: LOS GRAFICOS NO TIENEN STORYTELLING PORQUE SON PARTE DE UN INFORME 

# Cargar librerías necesarias
library(tidyverse)
library(scales)
library(readr)

# Configuración general
theme_set(theme_minimal(base_size = 12))

# Rutas 
# setwd(r'(D:\Docencia\UBA\Ciencia de datos\ciencia_de_datos_fceuba_2c25\ejemplo_workflow_tp_final)')
# Vuelvo a cargar el working directory, por las dudas de que haya cerrado la sesion
instub <- 'data/input'
outstub <- 'data/output'

# GRÁFICO 1: Crecimiento de Asia en el PBI industrial----
datos_pib_industrial <- read_csv(file.path(instub,"01_peso_asia_pib_manufacturero.csv"))

grafico1 <- ggplot(datos_pib_industrial, aes(x = anio, y = prop_industry_gdp)) +
  #geom_line(color = "#E63946", linewidth = 1.2) +
  geom_area(alpha = 0.8, aes(fill=agregados)) +
  scale_y_continuous(labels = scales::percent_format(),
                     limits = c(0, NA),
                     expand = expansion(mult = c(0, 0.05))) +
  scale_x_continuous(breaks = seq(1970, 2023, by = 10)) +
  labs(
    title = "Crecimiento de Asia en el PBI industrial global",
    subtitle = "Participación de Asia en el valor agregado manufacturero mundial, 1970-2023",
    x = NULL,
    y = "Participación (%)",
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    panel.grid.minor = element_blank(),
    plot.caption = element_text(hjust = 0, size = 9, color = "gray50"),
    legend.position='bottom',
    legend.title=element_blank()
  )

ggsave(file.path(outstub,"grafico_01_peso_asia_pbi_industrial.png"), 
       plot = grafico1, width = 10, height = 6, dpi = 300)


# ============================================================================
# GRÁFICO 2: Exportaciones industriales por contenido tecnológico
# ============================================================================

datos_expo_industrial <- read_csv(file.path(instub,"02_peso_asia_expo_industrial.csv"))

grafico_2 <- ggplot(datos_expo_industrial, 
                    aes(x = anio, y = prop_exportaciones, color = lall_desc_full)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_x_continuous(breaks = seq(1962, 2023, by = 10)) +
  scale_color_manual(
    values = c("Manufacturas de alta tecnología" = "#E63946", 
               "Manufacturas de media tecnología" = "#F77F00",
               "Manufacturas de baja tecnología" = "#06D6A0",
               "Manufacturas basadas en recursos naturales" = "#457B9D",
               "Total manufacturas" = '#01C761')
    ) +
  labs(
    title = "Crecimiento de Asia en las exportaciones industriales",
    subtitle = "Participación por contenido tecnológico (Clasificación de Lall), 1962-2023",
    x = NULL,
    y = "Participación en exportaciones mundiales (%)"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    legend.position = "bottom",
    panel.grid.minor = element_blank(),
    legend.title = element_blank()
  )

ggsave(file.path(outstub,"grafico_02_expo_asia_por_tecnologia.png"), 
       plot = grafico_2, width = 11, height = 6.5, dpi = 300)


# ============================================================================
# GRÁFICO 3: PIB industrial per cápita - Convergencia vs EE.UU.
# ============================================================================

datos_pib_percapita <- read_csv(file.path(instub,"03_pib_per_capita_asia.csv"))

grafico_3 <- ggplot(datos_pib_percapita, aes(x = anio, y = gdp_indust_pc_vs_usa, color = geonombreFundar)) +
  geom_line(linewidth = 1) +
  geom_hline(yintercept = 1, linetype = "dashed", color = "gray40") +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_x_continuous(breaks = seq(1970, 2023, by = 10)) +
  annotate("text", x = 2020, y = 1.02, label = "EE.UU. = 100%", 
           size = 3.5, color = "gray40") +
  labs(
    title = "PIB industrial per cápita: convergencia hacia Estados Unidos",
    subtitle = "PIB manufacturero per cápita como % del estadounidense, 1970-2023",
    x = NULL,
    y = "PIB industrial per cápita (EE.UU. = 100%)"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    legend.position = "bottom",
    panel.grid.minor = element_blank()
  )


ggsave(file.path(outstub,"grafico_03_pib_percapita_convergencia.png"), 
       plot = grafico_3, width = 11, height = 6.5, dpi = 300)


# ============================================================================
# GRÁFICO 4: Participación de manufacturas en el VAB total
# ============================================================================

datos_vab <- read_csv(file.path(instub,"04_vab_proporcion.csv"))

grafico_4 <- ggplot(datos_vab %>% 
                      filter(subregion_es %in% c('América Latina y el Caribe',
                                                 'Europa del Sur',
                                                 'Europa Occidental',
                                                 'Europa del Este',
                                                 'Sudeste Asiático',
                                                 'América del Norte',
                                                 'Este de Asia')), 
                    aes(x = anio, y = valor, color = subregion_es)) +
  geom_line(linewidth = 1) +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_x_continuous(breaks = seq(1970, 2023, by = 10)) +
  labs(
    title = "Divergencia estructural: participación de manufacturas en el VAB total",
    subtitle = "Porcentaje del valor agregado manufacturero en el VAB total, 1970-2023",
    x = NULL,
    y = "Participación de manufacturas en VAB (%)",
    caption = "Fuente: Naciones Unidas"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(size = 11, color = "gray40"),
    legend.position = "bottom",
    legend.title = element_blank(),
    panel.grid.minor = element_blank()
  )

ggsave(file.path(outstub,"grafico_04_vab_manufactura_proporcion.png"), 
       plot = grafico_4, width = 11, height = 6.5, dpi = 300)

