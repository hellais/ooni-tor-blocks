HTTP/1.0 403 xxx
Content-Length: 2938
Via: 1.1 varnish
Accept-Ranges: bytes
Server: Varnish
X-Pinterest-RID: 759608086890
Connection: Close
X-Varnish: 375002655
Cache-Control: no-cache
Date: Fri, 17 Apr 2015 00:17:56 GMT
Content-Type: text/html; charset=utf-8
Age: 0


<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN">
<html lang="en">
<head>
    <title>Pinterest - Forbidden</title>
    <link rel="stylesheet" href="//passets-ec.pinterest.com/css/error.css" type="text/css" media="all"></link>
    <style type="text/css">
        body {
            font-size: 24px;
            color: #B7AEB4;
            }

        body a.link,
        body h1,
        body p {
            -webkit-transition: opacity 0.5s ease-in-out;
            -moz-transition: opacity 0.5s ease-in-out;
            transition: opacity 0.5s ease-in-out;
            }

        #wrapper {
            text-align: center;
            margin: 100px auto;
            width: 594px;
            }

        a.link {
            text-shadow: 0px 1px 2px white;
            font-weight: 600;
            color: #cb2027;
            opacity: 0;
            }

        b {
            text-shadow: 0px 1px 2px white;
            font-weight: 600;
            color: #cb2027;
        }

        h1 {
            text-shadow: 0px 1px 2px white;
            font-size: 24px;
            opacity: 0;
            }

        img {
            -webkit-transition: opacity 1s ease-in-out;
            -moz-transition: opacity 1s ease-in-out;
            transition: opacity 1s ease-in-out;
            opacity: 0;
            }

        p {
            text-shadow: 0px 1px 2px white;
            font-weight: normal;
            font-weight: 200;
            opacity: 0;
            }

        .fade {
            opacity: 1;
            }

        @media only screen and (min-device-width: 320px) and (max-device-width: 480px) {
            #wrapper {
                margin: 40px auto;
                text-align: center;
                width: 280px;
                }
            }
    </style>

    <script src="//passets-ec.pinterest.com/js/jquery-1.6.2.min.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/javascript">
      $('document').ready(function() {
        if (!$.browser.msie) {
          $('img').addClass('fade').delay(800).queue(function(next) {
            $('h1, p').addClass('fade');
            $('a.link').css('opacity', 1);
            next();
          });
        } else {
          $('img, h1, p').addClass('fade');
          $('a.link').css('opacity', 1);
        }
      });
    </script>
    <link rel="icon" href="//pinterest.com/favicon.ico" type="image/x-icon" />
</head>

<body>
    <div id="wrapper">
        <img alt="Pinterest Logo" src="//passets-ec.pinterest.com/images/LogoRed.png" />
        <img alt="Robot" src="//passets-ec.pinterest.com/images/429.png" />
        <h1>Uh oh! We've found a bot</h1>
        <p>It looks like there's a bot running on your network. <a class="link" href="//help.pinterest.com/entries/22914692">Send us a message</a> with your IP address and we'll help you get going again.</p>
        <p>Your IP is: 77.109.138.42</p>
    </div>
</body>
</html>
