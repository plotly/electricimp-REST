// initialize pins
local sensor = hardware.pin1;
sensor.configure(ANALOG_IN);

// function returns voltage from pin
function getSensor() {
    server.log("getting light");
    local supplyVoltage = hardware.voltage();
    local voltage = supplyVoltage * light_sensor.read() / 65535.0;
    return (voltage);
}

// Send Sensor Data to be plotted
function sendDataToAgent() {
    local supplyVoltage = hardware.voltage();
    local sensor_voltage = getSensor();

    local sensordata = {
        sensor_reading = sensor_voltage,
        time_stamp = getTime()
    }
    agent.send("new_readings", sensordata);
    // How often to make http request
    imp.wakeup(1800, sendDataToAgent);
}


// Get Time String, -14400 is for -4 GMT (Montreal)
// use 3600 and multiply by the hours +/- GMT.
// e.g for +5 GMT local date = date(time()+18000, "u");
function getTime() {
    local date = date(time()-14400, "u");
    local sec = stringTime(date["sec"]);
    local min = stringTime(date["min"]);
    local hour = stringTime(date["hour"]);
    local day = stringTime(date["day"]);
    local month = date["month"];
    local year = date["year"];
    return year+"-"+month+"-"+day+" "+hour+":"+min+":"+sec;

}

// Fix Time String
function stringTime(num) {
    if (num < 10)
        return "0"+num;
    else
        return ""+num;
}

// Initialize Loop
sendDataToAgent();

