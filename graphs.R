library(ggplot2)

palette <- c(UNBLOCKED="gray85", "TOR-BLOCKED"="blue", "NONTOR-BLOCKED"="darkorange", "BOTH-BLOCKED"="brown")

blocker.palette <- c(
	"Akamai"="skyblue", # "#0098cc",
	"Amazon"="red",
	"Bluehost"="#3575c0",
	"CloudFlare"="#fe8d1b",
	"Convio"="darkkhaki",
	"Craigslist"="#800080",
	"Google"="#02a05b",
	"Site5"="#f93c74",
	"SonicWALL"="green",
	"Yelp"="#c41200",
	"other"="#202020",
	"UNBLOCKED"="gray85"
)

blockers <- c(
	"403-AKAMAI"="Akamai",
	"404-AKAMAI"="Akamai",
	"503-AMAZON"="Amazon",
	"403-BLUEHOST"="Bluehost",
	"403-CLOUDFLARE"="CloudFlare",
	"503-CLOUDFLARE"="CloudFlare",
	"501-CONVIO"="Convio",
	"403-CRAIGSLIST"="Craigslist",
	"403-GOOGLE-SORRY"="Google",
	"406-SITE5"="Site5",
	"403-SONICWALL"="SonicWALL",
	"503-YELP"="Yelp",

	"403-BADBEHAVIOR"="other",
	"403-PASTEBIN"="other",
	"403-PINTEREST"="other",
	"403-SUCURI"="other",
	"403-RACKSPACE"="other",
	"403-WILDAPRICOT"="other",
	"410-MYSPACE"="other",
	"503-DOD"="other",

	"400-OTHER"="other",
	"401-OTHER"="other",
	"403-OTHER"="other",
	"404-OTHER"="other",
	"405-OTHER"="other",
	"406-OTHER"="other",
	"410-OTHER"="other",
	"413-OTHER"="other",
	"500-OTHER"="other",
	"502-OTHER"="other",
	"503-OTHER"="other",
	"504-OTHER"="other"
)

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

class_to_blocker <- function(class) {
	ifelse(class %in% names(blockers), blockers[class], class)
}

x$tor_blocker <- factor(ifelse(x$tor_isblocked, class_to_blocker(as.character(x$tor_class)), "UNBLOCKED"), levels=names(blocker.palette))
write.csv(sort(table(x$tor_class)), "", quote=F)
write.csv(sort(table(x[x$blocked=="TOR-BLOCKED", ]$tor_class)), "", quote=F)
write.csv(sort(table(x$tor_blocker)), "", quote=F)


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

p <- ggplot(x, aes(as.Date(date), fill=blocked))
p <- p + geom_bar(binwidth=7)
p <- p + scale_fill_manual(values=palette)
p <- p + theme_bw()
p <- p + theme(panel.grid.major=element_blank(), panel.grid.minor=element_blank())
p <- p + labs(title="Number of request pairs and blocking per week", x=NULL, y="Number of request pairs")
ggsave("ooni-blocked-date-all.pdf", p, width=7, height=4)


# Make a graph of the top URLs according to the current order of the "url"
# column. Pass NULL for topn to get all URLs.
make.blocked.graph <- function(x, topn, title) {
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

make.tor_blocker.graph <- function(x, topn, title) {
	if (!is.null(topn)) {
		x <- x[x$url %in% rev(levels(x$url))[1:topn], ]
		title <- sprintf("%s\nTop %d URLs of %d are shown.", title, length(unique(x$url)), length(levels(x$url)))
	} else {
		title <- sprintf("%s\nAll %d URLs are shown.", title, length(levels(x$url)))
	}

	p <- ggplot(x, aes(date, url, color=tor_blocker))
	p <- p + geom_point(size=2.5, alpha=0.5)
	p <- p + guides(color=guide_legend(override.aes=c(alpha=1)))
	p <- p + scale_color_manual(values=blocker.palette)
	p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
	p <- p + theme_bw()
	p <- p + labs(title=title, x=NULL, y=NULL)
	p
}

# Sort first by number of TOR-BLOCKED, then by number of observations.
x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="TOR-BLOCKED", sum)

p <- make.blocked.graph(x, NULL, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked.pdf", p, width=12, height=400, limitsize=F)
p <- make.blocked.graph(x, 100, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked-top-100.pdf", p, width=12, height=12, limitsize=F)

p <- make.tor_blocker.graph(x, NULL, "Type of Tor blocks (Tor is blocked).")
ggsave("ooni-tor-blocked-type.pdf", p, width=12, height=400, limitsize=F)
p <- make.tor_blocker.graph(x, 100, "Type of Tor blocks (Tor is blocked).")
ggsave("ooni-tor-blocked-type-top-100.pdf", p, width=12, height=12, limitsize=F)


# Sort first by number of NONTOR-BLOCKED, then by number of observations.
x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="NONTOR-BLOCKED", sum)
p <- make.blocked.graph(x, NULL, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked.pdf", p, width=12, height=400, limitsize=F)
p <- make.blocked.graph(x, 100, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked-top-100.pdf", p, width=12, height=12, limitsize=F)
