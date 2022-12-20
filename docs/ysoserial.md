## ysoserial

### Installation
Requires JDK - check docker file for Java install

### Usage
`java -jar /usr/share/ysoserial.jar CommonsCollections4 'rm /home/carlos/morale.txt' | base64 -w 0`
Will generate a base64 encoded payload

 Note that not all of the gadget chains in ysoserial enable you to run arbitrary code. Instead, they may be useful for other purposes. For example, you can use the following ones to help you quickly detect insecure deserialization on virtually any server:

* The URLDNS chain triggers a DNS lookup for a supplied URL. Most importantly, it does not rely on the target application using a specific vulnerable library and works in any known Java version. This makes it the most universal gadget chain for detection purposes. If you spot a serialized object in the traffic, you can try using this gadget chain to generate an object that triggers a DNS interaction with your server. If it does, you can be sure that deserialization occurred on your target.
* JRMPClient is another universal chain that you can use for initial detection. It causes the server to try establishing a TCP connection to the supplied IP address. Note that you need to provide a raw IP address rather than a hostname. This chain may be useful in environments where all outbound traffic is firewalled, including DNS lookups. You can try generating payloads with two different IP addresses: a local one and a firewalled, external one. If the application responds immediately for a payload with a local address, but hangs for a payload with an external address, causing a delay in the response, this indicates that the gadget chain worked because the server tried to connect to the firewalled address. In this case, the subtle time difference in responses can help you to detect whether deserialization occurs on the server, even in blind cases.
