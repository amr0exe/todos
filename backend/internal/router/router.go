package router

import "github.com/gin-gonic/gin"

func SetupRouter(h *TodoHandler) *gin.Engine {
	r := gin.Default()

	api := r.Group("/api")
	{
		api.POST("/todo", h.CreateTodos)
		api.GET("/all", h.GetTodos)
		api.DELETE("/todo/:id", h.DeleteTodos)
	}

	return r
}
