defmodule Fam.PageController do
  use Fam.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
