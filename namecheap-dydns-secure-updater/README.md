This tool allows me to update my dynamic DNS settings in namecheap.com, for making my computer to have an name address like `mysubdomain.example.com`, using their REST API (setup required and more info at: https://www.namecheap.com/support/knowledgebase/article.aspx/29/11/how-do-i-use-a-browser-to-dynamically-update-the-hosts-ip ).  

It would also be possible to use `ddclient`, but I would have to write down my dynamic DNS password in a  plaintext file, which is not good idea. 
To understand a bit more why this is necessary, check my comments at : https://www.namecheap.com/support/knowledgebase/article.aspx/583/11/how-to-configure-ddclient#comment-3513984908 

Before, note that sensitive data is never printed, and there is no keyboard echoing. 

````
ruby enc.rb  "" "" 
multi_line_data[ data 1/3, echoing, control-D to stop]:
data_file [data 2/3]:
single_line_data[data 3/3, no echo part]: HERE YOUR DNS PW
password: HERE_A_PW_FOR_THIS_TOOL
````
This will generate some `enc.iv`  and `enc.encrypted` files, where my DNS PW is stored encrypted. protected by a password that I am using exclusively for running this tool.  It just has to be done once (unless you remove those files). 
When I connect to the internet, I run:

````
./namecheap.ddns.rb "example.com" "mysubdomain"   # @ for top-level domain @
domain:
host:
iv:
encrypted:
password: HERE_A_PW_FOR_THIS_TOOL
````

Then, I can go, from any computer connected to the internet, to the browser and access the web server set at my computer, like `http://mysubdomain.example.com`.

This tool could be reading my DNS password directly, instead of a dedicated password. But it will eventually be developed into a service -- then, instead of typing a password once per internet connection, it would be once per computer startup. Then, it will eventually be connected to another authentication service / keying, where the password would be required once per session (a single action per many services startups).

Note that, if you're behind NAT (normally after a WIFI router) you still need to configure it to forward traffic to your computer. This is only about name resolution.

