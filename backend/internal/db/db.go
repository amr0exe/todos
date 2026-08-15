package db

import (
	"log/slog"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

func Connect(url string) (*gorm.DB, error) {
	db, err := gorm.Open(postgres.Open(url), &gorm.Config{})
	if err != nil {
		slog.Error("Failed connection to postgres_db", "error", nil)
		return nil, err
	}

	db.AutoMigrate(&Todo{})

	return db, err
}
