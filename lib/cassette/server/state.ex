defmodule Cassette.Server.State do
  @moduledoc """
  Struct to represent the internal state of the `Cassette.Server`
  """

  alias Cassette.Config
  alias Cassette.User

  defstruct config: Config.default, tgt: {:tgt, 0, ""}, sts: %{}, validations: %{}

  @type tgt :: {:tgt, non_neg_integer(), String.t}
  @type st :: {String.t, non_neg_integer()}
  @type validation :: {User.t, non_neg_integer()}
  @type t :: %__MODULE__{config: Config.t, tgt: tgt, sts: %{String.t => st},
    validations: %{{String.t, String.t} => validation}}

  @spec put_validation(t, String.t, {non_neg_integer, User.t | nil}) :: t
  @doc """
  Updates the validation cache for the given `{service, ticket}` pair with the returned user
  """
  def put_validation(state, {service, ticket}, {user, expires_at}) do
    %{state | validations: Map.put(state.validations, {service, ticket}, {user, expires_at})}
  end

  @doc """
  Updates the tgt cache
  """
  @spec put_tgt(t, String.t, non_neg_integer()) :: t
  def put_tgt(state, tgt, expires_at) when is_binary(tgt) and is_number(expires_at) do
    %{state | tgt: {:tgt, expires_at, tgt}}
  end

  @doc """
  Updates the st cache for the given `service`
  """
  @spec put_st(t, String.t, st) :: t
  def put_st(state, service, {st, expires_at}) when is_binary(service) and is_binary(st) and is_number(expires_at) do
    %{state | sts: Map.put(state.sts, service, {st, expires_at})}
  end
end
