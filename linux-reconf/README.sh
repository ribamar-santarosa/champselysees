With the lack of respect to the Open Closed principle and Design by Contract, 
configuring a Linux system is getting more and more chaotic.

In this script I put things to force the system to reconfigure every now 
and then. Eg. After `ibus`, my keyboard will lose its configuration and
go to a very crazy layout. So, I put in `crontab` something to reconfigure
it, while I don´ t find the time to learn all about `ibus`  (only to 
setup a keyboard).
