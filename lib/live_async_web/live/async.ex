defmodule LiveAsyncWeb.AsyncTest do
  use LiveAsyncWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.flash_group flash={@flash} />
    <div class="p-5">
      <button disabled={!@btn} class="btn" phx-click="start">実行</button>
      <p class="m-2">{@text}</p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket =
      assign(socket, text: "実行ボタンを押してください")
      |> assign(btn: true)

    {:ok, socket}
  end

  def handle_event("start", _unsigned_params, socket) do
    pid = self()
    Task.start_link(fn -> run(pid) end)

    socket = assign(socket, btn: false)

    {:noreply, socket}
  end

  def run(pid) do
    1..100
    |> Enum.each(fn x -> run_sub(x, pid) end)

    Process.send(pid, {:end, "完了しました"}, [])
    :ok
  end

  def run_sub(no, pid) do
    Process.sleep(20)
    Process.send(pid, {:run, "処理中#{no} %"}, [])
  end

  def handle_info({:run, msg}, socket) do
    socket = assign(socket, text: msg)
    {:noreply, socket}
  end

  def handle_info({:end, msg}, socket) do
    socket =
      assign(socket, text: msg)
      |> assign(btn: true)

    {:noreply, socket}
  end
end
