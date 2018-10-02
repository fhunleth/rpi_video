defmodule RpiVideo do
  @moduledoc """
  Documentation for RpiVideo.
  """

  @doc """
  Play a movie back fullscreen

  Pass in a path to a .h264 file.
  """
  def play(path) do
    player = Application.app_dir(:rpi_video, "/priv/rpi_video")
    System.cmd(player, [path])
  end
end
