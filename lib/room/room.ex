defmodule Room do
  defstruct [:name, :participans, :message]

  def connect_participan(room = %Room{}, participan) do
    unless Enum.member?(room.participans, participan) do
      {:ok,
       %Room{
         name: room.name,
         participans: room.participans ++ [participan | []],
         message: room.message
       }, "User connected successfull #{participan}"}
    else
      {:error, room, "INFO: The participan is already connected: #{participan}"}
    end
  end

  def set_participans_list(room = %Room{}, participans_list) when is_list(participans_list) do
    %Room{
      name: room.name,
      participans: participans_list,
      message: room.message
    }
  end

  def set_message_list(room = %Room{}, message_list) when is_list(message_list) do
    %Room{
      name: room.name,
      participans: room.participans,
      message: message_list
    }
  end

  def disconnect_participan(room = %Room{}, participan) do
    if Enum.member?(room.participans, participan) do
      {:ok,
       %Room{
         name: room.name,
         participans: List.delete(room.participans, participan),
         message: room.message
       }, "User disconnected successfull #{participan}"}
    else
      {:error, room, "ERROR: The participan was not disconnected in the room: #{participan}"}
    end
  end

  def add_message(room = %Room{}, participan, message) do
    # Process.sleep(1)

    if Enum.member?(room.participans, participan) do
      message =
        "Name participan: #{participan}" <>
          " -:- TimeStamp: " <>
          to_string(:os.system_time(:millisecond)) <> " -:- Message: " <> message

      {:ok,
       %Room{
         name: room.name,
         participans: room.participans,
         message: room.message ++ [message | []]
       }, "Message added"}
    else
      {:error, room,
       "ERROR: The participan <#{participan}> should be connected to the room before to post"}
    end
  end

  def new_room(name_room) do
    %Room{name: name_room, participans: [], message: []}
  end

  # defp test do
  #  room01 = Room.new_room("Room01")
  #  get_room = fn -> room01 end
  #  room01 = Room.connect_participan(room01, "Participan 1")
  #  room01 = Room.connect_participan(room01, "Participan 2")
  #  room01 = Room.connect_participan(room01, "Participan 2")
  #  room01 = Room.add_message(room01, "Participan 2", "First message")
  #  Room.disconnect_participan(room01, "Participan 2")
  #  IO.inspect(get_room.())
  # end
end
