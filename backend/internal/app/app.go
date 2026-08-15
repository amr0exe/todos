package app

import (
	"fmt"

	"github.com/amr0exe/todos/internal/config"
	"github.com/amr0exe/todos/internal/db"
	"github.com/amr0exe/todos/internal/router"
)

func Start() {
	cfg, err := config.Load()
	if err != nil {
		return
	}

	db, err := db.Connect(cfg.DB_URL)
	if err != nil {
		return
	}

	rH := router.NewTodoHandler(db)
	r := router.SetupRouter(rH)

	url := fmt.Sprintf("%s:%s", cfg.HOST, cfg.PORT)
	r.Run(url)
}
