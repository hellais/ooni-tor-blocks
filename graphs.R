library(ggplot2)

palette <- c(UNBLOCKED="gray85", "TOR-BLOCKED"="blue", "NONTOR-BLOCKED"="darkorange", "BOTH-BLOCKED"="brown")

x <- read.csv("findblocks.csv", colClasses=list(
	report_id="factor", probe_cc="factor",
	nontor_isblocked="logical", nontor_status="integer", nontor_class="factor",
	tor_isblocked="logical", tor_status="integer", tor_class="factor",
	url="character"
))
x$date <- as.POSIXct(x$date, tz="GMT")
Encoding(x$url) <- "latin1"

x$blocked <- ifelse(x$nontor_isblocked,
	ifelse(x$tor_isblocked, "BOTH-BLOCKED", "NONTOR-BLOCKED"),
	ifelse(x$tor_isblocked, "TOR-BLOCKED", "UNBLOCKED")
)


x$probe_cc <- reorder(x$probe_cc, x$probe_cc, length)

p <- ggplot(x, aes(probe_cc, fill=blocked))
p <- p + geom_histogram()
p <- p + scale_fill_manual(values=palette)
p <- p + coord_flip()
p <- p + theme_bw()
p <- p + labs(title="Number of request pairs and blocking by country", x="Country", y="Number of request pairs")
ggsave("ooni-blocked-cc-all.pdf", p, width=7, height=7)

p <- ggplot(x[x$blocked!="UNBLOCKED", ], aes(probe_cc, fill=blocked))
p <- p + geom_histogram()
p <- p + scale_fill_manual(values=palette)
p <- p + coord_flip()
p <- p + theme_bw()
p <- p + labs(title="Number of request pairs and blocking by country\n(UNBLOCKED request pairs not shown)", x="Country", y="Number of request pairs")
ggsave("ooni-blocked-cc.pdf", p, width=7, height=7)


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
	p <- p + geom_point(size=2.5, alpha=0.5)
	p <- p + guides(color=guide_legend(override.aes=c(alpha=1)))
	p <- p + scale_color_manual(values=palette)
	p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
	p <- p + theme_bw()
	p <- p + labs(title=title, x=NULL, y=NULL)
	p
}

# Sort first by number of TOR-BLOCKED, then by number of observations.
x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="TOR-BLOCKED", sum)
p <- makegraph(x, NULL, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked.pdf", p, width=12, height=400, limitsize=F)
p <- makegraph(x, 100, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked-top-100.pdf", p, width=12, height=12, limitsize=F)

# Sort first by number of NONTOR-BLOCKED, then by number of observations.
x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="NONTOR-BLOCKED", sum)
p <- makegraph(x, NULL, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked.pdf", p, width=12, height=400, limitsize=F)
p <- makegraph(x, 100, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked-top-100.pdf", p, width=12, height=12, limitsize=F)

levels(x$tor_class) <- list(
	"Akamai"=c("403-AKAMAI", "404-AKAMAI"),
	"Amazon"=c("503-AMAZON"),
	"Bluehost"=c("403-BLUEHOST"),
	"CloudFlare"=c("403-CLOUDFLARE", "503-CLOUDFLARE"),
	"Convio"=c("501-CONVIO"),
	"Craigslist"=c("403-CRAIGSLIST"),
	"Google"=c("403-GOOGLE-SORRY"),
	"Site5"=c("406-SITE5"),
	"SonicWALL"=c("403-SONICWALL"),
	"Yelp"=c("503-YELP"),
	"other"=c("403-OTHER", "404-OTHER", "405-OTHER", "406-OTHER", "500-OTHER", "502-OTHER", "503-DOD", "503-OTHER")
)

palette <- c(
	"Akamai"="#0098cc",
	"Amazon"="#232f3e",
	"Bluehost"="#3575c0",
	"CloudFlare"="#fe8d1b",
	"Convio"="#470e6d",
	"Craigslist"="#800080",
	"Google"="#202020",
	"Site5"="#f93c74",
	"SonicWALL"="green",
	"Yelp"="#c41200",
	"other"="#202020"
)

x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="TOR-BLOCKED", sum)
p <- ggplot(x[x$blocked=="TOR-BLOCKED" & x$url %in% rev(levels(x$url))[1:100], ], aes(date, url, color=tor_class))
p <- p + geom_point(size=2.5, alpha=0.5)
p <- p + guides(color=guide_legend(override.aes=c(alpha=1)))
p <- p + scale_color_manual(values=palette)
p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
p <- p + theme_bw()
p <- p + labs(title="Tor blocking type", x=NULL, y=NULL)
ggsave("tor-blocked-type-top-100.pdf", p, width=12, height=12, limitsize=F)
