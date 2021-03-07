defmodule Queryable.Repo.Migrations.AddSampleTable do
  use Ecto.Migration

  def change do
    create table(:sample) do
      add(:name, :string)
      add(:surname, :string)
      add(:age, :integer)
    end
  end
end
