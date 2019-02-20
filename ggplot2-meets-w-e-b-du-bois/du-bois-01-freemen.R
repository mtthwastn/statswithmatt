#################################
### ggplot2 meets W. E. B. Du Bois
###
### graph 1: =========================================
### proportion of freemen and slaves
### original: https://hdl.loc.gov/loc.pnp/ppmsca.33913
###
### digitized original collection available at:
### https://www.loc.gov/pictures/collection/anedub/dubois.html
#################################

library(dplyr)
library(ggplot2)

### intial setup: ====================================

# going to use the Inconsolata font, available for download here:
# https://fonts.google.com/specimen/Inconsolata
font_name <- "Inconsolata"

# set up theme skeleton with apporpriate font, correct background color,
# centered and bold main title, centered subtitle
theme_du_bois <- function() {
  theme_gray(base_family = font_name) %+replace%
    theme(
      plot.background = element_rect(
        fill = "antiquewhite2",
        color = "antiquewhite2"
      ),
      panel.background = element_rect(
        fill = "antiquewhite2",
        color = "antiquewhite2"
      ),
      plot.title = element_text(
        hjust = 0.5,
        face = "bold"
      ),
      plot.subtitle = element_text(hjust = 0.5)
    )
}

# creating data from original graph -------
freemen <- data.frame(
  year = seq(1790, 1870, by = 10),
  pct_free = c(0.08, 0.11, 0.135, 0.13, 0.14, 0.13, 0.12, 0.11, 1)
) %>%
  dplyr::mutate(
    pct_slave = 1 - pct_free,
    # replace the last value (0%) with the previous one so that it's aligned
    # in the same place as the actual image
    labels = replace(pct_slave, n(), pct_slave[n() - 1])
  )

# plot -------
ppmsca_33913 <- ggplot(
  data = freemen,
  mapping = aes(
    x = year,
    y = pct_slave
  )
) +
  geom_area(aes(y = 1),
    fill = "seagreen"
  ) +
  geom_area(fill = "gray15") +
  labs(
    title = "PROPORTION OF FREEMEN AND SLAVES AMONG AMERICAN NEGROES.\nPROPORTION DES NÈGRES LIBRES ET DES ESCLAVES EN AMÉRIQUE.",
    subtitle = "DONE BY ATLANTA UNIVERSITY."
  ) +
  scale_x_continuous(
    breaks = seq(1790, 1870, by = 10),
    position = "top"
  ) +
  coord_cartesian(
    expand = FALSE,
    clip = "off",
    xlim = c(1788, 1872)
  ) +
  theme_du_bois()

# annotations for plot
ppmsca_33913 + geom_text(aes(
  y = labels,
  label = paste0(100 * pct_free, "%"),
  family = font_name,
  fontface = "bold"
),
nudge_y = 0.02
) +
  annotate("text",
    label = c("SLAVES\nESCLAVES", "FREE - LIBRE"),
    color = c("antiquewhite", "black"),
    size = c(9, 6),
    x = 1830,
    y = c(0.5, 0.97),
    family = font_name,
    fontface = "bold"
  ) +
  ### theme adjustments
  theme(
    text = element_text(face = "bold"),
    panel.background = element_blank(),
    plot.subtitle = element_text(size = 7),
    panel.grid.major.x = element_line(color = "gray25"),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    axis.text.y = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank()
  )
