defmodule ChannelSpec.OutgoingTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Event

  test "outgoing without block creates basic event" do
    defmodule SimpleOutgoingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        outgoing "joined"
      end
    end

    assert SimpleOutgoingChannel.__channel_spec__().outgoing == [
             %Event{name: "joined"}
           ]
  end

  test "outgoing supports description" do
    defmodule DescriptionOutgoingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        outgoing "joined" do
          description "A user joined the room"
        end
      end
    end

    assert DescriptionOutgoingChannel.__channel_spec__().outgoing == [
             %Event{
               name: "joined",
               description: "A user joined the room"
             }
           ]
  end

  test "outgoing supports payload" do
    defmodule PayloadOutgoingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        outgoing "joined" do
          payload MyApp.JoinedPayload
        end
      end
    end

    [event] = PayloadOutgoingChannel.__channel_spec__().outgoing

    assert event.payload == MyApp.JoinedPayload
  end

  test "outgoing supports tags" do
    defmodule TaggedOutgoingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        outgoing "joined" do
          tags ["presence", "realtime"]
        end
      end
    end

    [event] = TaggedOutgoingChannel.__channel_spec__().outgoing

    assert event.tags == ["presence", "realtime"]
  end

  test "order is preserved for multiple outgoing events" do
    defmodule MultiOutgoingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        outgoing "joined"
        outgoing "message_created"
      end
    end

    assert MultiOutgoingChannel.__channel_spec__().outgoing == [
             %Event{name: "joined"},
             %Event{name: "message_created"}
           ]
  end

  test "outgoing events cannot define replies" do
    assert_raise ChannelSpec.ValidationError,
                 ~s(replies are not supported for outgoing event "joined"),
                 fn ->
                   defmodule InvalidOutgoingChannel do
                     @moduledoc false
                     use ChannelSpec

                     channel_spec do
                       topic "room:*"

                       outgoing "joined" do
                         reply :ok
                       end
                     end
                   end
                 end
  end

  test "outgoing events default replies to empty list" do
    defmodule DefaultOutgoingRepliesChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        outgoing "joined"
      end
    end

    [event] = DefaultOutgoingRepliesChannel.__channel_spec__().outgoing

    assert event.replies == []
  end
end
