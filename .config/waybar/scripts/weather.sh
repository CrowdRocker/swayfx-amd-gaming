#!/bin/bash
CITY="Lincoln"
APIKEY="8757378ef1931291f070a0ebcce431e7"
weather=$(curl -sf "http://api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$APIKEY&units=metric")
if [ "$weather" ]; then
    temp=$(echo "$weather" | jq '.main.temp' | cut -d. -f1)
    desc=$(echo "$weather" | jq -r '.weather[0].main')
    echo "$desc $temp°C"
else
    echo "N/A"
fi
