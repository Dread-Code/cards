defmodule Cards do
  @moduledoc """
    Provides methods for creating and handling a deck of cards
  """

  @doc """
    Return a list of strings represneting a deck of cards
  """
  def create_deck do
    values = ["Ace", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten"]
    suits = ["Spades", "Clubs", "Herts", "Diamonds"]

    # podemos hacer una fla list de dos maneras una es esta:
    # cards =
    #   for value <- values do
    #     for suit <- suits do
    #       "#{value} of #{suit}"
    #     end
    #   end

    # List.flatten(cards)

    # Esta es la otra forma:
    for suit <- suits, value <- values do
      "#{value} of #{suit}"
    end
  end

  @doc """
    Divides a  deck into a hand and the remainder of the deck.
    The `hand_size` argument indicates how many cardss should
    be in the hand

  ## Examples

      iex> deck = Cards.create_deck
      iex> {hand, _rest_deck} = Cards.deal(deck, 1)
      iex> hand
      ["Ace of Spades"]
  """
  def deal(deck, hand_size) do
    Enum.split(deck, hand_size)
  end

  @doc """
    Esta es una perspectiva documentada y bien explicada de como funciona Enum.shuffle()
  """
  def shuffle(array) do
    # Enum.shuffle(deck)
    randomizador =
      Enum.reduce(array, [], fn x, acc ->
        # retorna un array con una tupla que estaria conformada por un numero random y el elemento que viene en el array
        [{:rand.uniform(), x} | acc]
      end)

    # Organiza la tupla de manera ascendente
    organizador = :lists.keysort(1, randomizador)

    shuffle_unwrap(organizador, [])
  end

  # Toma el segundo elemento de la tupla y lo pone en la cabeza del array t
  defp shuffle_unwrap([{_, h} | enumerable], t) do
    shuffle_unwrap(enumerable, [h | t])
  end

  # Si pasa un array vacio [] retornara la cola t
  defp shuffle_unwrap([], t), do: t

  # -------------------------------------------------------------------------------------------

  # Tiene una guarda para cuando sea un array active otra funcion
  def filter(enumerable, fun) when is_list(enumerable) do
    filter_list(enumerable, fun)
  end

  # def filter(enumerable, fun) do
  # reduce(enumerable, [], R.filter(fun))
  # |> :lists.reverse()
  # end

  ## filter para arrays

  defp filter_list([head | tail], fun) do
    # Si head cumple con la funcion que se le pasa retornara un array
    # nuevo con ese mismo en la cabeza y concatenara la cola pero pasandole
    # revursivamente la funcion filterlist ...
    if fun.(head) do
      [head | filter_list(tail, fun)]
    else
      # ... si no, pasara solo la cola y l funcion recusivamente
      filter_list(tail, fun)
    end
  end

  # Si le llega a pasar un array vacio retornara un []
  defp filter_list([], _fun) do
    []
  end

  @doc """
    Determines whether a deck contains a given card

  ## Examples
      iex> deck = Cards.create_deck
      iex> Cards.contains?(deck, "Ace of Spades")
      true
  """
  def contains?(deck, card) do
    Enum.member?(deck, card)
  end

  def save(deck, filename) do
    binary = :erlang.term_to_binary(deck)
    File.write!(filename, binary)
  end

  def load(filename) do
    case File.read(filename) do
      {:ok, binary} -> :erlang.binary_to_term(binary)
      {:error, _reason} -> "That file does not exist"
    end
  end

  def create_hand(hand_size) do
    create_deck()
    |> shuffle()
    |> deal(hand_size)
  end
end
