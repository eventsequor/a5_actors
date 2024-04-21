# A5Actors

@autor Eder Leandro Carbonero Baquero

## CSP Communicationg sequential processes

This is a room that allow to implemented the **actors** model, we can add user, delete they and write message in the room, all information in keeping in memory. 


## How to compile and start to use in console
Execute the next command then follow the steps in the [Explanation used](#Explanation-used)
```shell
iex -S mix
```

## Explanation used


```shell
# Start Chat is mandatory execute this method before all
Chat.start()

# Define some user
user = "MyFirstUser"

# Add user to chat or register it
Chat.add_user(user)

# Writte some message on the Room Chat
# Send the user and message
Chat.write_message(user. "This is my first message")

# Delete user
Chat.user_delete(user)

# If you want to look the chat information you can execute, this return a struct of the room with the last information registered 
Chat.get_room()
```

## Example use console output

```shell
iex(1)> Chat.start(true)
{:ok, #PID<0.148.0>, "success creation of <name: room> room actor"}
iex(2)> Chat.add_user("Participan01")
Message receive:
{:add_user, #PID<0.147.0>, "Participan01"}
{:ok, "User connected successfull Participan01"}
iex(3)> Chat.write_message("Participan01", "Message one")
Message receive:
{:write_message, #PID<0.147.0>, "Participan01", "Message one"}
{:ok, "Message added"}
iex(4)> Chat.write_message("Participan01", "Message two")
Message receive:
{:write_message, #PID<0.147.0>, "Participan01", "Message two"}
{:ok, "Message added"}
iex(5)> Chat.get_room
{:ok,
 %Room{
   name: "Room01",
   participans: ["Participan01"],
   message: ["Name participan: Participan01 -:- TimeStamp: 1713665469692 -:- Message: Message one",
    "Name participan: Participan01 -:- TimeStamp: 1713665476003 -:- Message: Message two"]
 }}
iex(6)> Chat.user_delete("Participan01")
Message receive:
{:user_delete, #PID<0.147.0>, "Participan01"}
{:ok, "User disconnected successfull Participan01"}
iex(7)> Chat.write_message("Participan01", "Message two")
Message receive:
{:write_message, #PID<0.147.0>, "Participan01", "Message two"}
{:error,
 "ERROR: The participan <Participan01> should be connected to the room before to post"}
iex(8)> Chat.get_room
{:ok,
 %Room{
   name: "Room01",
   participans: [],
   message: ["Name participan: Participan01 -:- TimeStamp: 1713665469692 -:- Message: Message one",
    "Name participan: Participan01 -:- TimeStamp: 1713665476003 -:- Message: Message two"]
 }}
iex(9)>
```

## Test multiple requests, create participans an the same time

This test want to proof the all participans are create in a process a the same time are in the room and any user are lost

```shell
iex(1)> Chat.start
{:ok, #PID<0.135.0>, "success creation of <name: room> room actor"}
iex(2)> Enum.each(1..1000,fn x -> spawn(fn -> Chat.add_user("Participan#{x}") end)  end)
:ok
iex(3)> {_, room} = Chat.get_room
{:ok,
 %Room{
   name: "Room01",
   participans: ["Participan1", "Participan2", "Participan3", "Participan4",
    "Participan6", "Participan7", "Participan8", "Participan9", "Participan5",
    "Participan10", "Participan11", "Participan12", "Participan13",
    "Participan14", "Participan15", "Participan16", "Participan17",
    "Participan18", "Participan19", "Participan20", "Participan21",
    "Participan22", "Participan23", "Participan24", "Participan25",
    "Participan27", "Participan26", "Participan28", "Participan29",
    "Participan30", "Participan31", "Participan32", "Participan33",
    "Participan34", "Participan35", "Participan36", "Participan37",
    "Participan39", "Participan40", "Participan38", "Participan41",
    "Participan42", "Participan43", "Participan44", "Participan45",
    "Participan46", ...],
   message: []
 }}
iex(4)> Enum.count(room.participans)
# The number of participans was create successfully expected 1000
1000
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `a5_actors` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:a5_actors, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/a5_actors>.

