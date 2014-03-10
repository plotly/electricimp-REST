device.on("new_readings" function(msg) {
    local data = [{
        x = msg.time_stamp,
        y = msg.light_sensor_reading,
        type = "scatter",
        mode = "markers",
        marker = {
            size = (msg.light_sensor_reading)*2,
        }
    },
    {
        x = msg.time_stamp,
        y = msg.temp_sensor_reading,
        type = "bar"
    }];

    local layout = {
        fileopt = "extend",
        filename = "REST API Electric Imp Daylight Sensor Temp 88",
    };


    local payload = {
    un = "electricimp",
    key = "6hpu3v8jaf",
    origin = "plot",
    platform = "rest",
    args = http.jsonencode(data),
    kwargs = http.jsonencode(layout),
    version = "0.0.1"
    };
    // encode data and log
    local headers = { "Content-Type" : "application/json" };
    local body = http.urlencode(payload);
    local url = "https://plot.ly/clientresp";
    HttpPostWrapper(url, headers, body, true);
});

function HttpPostWrapper (url, headers, string, log) {

  local request = http.post(url, headers, string);
  local response = request.sendsync();
  if (log)
    server.log(http.jsonencode(response));
  return response;

}



