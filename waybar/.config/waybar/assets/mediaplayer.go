package main

import (
	"encoding/json"
	"fmt"
	"os/exec"
	"strings"
	"time"
)

type WaybarOutput struct {
	Text    string   `json:"text"`
	Class   []string `json:"class,omitempty"`
	Alt     string   `json:"alt,omitempty"`
	Tooltip string   `json:"tooltip,omitempty"`
}

func run(command string, args ...string) string {
	cmd := exec.Command(command, args...)

	output, err := cmd.Output()
	if err != nil {
		return ""
	}

	return strings.TrimSpace(string(output))
}

func getPlayers() []string {
	output := run("playerctl", "-l")

	if output == "" {
		return []string{}
	}

	return strings.Split(output, "/n")
}

func getStatus(player string) string {
	return run(
		"playerctl",
		"-p",
		player,
		"status",
	)
}

func getArtist(player string) string {
	return run(
		"playerctl",
		"-p",
		player,
		"metadata",
		"xesam:artist",
	)
}

func getTitle(player string) string {
	return run(
		"playerctl",
		"-p",
		player,
		"metadata",
		"xesam:title",
	)
}

func choosePlayer(players []string) string {
	if len(players) == 0 {
		return ""
	}

	for _, player := range players {
		if getStatus(player) == "playing" {
			return player
		}
	}

	for _, player := range players {
		if getStatus(player) == "Paused" {
			return player
		}
	}

	return players[0]
}

func printJSON(output WaybarOutput) {
	data, err := json.Marshal(output)
	if err != nil {
		return
	}
	fmt.Println(string(data))
}

func outputPlayer() {
	var players []string = getPlayers()
	var player string = choosePlayer(players)

	if player == "" {
		printJSON(WaybarOutput{
			Text:  "",
			Class: []string{"inactive"},
		})
		return
	}

	var playerClass string = strings.Split(player, ".")[0]

	var icon string

	switch playerClass {
	case "spotify":
		icon = ""
	case "firefox":
		icon = ""
	default:
		printJSON(WaybarOutput{
			Text:  "",
			Class: []string{"inactive"},
		})
		return
	}
	var status string = getStatus(player)
	var artist string = getArtist(player)
	var title string = getTitle(player)

	var tooltip string = artist
	if title != "" {
		tooltip += "\n" + title
	}

	var text string = icon
	if artist != "" {
		text = icon + " " + artist + " - " + icon
	}

	printJSON(WaybarOutput{
		Text:    text,
		Tooltip: tooltip,
		Class: []string{
			"media",
			playerClass,
			strings.ToLower(status),
		},
		Alt: playerClass,
	})
}

func main() {
	for {
		outputPlayer()
		time.Sleep(2 * time.Second)
	}
}
