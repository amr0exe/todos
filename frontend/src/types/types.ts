export interface Todo {
    id: number;
    name: string;
    created_at: string;
}

export interface ApiResponse<T> {
    data: T;
    message: string;
    success: boolean;
}

export interface CreateTodo {
    title: string;
}
