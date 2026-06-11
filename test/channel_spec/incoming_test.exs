defmodule ChannelSpec.IncomingTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Event

  defmodule RoomChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"

      incoming "join"
      incoming "leave"
    end
  end

  test "accumulates incoming events in declaration order" do
    assert RoomChannel.__channel_spec__().incoming == [
             %Event{name: "join"},
             %Event{name: "leave"}
           ]
  end
end
