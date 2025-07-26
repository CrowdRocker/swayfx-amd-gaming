#!/bin/bash
CITY="London"
APIKEY="your_openweathermap_api_key"
weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$APIKEY&units=metric")
if [ "$weather" ]; then
    temp=$(echo "$weather" | jq '.main.temp' | cut -d. -f1)
    desc=$(echo "$weather" | jq -r '.weather[0].main')
    echo "$desc $temp°C"
else
    echo "N/A"
fi