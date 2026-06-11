defmodule ChannelSpec.IncomingTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Event

  defmodule BaseChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"
    end
  end

  defmodule SimpleIncomingChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"

      incoming "join"
    end
  end

  defmodule RichIncomingChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"

      incoming "join" do
        description "User joins room"
      end
    end
  end

  test "incoming without block creates basic event" do
    assert SimpleIncomingChannel.__channel_spec__().incoming == [
             %Event{name: "join"}
           ]
  end

  test "incoming with block supports description" do
    assert RichIncomingChannel.__channel_spec__().incoming == [
             %Event{
               name: "join",
               description: "User joins room"
             }
           ]
  end

  test "order is preserved for multiple incoming events" do
    defmodule MultiIncomingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join"
        incoming "leave"
      end
    end

    assert MultiIncomingChannel.__channel_spec__().incoming == [
             %Event{name: "join"},
             %Event{name: "leave"}
           ]
  end

  test "event supports payload" do
    defmodule PayloadChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join" do
          description "User joins"
          payload MyApp.JoinPayload
        end
      end
    end

    [event] = PayloadChannel.__channel_spec__().incoming

    assert event.payload == MyApp.JoinPayload
    assert event.description == "User joins"
  end
end
