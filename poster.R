library(ggplot2)
library(grid)

# URLs probed fewer than this many times will be ignored.
min.probes.required = 500

blocker.palette <- c(
	"Akamai"="cyan", # "#0098cc",
	"Amazon"="red",
	"Bluehost"="blue", # "#3575c0",
	"CloudFlare"="#fe8d1b",
	"Convio"="red",
	"Craigslist"="#800080",
	"Google"="#02a05b",
	"Site5"="#f93c74",
	"SonicWALL"="green",
	"Yelp"="#c41200",
	"custom"="midnightblue",
	"other"="#202020",
	"timeout"="magenta",
	"reject"="green",
	"OTHER-OONI-ERROR"="pink",
	"unblocked"="gray85"
)


blockers <- new.env(parent=emptyenv())

blockers[["403-AKAMAI"]] <- "Akamai"
blockers[["404-AKAMAI"]] <- "Akamai"
blockers[["403-BLUEHOST"]] <- "Bluehost"
blockers[["403-CLOUDFLARE"]] <- "CloudFlare"
blockers[["503-CLOUDFLARE"]] <- "CloudFlare"
blockers[["501-CONVIO"]] <- "Convio"
blockers[["406-SITE5"]] <- "Site5"

blockers[["403-AMAZON-CLOUDFRONT"]] <- "custom" # "Amazon"
blockers[["503-AMAZON"]] <- "custom" # "Amazon"
blockers[["406-ARIANNELINGERIE"]] <- "custom"
blockers[["403-CRAIGSLIST"]] <- "custom" # "Craigslist"
blockers[["403-EZINEARTICLES"]] <- "custom"
blockers[["403-GOOGLE-SORRY"]] <- "custom" # "Google"
blockers[["403-GROUPON"]] <- "custom"
blockers[["200-HACKFORUMS"]] <- "custom"
blockers[["999-LINKEDIN"]] <- "custom"
blockers[["404-LIVEJOURNAL-451"]] <- "custom"
blockers[["410-MYSPACE"]] <- "custom"
blockers[["403-PASTEBIN"]] <- "custom"
blockers[["403-PINTEREST"]] <- "custom"
blockers[["403-TYPEPAD"]] <- "custom"
blockers[["910-VICTORIASSECRET"]] <- "custom"
blockers[["920-VICTORIASSECRET"]] <- "custom"
blockers[["999-YAHOO"]] <- "custom"
blockers[["403-YELP"]] <- "custom" # "Yelp"
blockers[["503-YELP"]] <- "custom" # "Yelp"

blockers[["200-PARKINGCREW"]] <- "other"
blockers[["403-BADBEHAVIOR"]] <- "other"
blockers[["503-DOD"]] <- "other"
blockers[["403-INCAPSULA"]] <- "other"
blockers[["403-MCAFEE"]] <- "other"
blockers[["403-RACKSPACE"]] <- "other"
blockers[["403-SONICWALL"]] <- "other" # "SonicWALL"
blockers[["403-SUCURI"]] <- "other"
blockers[["403-WILDAPRICOT"]] <- "other"
blockers[["403-WITZA"]] <- "other"

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
blockers[["429-OTHER"]] <- "other"
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

blockers[["OTHER-OONI-ERROR"]] <- "other"
blockers[["TIMEOUT"]] <- "timeout"
blockers[["REJECT"]] <- "reject"


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

x$tor_blocker <- factor(ifelse(x$blocked=="TOR-BLOCKED", class_to_blocker(as.character(x$tor_class)), "unblocked"))
x$tor_blocker <- droplevels(x$tor_blocker)
x$tor_blocker <- factor(x$tor_blocker, levels=unique(c("unblocked", "timeout", "CloudFlare", "reject", "custom", "other", "Bluehost", "Akamai", "Convio", "Site5"), levels(x$tor_blocker)))

x <- x[as.Date(x$date) >= as.Date("2014-10-01"), ]


# Remove URLs probed only a few times.
x <- x[table(x$url)[x$url] >= min.probes.required, ]
# Remove entries where not both responses are good.
x <- x[!is.na(x$nontor_isblocked)&!is.na(x$tor_isblocked), ]


makelabeler <- function(x) {
	function (labels) {
		v <- vector("character", length(labels))
		for (i in 1:length(labels)) {
			v[[i]] <- sprintf("%s (%.2f%%)    ", labels[[i]], 100*sum(x$tor_blocker == labels[[i]])/length(x$tor_blocker))
		}
		names(v) <- labels
		v
	}
}

makeurllabeler <- function(x) {
	function (labels) {
		v <- vector("character", length(labels))
		for (i in 1:length(labels)) {
			v[[i]] <- sprintf("%2.f%%", with(x[x$url==labels[[i]], ], 100*sum(blocked=="TOR-BLOCKED")/length(blocked)))
		}
		names(v) <- labels
		v
	}
}

date.label <- function(d) {
	out <- vector("character", length(d))
	show.year <- T
	for (i in 1:length(d)) {
		# Show the year for the first tick and for each January.
		if (is.na(d[[i]])) {
			next
		}
		if (as.POSIXlt(d[[i]])[[5]] == 0) {
			show.year <- T
		}
		out[[i]] <- strftime(d[[i]], ifelse(show.year, "%b\n%Y", "%b"), tz="GMT")
		show.year <- F
	}
	out
}

make.tor_blocker.graph <- function(x, topn, title) {
	y <- x
	labeler <- makelabeler(y)
	urllabeler <- makeurllabeler(y)

	if (!is.null(topn)) {
		x <- x[x$url %in% rev(levels(x$url))[1:topn], ]
		title <- sprintf("%s\nTop %d URLs of %d are shown.", title, length(unique(x$url)), length(levels(x$url)))
	} else {
		title <- sprintf("%s\nAll %d URLs are shown.", title, length(levels(x$url)))
	}
	cat(sprintf("%s\n", title))

	p <- ggplot(x, aes(date, url), environment=environment())
	p <- p + geom_point(aes(color=tor_blocker), size=3.4, alpha=0.8, shape=124)
	p <- p + geom_text(data=data.frame(date=min(x$date)-10*60*60*24, url=unique(x$url)), aes(date, url, label=urllabeler(unique(x$url))), hjust=1, size=3)
	p <- p + guides(color=guide_legend(override.aes=c(size=8, alpha=1, shape=15), title=NULL))
	p <- p + scale_color_manual(values=blocker.palette, labels=labeler)
	p <- p + scale_x_datetime(breaks="1 month", labels=date.label, limits=range(x$date))
	p <- p + theme_minimal()
	p <- p + theme(legend.position="bottom")
	p <- p + theme(legend.text=element_text(size=14))
	p <- p + theme(axis.ticks=element_blank())
	p <- p + labs(title=NULL, x=NULL, y=NULL)
	p
}

x$url <- reorder(x$url, x$blocked, function(z) { sum(z=="TOR-BLOCKED")/length(z) })

p <- make.tor_blocker.graph(x, 250, "Tor blockers")
ggsave("poster.pdf", p, width=24, height=32, limitsize=F)
