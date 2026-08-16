import axios from "axios"
import { type ApiResponse, type Todo } from "../types/types"

export const apiClient = axios.create({
    baseURL: import.meta.env.VITE_API_BASE_URL,
    headers: {
        'Content-Type': 'application/json'
    }
})

export const todoApi = {
    getAll: async (): Promise<Todo[]> => {
        const response = await apiClient.get<ApiResponse<Todo[]>>("/all")
        return response.data.data
    },

    create: async (title: string): Promise<Todo> => {
        const res = await apiClient.post<Todo>("/todo", { name: title })
        return res.data
    },

    delete: async (id: number): Promise<void> => {
        await apiClient.delete(`/todo/${id}`)
    }
}
