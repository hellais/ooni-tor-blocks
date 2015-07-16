HTTP/1.0 520 xxx
Transfer-Encoding: chunked
Set-Cookie: __cfduid=d411e8a020230911653ecd0de2a6eb0501429056016; expires=Thu, 14-Apr-16 00:00:16 GMT; path=/; domain=.mizzima.com; HttpOnly
Expires: Thu, 01 Jan 1970 00:00:01 GMT
Server: cloudflare-nginx
Connection: close
Pragma: no-cache
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Date: Wed, 15 Apr 2015 00:00:32 GMT
X-Frame-Options: SAMEORIGIN
Content-Type: text/html; charset=UTF-8
CF-RAY: 1d735e84d5af1a6c-VIE

13f5
<!DOCTYPE html>
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en-US"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="en-US"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="en-US"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en-US"> <!--<![endif]-->
<head>
<meta http-equiv="refresh" content="0">
<meta http-equiv="set-cookie" content="cf_use_ob=80; expires=Wed, 15-Apr-15 00:01:02 GMT; path=/">
<meta http-equiv="set-cookie" content="cf_ob_info=520:1d735e84d5af1a6c:VIE; expires=Wed, 15-Apr-15 00:01:02 GMT; path=/">
<title>www.mizzima.com | 520: Web server is returning an unknown error</title>
<meta charset="UTF-8"/>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1"/>
<meta name="robots" content="noindex, nofollow"/>
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1"/>
<script type="text/javascript">
//<![CDATA[
try{if (!window.CloudFlare) {var CloudFlare=[{verbose:0,p:0,byc:0,owlid:"cf",bag2:1,mirage2:0,oracle:0,paths:{cloudflare:"/cdn-cgi/nexp/dok3v=1613a3a185/"},atok:"9672685847aae43e7a808287e4908f86",petok:"f1c2c8054f99144c6fd366fabe18e92da66c3cbd-1429056032-1800",zone:"mizzima.com",rocket:"a",apps:{}}];document.write('<script type="text/javascript" src="//ajax.cloudflare.com/cdn-cgi/nexp/dok3v=7e13c32551/cloudflare.min.js"><'+'\/script>');}}catch(e){};
//]]>
</script>
<link rel="stylesheet" id="cf_styles-css" href="/cdn-cgi/styles/cf.errors.css" type="text/css" media="screen,projection"/>
<!--[if lt IE 9]><link rel="stylesheet" id='cf_styles-ie-css' href="/cdn-cgi/styles/cf.errors.ie.css" type="text/css" media="screen,projection" /><![endif]-->
<style type="text/css">body{margin:0;padding:0}</style>
<!--[if lte IE 9]><script type="text/javascript" src="/cdn-cgi/scripts/jquery.min.js"></script><![endif]-->
<!--[if gte IE 10]><!--><script type="text/rocketscript" data-rocketsrc="/cdn-cgi/scripts/zepto.min.js"></script><!--<![endif]-->
<script type="text/rocketscript" data-rocketsrc="/cdn-cgi/scripts/cf.common.js"></script>
</head>
<body>
<div id="cf-wrapper">
<div id="cf-error-details" class="cf-error-details-wrapper">
<div class="cf-wrapper cf-error-overview">
<h1>
<span class="cf-error-type" data-translate="error">Error</span>
<span class="cf-error-code">520</span>
<small class="heading-ray-id">Ray ID: 1d735e84d5af1a6c &bull; 2015-04-15 00:00:32 UTC</small>
</h1>
<h2 class="cf-subheadline" data-translate="error_desc">Web server is returning an unknown error</h2>
</div> 
<div class="cf-section cf-highlight cf-status-display">
<div class="cf-wrapper">
<div class="cf-columns cols-3">
<div id="cf-browser-status" class="cf-column cf-status-item cf-browser-status ">
<div class="cf-icon-error-container">
<i class="cf-icon cf-icon-browser"></i>
<i class="cf-icon-status cf-icon-ok"></i>
</div>
<span class="cf-status-desc" data-translate="browser_desc">You</span>
<h3 class="cf-status-name" data-translate="browser_label">Browser</h3>
<span class="cf-status-label" data-translate="browser_status_label">Working</span>
</div>
<div id="cf-cloudflare-status" class="cf-column cf-status-item cf-cloudflare-status ">
<div class="cf-icon-error-container">
<i class="cf-icon cf-icon-cloud"></i>
<i class="cf-icon-status cf-icon-ok"></i>
</div>
<span class="cf-status-desc" data-translate="cloud_desc">Vienna</span>
<h3 class="cf-status-name" data-translate="cloud_label">CloudFlare</h3>
<span class="cf-status-label" data-translate="cloud_status_label">Working</span>
</div>
<div id="cf-host-status" class="cf-column cf-status-item cf-host-status cf-error-source">
<div class="cf-icon-error-container">
<i class="cf-icon cf-icon-server"></i>
<i class="cf-icon-status cf-icon-error"></i>
</div>
<span class="cf-status-desc" data-translate="server_desc">www.mizzima.com</span>
<h3 class="cf-status-name" data-translate="server_label">Host</h3>
<span class="cf-status-label" data-translate="server_status_label">Error</span>
</div>
</div>
</div>
</div> 
<div class="cf-section cf-wrapper">
<div class="cf-columns two">
<div class="cf-column">
<h2 data-translate="what_happened">What happened?</h2>
<p data-translate="unknown_error_desc">There is an unknown connection issue between CloudFlare and the origin web server. As a result, the web page can not be displayed.</p>
</div>
<div class="cf-column">
<h2 data-translate="what_can_i_do">What can I do?</h2>
<h5 data-translate="if_website_visitor">If you are a visitor of this website:</h5>
<p data-translate="try_again_in_a_few">Please try again in a few minutes.</p>
<h5 data-translate="if_website_owner">If you are the owner of this website:</h5>
<p><span data-translate="520_owner_desc">There is an issue between CloudFlare's cache and your origin web server. CloudFlare monitors for these errors and automatically investigates the cause. To help support the investigation, you can pull the corresponding error log from your web server and submit it our support team. Please include the Ray ID (which is at the bottom of this error page).</span> 
315
<a href="https://support.cloudflare.com/hc/en-us/articles/200171936-Error-520" data-translate="addtl_troubleshooting">Additional troubleshooting resources</a>.</p>
</div>
</div>
</div> 
<div class="cf-error-footer cf-wrapper">
<p>
<span class="cf-footer-item">CloudFlare Ray ID: <strong>1d735e84d5af1a6c</strong></span>
<span class="cf-footer-separator">&bull;</span>
<span class="cf-footer-item"><span data-translate="your_ip">Your IP</span>: 84.114.155.197</span>
<span class="cf-footer-separator">&bull;</span>
<span class="cf-footer-item"><span data-translate="performance_security_by">Performance &amp; security by</span> <a data-orig-proto="https" data-orig-ref="www.cloudflare.com/5xx-error-landing" id="brand_link" target="_blank">CloudFlare</a></span>
</p>
</div> 
</div> 
</div> 
1


0
