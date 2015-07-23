import subprocess
import yaml

def yaml_load_sloppy(f):
    # This is much faster than yaml.safe_load_all.
    y = yaml.load_all(f, Loader=yaml.CSafeLoader)
    while True:
        while True:
            try:
                doc = next(y)
                break
            except StopIteration:
                return
            except yaml.scanner.ScannerError, e:
                # Skip ahead to the next line.
                while True:
                    line = f.readline()
                    if not line or line == "...\n":
                        break
                print >> sys.stderr, "%s, skipping ahead" % e
                y = yaml.load_all(f, Loader=yaml.CSafeLoader)
        yield doc

# Fix some disparate entry formats so they are common enough to work with.
def fixup_entry(doc):
    assert doc["record_type"] == "entry"

    report = doc.get("report")
    if report is not None:
        # Some old OONI reports have some of the fields one level deeper under a
        # "report" key.
        for k, v in report.items():
            assert k not in doc
            doc[k] = v
        del doc["report"]

    # Some failures can lead to there being to requests array. For example,
    #   failure: Router $BD1907CD4E72F940F934FF932549599D886F9044 not in consensus.
    doc.setdefault("requests", [])

    for request in doc["requests"]:
        if type(request["request"]["url"]) == unicode:
            request["request"]["url"] = request["request"]["url"].encode("utf-8")

    for request in doc["requests"]:
        try:
            is_tor = request["request"]["tor"]
            # Some reports have tor:true and tor_false instead of having a
            # sub-table.
            if type(is_tor) == bool:
                request["request"]["tor"] = {"is_tor": is_tor}
        except KeyError:
            # Some older reports indicate the use of Tor by a special "shttp"
            # URL scheme.
            # https://gitweb.torproject.org/ooni-probe.git/tree/ooni/templates/httpt.py?id=7888084a8be52bdee4df69ac650b84ddb90e084e#n46
            # "To perform requests over Tor you will have to use the special URL
            # schema 'shttp'. For example to request / on example.com you will
            # have to do specify as URL 'shttp://example.com/'."
            if request["request"]["url"].startswith("shttp"):
                request["request"]["url"] = "http" + request["request"]["url"][5:]
                request["request"]["tor"] = {"is_tor": True}
            else:
                request["request"]["tor"] = {"is_tor": False}

    # Older reports don't summarize the individual request errors into toplevel
    # control_failure and experiment_failure members.
    # https://gitweb.torproject.org/ooni-probe.git/commit/?id=f8b13b0b9cb1fd453c77a887726318b04ffe148e
    doc.setdefault("control_failure", None)
    doc.setdefault("experiment_failure", None)
    for request in doc["requests"]:
        failure = request.get("failure")
        if failure is not None:
            if request["request"]["tor"]["is_tor"]:
                doc["control_failure"] = failure
            else:
                doc["experiment_failure"] = failure

    for request in doc["requests"]:
        try:
            response = request["response"]
        except KeyError:
            continue

        # YAMLOO can give us either a binary string (type str) or a Unicode string
        # (type unicode, with unspecified original encoding) for the body. If it's
        # Unicode, guess the encoding was UTF-8. It might be possible to scrape the
        # Content-Type for the encoding.
        body = response["body"]
        if body is None:
            response["body"] = ""
        elif type(body) == unicode:
            response["body"] = body.encode("utf-8")

        # And some web sites use non-ASCII in headers.
        for key, values in response["headers"]:
            for i in range(len(values)):
                if type(values[i]) == unicode:
                    values[i] = values[i].encode("utf-8")

    return doc

# Return an iterator over OONI documents.
def ooni_open(f):
    yamloo = yaml_load_sloppy(f)
    for doc in yamloo:
        if doc["record_type"] == "entry":
            doc = fixup_entry(doc)
        yield doc

# Wow! Python's gzip module is slow! Uncompress with gzip instead. (Also has the
# advantage that decompression can use a separate core.)
def open_zcat(filename):
    p = subprocess.Popen(["gzip", "-dc", filename], stdout=subprocess.PIPE, bufsize=-1)
    return p.stdout

# Opens an OONI report by filename, optionally decompressing with gzip depending
# on the extension.
def ooni_open_file(filename):
    if filename.endswith(".gz"):
        f = open_zcat(filename)
    else:
        f = open(filename)
    return ooni_open(f)
