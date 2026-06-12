defmodule ChannelSpecTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Spec

  defmodule RoomChannel do
    @moduledoc false
    use ChannelSpec

    channel_spec do
      topic "room:*"
      description "Realtime chat rooms"
    end
  end

  describe "__channel_spec__/0" do
    test "builds spec with topic and description" do
      assert RoomChannel.__channel_spec__() == %Spec{
               topic: "room:*",
               description: "Realtime chat rooms",
               incoming: [],
               outgoing: []
             }
    end
  end
end
