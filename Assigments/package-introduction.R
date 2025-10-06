install.packages("ggvis")
library("ggvis")
head(mtcars)
plot(mtcars$mpg,mtcars$cyl)

mtcars %>% 
  ggvis(~wt) %>% 
  layer_histograms(width =  input_slider(0, 2, step = 0.10, label = "width"),
                   center = input_slider(0, 2, step = 0.05, label = "center"))
  
mtcars %>% ggvis(~wt, ~mpg) %>%
    layer_smooths(span = input_slider(0,1, step = 0.1, value = 0.8,label = "Span")) %>%
    layer_points()
                  
                  
mtcars %>% ggvis(~mpg) %>% layer_histograms()