# **NodeMCU_Hacked** # 
Derived from version 0.9.5
This is a forked version of nodemcu-firmware: https://github.com/nodemcu/nodemcu-firmware

The changes from the original version are relatives to how MQTT "publish" is managed.

I removed the queue mechanism on publish: now message are directly sent and not ordered.

This question on stackoverflow it explains why I made this changes:
http://stackoverflow.com/questions/33414441/nodemcu-and-esp8266-slow-mqtt-publish

Check my blog for other details: http://pestohacks.blogspot.com and description of a sample project
