defmodule ChannelSpec.IncomingTest do
  use ExUnit.Case, async: true

  alias ChannelSpec.Event

  test "incoming without block creates basic event" do
    defmodule SimpleIncomingChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join"
      end
    end

    assert SimpleIncomingChannel.__channel_spec__().incoming == [
             %Event{name: "join"}
           ]
  end

  test "incoming with block supports description" do
    defmodule DescriptionChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join" do
          description "User joins room"
        end
      end
    end

    assert DescriptionChannel.__channel_spec__().incoming == [
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

  test "event supports tags" do
    defmodule TaggedChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join" do
          tags ["auth", "presence"]
        end
      end
    end

    [event] = TaggedChannel.__channel_spec__().incoming

    assert event.tags == ["auth", "presence"]
  end

  test "event supports multiple replies" do
    defmodule MultiReplyChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join" do
          reply :ok
          reply :error, payload: MyApp.JoinError
          reply :error, payload: MyApp.SomeOtherError, description: "Some other error"
        end
      end
    end

    [event] = MultiReplyChannel.__channel_spec__().incoming

    assert [
             %ChannelSpec.Reply{
               status: :ok
             },
             %ChannelSpec.Reply{
               status: :error,
               payload: MyApp.JoinError
             },
             %ChannelSpec.Reply{
               status: :error,
               payload: MyApp.SomeOtherError,
               description: "Some other error"
             }
           ] = event.replies
  end

  test "reply supports keyword options" do
    defmodule ReplyOptionsChannel do
      @moduledoc false
      use ChannelSpec

      channel_spec do
        topic "room:*"

        incoming "join" do
          reply :ok,
            payload: MyApp.JoinSuccess,
            description: "Successfully joined"
        end
      end
    end

    [event] = ReplyOptionsChannel.__channel_spec__().incoming

    assert [
             %ChannelSpec.Reply{
               status: :ok,
               payload: MyApp.JoinSuccess,
               description: "Successfully joined"
             }
           ] = event.replies
  end
end
