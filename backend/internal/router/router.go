package router

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(24)
			return
		}

		c.Next()
	}
}

func SetupRouter(h *TodoHandler) *gin.Engine {
	r := gin.Default()

	r.Use(CORSMiddleware())

	api := r.Group("/api")
	{
		api.POST("/todo", h.CreateTodos)
		api.GET("/all", h.GetTodos)
		api.DELETE("/todo/:id", h.DeleteTodos)

		api.GET("/healthz", func(c *gin.Context) {
			c.Status(http.StatusOK)
		})
	}

	return r
}
