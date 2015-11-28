Steps:
1. connect the adxl345: CS (3.3V) , Vcc(3.3V) , GND(common GND), SDA (GPIO 2), SDL (GPIO 0). 
2. Change the script for these field:
  * wifi name
  * wifi password
  * mqtt broker ip

3. Copy the script on the esp8266.

4. Run an mqtt broker  /usr/local/opt/mosquitto/sbin/mosquitto -p 8001
5. Run an mqtt consumer/subscriber mosquitto_sub -h 127.0.0.1 -p 8001 -t "#" (use this if you are on the broker machine)
6. Connect to the esp8266 and launch these commands:
  1. dofile("main3.lua");
  2. setup_pub();
  3. go();
