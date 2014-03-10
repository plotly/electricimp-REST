local light_sensor = hardware.pin8;
local temp_sensor = hardware.pin2;

light_sensor.configure(ANALOG_IN);
temp_sensor.configure(ANALOG_IN);


function getLight() {
    server.log("getting light");
    local supplyVoltage = hardware.voltage();
    local voltage = supplyVoltage * light_sensor.read() / 65535.0;
    return (voltage)*20;
}

function getTemp() {
    //server.log("getting temp");
    local reading = temp_sensor.read();
    local ratio = 65535.0 / reading;
    local voltage = 3300 / ratio;
    // get temperature in degrees Celsius
    local temperatureC = (voltage - 500) / 10.0;
    // convert to degrees Farenheit
    local temperatureF = (temperatureC * 9.0 / 5.0) + 32.0;
    server.log("temp: " + temperatureC);
    // set our output to desired temperature unit
    local temp = temperatureC;
    return temp;
}

function printTemp() {
    server.log(getTemp());
    imp.wakeup(1, printTemp);
}

function getSensors() {
    local supplyVoltage = hardware.voltage();

    local light_voltage = getLight();

    local temp_voltage = getTemp();

    local sensordata = {
        light_sensor_reading = light_voltage,
        temp_sensor_reading = temp_voltage,
        time_stamp = getTime()
    }
    agent.send("new_readings", sensordata);
    imp.wakeup(1800, getSensors);
}

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

function stringTime(num) {
    if (num < 10)
        return "0"+num;
    else
        return ""+num;
}

getSensors();
printTemp();
