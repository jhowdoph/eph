install.packages("tidyverse")
install.packages("quantmod")
install.packages("plotly")

library(tidyverse)
library(quantmod)
library(plotly)

getSymbols(c("ONCO3.SA", "RDOR3.SA"), from = "2021-09-21", to = "2023-09-21")

bbands <- BBands(Cl(ONCO3.SA), n = 20, sd = 2)

dados <- data.frame(Date = index(ONCO3.SA), coredata(ONCO3.SA), coredata(bbands))

fig <- plot_ly(data = dados, x = ~Date, type = "candlestick",
               open = ~ONCO3.SA.Open, close = ~ONCO3.SA.Close,
               high = ~ONCO3.SA.High, low = ~ONCO3.SA.Low) %>%
  add_lines(y = ~dn, name = "Lower Band", line = list(color = "blue")) %>%
  add_lines(y = ~mavg, name = "Middle Band", line = list(color = "red")) %>%
  add_lines(y = ~up, name = "Upper Band", line = list(color = "blue"))


fig <- fig %>% layout(width = 800, height = 500)


fig 

###se houve incorporacao
fig <- fig %>% 
  add_markers(x = ~Date[which(dados$ONCO3.SA.Close <= dados$dn)], 
              y = ~dn[which(dados$ONCO3.SA.Close <= dados$dn)], 
              marker = list(symbol = "triangle-up", size = 10, color = "green"), 
              name = "incorporacao1")

###se houve incorporacao
fig <- fig %>% 
  add_markers(x = ~Date[which(dados$ONCO3.SA.Close >= dados$up)], 
              y = ~up[which(dados$ONCO3.SA.Close >= dados$up)], 
              marker = list(symbol = "triangle-down", size = 10, color = "red"), 
              name = "incorporacao2")


fig
