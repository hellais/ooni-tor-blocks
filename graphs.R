library(ggplot2)
library(grid)

# URLs probed fewer than this many times will be ignored.
min.probes.required = 100

palette <- c(UNBLOCKED="gray80", "TOR-BLOCKED"="blue", "NONTOR-BLOCKED"="darkorange", "BOTH-BLOCKED"="brown")

blocker.palette <- c(
	"Akamai"="#0098cc",
	"Amazon"="red",
	"Bluehost"="blue", # "#3575c0",
	"CloudFlare"="#fe8d1b",
	"Convio"="darkkhaki",
	"Craigslist"="#800080",
	"Google"="#02a05b",
	"Site5"="#f93c74",
	"SonicWALL"="green",
	"Yelp"="#c41200",
	"other"="#202020",
	"UNBLOCKED"="gray80"
)


blockers <- new.env(parent=emptyenv())

blockers[["403-AKAMAI"]] <- "Akamai"
blockers[["404-AKAMAI"]] <- "Akamai"
blockers[["403-AMAZON-CLOUDFRONT"]] <- "Amazon"
blockers[["503-AMAZON"]] <- "Amazon"
blockers[["403-BLUEHOST"]] <- "Bluehost"
blockers[["403-CLOUDFLARE"]] <- "CloudFlare"
blockers[["503-CLOUDFLARE"]] <- "CloudFlare"
blockers[["501-CONVIO"]] <- "Convio"
blockers[["403-CRAIGSLIST"]] <- "Craigslist"
blockers[["403-GOOGLE-SORRY"]] <- "Google"
blockers[["406-SITE5"]] <- "Site5"
blockers[["403-SONICWALL"]] <- "SonicWALL"
blockers[["403-YELP"]] <- "Yelp"
blockers[["503-YELP"]] <- "Yelp"

blockers[["406-ARIANNELINGERIE"]] <- "other"
blockers[["403-BADBEHAVIOR"]] <- "other"
blockers[["503-DOD"]] <- "other"
blockers[["403-EZINEARTICLES"]] <- "other"
blockers[["403-GROUPON"]] <- "other"
blockers[["200-HACKFORUMS"]] <- "other"
blockers[["403-INCAPSULA"]] <- "other"
blockers[["999-LINKEDIN"]] <- "other"
blockers[["404-LIVEJOURNAL-451"]] <- "other"
blockers[["403-MCAFEE"]] <- "other"
blockers[["410-MYSPACE"]] <- "other"
blockers[["403-PASTEBIN"]] <- "other"
blockers[["403-PINTEREST"]] <- "other"
blockers[["403-RACKSPACE"]] <- "other"
blockers[["403-SUCURI"]] <- "other"
blockers[["403-TYPEPAD"]] <- "other"
blockers[["910-VICTORIASSECRET"]] <- "other"
blockers[["920-VICTORIASSECRET"]] <- "other"
blockers[["403-WILDAPRICOT"]] <- "other"
blockers[["403-WITZA"]] <- "other"
blockers[["999-YAHOO"]] <- "other"

blockers[["400-OTHER"]] <- "other"
blockers[["401-OTHER"]] <- "other"
blockers[["402-OTHER"]] <- "other"
blockers[["403-OTHER"]] <- "other"
blockers[["404-OTHER"]] <- "other"
blockers[["405-OTHER"]] <- "other"
blockers[["406-OTHER"]] <- "other"
blockers[["409-OTHER"]] <- "other"
blockers[["410-OTHER"]] <- "other"
blockers[["412-OTHER"]] <- "other"
blockers[["413-OTHER"]] <- "other"
blockers[["415-OTHER"]] <- "other"
blockers[["418-OTHER"]] <- "other"
blockers[["421-OTHER"]] <- "other"
blockers[["424-OTHER"]] <- "other"
blockers[["456-OTHER"]] <- "other"
blockers[["499-OTHER"]] <- "other"
blockers[["500-OTHER"]] <- "other"
blockers[["501-OTHER"]] <- "other"
blockers[["502-OTHER"]] <- "other"
blockers[["503-OTHER"]] <- "other"
blockers[["504-OTHER"]] <- "other"
blockers[["508-OTHER"]] <- "other"
blockers[["509-OTHER"]] <- "other"
blockers[["522-OTHER"]] <- "other"
blockers[["600-OTHER"]] <- "other"
blockers[["800-OTHER"]] <- "other"
blockers[["910-OTHER"]] <- "other"
blockers[["920-OTHER"]] <- "other"
blockers[["999-OTHER"]] <- "other"

# Probably client-side censorship.
blockers[["200-EEEP"]] <- "other"
blockers[["200-EEEP-OTHER"]] <- "other"
blockers[["200-INDIA"]] <- "other"
blockers[["403-IRAN"]] <- "other"


x <- read.csv("findblocks.csv", colClasses=list(
	report_id="factor", probe_cc="factor",
	nontor_isblocked="logical", nontor_status="integer", nontor_class="factor", nontor_error="factor",
	tor_isblocked="logical", tor_status="integer", tor_class="factor", tor_error="factor",
	tor_exit_ip="factor", tor_exit_nickname="factor",
	url="character"
))
x$report_date <- as.POSIXct(x$report_date, tz="GMT")
x$date <- as.POSIXct(x$date, tz="GMT")
Encoding(x$url) <- "latin1"

