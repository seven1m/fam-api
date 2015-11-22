defmodule Fam.UserTest do
  use Fam.ModelCase

  alias Fam.User

  @valid_attrs %{email: "tim@timmorgan.org", first_name: "Tim", last_name: "Morgan", password: "password"}
  @invalid_attrs %{}

  setup do
    user = User.changeset(%User{}, @valid_attrs) |> Repo.insert!
    {:ok, %{user: user}}
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
