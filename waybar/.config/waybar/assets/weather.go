package main

import (
	"encoding/json"
	"fmt"
	"io"
	"math"
	"net/http"
	"net/url"
	"time"
)

const CITY = "americana"
const CALIBRATION_OFFSET = 0

type GeoResponse struct {
	Results []GeoResult `json:"results"`
}

type GeoResult struct {
	Name      string  `json:"name"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

type WeatherResponse struct {
	Current CurrentWeather `json:"current"`
}

type CurrentWeather struct {
	Temperature         float64 `json:"temperature_2m"`
	ApparentTemperature float64 `json:"apparent_temperature"`
	WeatherCode         int     `json:"weather_code"`
}

type WaybarOutput struct {
	Text    string `json:"text"`
	Tooltip string `json:"tooltip"`
}

func getJson(adress string, target any) error {
	client := &http.Client{
		Timeout: 30 * time.Second,
	}

	req, err := http.NewRequest("GET", adress, nil)
	if err != nil {
		return err
	}

	req.Header.Set("User-Agent", "Waybar")

	response, err := client.Do(req)
	if err != nil {
		return err
	}

	defer response.Body.Close()

	if response.StatusCode != http.StatusOK {
		return fmt.Errorf("HTTP error: %s", response.Status)
	}

	body, err := io.ReadAll(response.Body)
	if err != nil {
		return err
	}

	err = json.Unmarshal(body, target)
	if err != nil {
		return err
	}
	return nil
}

func icon(code int) string {
	switch {
	case code == 0:
		return "☀"

	case code == 1 || code == 2:
		return "󰖕"

	case code == 3:
		return ""

	case code == 45 || code == 48:
		return "󰖑"

	case code >= 51 && code <= 67:
		return "󰖗"

	case code >= 71 && code <= 77:
		return ""

	case code >= 80 && code <= 82:
		return "󰖖"

	case code >= 95 && code <= 99:
		return ""

	default:
		return ""
	}
}

func printJSON(output WaybarOutput) {
	data, err := json.Marshal(output)
	if err != nil {
		return
	}
	fmt.Println(string(data))
}

func run() error {
	city := url.QueryEscape(CITY)

	geoURL := "https://geocoding-api.open-meteo.com/v1/search" +
		"?name=" + city +
		"&count=1&language=en&format=json"

	var geo GeoResponse

	err := getJson(geoURL, &geo)
	if err != nil {
		return err
	}

	if len(geo.Results) == 0 {
		return fmt.Errorf("city not found: %s", CITY)
	}

	result := geo.Results[0]

	weatherURL := fmt.Sprintf(
		"https://api.open-meteo.com/v1/forecast"+
			"?latitude=%f"+
			"&longitude=%f"+
			"&current=temperature_2m,apparent_temperature,weather_code"+
			"&temperature_unit=celsius"+
			"&models=gfs_seamless",
		result.Latitude,
		result.Longitude,
	)
	var weather WeatherResponse

	err = getJson(weatherURL, &weather)
	if err != nil {
		return err
	}

	current := weather.Current

	temp := int(math.Round(current.Temperature)) + CALIBRATION_OFFSET
	feels := int(math.Round(current.ApparentTemperature)) + CALIBRATION_OFFSET

	printJSON(WaybarOutput{
		Text: fmt.Sprintf(
			"󰖐 %s %d°C",
			icon(current.WeatherCode),
			temp),

		Tooltip: fmt.Sprintf(
			"%s\nTemperature: %d°C\nFeels like: %d°C",
			result.Name,
			temp,
			feels,
		),
	})
	return nil
}

func main() {
	err := run()

	if err != nil {
		printJSON(WaybarOutput{
			Text:    "Weather N/A",
			Tooltip: err.Error(),
		})
	}
}
