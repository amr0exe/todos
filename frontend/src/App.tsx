import { useState, type SubmitEvent } from "react"
import { useTodos } from "./hooks/useTodos"

function App() {

    const { todos, isLoading, isError, createTodo, removeTodo } = useTodos()
    const [title, setTitle] = useState("")

    const handleSubmit = async (e: SubmitEvent) => {
        e.preventDefault()
        if (!title.trim()) return
        await createTodo(title)
        setTitle("")
    }

    if (isLoading) return <div>loading...</div>
    if (isError) return <div>Error...</div>

    return (
        <div className="min-w-screen min-h-screen">
            <div className="flex flex-col mx-auto items-center w-1/2 h-screen gap-5">
                <h1 className="font-playfair text-6xl font-bold">Start Your Todos!!</h1>

                <form onSubmit={handleSubmit} className="flex gap-5">
                    <input type="text" value={title} onChange={(e) => setTitle(e.target.value)} className="border rounded-xs px-6 py-1.5 font-inter text-black text-sm" placeholder="write here" />
                    <button className="rounded-sm px-7 py-1.5 font-inter text-sm bg-black text-white">CRET</button>
                </form>

                <hr className="h-1 w-full" />

                <div className="w-full h-2/3 border-b flex flex-col gap-3">
                    {todos.map((todo) => (
                        <div key={todo.id} className="flex justify-center gap-5 items-center">
                            <p className="w-9/12 font-inter">{todo.name}</p>
                            <button onClick={() => removeTodo(todo.id)} className="font-jetbrains text-sm px-7 py-1.5 rounded-sm text-white bg-black">DEL</button>
                        </div>
                    ))}
                </div>

                <div className="flex gap-5">
                    <button className="font-jetbrains p-1.5 px-7 bg-black text-white rounded-sm">
                        P"RV
                    </button>

                    <button className="font-jetbrains p-1.5 px-7 bg-black text-white rounded-sm">
                        N"XT
                    </button>
                </div>
            </div>
        </div>
    )
}

export default App
