defmodule Fam.User do
  use Fam.Web, :model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    timestamps
  end

  @required_fields ~w(email first_name last_name password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
