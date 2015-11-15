defmodule Fam.InviteTest do
  use Fam.ModelCase

  alias Fam.Invite

  @valid_attrs %{token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Invite.changeset(%Invite{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Invite.changeset(%Invite{}, @invalid_attrs)
    refute changeset.valid?
  end
end
