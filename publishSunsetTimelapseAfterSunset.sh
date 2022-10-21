#!/usr/bin/env bash
PATH="/usr/local/bin/:/usr/bin:/bin"

DATE=$(date +"%Y-%m-%d")
SUNSET_API_PROXY_URL=

SUNSET_TIME=$(curl --silent "$SUNSET_API_PROXY_URL?lat=40.730610&lng=-73.935242&date=$DATE" | jq -r '.results.sunset')
SUNSET_TIME_ET=$(TZ=US/Eastern gdate -d "$SUNSET_TIME")
SUNSET_TIME_ET_90MIN_AFTER=$(TZ=US/Eastern gdate -d "$SUNSET_TIME_ET + 90 minutes")

NOW=$(date)
DIFF=$(( $(gdate -d "$NOW" "+%s") - $(gdate -d "$SUNSET_TIME_ET_90MIN_AFTER" "+%s") ))

echo "NOW: $NOW";
echo "90 MIN AFTER SUNSET: $SUNSET_TIME_ET_90MIN_AFTER";
echo "Minutes between NOW and 90 MIN AFTER SUNSET: $((DIFF / 60))"

if [ $DIFF -le 10 ] && [ $DIFF -ge 0 ]; then
    ./publishSunsetTimelapse.sh 
fi
