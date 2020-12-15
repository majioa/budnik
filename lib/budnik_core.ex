# based on SlackClient
defmodule BudnikCore do
   use GenServer

   def start(init_arg \\ %{}, _options \\ []) do
      {:ok, pid} = GenServer.start_link(__MODULE__, init_arg, name: __MODULE__)

#GenServer.cast(pid, :fetch)

      {:ok, pid}
   end

#   def run(pid) do
#      GenServer.call(pid, {:run})
#   end

   @impl true
   def init(state) do
      new_state = state
         |> Map.put(:me, {:ok, Nadia.get_me})
         |> Map.put(:act_at, 0)
#         |> Map.put(:act_at, DateTime.utc_now)
         |> Map.put(:chats, %{})

      schedule_fetch()

      {:ok, new_state}
   end

#   @impl true
#   def handle_call({:run}, _from_id, state) do
#      new_state = state
#         |> Map.put(:chats, state[:chats]
#            |> Map.put(_from_id, %{}))
#
#      {:ok, new_state}
#      {:reply, state, state}
#   end

#   @impl true
#   def handle_cast({:push, element}, state) do
#      {:noreply, [element | state]}
#   end

#   def handle_call({:start}, from_id, state) do
#      new_state = state
#         |> Map.put(:chats, state[:chats]
#            |> Map.put(from_id, %{}))
#
#      {:ok, new_state}
#   end
#   ##############
   # Client API #
   ##############

   defp schedule_fetch do
      # In 0,1 second
      Process.send_after(self(), :work, 1000)
   end

#   def start(_module, _init_arg, _options \\ []) do
#      GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
#   end

#   def start() do
#      GenServer.start(__MODULE__, %{}, name: __MODULE__)
#   end

#   def message(message_text, options \\ []) do
#      GenServer.cast(__MODULE__, {:message, message_text, options})
#   end

#   def stop do
#      GenServer.stop(__MODULE__)
#   end

#   def handle_cast({:message, message_text, to_id}, state) do
#      send_message(message_text, to_id)
#
#      {:noreply, state}
#   end
#
#   def handle_call({:start}, from_id, state) do
#      new_state = state
#         |> Map.put(:chats, state[:chats]
#            |> Map.put(from_id, %{}))
#
#      {:ok, new_state}
#   end

   @impl true
   def handle_cast(:fetch, state) do
      fetch(state)
   end

   @impl true
   def handle_info(:work, state) do
#      schedule_fetch()

      GenServer.cast(self(), :fetch)

      {:noreply, state}
   end

   # private

   defp send_message(message_text, to_id) do
      case Nadia.send_message(to_id, message_text) do
         {:ok, _result} ->
            :ok
         {:error, %Nadia.Model.Error{reason: "Please wait a little"}} ->
            :wait
      end
   end

   defp fetch state do
      amount = 100
      "================================" |> IO.inspect

      state[:act_at] |> IO.inspect

      fetch(state, amount)

      "------" |> IO.inspect

#      new_state = state |> Map.put(:act_at, DateTime.utc_now |> get_unix_time)
      new_state = state |> Map.put(:act_at, DateTime.utc_now |> DateTime.to_unix)

      {:noreply, new_state}
   end

   defp fetch state, amount do
      {:ok, updates} = Nadia.get_updates limit: amount

      updates
         |> Enum.reject(fn x ->
#            x.message.date() |> DateTime.from_unix |> IO.inspect
#           (x |> get_unix_time < state[:act_at])  |> IO.inspect
#            x |> get_unix_time |> IO.inspect
            x.message.date() |> IO.inspect
            x.message.date() < state[:act_at] end)
#            (x |> get_unix_time) < state[:act_at] end)
         |> Enum.map(fn x ->
            x |> parse_message end)
   end

#   defp times_compare x, y do
#   end

#   defp get_unix_time 0 do
#      {:ok, time} = 0 |> DateTime.from_unix
#
#      time
#   end

#   defp get_unix_time x do
#      {:ok, time} = x.message.date() |> DateTime.from_unix
#
#      time
#   end

   defp parse_message(m) do
      entity_type = get_entity_type m.message.entities

      entity_type |> IO.inspect
      case entity_type do
         "bot_command" -> 
            parse_bot_command(m.message.text, m.message)
         "text" -> 
            parse_text(m.message.text, m.message)
         _ ->
            send_message("Я вас не поняло.", m.message.chat.id)
         end
   end

   defp get_entity_type nil do
      "text"
   end

   defp get_entity_type [entity] do
      entity.type
   end

   defp get_entity_type [entity|_] do
      entity.type
   end

   defp parse_bot_command(text, message) do
      "command" |> IO.inspect

      [ cmd | _ ] = text |> String.split("\n")

      case cmd do
         "/start" ->
#nil
            send_message("Приветствую вас.", message.chat.id)
         true ->
            send_message("Я вас не поняло.", message.chat.id)
         end
   end

   defp parse_text(text, _message) do
      case text do
         "" ->
            nil
         _ ->
            ~s(text: #{text}) |> IO.inspect
            nil
         end

      :ok
   end
end
