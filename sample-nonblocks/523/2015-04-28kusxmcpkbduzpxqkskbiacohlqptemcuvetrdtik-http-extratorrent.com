HTTP/1.0 523 xxx
Transfer-Encoding: chunked
Set-Cookie: __cfduid=d3c01b83ca4ddffc8df715c6a491ead811430179235; expires=Wed, 27-Apr-16 00:00:35 GMT; path=/; domain=.extratorrent.com; HttpOnly
Expires: Thu, 01 Jan 1970 00:00:01 GMT
Server: cloudflare-nginx
Connection: close
Pragma: no-cache
Cache-Control: no-store, no-cache, must-revalidate, post-check=0, pre-check=0
Date: Tue, 28 Apr 2015 00:00:36 GMT
X-Frame-Options: SAMEORIGIN
Content-Type: text/html; charset=UTF-8
CF-RAY: 1dde7cdcae2f0cad-AMS

89c
<!DOCTYPE html>
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en-US"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="en-US"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="en-US"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en-US"> <!--<![endif]-->
<head>
<meta http-equiv="refresh" content="0">

<meta http-equiv="set-cookie" content="cf_use_ob=80; expires=Tue, 28-Apr-15 00:01:06 GMT; path=/">

<meta http-equiv="set-cookie" content="cf_ob_info=523:1dde7cdcae2f0cad:AMS; expires=Tue, 28-Apr-15 00:01:06 GMT; path=/">


<title>extratorrent.com | 523: Origin is unreachable</title>
<meta charset="UTF-8" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge,chrome=1" />
<meta name="robots" content="noindex, nofollow" />
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1" />
<link rel="stylesheet" id="cf_styles-css" href="/cdn-cgi/styles/cf.errors.css" type="text/css" media="screen,projection" />
<!--[if lt IE 9]><link rel="stylesheet" id='cf_styles-ie-css' href="/cdn-cgi/styles/cf.errors.ie.css" type="text/css" media="screen,projection" /><![endif]-->
<style type="text/css">body{margin:0;padding:0}</style>
<!--[if lte IE 9]><script type="text/javascript" src="/cdn-cgi/scripts/jquery.min.js"></script><![endif]-->
<!--[if gte IE 10]><!--><script type="text/javascript" src="/cdn-cgi/scripts/zepto.min.js"></script><!--<![endif]-->
<script type="text/javascript" src="/cdn-cgi/scripts/cf.common.js"></script>

</head>
<body>
<div id="cf-wrapper">

    

    <div id="cf-error-details" class="cf-error-details-wrapper">
        <div class="cf-wrapper cf-error-overview">
            <h1>
              <span class="cf-error-type" data-translate="error">Error</span>
              <span class="cf-error-code">523</span>
              <small class="heading-ray-id">Ray ID: 1dde7cdcae2f0cad &bull; 2015-04-28 00:00:36 UTC</small>
            </h1>
            <h2 class="cf-subheadline" data-translate="error_desc">Origin is unreachable</h2>
        </div><!-- /.error-overview -->

        <div class="cf-section cf-highlight cf-s
e4e
tatus-display">
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
  <span class="cf-status-desc" data-translate="cloud_desc">Amsterdam</span>
  <h3 class="cf-status-name" data-translate="cloud_label">CloudFlare</h3>
  <span class="cf-status-label" data-translate="cloud_status_label">Working</span>
</div>

<div id="cf-host-status" class="cf-column cf-status-item cf-host-status cf-error-source">
  <div class="cf-icon-error-container">
    <i class="cf-icon cf-icon-server"></i>
    <i class="cf-icon-status cf-icon-error"></i>
  </div>
  <span class="cf-status-desc" data-translate="server_desc">extratorrent.com</span>
  <h3 class="cf-status-name" data-translate="server_label">Host</h3>
  <span class="cf-status-label" data-translate="server_status_label">Error</span>
</div>

                </div>
            </div>
        </div><!-- /.status-display -->

        <div class="cf-section cf-wrapper">
            <div class="cf-columns two">
                <div class="cf-column">
                    <h2 data-translate="what_happened">What happened?</h2>
                    <p data-translate="origin_not_reachable">The origin web server is not reachable.</p>
                </div>

                <div class="cf-column">
                    <h2 data-translate="what_can_i_do">What can I do?</h2>
                          <h5 data-translate="if_website_visitor">If you're a visitor of this website:</h5>
      <p data-translate="try_again_in_a_few">Please try again in a few minutes.</p>

      <h5 data-translate="if_website_owner">If you're the owner of this website:</h5>
      <p><span data-translate="523_owner_desc">Check your DNS Settings. A 523 error means that CloudFlare could not reach your host web server. The most common cause is that your DNS settings are incorrect. Please contact your hosting provider to confirm your origin IP and then make sure the correct IP is listed for your A record in your CloudFlare DNS Settings page.</span> <a href="https://support.cloudflare.com/hc/en-us/articles/200171946-Error-523" data-translate="addtl_troubleshooting">Additional troubleshooting information here.</a></p>
                </div>
            </div>
        </div><!-- /.section -->

        <div class="cf-error-footer cf-wrapper">
  <p>
    <span class="cf-footer-item">CloudFlare Ray ID: <strong>1dde7cdcae2f0cad</strong></span>
    <span class="cf-footer-separator">&bull;</span>
    <span class="cf-footer-item"><span data-translate="your_ip">Your IP</span>: 130.255.73.164</span>
    <span class="cf-footer-separator">&bull;</span>
    <span class="cf-footer-item"><span data-translate="performance_security_by">Performance &amp; security by</span> <a data-orig-proto="https" data-orig-ref="www.cloudflare.com/5xx-error-landing" id="brand_link" target="_blank">CloudFlare</a></span>
    
  </p>
</div><!-- /.error-footer -->


    </div><!-- /#cf-error-details -->
</div><!-- /#cf-wrapper -->

0
