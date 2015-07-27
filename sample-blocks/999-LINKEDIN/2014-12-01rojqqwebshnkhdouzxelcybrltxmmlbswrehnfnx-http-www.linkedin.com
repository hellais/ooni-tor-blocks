HTTP/1.0 999 xxx
Content-Length: 1852
X-Li-Pop: PROD-IDB2
Set-Cookie: denial-reason-code=1,2,1; Max-Age=5
Set-Cookie: denial-client-ip=37.130.227.133; Max-Age=5
X-LI-UUID: EGdPDZexqxOgQZRgAisAAA==
Server: ATS
Date: Mon, 01 Dec 2014 08:16:10 GMT
Content-Type: text/html

<html>
<head>
  <script type="text/javascript">
  window.onload = function()
    {
      var cookies = document.cookie.split(';');
      for (var i = 0; i < cookies.length; i++)
      {
        var fields = cookies[i].split('=');
        if (fields.length == 2)
        {
          var name = fields[0].replace(/\s/g, '');
          if (name == 'denial-reason-code')
          {
            document.getElementById('denialReasonCodes').textContent = fields[1];
          }
          if (name == 'denial-client-ip')
          {
            document.getElementById('denialIp').textContent = fields[1];
          }
        }
      }
      document.getElementById('denialUrl').textContent = document.location;
      document.getElementById('denialTime').textContent = (new Date()).toString();
    }
  </script>
  <title>999: request failed</title>
  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
  <link rel="stylesheet" type="text/css" href="http://www.linkedin.com/scds/concat/common/css?h=9z3sq2jihmaimdbx7j4cn6odq" />
</head>

<body class="errorpg">

<div id="header">
  <a href="/home" ><img src="http://www.linkedin.com/scds/common/u/img/logos/logo_linkedin_119x32.png" width="119" height="32" alt="LinkedIn"></a>
</div>

<div id="main" class="error404">
  <h1>Request denied</h1>
  <p>Sorry, we are unable to serve your request at this time due to unusual traffic from your network connection.
  <br />
  <br />
  Please visit our <a href="http://help.linkedin.com/app/answers/global/id/5932/ft/eng">help page</a> and provide the information below for further assistance.</p><br />
   <b>Reason codes: </b><div id="denialReasonCodes"></div><br />
   <b>IP: </b><div id="denialIp"></div><br />
   <b>Url: </b><div id="denialUrl"></div><br />
   <b>Time: </b><div id="denialTime"></div><br />
  <br />

</div>

</body>
</html>