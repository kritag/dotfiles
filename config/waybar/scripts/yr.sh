#!/bin/bash

LAT="59.90781" # Replace with your latitude
LON="10.7965"  # Replace with your longitude
URL="https://api.met.no/weatherapi/locationforecast/2.0/compact?lat=${LAT}&lon=${LON}"

# Fetch weather data
WEATHER_JSON=$(curl -s -H "User-Agent: myweatherapp" "$URL")

# Find the first future forecast (≥ now)
FUTURE_ENTRY=$(echo "$WEATHER_JSON" | jq -r '
  .properties.timeseries |
  map(. + {timestamp: (.time | fromdate)}) |
  sort_by(.timestamp) |
  map(select(.timestamp >= now)) |
  first
')

# Find the latest past forecast (if no future data is available)
PAST_ENTRY=$(echo "$WEATHER_JSON" | jq -r '
  .properties.timeseries |
  map(. + {timestamp: (.time | fromdate)}) |
  sort_by(.timestamp) |
  map(select(.timestamp < now)) |
  last
')

# Use future forecast if available, otherwise fallback to past
if [[ "$FUTURE_ENTRY" != "null" ]]; then
  LATEST_ENTRY="$FUTURE_ENTRY"
else
  LATEST_ENTRY="$PAST_ENTRY"
fi

# Extract timestamp (for debugging)
LATEST_TIMESTAMP=$(echo "$LATEST_ENTRY" | jq -r '.time')

# Extract air temperature
TEMP=$(echo "$LATEST_ENTRY" | jq -r '.data.instant.details.air_temperature' | xargs printf "%.0f")

# Extract weather condition symbol with a fallback
WEATHER_CODE=$(echo "$LATEST_ENTRY" | jq -r '
  .data.next_1_hours.summary.symbol_code // .data.next_12_hours.summary.symbol_code // empty
')
# Map weather codes to icons

case "$WEATHER_CODE" in
"clearsky_day") ICON="󰖙" ;;       # Clear sky (day)
"clearsky_night") ICON="󰖔" ;;      # Clear sky (night)
"fair_day") ICON=" " ;;           # Fair weather (day)
"fair_night") ICON=" " ;;         # Fair weather (night)
"partlycloudy_day") ICON="󰖕" ;;   # Partly cloudy (day)
"partlycloudy_night") ICON="󰼱" ;; # Partly cloudy (night)
"cloudy") ICON="󰖐 " ;;             # Cloudy
"lightrain") ICON="󰼳" ;;           # Light rain
"rain") ICON="󰖗" ;;               # Rain
"heavyrain") ICON="󰖗󰖗" ;;        # Heavy rain
"lightsnow") ICON="󰼴" ;;           # Light snow
"snow") ICON="󰖘" ;;               # Snow
"heavysnow") ICON="󰼶" ;;          # Heavy snow
"fog") ICON="󰖑" ;;                # Fog
"thunderstorm") ICON="󰙾" ;;       # Thunderstorm
*) ICON="🌍" ;;                     # Default (unknown weather)
esac
# Output to Waybar
echo "$ICON ${TEMP}°C"
