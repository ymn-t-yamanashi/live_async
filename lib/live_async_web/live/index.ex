defmodule LiveAsyncWeb.SampleLive.Index do
  use LiveAsyncWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      assign(socket, text: "実行ボタンを押してください")
      |> assign(btn: true)
      |> assign(ret: nil)

    {:ok, socket}
  end

  def handle_event("start", _, socket) do
    pid = self()

    socket =
      assign(socket, btn: false)
      |> assign(ret: nil)
      |> assign_async(:ret, fn -> run(pid) end)

    {:noreply, socket}
  end

  def run(pid) do
    1..100
    |> Enum.each(fn x -> run_sub(x, pid) end)

    Process.send(pid, {:end, "完了しました"}, [])
    {:ok, %{ret: Enum.random(1..10)}}
  end

  def run_sub(no, pid) do
    Process.sleep(20)
    Process.send(pid, {:run, "処理中#{no} %"}, [])
  end

  def handle_info({:run, msg}, socket) do
    {:noreply, assign(socket, text: msg)}
  end

  def handle_info({:end, msg}, socket) do
    socket =
      assign(socket, text: msg)
      |> assign(btn: true)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />
    <div class="p-5">
      <button disabled={!@btn} class="btn" phx-click="start">実行</button>
      <p class="m-2">{@text}</p>
      <p class="m-2">{inspect(@ret)}</p>
    </div>
    """
  end
end
