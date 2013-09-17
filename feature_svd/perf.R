perf <- read.table("perf.txt")

plot(perf$V1, perf$V3/perf$V2, type='b')

plot(perf$V1, perf$V3, log='xy', type = 'b', ylim = c(0.1, max(perf$V3)), )
lines(perf$V1, perf$V2, type = 'b', col = 'red')

lm(log(perf$V3) ~ log(perf$V1))

