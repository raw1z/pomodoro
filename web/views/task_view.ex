defmodule Pomodoro.TaskView do
  use Pomodoro.Web, :view

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, Pomodoro.TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, Pomodoro.TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      descripton: task.descripton,
      done: task.done}
  end
end
