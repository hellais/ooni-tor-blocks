library(ggplot2)

palette <- c(UNBLOCKED="gray85", "TOR-BLOCKED"="blue", "NONTOR-BLOCKED"="darkorange", "BOTH-BLOCKED"="brown")

x <- read.csv("findblocks.csv", colClasses=list(
	report_id="factor", probe_cc="factor",
	nontor_isblocked="logical", nontor_status="integer", nontor_class="factor",
	tor_isblocked="logical", tor_status="integer", tor_class="factor",
	url="factor"
))
x$date <- as.POSIXct(x$date, tz="GMT")

x$blocked <- ifelse(x$nontor_isblocked,
	ifelse(x$tor_isblocked, "BOTH-BLOCKED", "NONTOR-BLOCKED"),
	ifelse(x$tor_isblocked, "TOR-BLOCKED", "UNBLOCKED")
)

x$url <- reorder(x$url, x$url, length)
x$url <- reorder(x$url, x$blocked=="TOR-BLOCKED", sum)

p <- ggplot(x, aes(date, url, color=blocked))
p <- p + geom_point(size=3, alpha=0.5, position=position_jitter(width=0.1, height=0))
p <- p + guides(color=guide_legend(override.aes=c(alpha=1)))
p <- p + scale_color_manual(values=palette)
p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
p <- p + theme_bw()
ggsave("ooni-blocks.pdf", p, width=16, height=240, limitsize=F)
