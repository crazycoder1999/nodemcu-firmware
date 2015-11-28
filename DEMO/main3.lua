wifi.sta.disconnect();
wifi.setmode(wifi.STATION);
cfg=wifi.sta.config("YOUR_WIFINAME_HERE","YOUR_WIFI_PASSWORD_HERE",0);
ssid, password, bssid_set, bssid=wifi.sta.getconfig();
print("config " ..ssid .. " pwd " .. password .. " BSET " .. bssid_set .. " - " .. bssid);
print ("connecting");
wifi.sta.connect();
-- manca il formato dei messaggi
-- manca capire come fare mandare in loop senza che si blocchi
id = 0;
sda = 4; --gpio2 
scl = 3; --gpio0 
dev_addr = 0x53; --device address
-- initialize i2c, set pin1 as sda, set pin2 as scl
i2c.setup(id,sda,scl,i2c.SLOW)
ddelay = 40000; -- time to wait for each message
--tdelay = ( ddelay / 1000 ) + 30;
tdelay = 150;
msg = "empty";
m = nil;
brokerip = "YOUR_MQTT_BROKER_HERE";
isconnected = 0;
function sendMSG() 
	if isconnected > 0 then
		m:publish("accels",msg,0,0, nil);
	else
		print("not connected..");
	end
end

--add control to "disconnect"
function setup_pub ()
	m = nill;
	m = mqtt.Client("client", 10, "", "");
	m:on("connect", function(con) print ("ESP8266 connected") end);
	m:connect(brokerip, 8001, 0, function(conn) print("connected"); isconnected=1; end)
end

function closeme(m)
	m:close();
end

local function twoCompl(value)
	if value > 32767 then value = -(65535 - value + 1) 
	end
	return value
end 

-- user defined function: read from reg_addr content of dev_addr
function read_reg(reg_addr)
      i2c.start(id)
      i2c.address(id, dev_addr ,i2c.TRANSMITTER)
      i2c.write(id,reg_addr)
      tmr.delay(ddelay) --wait for measurment
      i2c.stop(id)
      i2c.start(id)
      i2c.address(id, dev_addr,i2c.RECEIVER)
      tmr.delay(ddelay) --wait for measurment
      c = i2c.read(id,6);
      x = twoCompl(string.byte(c,2) * 256 + string.byte(c,1));
      y = twoCompl(string.byte(c,4) * 256 + string.byte(c,3));
      z = twoCompl(string.byte(c,6) * 256 + string.byte(c,5));
      i2c.stop(id)
      return x,y,z;
end

local function writeTo(reg_addr,val) 
      i2c.start(id) -- setup the destination
      i2c.address(id, dev_addr ,i2c.TRANSMITTER)
      tmr.delay(ddelay) --wait for measurment
      i2c.write(id,reg_addr) -- registry
      tmr.delay(ddelay) --wait for measurment
      i2c.write(id,val)      -- value
      i2c.stop(id)
end

function init()
	print("Init done");
	writeTo(0x2d,0x08);
end

init();
tmr.delay(ddelay);

print(tdelay);
function go()
--	setup_pub();
	print ( wifi.sta.getip() );
	tmr.alarm(0, tdelay, 1, function()
		x,y,z = read_reg(0x32); 
		msg = '{"objtype":"producer","subtype":"accel","id":"01234","x":'..x..',"y":'..y..',"z":'..z..'}';
--		msg = " x "..x.." y ".. y .." z "..z; 
		sendMSG();
	end);
end

