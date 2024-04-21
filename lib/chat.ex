defmodule Chat do
  @moduledoc """
  This module is a kind of interface to use the Chat,
  behind it there is an actor model that saves all the
  information about the room. Save messages, manage
  users (add or delete)
  """
  @type word() :: String.t()
  @id_process_receive_message :receiver

  @doc """
  Start the room also the agent to keep the message and the last this create
  a supervisor to manage the Channel message
  """
  def start(show_answers_in_console \\ false) do
    if show_answers_in_console do
      Process.register(spawn(fn -> receive_message() end), @id_process_receive_message)
    end

    Room.RoomActor.start_link()
  end

  @doc """
  Add a new user, if the user exist it will not save it again
  """
  @spec add_user(word()) :: :ok
  def add_user(user) do
    send(:room, {:add_user, get_id_receiver_process(), user})
  end

  @doc """
  Delete a user, but if the user was deleted or was not created then it does nothing
  """
  @spec user_delete(word()) :: :ok
  def user_delete(user) do
    send(:room, {:user_delete, get_id_receiver_process(), user})
  end

  @doc """
  This receives a user and a message to save the message, but if the user is not
   registered in the room, the message will not be saved.
  """
  @spec write_message(word(), word()) :: :ok
  def write_message(user, message) do
    send(:room, {:write_message, get_id_receiver_process(), user, message})
  end

  defp receive_message do
    receive do
      any ->
        IO.puts("Message receive:")
        IO.inspect(any)
    end

    receive_message()
  end

  defp get_id_receiver_process do
    if Process.whereis(@id_process_receive_message) == nil do
      self()
    else
      Process.whereis(@id_process_receive_message)
    end
  end

  def get_room do
    task =
      Task.async(fn ->
        receive do
          any -> any
        end
      end)

    send(:room, {:get_room, task.pid})

    Task.await(task)
  end
end
