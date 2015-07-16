HTTP/1.0 200 xxx
Content-Length: 1273
Accept-Ranges: bytes
Server: Apache/2.2.3 (CentOS)
Last-Modified: Tue, 05 May 2015 10:41:28 GMT
Connection: close
ETag: "80400d-4f9-5155352224600"
Date: Wed, 03 Jun 2015 07:52:59 GMT
Content-Type: text/html; charset=UTF-8

<!DOCTYPE html>
<html>
    <head>
        <title>Access not allowed</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width">
        <link rel="stylesheet" href="css/style.css"/>
    </head>
    <body>
        <div id="wrapper">
            <div id="header">
                <img src="css/img/logo.png" alt="">
            </div>
            <div id="body">
                <h2>Δεν επιτρέπεται η πρόσβαση σε αυτή τη σελίδα</h2>
                <h3>Η σελίδα που προσπαθήσατε να επισκευθείτε παρέχει μη αδειοδοτημένες υπηρεσίες τυχερών παιγνίων. </h3>
                <p>Για περισσότερες πληροφορίες:</p>
                <p><a href="http://www.gamingcommission.gov.gr/index.php/el/">Επιτροπή Εποπτείας και Ελέγχου Παιγνίων (Ε.Ε.Ε.Π.) </a></p>
                <p><a href="http://www.gamingcommission.gov.gr/images/epopteia-kai-elegxos/blacklist/blacklist.pdf">Κατάλογος μη αδειοδοτημένων παρόχων (black list) </a></p>
            </div>
        </div>
    </body>
</html>
