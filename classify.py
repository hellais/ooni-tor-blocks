# coding: utf-8

import re

# Get the first header value for the given key, or None if the header does not
# appear.
def get_header(response, fieldname):
    for name, values in response["headers"]:
        if name.lower() == fieldname.lower():
            return values[0]
    return None

# Return (is_block, description) tuple. 4?? and 5?? status codes are considered
# blocks, along with selected other status codes when the reponse matches (some
# block pages are HTTP 200, for example). See the sample-blocks directory for
# the source files that led to these classifier rules.
def classify_response(response):
    status = response["code"]

    body = response["body"]
    if body is None:
        body = ""
    elif type(body) == unicode:
        body = body.encode("utf-8")

    server = get_header(response, "Server")

    # Non-blocks, despite 4?? or 5?? response code.
    if status == 520:
        if server == "cloudflare-nginx":
            # This is a special CloudFlare error code that means "web server is
            # returning an unknown error." We don't consider that a block.
            # https://support.cloudflare.com/hc/en-us/articles/200171936-Error-520-Web-server-is-returning-an-unknown-error
            return False, "%d" % status
    if status == 521:
        if server == "cloudflare-nginx":
            # This is a special CloudFlare error code that means "web server is
            # down." We don't consider that a block.
            # https://support.cloudflare.com/hc/en-us/articles/200171916-Error-521-Web-server-is-down
            return False, "%d" % status

    if status == 200:
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
        if re.search("<TITLE>Μή Επιτρεπτή Πρόσβαση</TITLE>", body) and re.search("<BR><BR>Για περισσότερες πληροφορίες: <a href=\"http://www\\.gamingcommission\\.gov\\.gr/index.php/el/\">http://www\\.gamingcommission\\.gov\\.gr/index\\.php/el/</a><BR><BR>", body):
            return True, "200-EEEP"
        # This is a catch-all designed to find other E.E.E.P. blocks that aren't
        # specifically enumerated above, for when new OONI reports are added.
        if re.search("gamingcommission\\.gov\\.gr", body):
            return True, "200-EEEP-OTHER"

    if status == 403:
        if server == "cloudflare-nginx" and re.search("<title>Attention Required! \\| CloudFlare</title>", body):
            return True, "403-CLOUDFLARE"
        if server == "cloudflare-nginx" and re.search("<title>4chan - Verification Required</title>", body):
            # 4chan.org customizes its CloudFlare block pages.
            return True, "403-CLOUDFLARE"
        if re.search("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1256\"><title>M[0-9]-[0-9]\n", body):
            return True, "403-IRAN"
        if server is not None and server.startswith("GFE/") and re.search("<h1>We're sorry\\.\\.\\.</h1><p>\\.\\.\\. but your computer or network may be sending automated queries\\.", body):
            return True, "403-GOOGLE-SORRY"
        if re.search("This IP has been automatically blocked\\.\nIf you have questions, please email: blocks-\\w+@craigslist\\.org\n", body):
            return True, "403-CRAIGSLIST"
        if re.search("<p>You can use this key to <a href=\"http://www\\.ioerror\\.us/bb2-support-key\\?key=[\\w-]+\">fix this problem yourself</a>\\.</p>", body):
            return True, "403-BADBEHAVIOR"
        if re.search("Access to the Web page you have attempted to view has been blocked by the University of Aberdeen's Web Content Filter Service\\.", body):
            return True, "403-ABERDEEN"
        if get_header(response, "Window-target") == "_top" and re.search("<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"/><meta name=\"id\" content=\"siteBlocked\"/><title>Web Site Blocked</title>", body):
            return True, "403-SONICWALL"
        if server == "Apache" and re.search("Access denied\\.  Your IP address \\[[\\d.]+\\] is blacklisted.  If you feel this is in error please contact your hosting providers abuse department\\.", body):
            return True, "403-BLUEHOST"

    if status == 403 or status == 404:
        if server == "AkamaiGHost" and re.search("<H1>Access Denied</H1>\n \nYou don't have permission to access \"[^\"]*\" on this server\\.<P>\nReference&#32;&#35;", body):
            return True, "%d-AKAMAI" % status

    if status == 406:
        if re.search("This request has been denied for security reasons\\.", body):
            return True, "406-SITE5"

    if status == 501:
        if body == "Not Implemented  Tor IP not allowed":
            return True, "501-CONVIO"
        # Some of the OONI samples are missing the body, so do a specific test
        # on the header format.
        if len(response["headers"]) == 2 and get_header(response, "Content-Length") == "35" and get_header(response, "Connection") == "close":
            return True, "501-CONVIO"

    if status == 503:
        if re.search("<div class=\"cf-browser-verification cf-im-under-attack\">", body):
            return True, "503-CLOUDFLARE"
        if re.search("<p>Please retry your request and <a href=\"mailto:feedback\\+unavailable@yelp.com\\?subject=IP%20Block%20Message%3A%20[\\d.]+\">contact Yelp</a> if you continue experiencing issues\\.</p>", body):
            return True, "503-YELP"

    if status // 100 == 4 or status // 100 == 5:
        return True, "%d-OTHER" % status
    return False, "%d" % status
