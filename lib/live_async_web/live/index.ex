defmodule LiveAsyncWeb.SampleLive.Index do
  use LiveAsyncWeb, :live_view
end

defmodule HeroComponent do
  use Phoenix.LiveComponent
  def mount(socket), do: {:ok, assign(socket, :list, [])}
  def handle_event("say_hello", _, socket), do: {:noreply, assign_async(socket, :list, &run/0)}

  # def handle_async(:list, {:ok, result_map}, socket) do
  #   # => %{list: [10]}
  #   IO.inspect(result_map, label: "Async Result Map")

  #   # result_map に含まれる値をソケットにマージする
  #   {:noreply, assign(socket, result_map)}
  # end

  def handle_async(:list, {:ok, new_list}, socket) do
    IO.inspect(new_list, label: "New List")
    # new_list は [:rand.uniform(10)] のようなリスト
    {:noreply, assign(socket, :list, new_list)}
  end

  def run() do
    Process.sleep(1000)
    new_list = [:rand.uniform(10)]
    {:ok, %{list: new_list}}
  end

  def render(assigns) do
    ~H"""
    <a href="#" phx-click="say_hello" phx-target={@myself}>
      <p>Say hello!</p>
      <p>{inspect(@list)}</p>
    </a>
    """
  end
end