x$blocked <- ifelse(x$nontor_isblocked,
	ifelse(x$tor_isblocked, "BOTH-BLOCKED", "NONTOR-BLOCKED"),
	ifelse(x$tor_isblocked, "TOR-BLOCKED", "UNBLOCKED")
)

class_to_blocker <- function(class) {
	# Replace empty keys with bogus ones, because mget doesn't allow to look up on empty variable names.
	unlist(mget(ifelse(class=="", "zzzzzzz", class), envir=blockers, ifnotfound=class))
}

x$tor_blocker <- factor(ifelse(x$tor_isblocked, class_to_blocker(as.character(x$tor_class)), "UNBLOCKED"))

x <- x[as.Date(x$date) >= as.Date("2014-09-01"), ]


p <- ggplot(data.frame(urlfreq=as.vector(sort(table(x$url)))), aes(urlfreq))
p <- p + stat_ecdf()
p <- p + theme_bw()
p <- p + scale_y_continuous(breaks=0:10/10)
p <- p + scale_x_log10(breaks=c(1, 2, 5, 10, 20, 50, 100, 200, 300, 500, 1000, 2000, 4000), minor_breaks=c())
p <- p + labs(title="CDF of number of times each URL was probed", x="Number of probes", y="Fraction of URLs probed x times or less")
ggsave("ooni-url-cdf.pdf", p, width=7, height=5)

breaks = c(1, 2, 5, 10, 20, 50, 100, 200, 300, 500)
data.frame(breaks=breaks, numurls=(1.0-ecdf(table(x$url))(breaks-1))*length(unique(x$url)))


# Remove URLs probed only a few times.
x <- x[table(x$url)[x$url] >= min.probes.required, ]


cat("\nFrequency of tor_class\n")
write.csv(rev(sort(table(x$tor_class))), "", quote=F)
cat("\nFrequency of tor_class (TOR-BLOCKED only)\n")
write.csv(rev(sort(table(x[x$blocked=="TOR-BLOCKED", ]$tor_class))), "", quote=F)
cat("\nFrequency of tor_blocker\n")
write.csv(rev(sort(table(x$tor_blocker))), "", quote=F)
cat("\nFrequency of tor_blocker (TOR-BLOCKED only)\n")
write.csv(rev(sort(table(x[x$blocked=="TOR-BLOCKED", ]$tor_blocker))), "", quote=F)



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


# Given a character vector c("foo", "bar"), return the named character vector
# c("foo"="foo  ", "bar"="bar  "); i.e., add space padding on the right for
# better appearance in a horizontally aligned legend.
padlabel <- function(label) {
	structure(sprintf("%s  ", label), names=label)
}

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
	p <- p + geom_point(size=3, alpha=0.8, shape=124)
	p <- p + guides(color=guide_legend(override.aes=c(alpha=1, shape=15), title=NULL))
	p <- p + scale_color_manual(values=palette, labels=padlabel(names(palette)))
	p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
	p <- p + theme_bw()
	p <- p + theme(legend.position="top")
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
	p <- p + geom_point(size=3, alpha=0.8, shape=124)
	p <- p + guides(color=guide_legend(override.aes=c(alpha=1, shape=15), title=NULL))
	p <- p + scale_color_manual(values=blocker.palette, labels=padlabel(names(blocker.palette)))
	p <- p + scale_y_discrete(labels=function(l) {strtrim(l, 40)})
	p <- p + theme_bw()
	p <- p + theme(legend.position="top")
	p <- p + labs(title=title, x=NULL, y=NULL)
	p
}

# Sort first by number of TOR-BLOCKED, then by number of observations.
x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="TOR-BLOCKED", sum)

p <- make.blocked.graph(x, NULL, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked.pdf", p, width=14, height=400, limitsize=F)
p <- make.blocked.graph(x, 200, "OONI URLs sorted by frequency of Tor blocking (Tor is blocked, non-Tor is unblocked).")
ggsave("ooni-tor-blocked-top-200.pdf", p, width=12, height=12*2, limitsize=F)

p <- make.tor_blocker.graph(x, NULL, "Type of Tor blocks (Tor is blocked).")
ggsave("ooni-tor-blocked-type.pdf", p, width=14, height=400, limitsize=F)
p <- make.tor_blocker.graph(x, 200, "Type of Tor blocks (Tor is blocked).")
ggsave("ooni-tor-blocked-type-top-200.pdf", p, width=12, height=12*2, limitsize=F)


# Sort first by number of NONTOR-BLOCKED, then by number of observations.
x$url <- reorder(x$url, x$blocked, length)
x$url <- reorder(x$url, x$blocked=="NONTOR-BLOCKED", sum)
p <- make.blocked.graph(x, NULL, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked.pdf", p, width=12, height=400, limitsize=F)
p <- make.blocked.graph(x, 200, "OONI URLs sorted by frequency of non-Tor blocking (Tor is unblocked, non-Tor is blocked).")
ggsave("ooni-nontor-blocked-top-200.pdf", p, width=12, height=12*2, limitsize=F)
