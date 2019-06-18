#################################
### ggplot2 meets W. E. B. Du Bois
###
### graph 3: =========================================
### city and rural population
### original: https://hdl.loc.gov/loc.pnp/ppmsca.33914
###
### digitized original collection available at:
### https://www.loc.gov/pictures/collection/anedub/dubois.html
#################################

library(ggplot2)

### initial setup: ====================================

# going to use the Inconsolata font, available for download here:
# https://fontlibrary.org/en/font/inconsolata
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
popn <- data.frame(
  year = rep(seq(1860, 1890, by = 10), times = 2),
  group = factor(
    rep(c("city", "rural"), each = 4),
    levels = c("city", "rural")
  ),
  pct = c(4.2, 8.5, 8.4, 12, 95.8, 91.5, 91.6, 88)
)

# plot -------
ppmsca_33914 <- ggplot(
  data = popn,
  mapping = aes(
    x = year,
    y = pct,
    fill = rev(group)
  )
) +
  geom_bar(stat = "identity") +
  geom_text(
    aes(
      label = paste0(pct, "%"),
      family = font_name,
      fontface = "bold"
    ),
    position = position_stack(vjust = 0.5),
    color = rep(c("black", "antiquewhite"), times = 4
    ),
    # need the 4.2% smaller to fit within the area
    size = c(5.5, 5.5, 5.5, 5.5, 5.5, 5.5, 3, 5.5)
  ) +
  coord_flip() +
  # to get the French title correctly, i can left-justify the entire title and
  # just pad the English title for indentation
  labs(
    title = "      CITY AND RURAL POPULATION AMONG AMERICAN NEGROES IN THE FORMER SLAVE STATES.\nPOPULATION DES NÈGRES HABITANT LES VILLES ET DE CEUX HABITANT LES COMPAGNES DANS LES ANCIENS\nETATS ESCLAVES.",
    subtitle = "DONE BY ATLANTA UNIVERSITY.",
    x = NULL,
    y = NULL
  ) +
  scale_fill_manual(
    values = c("black", "firebrick3"),
    name = NULL,
    labels = c(
      "PROPORTION LIVING IN VILLAGES AND COUNTRY DISTRICTS\nPROPORTION DANS LES VILLES ET LES COMPAGNES",
      "PROPORTION LIVING IN CITIES OF 8,000 INHABITANTS OR MORE.\nPROPORTION DANS LES VILLES DE 8,000 HABITANTS OU PLUS."
    ),
    # reverse legend so that city is on top and stays red
    guide = guide_legend(reverse = TRUE)
  ) +
  scale_x_reverse() +
  theme_du_bois()

# theme adjustments
ppmsca_33914 + theme(
  plot.title = element_text(
    size = 10,
    hjust = 0
  ),
  # ^make title left-justified
  plot.subtitle = element_text(
    size = 7,
    face = "bold"
  ),
  axis.ticks = element_blank(),
  axis.text.x = element_blank(),
  axis.text.y = element_text(
    face = "bold",
    size = 15
  ),
  panel.grid.major.x = element_blank(),
  panel.grid.minor = element_blank(),
  panel.grid.major.y = element_blank(),
  legend.text = element_text(size = 7),
  legend.position = "top",
  # make legend keys vertical and left-justified
  legend.direction = "vertical",
  legend.justification = "left",
  # remove white backgrounds from legend and keys
  legend.background = element_blank(),
  legend.key = element_blank()
)
