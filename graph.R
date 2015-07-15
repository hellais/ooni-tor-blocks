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

# Make a graph of the top URLs according to the current order of the "url"
# column. Pass NULL for topn to get all URLs.
makegraph <- function(x, topn, title) {
	if (!is.null(topn)) {
		x <- x[x$url %in% rev(levels(x$url))[1:topn], ]
		title <- sprintf("%s\nTop %d URLs of %d are shown.", title, length(unique(x$url)), length(levels(x$url)))
	} else {
		title <- sprintf("%s\nAll %d URLs are shown.", title, length(levels(x$url)))
	}

	p <- ggplot(x, aes(date, url, color=blocked))
	p <- p + geom_point(size=2.5, alpha=0.5, position=position_jitter(width=0.1, height=0))
	p <- p + guides(color=guide_legend(override.aes=c(alpha=1)))
	p <- p + scale_color_manual(values=palette)
	p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
	p <- p + theme_bw()
	p <- p + labs(title=title, x=NULL, y=NULL)
	p
}

x$url <- reorder(x$url, x$url, length)
x$url <- reorder(x$url, x$blocked=="TOR-BLOCKED", sum)
p <- makegraph(x, NULL, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked.pdf", p, width=12, height=180, limitsize=F)
p <- makegraph(x, 100, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked-top-100.pdf", p, width=12, height=12, limitsize=F)

x$url <- reorder(x$url, x$url, length)
x$url <- reorder(x$url, x$blocked=="NONTOR-BLOCKED", sum)
p <- makegraph(x, NULL, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked.pdf", p, width=12, height=180, limitsize=F)
p <- makegraph(x, 100, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked-top-100.pdf", p, width=12, height=12, limitsize=F)
