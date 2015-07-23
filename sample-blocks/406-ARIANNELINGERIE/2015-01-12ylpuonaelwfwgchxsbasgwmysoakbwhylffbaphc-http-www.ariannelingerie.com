HTTP/1.0 406 xxx
Content-Length: 4898
Vary: Accept-Encoding,User-Agent
Server: Apache
Connection: close
Date: Tue, 13 Jan 2015 00:51:16 GMT
Content-Type: text/html

<html>
<head>
<title>Lingerie, bras, panties, ready-to-wear, and more  | Arianne Lingerie | ariannelingerie.com</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<script type="text/javascript" src="cookie.js"></script>

	<script type="text/javascript">
	// name, value, expires, path, domain, secure
	Set_Cookie( 'ariannewelcome', 'none', '', '/', '', '' );

	// if Get_Cookie succeeds, cookies are enabled, since the cookie was successfully created.
	if ( Get_Cookie( 'ariannewelcome' ) )
	{
		cookie_set = true;
		// name, path, domain
		// make sure you use the same parameters in Set and Delete Cookie.
		Delete_Cookie('ariannewelcome', '/', '');
		window.location = 'welcome.php';
	}
	// if the Get_Cookie test fails, cookies are not enabled for this session.
	else
		cookie_set = false;
    </script>

<style>
body {
  background: #101116;
}
div.tr-menu-wrap { width: 355px; height: 45px; }

div.tr-menu-l {
float:left;
}

div.tr-menu-r {
float:right;
}

ul.trmenu { font-family: Arial, Verdana; font-size: 14px; margin: 0; padding: 0; list-style: none;}

ul.trmenu li {
    display: block;
    position: relative;
    float: left;
}
ul.trmenu li ul {
    display: none;
}
ul.trmenu li a {

	font-family: arial, sans-serif; font-weight: 400;
	font-size:	15px;
	text-transform: uppercase;
    display: block;
    text-decoration: none;
    color: #414347;
    border-top: 0 none;
    	padding: 13px 21px 13px 14px;
   /* background: #1e7c9a; */
    margin-left: 1px;
    white-space: nowrap;
}
ul.trmenu li a:hover {
background: #2c2c2c;
color: #f1acb6;
}
ul.trmenu li:hover ul {
    display: block;
    position: absolute;
    margin: 0 0px 0 -40px;
}
ul.trmenu li:hover li {
    float: none;
    font-size: 11px;
color: #f1acb6;
}
ul.trmenu li:hover a { background: #000000;     color: f1acb6; }
ul.trmenu li:hover li a:hover {
    background: #000000;
    color: #f1acb6;
}
</style>

<meta http-equiv="refresh" content="0;url=http://www.ariannelingerie.com/shop/">


<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-35049800-1']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript';

ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' :

'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore

(ga, s);
  })();

</script>

</head>

<body>
<div class="tr-menu-wrap">


			<ul class="trmenu">

			    <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie.html">LINGERIE</a>
			        <ul>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/lingerie-camisole.html">CAMISOLE</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/lingerie-panties.html">PANTIES</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/lingerie-mini-camisole.html">MINI-CAMISOLE</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/lingerie-chemise.html">CHEMISE</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/lingerie-teddy.html">TEDDY</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/bustier.html">BUSTIER</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/bustier.html">COVER-UP</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/lingerie/bras.html">BRAS</a></li>
			        </ul>
				</li>


			    <li><a href="http://www.ariannelingerie.com/shop/index.php/loungewear.html">LOUNGEWEAR</a>
			        <ul>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/loungewear/loungewear-chemise.html">CHEMISE</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/loungewear/loungewear-pant.html">PANTS</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/loungewear/loungewear-tops.html">TOPS</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/loungewear/robes.html">ROBES</a></li>
			        </ul>
				</li>


			    <li><a href="http://www.ariannelingerie.com/shop/index.php/tops.html">TOPS</a>
			        <ul>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/tops/tops-camisole.html">CAMISOLE</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/tops/tops-cardigan.html">CARDIGAN</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/tops/bolero.html">BOLERO</a></li>
			            <li><a href="http://www.ariannelingerie.com/shop/index.php/tops/bustier.html">BUSTIER</a></li>
			        </ul>
				</li>

			</ul>


</div>
</body>
</html>
