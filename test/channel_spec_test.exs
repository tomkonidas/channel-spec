defmodule ChannelSpecTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Spec

  defmodule RoomChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"
    end
  end

  test "__channel_spec__/0 returns the declared specification" do
    assert RoomChannel.__channel_spec__() == %Spec{
             topic: "room:*",
             description: nil,
             incoming: [],
             outgoing: []
           }
  end
end
