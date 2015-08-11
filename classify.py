# coding: utf-8

import re

# Get the first header value for the given key, or None if the header does not
# appear.
def get_header(response, fieldname, default=None):
    for name, values in response["headers"]:
        if name.lower() == fieldname.lower():
            return values[0]
    return default

# Return (is_block, description) tuple. Status codes >= 400 are considered
# blocks, along with selected other status codes when the reponse matches (some
# block pages are HTTP 200, for example). See the sample-blocks directory for
# the source files that led to these classifier rules.
def classify_response(response):
    status = response["code"]

    server = get_header(response, "Server")
    body = response["body"]

    # Non-blocks, despite 4?? or 5?? response code.
    if status == 408:
        # 408 is "Request Timeout", meaning the server timed out waiting for the
        # client to send a request. This is probably measurement error.
        return False, "%d" % status

    if status == 502:
        # 502 is "Bad Gateway". It means that a CDN server or proxy got a bad
        # response from the upstream server.
        if server == "cloudflare-nginx" or get_header(response, "CF-RAY") is not None:
            return False, "%d" % status

    if status == 504:
        # 504 is "Gateway Timeout". It means that a CDN server or proxy has
        # timed out waiting for the upstream server. This is pretty common, but
        # to be on the safe side we only recognize a few whitelisted pages. In
        # any case, even if it does indicate censorship, it is client-side
        # censorship.
        if server == "AkamaiGHost":
            return False, "%d" % status
        if server == "cloudflare-nginx" or get_header(response, "CF-RAY") is not None:
            return False, "%d" % status

    if status in (520, 521, 522, 523, 524, 525, 526):
        # These are special CloudFlare codes that mean there was an error
        # communicating with the origin server. We don't consider them blocks.
        # https://support.cloudflare.com/hc/en-us/articles/200171936-Error-520-Web-server-is-returning-an-unknown-error
        # https://support.cloudflare.com/hc/en-us/articles/200171916-Error-521-Web-server-is-down
        # https://support.cloudflare.com/hc/en-us/articles/200171906-Error-522-Connection-timed-out
        # https://support.cloudflare.com/hc/en-us/articles/200171946-Error-523-Origin-is-unreachable
        # https://support.cloudflare.com/hc/en-us/articles/200171926-Error-524-A-timeout-occurred
        # https://support.cloudflare.com/hc/en-us/articles/200278659-Error-525-SSL-handshake-failed
        # https://support.cloudflare.com/hc/en-us/articles/200721975-Error-526-Invalid-SSL-certificate
        if server == "cloudflare-nginx" or get_header(response, "CF-RAY") is not None:
            return False, "%d" % status

    if status == 200:
        if re.search("Error - site blocked", body):
            return True, "200-BRITISHTELECOM"

        # These are obnoxious search monetization things that ISPs serve when a
        # domain doesn't exit.
        if re.search("<meta http-equiv=\"refresh\" content=\"0;url=http://finder\\.cox\\.net", body):
            return True, "200-COX-FINDER"
        if re.search("window\\.open\\('http://www\\.parkingcrew\\.net/privacy\\.html'", body):
            return True, "200-PARKINGCREW"

        # These are all blocks of gambling web sites from a blacklist of the
        # Hellenic Gaming Commission (E.E.E.P.). Blocking is up to the ISP and
        # they do it variously.
        # https://ooni.torproject.org/post/eeep-greek-censorship/
        # Similar to but not the same as
        # https://ooni.torproject.org/post/eeep-greek-censorship/#cyta:d0c495f4479395eff703b25df5d2e963
        if re.search("<title>Access not allowed</title>", body) and re.search("<p>Για περισσότερες πληροφορίες:</p>\n                <p><a href=\"http://www\\.gamingcommission\\.gov\\.gr/index\\.php/el/\">Επιτροπή Εποπτείας και Ελέγχου Παιγνίων \\(Ε\\.Ε\\.Ε\\.Π\\.\\) </a></p>", body):
            return True, "200-EEEP"
        # This one looks like one of:
        # https://ooni.torproject.org/post/eeep-greek-censorship/#ote:d0c495f4479395eff703b25df5d2e963
        # https://ooni.torproject.org/post/eeep-greek-censorship/#cosmote:d0c495f4479395eff703b25df5d2e963
        # It can have "Server: Apache" or "Server: Apache/2.2.15 (CentOS)".
        if re.search("<TITLE>Μή Επιτρεπτή Πρόσβαση</TITLE>", body) and re.search("<BR><BR>Για περισσότερες πληροφορίες: <a href=\"http://www\\.gamingcommission\\.gov\\.gr/index\\.php/el/\">http://www\\.gamingcommission\\.gov\\.gr/index\\.php/el/</a><BR><BR>", body):
            return True, "200-EEEP"
        if re.search("<title>Μη δυνατή \r\nπρόσβαση</title>", body) and re.search("                    Η απαγόρευση της πρόσβασης επιβάλλεται από το νόμο \r\n4.002/2011 και τις αποφάσεις της Επιτροπής Εποπτείας και Ελέγχου Παιγνίων", body):
            return True, "200-EEEP"
        # This looks like one of:
        # https://ooni.torproject.org/post/eeep-greek-censorship/#wind:d0c495f4479395eff703b25df5d2e963
        # https://ooni.torproject.org/post/eeep-greek-censorship/#wind-mobile:d0c495f4479395eff703b25df5d2e963
        if re.search("<title>.: Απαγόρευση Πρόσβασης :.</title>", body):
            return True, "200-EEEP"
        # This is a catch-all designed to find other E.E.E.P. blocks that aren't
        # specifically enumerated above, for when new OONI reports are added.
        if re.search("gamingcommission\\.gov\\.gr", body):
            return True, "200-EEEP-OTHER"

        if re.search("Your datacenter is blocked\\. Please disable any VPN or proxy\\.", body):
            return True, "200-HACKFORUMS"

        # These are all ISP-specific block pages for URLs blocked by the
        # government of India at the end of 2014.
        # https://securityinabox.org/en/blog/22-02-2015/observations-recent-india-censorship
        if re.search("<!--This is a comment\\. Comments are not displayed in the browser-->", body):
            return True, "200-INDIA"
        # http://chaoslab.in/goiblocks/block_4.png
        if re.search("The requested url is blocked, based on the blocking Instruction order received from the Department of Telecommunications, Ministry of Communications & IT, Government of India\\.", body):
            return True, "200-INDIA"
        # http://chaoslab.in/goiblocks/block_5.png
        # There's also a variation that includes the domain.
        if re.search("HTTP Error 404 - File or Directory not found", body):
            return True, "200-INDIA"
        # This one is not found on the above blog post, however it looks like it
        # is from India and the same bunch of pastebin sites.
        if re.search("The URL you requested has been blocked", body):
            return True, "200-INDIA"

    if status == 301:
        if get_header(response, "Location", "").startswith("https://www.vpscontrol.net/"):
            return True, "301-VPSCONTROL"

    if status == 302:
        if get_header(response, "Location", "").startswith("http://www.shopper.com"):
            return True, "302-SHOPPERCOM"

    if status == 403:
        if re.search("Access to the Web page you have attempted to view has been blocked by the University of Aberdeen's Web Content Filter Service\\.", body):
            return True, "403-ABERDEEN"
        if get_header(response, "X-Amz-Cf-Id") is not None and re.search("<Error><Code>AccessDenied</Code><Message>Access Denied</Message><RequestId>", body):
            return True, "403-AMAZON-CLOUDFRONT"
        if re.search("<p>You can use this key to <a href=\"http://www\\.ioerror\\.us/bb2-support-key\\?key=[\\w-]+\">fix this problem yourself</a>\\.</p>", body):
            return True, "403-BADBEHAVIOR"
        if server == "Apache" and re.search("Access denied\\.  Your IP address \\[[\\d.]+\\] is blacklisted\\.  If you feel this is in error please contact your hosting providers abuse department", body):
            return True, "403-BLUEHOST"
        if server == "cloudflare-nginx" and re.search("<title>Attention Required! \\| CloudFlare</title>|One more step to access", body):
            return True, "403-CLOUDFLARE"
        if server == "cloudflare-nginx" and re.search("<noscript id=\"cf-captcha-bookmark\" class=\"cf-captcha-info\">|<button type=\"submit\" class=\"cf-captcha-submit\">", body):
            # A customized captcha page.
            return True, "403-CLOUDFLARE"
        if server == "cloudflare-nginx" and re.search("<title>Access denied \\| [^ ]* used CloudFlare to restrict access</title>", body):
            # With this one you don't get a captcha. May be controlled by the
            # site operator.
            return True, "403-CLOUDFLARE"
        if re.search("This IP has been automatically blocked\\.\n(Questions:|If you have questions, please email:) blocks-\\w+@craigslist\\.org", body):
            return True, "403-CRAIGSLIST"
        if re.search("<title>EzineArticles Submission", body):
            return True, "403-EZINEARTICLES"
        if server is not None and server.startswith("GFE/") and re.search("<h1>We're sorry\\.\\.\\.</h1><p>\\.\\.\\. but your computer or network may be sending automated queries\\.", body):
            return True, "403-GOOGLE-SORRY"
        if "domain=.groupon.com" in get_header(response, "Set-Cookie", "") and get_header(response, "Content-Encoding") == "gzip":
            return True, "403-GROUPON"
        if get_header(response, "X-Treatment-Name") is not None and get_header(response, "X-Bucket-Value") is not None and get_header(response, "Content-Encoding") == "gzip":
            # These weird headers seem to be unique to Groupon.
            return True, "403-GROUPON"
        if get_header(response, "X-Iinfo") is not None:
            return True, "403-INCAPSULA"
        if re.search("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1256\"><title>M[0-9]-[0-9]\n", body):
            return True, "403-IRAN"
        if re.search("<li>McAfee Global Threat Intelligence has determined</li>", body):
            return True, "403-MCAFEE"
        if re.search("<title>Pastebin\\.com - Access Denied Warning</title>\r", body):
            # "Censor Kitty denies access"
            # Pastebin is also on CloudFlare, so you could get a CloudFlare
            # captcha or their own custom block page.
            return True, "403-PASTEBIN"
        if re.search("href=\"//help\\.pinterest\\.com/entries/22914692\"", body):
            return True, "403-PINTEREST"
        if body == "<h2>Forbidden</h2>\n":
            return True, "403-RACKSPACE"
        if re.search("<title>Доступ всё ещё закрыт!</title>", body):
            return True, "403-SKYDNS"
        if get_header(response, "Window-target") == "_top" and re.search("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=\"id\" content=\"siteBlocked\"/><title>Web Site Blocked</title>", body):
            return True, "403-SONICWALL"
        if re.search("<title>Web Site Blocked</title>", body) and re.search("id=\"nsa_banner\" alt=\"SonicWALL Network Security Appliance\"", body):
            return True, "403-SONICWALL"
        if server == "Sucuri/Cloudproxy":
            return True, "403-SUCURI"
        if re.search("<img alt=\"404 page not found\" title=\"404 page not found\" src=\"data:image/png;base64,iVBOR", body):
            return True, "403-TYPEPAD"
        if server == "WA" and re.search("<title>403.6 - Access denied.</title>", body):
            return True, "403-WILDAPRICOT"
        if re.search("\\[403 Forbidden Error\\] - You might be blocked by your IP, Country, or ISP\\. You can try to contact us at http://www\\.witza\\.com/contact\\.php", body):
            return True, "403-WITZA"
        if re.search("<p>Please retry your request and <a href=\"mailto:feedback\\+forbidden@yelp\\.com", body):
            return True, "403-YELP"

    if status == 403 or status == 404:
        if server == "AkamaiGHost" and re.search("<H1>Access Denied</H1>\n \nYou don't have permission to access \"[^\"]*\" on this server\\.<P>\nReference&#32;&#35;", body):
            return True, "%d-AKAMAI" % status

    if status == 404:
        if re.search("<title>Error 451</title>", body):
            return True, "404-LIVEJOURNAL-451"

    if status == 406:
        if re.search("This request has been denied for security reasons\\.", body):
            return True, "406-SITE5"
        if re.search("<meta http-equiv=\"refresh\" content=\"0;url=http://www\\.ariannelingerie\\.com/shop/\">\n", body):
            return True, "406-ARIANNELINGERIE"

    if status == 410:
        # NB this check against the body depends on the input file processing
        # not having decoded the "chunked" Transfer-Encoding.
        if get_header(response, "X-Powered-By") == "Express" and get_header(response, "Transfer-Encoding") == "chunked" and body == "0\r\n\r\n":
            return True, "410-MYSPACE"
        if get_header(response, "X-Powered-By") == "Express" and get_header(response, "Content-Length") == "0" and body == "":
            return True, "410-MYSPACE"

    if status == 501:
        if body == "Not Implemented  Tor IP not allowed":
            return True, "501-CONVIO"
        # Some of the OONI samples are missing the body, so do a specific test
        # on the header format.
        if len(response["headers"]) == 2 and get_header(response, "Content-Length") == "35" and get_header(response, "Connection") == "close":
            return True, "501-CONVIO"

    if status == 503:
        if re.search("To discuss automated access to Amazon data please contact api-services-support@amazon\\.com\\.", body):
            return True, "503-AMAZON"
        if re.search("<div class=\"cf-browser-verification cf-im-under-attack\">", body):
            return True, "503-CLOUDFLARE"
        if re.search("<title>\\s*qos-mission-critical-pan\\s*</title>", body):
            return True, "503-DOD"
        if re.search("<p>Please retry your request and <a href=\"mailto:feedback\\+unavailable@yelp.com\\?subject=IP%20Block%20Message%3A%20[\\d.]+\">contact Yelp</a> if you continue experiencing issues\\.</p>", body):
            return True, "503-YELP"

    if status in (910, 920):
        if body == "<h1>File not found</h1>":
            return True, "%d-VICTORIASSECRET" % status

    if status == 999:
        if re.search("<title>999: request failed</title>", body):
            return True, "999-LINKEDIN"
        if re.search("/uas/login\\?trk=sentinel_org_block", body):
            return True, "999-LINKEDIN"
        if re.search("Yahoo! - 999 Unable to process request at this time -- error 999", body):
            return True, "999-YAHOO"

    if status >= 400:
        return True, "%d-OTHER" % status
    return False, "%d" % status
