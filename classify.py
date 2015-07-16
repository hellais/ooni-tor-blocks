import re

# Get the first header value for the given key, or None if the header does not
# appear.
def get_header(response, fieldname):
    for name, values in response["headers"]:
        if name.lower() == fieldname.lower():
            return values[0]
    return None

# Return (is_block, description) tuple. 4?? and 5?? status codes are considered
# blocks. See the sample-blocks directory for the source files that led to these
# classifier rules.
def classify_response(response):
    status = response["code"]

    body = response["body"]
    if body is None:
        body = ""
    elif type(body) == unicode:
        body = body.encode("utf-8")

    server = get_header(response, "Server")

    if status == 403:
        if server == "cloudflare-nginx" and re.search("<title>Attention Required! \\| CloudFlare</title>", body):
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
        if re.search("<title>4chan - Verification Required</title>", body):
            return True, "403-4CHAN"
    if status == 403 or status == 404:
        if server == "AkamaiGHost" and re.search("<H1>Access Denied</H1>\n \nYou don't have permission to access \"[^\"]*\" on this server\\.<P>\nReference&#32;&#35;", body):
            return True, "%d-AKAMAI" % status
    if status == 406:
        if re.search("This request has been denied for security reasons\\.", body):
            return True, "406-SITE5"
    if status == 501:
        if body == "Not Implemented  Tor IP not allowed":
            return True, "501-CONVIO"
    if status == 503:
        if re.search("<div class=\"cf-browser-verification cf-im-under-attack\">", body):
            return True, "503-CLOUDFLARE"
        if re.search("<p>Please retry your request and <a href=\"mailto:feedback\\+unavailable@yelp.com\\?subject=IP%20Block%20Message%3A%20[\\d.]+\">contact Yelp</a> if you continue experiencing issues\\.</p>", body):
            return True, "503-YELP"

    if status // 100 == 4 or status // 100 == 5:
        return True, "%d-OTHER" % status
    return False, "%d" % status
