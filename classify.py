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

    if status == 403:
        if get_header(response, "Server") == "cloudflare-nginx" and re.search("<title>Attention Required! \\| CloudFlare</title>", body):
            return True, "403-CLOUDFLARE"
        if re.search("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=windows-1256\"><title>M[0-9]-[0-9]\n", body):
            return True, "403-IRAN"
    if status == 404:
        if get_header(response, "Server") == "AkamaiGHost" and re.search("<H1>Access Denied</H1>\n \nYou don't have permission to access \"[^\"]*\" on this server\\.<P>\nReference&#32;&#35;", body):
            return True, "404-AKAMAI"

    if status // 100 == 4 or status // 100 == 5:
        return True, "%d-OTHER" % status
    return False, "%d" % status
