HTTP/1.0 503 xxx
X-Node: web53-r4-sfo2, www_all
Accept-Ranges: bytes
Vary: User-Agent
Server: Apache
Connection: close
Date: Sun, 28 Jun 2015 07:27:30 GMT
X-Proxied: extlb1-r4-sfo2
Content-Type: text/html; charset=UTF-8
X-Mode: ro

<!doctype html>
<html>
    <head>
        <title>503 Service Unavailable</title>
        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv="Cache-Control" content="no-cache">
        <meta http-equiv="Expires" content="0">
        <link rel="shortcut icon" href="/favicon.ico" type="image/ico">
    <style type="text/css">
        html, body, div, h1, h2, p, a {
            margin: 0;
            padding: 0;
            border: 0;
            outline: 0;
            font-weight: inherit;
            font-style: inherit;
            font-size: 100%;
            font-family: inherit;
            vertical-align: baseline;
        }

        :focus {
            outline: 0;
        }

        body {
            line-height: 1;
            color: black;
            font-family: arial, 'Lucida Grande', 'Bitstream Vera Sans', verdana, sans-serif;
            font-size: 12px;
            color: #555;
            background: #fff;
        }

        p {
            margin: 0;
            padding: 0;
            text-align:left;
            font-size: 12px;
            color: #555;
            margin-bottom: 10px;
        }

        h1, h2 {
            font-weight: bold;
            color: #C41200;
        }

        h1 {
            font-size: 18px;
            margin: 0 0 5px;
            text-align:left;
        }

        h2 {
            margin:15px 0px 15px 0px;
            font-size: 1.5em;
        }

        a, a:visited {
            color: #66c;
            text-decoration: none;
        }
        a:hover {color: #555; text-decoration: underline;}

        #wrap {
            width: 990px;
            margin: 0 auto;
        }

        #header {
            height: 80px;
            background:url(//s3-media1.ak.yelpcdn.com/assets/2/www/img/8038f2b948cc/gfx/header_minified.png) no-repeat;
            position: relative;
            text-align: center;
            margin: 10px 0 0;
        }

        #header #logo {
            margin:0 auto;
        }

        #header #logo a {
            display: block;
            height: 50px;
            outline: 0;
            text-decoration: none;
            text-indent: -9999px;
            white-space: nowrap;
        }

        #content{
            padding: 10px;
            border: 1px solid #ccc;
            border-top: none;
            padding-bottom: 15px;
        }

        #content h2 {
            text-align: center;
        }

        #content p{
            text-align: center;
        }

    </style>
    </head>
    <body>
        <div id="wrap">
            <div id="header">
                <h1 id="logo">
                    <a href="/">Yelp</a>
                </h1>
            </div>

            <div id="content">
                <h2>Sorry, you're not allowed to access this page.</h2>
                <p>Your IP address is: 46.28.110.136</p>
                <p>Please retry your request and <a href="mailto:feedback+unavailable@yelp.com?subject=IP%20Block%20Message%3A%2046.28.110.136">contact Yelp</a> if you continue experiencing issues.</p>
            </div>
        </div>

        <script type="text/javascript">
          var _gaq = _gaq || [];
          _gaq.push(['_setAccount', 'UA-30501-34']);
          _gaq.push(['_trackPageview']);

          (function() {
            var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
            ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
            var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
          })();
        </script>
    </body>
</html>
