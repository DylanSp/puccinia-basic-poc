defmodule Mix.Tasks.Build.Wasm do
  use Mix.Task

  import File
  import Path
  import System

  @shortdoc "Builds WebAssembly artifacts and puts them in the deployed assets folder"

  @moduledoc """
  This is where we would put any long form documentation and doctests.
  """

  def run(_args) do
    project_name = "pucciniabasicpoc"
    native_folder_name = "#{project_name}_rs"

    cmd("wasm-pack", ["build", "--target", "web"], cd: "native/#{native_folder_name}")

    files = [
      "#{native_folder_name}.js",
      "#{native_folder_name}_bg.wasm"
    ]

    for file <- files do
      source_path = join(["native", native_folder_name, "pkg", file])
      target_path = join(["assets", "js", file])
      cp!(source_path, target_path)
    end
  end
end
