defmodule Fam.SessionView do
  use Fam.Web, :view

  require Logger

  def render("create.json", %{data: data}) do
    data
  end
end
