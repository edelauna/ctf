## pktriot
Use it to set up a simple tunnel to a local host server. Generally to log requests and params.

## usage
[Reference](https://packetriot.com/tutorials/posts/serveo-users/)
Pre-req: requires an account

* `pktriot configure --url` - Can omit `--url` if did not sign up via SSO
    * Follow prompts, can default to [3, 1]
* `pktriot info` to view tunnel hostname
* `pktriot tunnel http add --domain ${subdomain}.${hostname} \
--destination 127.0.0.1 --http ${desiredPort}`
* `pktriot start` - Needs to be started
* Any time routing info is changes needs to be restarted
