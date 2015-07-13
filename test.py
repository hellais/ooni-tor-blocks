#!/usr/bin/env python

# This test script makes sure that the classify_response function correctly
# classifies the sample block pages in the sample-blocks directory.

import os
import os.path
import re
import unittest

from classify import classify_response

SAMPLE_BLOCKS_DIR = "sample-blocks"

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
    def testSampleBlocks(self):
        for dirname in os.listdir(SAMPLE_BLOCKS_DIR):
            if not os.path.isdir(os.path.join(SAMPLE_BLOCKS_DIR, dirname)):
                continue
            for basename in os.listdir(os.path.join(SAMPLE_BLOCKS_DIR, dirname)):
                filename = os.path.join(SAMPLE_BLOCKS_DIR, dirname, basename)
                if not os.path.isfile(filename):
                    continue
                response = build_response_filename(filename)
                _, class_ = classify_response(response)
                self.assertEqual(class_, dirname, "got %s but wanted %s for %s" % (class_, dirname, basename))

    def testEmpty(self):
        for code in range(0, 600):
            response = {"code": code, "headers": [], "body": ""}
            isblock, class_ = classify_response(response)
            if isblock:
                expected_class = "%d-OTHER" % code
            else:
                expected_class = "%d" % code
            self.assertEqual(class_, expected_class, "got class %s but wanted %s" % (class_, expected_class))

if __name__ == "__main__":
    unittest.main()
