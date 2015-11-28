Steps:
- connect the adxl345: CS (3.3V) , Vcc(3.3V) , GND(common GND), SDA (GPIO 2), SDL (GPIO 0). 
- Change the script for these field:
..* wifi name
..* wifi password
..* mqtt broker ip

- Copy the script on the esp8266.

- Run an mqtt broker  /usr/local/opt/mosquitto/sbin/mosquitto -p 8001
- Run an mqtt consumer/subscriber mosquitto_sub -h 127.0.0.1 -p 8001 -t "#" (use this if you are on the broker machine)
- Connect to the esp8266 and launch these commands:
- dofile("main3.lua");
- setup_pub();
- go();
