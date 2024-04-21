defmodule Room.RoomActor do
  @moduledoc """
  This module provides the interfaces an actor to manage the chat room
  """

  @id_proccess_room :room

  def start_link do
    name_room = @id_proccess_room

    if Process.whereis(name_room) == nil do
      pid_actor_room = spawn_link(__MODULE__, :loop, [Room.new_room("Room01")])
      Process.register(pid_actor_room, name_room)
      {:ok, pid_actor_room, "success creation of <name: #{name_room}> room actor"}
    else
      {:error, Process.whereis(name_room), "The room is ready created <name: #{name_room}>"}
    end
  end

  def loop(room = %Room{}) do
    receive do
      {:add_user, pid, user} ->
        case Room.connect_participan(room, user) do
          {:ok, room, stdout} ->
            send(pid, {:ok, stdout})
            room

          {:error, room, stderror} ->
            send(pid, {:error, stderror})
            room
        end

      {:get_room, pid} ->
        send(pid, {:ok, room})
        room

      {:user_delete, pid, user} ->
        case Room.disconnect_participan(room, user) do
          {:ok, room, stdout} ->
            send(pid, {:ok, stdout})
            room

          {:error, room, stderror} ->
            send(pid, {:error, stderror})
            room
        end

      {:write_message, pid, user, message} ->
        case Room.add_message(room, user, message) do
          {:ok, room, stdout} ->
            send(pid, {:ok, stdout})
            room

          {:error, room, stderror} ->
            send(pid, {:error, stderror})
            room
        end

      {:exit, pid} ->
        result_RoomManagerStop = :pending
        result_RoomActor = exit(:normal)
        send(pid, {:exit, result_RoomActor, result_RoomManagerStop})

      _ ->
        {:error}
        # code
    end

    loop(room)
  end
end
