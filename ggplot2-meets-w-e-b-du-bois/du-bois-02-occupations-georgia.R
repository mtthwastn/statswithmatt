#################################
### ggplot2 meets W. E. B. Du Bois
###
### graph 2: =========================================
### occupations in georgia
### original: https://hdl.loc.gov/loc.pnp/ppmsca.08993
###
### digitized original collection available at:
### https://www.loc.gov/pictures/collection/anedub/dubois.html
#################################

library(ggplot2)

### intial setup: ====================================

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
# need blank spots in specific places. should be simple enough to just make
# "blank" its own category for each race, right? then just color it to match
# the background and omit it from the legend
# from original image, looks like each semicircle is only filled from
# [pi/4, 3*pi/4]
occup <- data.frame(
  race = rep(c("black", "white"), each = 6),
  job = rep(c("ag", "serv", "manu", "trade", "prof", "NA"), times = 2),
  pct = c(62, 28, 5, 4.5, 0.5, 50, 64, 5.5, 13.5, 13, 4, 50)
)
# set factor levels in order of appearance on graph from [0, pi]
occup$job <- factor(
  occup$job,
  levels = c("NA", "prof", "trade", "manu", "serv", "ag")
)
# labeling
pct_labels <- paste0(occup$pct, "%")
pct_labels[c(6, 12)] <- "" # no label for NA
pct_labels[5] <- ".5%" # omit leading 0 to match the real graph

# plot -------
ppmsca_08993 <- ggplot(
  data = occup,
  mapping = aes(
    x = 1,
    y = pct,
    fill = race:job
  )
) +
  geom_bar(
    width = 1,
    stat = "identity"
  ) +
  coord_polar(
    theta = "y",
    # changing starting position for slices to be in the right places
    start = 1.3 * pi / 2
  ) +
  labs(
    title = "OCCUPATIONS OF NEGROES AND WHITES IN GEORGIA.",
    x = NULL,
    y = NULL
  ) +
  scale_fill_manual(
    values = rep(
      c("NA", "tan", "cornsilk2", "royalblue", "gold", "firebrick3"),
      times = 2
    ),
    # only need to specify one set of occupations so it'll use the
    # corresponding color for both halves. but wait, why did i put them in this
    # order (other than "because it works")? i don't know. pie charts are dumb
    # and i'm glad hadley says so in the coord_polar() documentation
    breaks = paste0(
      "black:",
      c("trade", "prof", "serv", "NA", "manu", "ag")
    ),
    labels = c(
      "TRADE AND\nTRANSPORTATION.",
      "PROFESSIONS.",
      "DOMESTIC AND\nPERSONAL SERVICE.",
      "",
      "MANUFACTURING AND\nMECHANICAL INDUSTRIES.",
      "AGRICULTURE, FISHERIES\nAND MINING."
    ),
    guide = guide_legend(
      title = NULL,
      nrow = 3,
      ncol = 2,
      keywidth = 0.7,
      keyheight = 0.7,
      reverse = TRUE
    )
  ) +
  theme_du_bois()

# annotations for plot
ppmsca_08993 + geom_text(
  aes(
  # need position_stack to center labels in each slice, but can't use position
  # and nudge_* together. would it work to just try different x values until i
  # find the one resulting in text at the top of each slice?
    x = 1.4,
    label = pct_labels,
    family = font_name
  ),
  position = position_stack(vjust = 0.5),
  size = 2.5
) +
  annotate(
    "text",
    label = c("NEGROES.", "WHITES."),
    x = 1.55,
    y = c(203, 50),
    size = 3,
    family = font_name
  ) +
  ### theme adjustments
  theme(
    plot.title = element_text(size = 14),
    panel.grid = element_blank(),
    panel.border = element_blank(),
    axis.ticks = element_blank(),
    axis.text = element_blank(),
    # remove white background from legend
    legend.background = element_blank(),
    legend.text = element_text(
      size = 6,
      # add more spacing between legend columns
      margin = margin(r = 70, unit = "pt")
    ),
    # move legend to the middle of plot
    legend.position = c(0.6, 0.5),
    # remove white background from legend keys
    legend.key = element_blank()
  )

