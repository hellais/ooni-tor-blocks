HTTP/1.0 408 xxx
Connection: close
Content-Type: text/html
Cache-Control: no-cache

<html><body><h1>408 Request Time-out</h1>
Your browser didn't send a complete request in time.
</body></html>
