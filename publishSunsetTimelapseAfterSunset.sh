#!/usr/bin/env bash
PATH="/usr/local/bin/:/usr/bin:/bin"

DATE=$(date +"%Y-%m-%d")
SUNSET_API_PROXY_URL=

SUNSET_TIME=$(curl --silent "$SUNSET_API_PROXY_URL?date=$DATE" | jq -r '.results.sunset')
SUNSET_TIME_ET=$(TZ=US/Eastern gdate -d "$SUNSET_TIME")
SUNSET_TIME_ET_90MIN_AFTER=$(TZ=US/Eastern gdate -d "$SUNSET_TIME_ET + 90 minutes")

NOW=$(date)
DIFF_SECONDS=$(( $(gdate -d "$NOW" "+%s") - $(gdate -d "$SUNSET_TIME_ET_90MIN_AFTER" "+%s") ))
DIFF_MINUTES=$((DIFF_SECONDS / 60))

echo "NOW: $NOW";
echo "90 MIN AFTER SUNSET: $SUNSET_TIME_ET_90MIN_AFTER";
echo "Minutes between NOW and 90 MIN AFTER SUNSET: $DIFF_MINUTES"

if ((DIFF_MINUTES >= 0 && DIFF_MINUTES <= 10)); then
    ./publishSunsetTimelapse.sh 
fi
