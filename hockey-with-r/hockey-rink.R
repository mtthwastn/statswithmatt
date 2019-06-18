#################################
### creating a hockey rink in R
###
### this script will plot one
### offensive zone from x = [25, 100] ("right") (default)
### or x = [-100, -25] ("left")
###
### the data records coordinates relative to
### the center dot (0, 0)
###
####################################

draw_rink <- function(side = "right"){
  
  draw_circle <- function(x, y, r, start = 0, end = 2*pi, nsteps = 1001, ...){
    
    # function to plot a circle: turns (x,y) into polar coordinates
    #
    # INPUTS:
    #   - (x,y) = cartesian coordinates
    #   - r = circle radius
    #   - start, end = how much of circle to draw (in radians)
    #   - nsteps = resolution/smoothness
    
    rs <- seq(start, end, length = nsteps) # sequence
    x_polar <- x + r*cos(rs) 
    y_polar <- y + r*sin(rs) 
    lines(x_polar , y_polar, ...)
  }
  
  draw_boundaries <- function(side = "right"){
    
    stopifnot(side %in% c("right", "left"))
    
    x_blue_line <- 25
    x_end <- 100
    r_corner <- 28
    
    if (side == "left") {
      x_blue_line <- -x_blue_line
      x_end <- -x_end
      r_corner <- -r_corner
    }
    
    # blue line
    segments(
      x0 = x_blue_line, y0 = 42.5,
      x1 = x_blue_line, y1 = -42.5,
      col = "blue", lwd = 3
    )
    # boards
    segments(
      x0 = x_blue_line, y0 = c(42.5, -42.5),
      x1 = (x_end - r_corner), y1 = c(42.5, -42.5),
      lwd = 2
    ) # boards

  }
  
  ### zone boundaries
  draw_boundaries(side)
  
  ### ends
  draw_end <- function(side = "right"){
    
    stopifnot(side %in% c("right", "left"))
    
    x0 <- 89
    y0 <- 42.5
    x1 <- 100
    r <- 28
    nsteps <- 1001
    
    # circle center at (89, 14.5), so angle1 = pi/2
    # next point is x at 100, so x1 = 11
    
    # center: (72, 14.5)
    
    center_x <- x1 - r
    center_y <- y0 - r
    
    rs <- seq(pi/2, 0, length = nsteps)
    x_polar <- center_x + r*cos(rs)
    y_polar <- center_y + r*sin(rs)
    y_end <- y_polar[nsteps] # y coord of end board
    
    # goal line
    goal_angle <- acos((x0 - center_x)/r)
    y_goal <- center_y + r*sin(goal_angle)
    
    if (side == "left") {
      x_polar <- -x_polar
      x0 <- -x0
      x1 <- -x1
    }
    
    # draw goal line
    segments(
      x0 = x0, y0 = y_goal,
      x1 = x0, y1 = -y_goal,
      lwd = 2, col = "red"
    )
    # draw board curve
    lines(x_polar, y_polar, lwd = 2)
    lines(x_polar, -y_polar, lwd = 2)
    # connect ends
    segments(
      x0 = x1, y0 = y_end,
      x1 = x1, y1 = -y_end,
      col = "black", lwd = 2
    )
  }
  
  # ends
  draw_end(side)
  
  ### crease + trapezoid
  draw_crease <- function(side = "right"){
    
    stopifnot(side %in% c("right", "left"))
    
    # crease:
    # 8' wide
    x_goal_line <- 89
    x_end <- 100
    # semicircle with 6' radius from center of goal line
    r_crease <- 6
    # 4.5' until circle starts
    x_circle_start <- x_goal_line - 4.5
    # 4' until start of 5" lines into crease
    x_small_lines <- x_goal_line - 4
    
    if (side == "left") {
      x_goal_line <- -x_goal_line
      x_end <- -x_end
      x_circle_start <- -x_circle_start
      x_small_lines <- -x_small_lines
      r_crease <- -r_crease
    }
    
    # crease to circle start
    segments(
      x0 = x_goal_line, y0 = c(-4, 4),
      x1 = x_circle_start, y1 = c(-4, 4),
      col = "red"
    )
    
    # 5" lines into crease
    segments(
      x0 = x_small_lines, y0 = c(-4, 4),
      x1 = x_small_lines, y1 = (41/12)*c(-1, 1),
      col = "red"
    )
    
    # semicircle beginning 4.5' out
    draw_circle(
      x = x_goal_line, y = 0, r = r_crease,
      start = acos(-4.5/6), end = (2*pi - acos(-4.5/6)),
      col = "red"
    )
    
    # draw restricted area:
    # trapezoid is 8' from each goal post
    # bottom base is 28' long
    segments(
      x0 = x_goal_line, y0 = c(11, -11),
      x1 = x_end, y1 = c(14, -14),
      col = "red"
    )
  }

  # crease + trapezoid
  draw_crease(side)
  
  ### net
  draw_net <- function(side = "right"){
    
    stopifnot(side %in% c("right", "left"))
    
    x0 <- 89
    x1 <- (x0 + 40/12) # net is 40" deep
    y0 <- 3
    r <- (20/12)
    nsteps <- 1001
    
    center_x <- x1 - r
    center_y <- y0 - r
    rs <- seq(pi/2, 0, length = nsteps)
    x_polar <- center_x + r*cos(rs)
    y_polar <- center_y + r*sin(rs)
    y_end <- y_polar[nsteps]
    
    if (side == "left") {
      x_polar <- -x_polar
      x0 <- -x0
      x1 <- -x1
    }
    
    # draw net curve
    lines(x_polar, y_polar)
    lines(x_polar, -y_polar)
    # connect
    segments(
      x0 = x0, y0 = c(y0, -y0),
      x1 = x_polar[1], y1 = c(y0, -y0)
    )
    segments(
      x0 = x1, y0 = y_end,
      x1 = x1, y1 = -y_end
    )
  }
  
  # net
  draw_net(side)
  
  
  ### faceoff circles
  draw_faceoff <- function(side = "right"){
    
    stopifnot(side %in% c("right", "left"))
    
    x_goal_line <- 89
    
    ### faceoff circle parameters:
    # dot locations: 20' from goal line, 22' in each y direction
    x_dot <- x_goal_line - 20
    y_dot <- 22
    # dots 2' diameter
    r_dot <- 1
    # circle radius 15' from center of dot
    r_faceoff_circle <- 15
    # from center dot, lines should be 2' long, 5'7" apart
    x_point <- (x_dot - 2)/24 # 5'7" apart
    y_point <- sqrt(15^2 - x_point^2)
    
    if (side == "left") {
      x_goal_line <- -x_goal_line
      x_dot <- -x_dot
      r_faceoff_circle <- -r_faceoff_circle
      x_point <- -x_point
    }
    
    # face-off circles
    draw_circle(
      x = x_dot, y = y_dot, r = r_faceoff_circle,
      start = 0, end = 2*pi,
      col = "red"
    )
    draw_circle(
      x = x_dot, y = -y_dot, r = r_faceoff_circle,
      start = 0, end = 2*pi,
      col = "red"
    )
    
    # face-off dots
    # top
    draw_circle(
      x = x_dot, y = y_dot, r = r_dot,
      start = 0, end = 2*pi,
      col = "red"
    )
    # bottom
    draw_circle(
      x = x_dot, y = -y_dot, r = r_dot,
      start = 0, end = 2*pi,
      col = "red"
    )
    
    # lines for top circle
    segments(
      x0 = (x_dot + c(x_point, -x_point)),
      y0 = (y_dot - y_point),
      x1 = (x_dot + c(x_point, -x_point)),
      y1 = (y_dot - 2 - y_point),
      col = "red"
    )
    segments(
      x0 = (x_dot + c(x_point, -x_point)), 
      y0 = (y_dot + y_point),
      x1 = (x_dot + c(x_point, -x_point)), 
      y1 = (y_dot + 2 + y_point),
      col = "red"
    )
    # inner lines
    # parallel to side boards
    # parallel to end boards. 2'10" long
    segments(
      x0 = (x_dot + c(2, 2, -2, -2)),
      y0 = (y_dot + c(1, -1)),
      x1 = (x_dot + c(6, 6, -6, -6)), 
      y1 = (y_dot + c(1, -1)),
      col = "red"
    )
    segments(
      x0 = (x_dot + c(2, 2, -2, -2)),
      y0 = (y_dot + c(1, -1)),
      x1 = (x_dot + c(2, 2, -2, -2)),
      y1 = (y_dot + c(1, -1) + c(34/12, -34/12)),
      col = "red"
    )
    # lines for bottom circle
    segments(
      x0 = (x_dot + c(x_point, -x_point)),
      y0 = (-y_dot - y_point),
      x1 = (x_dot + c(x_point, -x_point)),
      y1 = (-y_dot - 2 - y_point),
      col = "red"
    )
    segments(
      x0 = (x_dot + c(x_point, -x_point)),
      y0 = (-y_dot + y_point),
      x1 = (x_dot + c(x_point, -x_point)),
      y1 = (-y_dot + 2 + y_point),
      col = "red"
    )
    segments(
      # parallel to side boards
      x0 = (x_dot + c(2, 2, -2, -2)),
      y0 = (-y_dot + c(1, -1)),
      x1 = (x_dot + c(6, 6, -6, -6)),
      y1 = (-y_dot + c(1, -1)),
      col = "red"
    )
    segments(
      # parallel to side boards
      x0 = (x_dot + c(2, 2, -2, -2)), 
      y0 = (-y_dot - c(1, -1)),
      x1 = (x_dot + c(2, 2, -2, -2)),
      y1 = (-y_dot - c(1, -1) - c(34/12, -34/12)),
      col = "red"
    )
  }
  
  # circles
  draw_faceoff(side)
}

plot_rink <- function(x, y, side = "right", xlab = "x", ylab = "y", ...){
  # function to plot the rink
  # inputs:
  #   - (x,y) = point coordinates
  #   - ... = additional arguments passed to plot()
  
  stopifnot(side %in% c("right", "left"))
  
  # xlim <- c(25, 100)
  # ylim <- c(-42.5, 42.5)
  xlim <- c(24, 100)
  ylim <- c(-43, 43)
  if (side == "left") {
    xlim <- c(-100, -24)
  }
  
  plot(x, y, xlim = xlim, ylim = ylim, xlab = xlab, ylab = ylab, ...)
  draw_rink(side)
}
