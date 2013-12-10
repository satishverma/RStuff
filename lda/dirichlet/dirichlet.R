library(ggplot2)
library(gtools)
library(reshape2)

plot.dirichlet.data <- function(n, alpha, nrow)
{
  dat <- rdirichlet(n, alpha)
  melt.dat <- melt(dat)
  melt.dat[,"Var2"] <- as.factor(melt.dat[,"Var2"])
  colnames(melt.dat) <- c("draw", "item", "value")
  ggplot(data=melt.dat, aes(x=item, y=value, ymin=0, ymax=value)) +
    geom_linerange(colour="blue") + geom_point(colour="blue") +
    facet_wrap(~ draw, nrow=nrow) + ylim(0,1) +
    opts(panel.border=theme_rect(fill = NA, colour = "gray50"))
}

make.dirichlet.plot <- function(alpha.scalar, makepdf=F)
{
  alpha <- rep(alpha.scalar, 10)
  filename <- sprintf("~/Desktop/alpha=%g.pdf", alpha.scalar)
  if (makepdf) {
    cat(filename)
    pdf(filename, height=7, width=10)
  }
  print(plot.dirichlet.data(15, alpha, 3))
  if (makepdf) dev.off()
}


make.dirichlet.plots <- function()
{
  make.plot(1, makepdf=T)
  make.plot(10, makepdf=T)
  make.plot(100, makepdf=T)
  make.plot(0.1, makepdf=T)
  make.plot(0.01, makepdf=T)
  make.plot(0.001, makepdf=T)
}

plot.dirichlet.data(10,c(1,1,1,1,1,1),10)

