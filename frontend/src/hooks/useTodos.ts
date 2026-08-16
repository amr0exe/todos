import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { todoApi } from "../apis/todos";

export function useTodos() {
    const queryClient = useQueryClient()

    const todosQuery = useQuery({
        queryKey: ['todos'],
        queryFn: todoApi.getAll,
    })

    const createTodoMutation = useMutation({
        mutationFn: todoApi.create,
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['todos'] })
        }
    })

    const deleteMutation = useMutation({
        mutationFn: todoApi.delete,
        onSuccess: () => {
            queryClient.invalidateQueries({ queryKey: ['todos'] })
        }
    })

    return {
        todos: todosQuery.data ?? [],
        isLoading: todosQuery.isLoading,
        isError: todosQuery.isError ? "failed to sync todos" : null,
        createTodo: createTodoMutation.mutateAsync,
        removeTodo: deleteMutation.mutateAsync,
    }
}
