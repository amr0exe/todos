package router

import (
	"net/http"

	"github.com/amr0exe/todos/internal/db"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type CreateTodo struct {
	Name string `json:"name"`
}

type TodoHandler struct {
	db *gorm.DB
}

func NewTodoHandler(db *gorm.DB) *TodoHandler {
	return &TodoHandler{db: db}
}

func (h *TodoHandler) GetTodos(c *gin.Context) {
	ctx := c.Request.Context()
	todos, err := gorm.G[db.Todo](h.db).Find(ctx)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "failed fetching",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "fetching success",
		"data":    todos,
	})
}

func (h *TodoHandler) DeleteTodos(c *gin.Context) {
	id := c.Param("id")
	ctx := c.Request.Context()

	rows, err := gorm.G[db.Todo](h.db).Where("id = ?", id).Delete(ctx)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "something went wrong on server.",
		})
		return
	}
	if rows == 0 {
		c.JSON(http.StatusBadRequest, gin.H{
			"success": false,
			"message": "its empty basically",
		})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"success": true,
		"message": "deletion success",
	})
}

func (h *TodoHandler) CreateTodos(c *gin.Context) {
	var req CreateTodo
	ctx := c.Request.Context()

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"message": "missing required context",
		})
		return
	}

	todo_info := &db.Todo{
		Name: req.Name,
	}

	err := gorm.G[db.Todo](h.db).Create(ctx, todo_info)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{
			"message": "Something went wrong, Please try again!!",
		})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Creation succcess",
	})
}
