defmodule Fam.Repo.Migrations.CreateInvite do
  use Ecto.Migration

  def change do
    create table(:invites) do
      add :token, :string

      timestamps
    end

  end
end
