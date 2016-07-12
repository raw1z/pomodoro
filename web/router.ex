defmodule Pomodoro.Router do
  use Pomodoro.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pomodoro do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Pomodoro do
    pipe_through :api
    resources "/tasks", TaskController, except: [:new, :edit]
  end
end
