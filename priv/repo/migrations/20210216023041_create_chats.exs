defmodule LiveChatApp.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:room_name, :string)
      add(:sender_id, references(:users, on_delete: :nothing))
      add(:receiver_id, references(:users, on_delete: :nothing))

      timestamps()
    end

    create table(:messages, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:user_id, references(:users, on_delete: :nothing))
      add(:chat_id, references(:chats, on_delete: :nothing, type: :uuid))
      add(:content, :text)
      add(:status, :string)

      timestamps()
    end

    create index(:chats, [:sender_id])
    create index(:chats, [:receiver_id])
    create index(:messages, [:user_id])
    create index(:messages, [:chat_id])
  end
end
