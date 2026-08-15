package config

import (
	"errors"
	"log/slog"
	"os"

	"github.com/joho/godotenv"
)

type Config struct {
	PORT   string
	HOST   string
	DB_URL string
}

func Load() (*Config, error) {
	_ = godotenv.Load()

	cfg := &Config{
		PORT:   os.Getenv("PORT"),
		HOST:   os.Getenv("HOST"),
		DB_URL: os.Getenv("DB_URL"),
	}

	if cfg.PORT == "" || cfg.HOST == "" || cfg.DB_URL == "" {
		slog.Warn("some env's have gone missing", "warning", nil)
		return nil, errors.New("some env's are missing")
	}

	return cfg, nil
}
