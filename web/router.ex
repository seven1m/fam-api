defmodule Fam.Router do
  use Fam.Web, :router

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

  scope "/", Fam do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", Fam do
    pipe_through :api

    resources "/session", SessionController, only: [:new, :create, :delete], singleton: true
    get "/session/verify", SessionController, :verify
  end
end
