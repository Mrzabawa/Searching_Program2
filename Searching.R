library(ggplot2)

sorted <- read.csv("/Users/michaelzabawa/Documents/Github/Searching_Program2/sortedgraph.txt", header = FALSE)
unsorted <- read.csv("/Users/michaelzabawa/Documents/Github/Searching_Program2/unsortedgraph.txt", header = FALSE)
head(unsorted)
plot(unsorted)
plot(sorted)
sorted$log_n <- log(sorted$V1)
unsorted$n = unsorted$V1

ggplot(data = sorted, aes(x = V1)) +
  geom_point(aes(y = V2), shape = ".", size = 6, alpha = .4)+
  geom_line(aes(y = log_n + 4 , color = "Value: log(n) + 4"))+
  labs(title = "Sorted Bisection Search", y = "Average Number of Comparisions",
       x = "Size of Array: n", color = "")

ggplot(data = unsorted, aes(x = V1, y = V2))+
  geom_point(shape = ".", size = 6, alpha = .4)+
  geom_line(aes(y = n, color = "Value: n "))+
  labs(title = "Unsorted Linear Search", y = "Average Number of Comparisions",
       x = "Size of Array: n", color = "")

