#!/usr/bin/env python

# This test script makes sure that the classify_response function correctly
# classifies the sample block pages in the sample-blocks directory.
# It also tests other helper functions.

import imp
import os
import os.path
import re
import sys
import unittest

sys.dont_write_bytecode = True # Don't write a "findblocksc" file.
findblocks = imp.load_source("findblocks", "findblocks")
from findblocks import canonicalize_url
from classify import classify_response

SAMPLE_BLOCKS_DIR = "sample-blocks"
SAMPLE_NONBLOCKS_DIR = "sample-nonblocks"

def build_response(f):
    response = {}
    status_line = f.readline().strip()
    m = re.match(r'^HTTP/1.[01] (\d\d\d)', status_line)
    response["code"] = int(m.group(1))
    response["headers"] = []
    while True:
        line = f.readline().strip()
        if not line:
            break
        m = re.match(r'^([^:]*):\s*(.*)', line)
        name, value = m.group(1), m.group(2)
        for fieldname, values in response["headers"]:
            if name.lower() == fieldname.lower():
                values.append(value)
                break
        else:
            response["headers"].append((name, [value]))
    response["body"] = f.read()
    return response

def build_response_filename(filename):
    with open(filename) as f:
        return build_response(f)

class TestClassifyResponse(unittest.TestCase):
    def sampleSub(self, path, block):
        for dirname in os.listdir(path):
            if not os.path.isdir(os.path.join(path, dirname)):
                continue
            for basename in os.listdir(os.path.join(path, dirname)):
                filename = os.path.join(path, dirname, basename)
                if not os.path.isfile(filename):
                    continue
                response = build_response_filename(filename)
                isblock, class_ = classify_response(response)
                self.assertEqual(isblock, block, "got isblocked=%s but wanted %s for %s" % (isblock, block, os.path.join(path, dirname, basename)))
                self.assertEqual(class_, dirname, "got %s but wanted %s for %s" % (class_, dirname, os.path.join(path, dirname, basename)))

    def testSampleBlocks(self):
        self.sampleSub(SAMPLE_BLOCKS_DIR, True)

    def testSampleNonBlocks(self):
        self.sampleSub(SAMPLE_NONBLOCKS_DIR, False)

    def testEmpty(self):
        for code in range(0, 600):
            response = {"code": code, "headers": [], "body": ""}
            isblock, class_ = classify_response(response)
            if isblock:
                expected_class = "%d-OTHER" % code
            else:
                expected_class = "%d" % code
            self.assertEqual(class_, expected_class, "got class %s but wanted %s" % (class_, expected_class))

class TestCanonicalizeURL(unittest.TestCase):
    def testCanonicalizeURL(self):
        self.assertEqual(canonicalize_url("http://example.com"), canonicalize_url("http://example.com/"))
        self.assertNotEqual(canonicalize_url("http://example.com"), canonicalize_url("https://example.com/"))
        self.assertNotEqual(canonicalize_url("http://example.com/foo"), canonicalize_url("http://example.com/bar"))

if __name__ == "__main__":
    unittest.main()
