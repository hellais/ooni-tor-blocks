HTTP/1.0 403 xxx
Content-type: text/html; charset=UTF-8

<html>
<head>
<meta http-equiv="Content-Type" content="text/html">
<meta name="id" content="siteBlocked">
<title>Web Site Blocked</title>
<style type="text/css">
#shd { width:500px;position:relative;right:3px;top:3px;margin-right:3px;margin-bottom:3px;text-align:center; }
#shd .second,
#shd .third,
#shd .box { position:relative;left:-1px;top:-1px; }
#shd .first { background: #f1f0f1; }
#shd .second { background: #dbdadb; }
#shd .third { background: #b8b6b8; }
#shd .box { background:#ffffff;border:1px solid #848284;height:350px; }
.strip { width:100%;height:70px; }
.warn {
background-color:#f0d44d;
filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#fae379', endColorstr='#eed145');
background:-webkit-gradient(linear, left top, left bottom, from(#fae379), to(#eed145));
background:-moz-linear-gradient(top,  #fae379,  #eed145);
font-size:14px;
font-weight:bold;
}
#nsa_banner { position:relative;float:left; }
#alert_icon { position:relative;top:15px;left:20px;float:left; }
#alert_text { float:left;position:relative;top:25px;left:40px;width:400px; }
</style>
<script type="text/JavaScript">
var isIE7=false;
function onLoadFunc()
{
var s = document.URL;
s = s.replace(/</g, "&lt;").replace(/>/g, "&gt;");
if (s.length < 50) { s='URL: <b>'+s+'</b>'; }
else { s='URL: <b>'+s.substring(0,50)+'</b>...'; }
var o=document.getElementById("urlp");
if (o) { o.innerHTML=s; }
if (isIE7==true) {
var base="http://192.168.88.1/";
if (base.indexOf("fw_interface")>=0) {
base="";
}
o=document.getElementById("nsa_banner");
if (o) { o.src=base+"nsa_banner.gif"; }
o=document.getElementById("alert_icon");
if (o) { o.src=base+"alert_icon.gif"; }
}
}
</script>
</head>
<body onload="onLoadFunc();">
<div style="width:100%;height:100px;"></div>
<center>
<div id="shd"><div class="first"><div class="second"><div class="third">
<div class="box">
<div class="strip">

<img src="data:image/jpeg;base64,
R0lGODlhRQFDANU/APv9/bCwsaSlplVVV8fHyN3d3tLS0nd4edPo9JiZmujo6Ven1Ofz+bXY7JbI
5PT09Hm43TaVzCOLx4KDhczk8uPj5Gxtbvf5+mBhY/Dw8Lu7vBqGxavT6ozD4oqLjEKbz06i0h2I
xmCr122y2r/d76HO5yuQyY6OkIW/4FtcXn+73m5vcN/u92VlZ8DBwX1+f4WGh2hpaxeFxNfY2F9g
Yt/f4IiIiu72+6CgoZKTlICBgnJzdKysrbS1tre4uf///yH/C1hNUCBEYXRhWE1QPD94cGFja2V0
IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4
bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNS4wLWMwNjEg
NjQuMTQwOTQ5LCAyMDEwLzEyLzA3LTEwOjU3OjAxICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpy
ZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRl
c2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94
YXAvMS4wL21tLyIgeG1sbnM6c3RSZWY9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlw
ZS9SZXNvdXJjZVJlZiMiIHhtbG5zOnhtcD0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyIg
eG1wTU06T3JpZ2luYWxEb2N1bWVudElEPSJ4bXAuZGlkOjJENjlCNjAxOTkyMDY4MTE5MkIwQUQz
NDdBNzMwNTkxIiB4bXBNTTpEb2N1bWVudElEPSJ4bXAuZGlkOjI4Q0JCRUYwRDlBODExRTFCODlE
Qzg3RkIyNTc4NjIzIiB4bXBNTTpJbnN0YW5jZUlEPSJ4bXAuaWlkOjI4Q0JCRUVGRDlBODExRTFC
ODlEQzg3RkIyNTc4NjIzIiB4bXA6Q3JlYXRvclRvb2w9IkFkb2JlIFBob3Rvc2hvcCBDUzUuMSBN
YWNpbnRvc2giPiA8eG1wTU06RGVyaXZlZEZyb20gc3RSZWY6aW5zdGFuY2VJRD0ieG1wLmlpZDoz
MUREM0NEQkFGMjA2ODExOTJCMEFEMzQ3QTczMDU5MSIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRp
ZDoyRDY5QjYwMTk5MjA2ODExOTJCMEFEMzQ3QTczMDU5MSIvPiA8L3JkZjpEZXNjcmlwdGlvbj4g
PC9yZGY6UkRGPiA8L3g6eG1wbWV0YT4gPD94cGFja2V0IGVuZD0iciI/PgH//v38+/r5+Pf29fTz
8vHw7+7t7Ovq6ejn5uXk4+Lh4N/e3dzb2tnY19bV1NPS0dDPzs3My8rJyMfGxcTDwsHAv769vLu6
ubi3trW0s7KxsK+urayrqqmop6alpKOioaCfnp2cm5qZmJeWlZSTkpGQj46NjIuKiYiHhoWEg4KB
gH9+fXx7enl4d3Z1dHNycXBvbm1sa2ppaGdmZWRjYmFgX15dXFtaWVhXVlVUU1JRUE9OTUxLSklI
R0ZFRENCQUA/Pj08Ozo5ODc2NTQzMjEwLy4tLCsqKSgnJiUkIyIhIB8eHRwbGhkYFxYVFBMSERAP
Dg0MCwoJCAcGBQQDAgEAACH5BAEAAD8ALAAAAABFAUMAAAb/wJ9wSCwaj8ikcslsOp/QqHRKrVqv
2Kx2y+16v+CweEwum8/otHrNbrvf8Lh8Tq/b7/i8fs/v+/+AgYKDhIWGh4iJiouMjY6PkJGSk5Re
FwwNECASISEbnREgKCQ3AJWnqHCYIhsyrq+tr64mKqSpt7hjNw0gsiYfICIqHSMLIB8SsgskprnO
z1YUI68hCx0NN0csDSq9riEQLNDj5EwlEd8jDRdNNyULrx8k5fT1PyghriDMUe7oMhI42BvoTMUr
FAyqsBDhKiDBh6dQtArYrMqNDg0FQtz4qEQ+CfOyAOjQykRIjigRIUAXogSXkTI2gEiIq0fKShdY
yUBRUcsN/3gyOvQ8heMmpQYxP9DsgsCEDBMIcOUwKulGL5BhHLgaMZTSBKqRSGxlB4YBiE/iUn0F
6+jCNAkNxmCU4aCrpLVsGTHIt4BsmJUyItiNhDevIqRBnTBwEHWKzrSnCv8pYECBYSMQnsZtIGJB
ZxEOIP9gASKESSEMiolwKYSzZ9EO8mlEkgHHixc8/D45UeNIARszhhjw8UBIBg82f1SwYWAIgR0E
hlzgAaNAE8lEDAwIQGRAcyQPuF/RrqSAhQHoJxTnMoF7+CcKBmiYQv6HdzW9lP5wEOuVBJcANOCU
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"
id="nsa_banner" alt="SonicWALL Network Security Appliance" />

</div>
<div class="warn strip">
<img src="data:image/png;base64,
R0lGODlhKgAmAPUCAAcGCjo3HgocYj88RVBMLnBqMGRbFkhGQkdGQVdUUG5qT29tcWJfRIN5IZWM
JqyiMYqGU4mHapqVbq2nSqypeMG1RNzPLePZOuXZLvLmOdTLTNTRbOXbQ+ffVObdaurhSe3nVfDq
WvnxTfLtY/byaPn2d+zkcMO3PqqqsLCwt5KSmLm6wc3Ijf38h/Hsk/Hrp/HtuPv4p/v5t+3optzX
ptjZ39TV28jJ0Nvc4/7+xPbzyPXyz+Tl7Ojp8P386t/g5yH5BAEAAAIALAAAAAAqACYAAAb+QIFw
SCwaj8ikcslsLnsrFYrnrB55twSBsOpZv4KejfFwTQg2KtjZWzRivpwjgVs3eynCxsd3GVJedko/
Cg85Pjs7OicEdYJIPSoGLog6iX4qao9EYgwViYo6ohpompthki6KMKwwOi8OCz+nQlAEHaGiO6w6
HgYogZs8Cw4xuzA0LDQwMzAxDwmzm3gGJrs6LAoJCyzMLyYGKsF2PAkPMjquEdsDEjPvLhUEN+Nf
kZOvrOsJ7TMu/y4aLDBlpUeNABpazZAh4UCCABT8uaDhghSgNcOKMXsng8KBAQNY/KPoosWcendu
EPDwouWLhSwIBGBA0sUGDx4yFJjypdz+gxguXc5QAECBBxAWkibF8AANyiSRCriY8fLfCxclGgBw
gEGpVwwNMlXBQUDDS39XPWDI4GBrhgsYLshdaoHARSZtHLho6S+E3AsiJgB4IOICBw5/4bJd8LSI
mJVAXYy48KHyBxEnEIrg8OEwYg5xdQJbUm5CDBcmLIO4DEKEhgKsQayujBgwIxyNw6Ao0CKGh8qy
QwgnQZz4iBHCZVtGLKKAOEg19LgI8QGE8OMjiJcg4YHEdhLHhVsG3GHeUx4qILSgLjxEdu8lSmyQ
qec7+OSzQzxgbARLgu4dDGcCfPG1QBQAAKgXHwkmhDfbByRwUc8wE5RgXQgDxldCCxzGtrBBAQEU
4EGHCzoIAgckaJBADePgoMB2IDRYggkbbtjhaSXF0GELCzao3ActMMDfEDaoF1x2GvK445I8aohc
CMpdUMIEB0gjxA0MuBDDljHIkEMOXn4p5phf7vClDDJsuSQDdBCBwwIEKBDBnHTWaeeddkKgpwIE
JJCCKTyksMAABxxAQKGIJqrooogOcKhDKKRBBA843IDCpZhmqmkKKWjq6aUprJDGOD3wwEMNqKZa
Aw442KDqqzi8imqsq+LAQ260LBEEADs=" id="alert_icon" alt="Alert">
<div id="alert_text">
This site has been blocked by the network administrator.
</div>
</div>
<div>
<p id="urlp">
</p>
<p>
Block policy: <b>Default</b>
</p>
<p>
Client IP address: <b>192.168.88.197</b>
</p>
<p>
Block reason: <b>Forbidden Category "Intimate Apparel/Swimsuit"</b>
</p>
<p>
If you believe the below web site is rated incorrectly click <a href="http://cfssupport.sonicwall.com/" target='new'>here</a>.
</p>
</div>
</div>
</div></div></div></div>
</center>
</body>
</html> 