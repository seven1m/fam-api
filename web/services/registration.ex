defmodule Fam.Registration do
  import Ecto.Changeset, only: [put_change: 3]

  alias Fam.Repo
  alias Fam.Invite
  alias Fam.Password

  def create(token, changeset) do
    invite = Repo.get_by Invite, token: token
    if invite do
      changeset
      |> put_change(:crypted_password, Password.hash(changeset.params["password"]))
      |> Repo.insert()
    else
      {:error, "token invalid"}
    end
  end
end
