Electric Imp + Plotly REST API
================

##### Make HTTP posts with the Electric Imp and Visualize your sensor Data

You'll need to have an account with Plot.ly to begin. 

You can sign up at https://plot.ly/

Make sure to also take note of your API key.

If you don't have one, you can find it at https://plot.ly/api/key, or in your user settings tab!



##### Next, load up the agent.nut and device.nut files in the Electric Imp IDE.

This example features one sensor reading, but can easily be used to read as many sensors as you'd like. 
  
  
Once you've set up your Imp Device to send some sensor data to the Imp Agent, you'll POST to Plot.ly using the following code:  
```c
// When Device sends new readings, Run this!
device.on("new_readings" function(msg) {

    //Plotly Data Object
    local data = [{
        x = msg.time_stamp, // Time Stamp from Device
        y = msg.sensor_reading // Sensor Reading from Device
    }];

    // Plotly Layout Object
    local layout = {
        fileopt = "extend",
        filename = "Your Clever Filename",
    };

    // Setting up Data to be POSTed
    local payload = {
    un = "your_username",
    key = "your_apikey",
    origin = "plot",
    platform = "electricimp",
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

// Http Request Handler
function HttpPostWrapper (url, headers, string, log) {
  local request = http.post(url, headers, string);
  local response = request.sendsync();
  if (log)
    server.log(http.jsonencode(response));
  return response;
}
```
