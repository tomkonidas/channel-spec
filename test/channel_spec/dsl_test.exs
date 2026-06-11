defmodule ChannelSpec.DSLTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Spec

  defmodule RoomChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"
      description "Chat room channel"
    end
  end

  test "builds spec with topic and description" do
    assert RoomChannel.__channel_spec__() == %Spec{
             topic: "room:*",
             description: "Chat room channel",
             incoming: [],
             outgoing: []
           }
  end
end
