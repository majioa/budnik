defmodule Budnik do
#   @moduledoc """
#   Documentation for `Budnik`.
#   """
#
#   @doc """
#   Hello world.
#
#   ## Examples
#
#      iex> Budnik.hello()
#      :world
#
#   """
#   def hello do
#      :world
#   end
#
#   def start do
#      make "NPM", "chromedriver"
#   end
#
#   def list do
#      HTTPoison.start
#      url = "https://libraries.io/api/platforms?api_key=f5ea575a1c184b18890d0b8d03d1ffeb"
#      case HTTPoison.get(url) do
#         {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#            Jason.decode!(body)
#         {:ok, %HTTPoison.Response{status_code: 404}} ->
#            IO.puts "Not found :("
#         {:error, %HTTPoison.Error{reason: reason}} ->
#            IO.inspect reason
#      end
#   end
#
#   def pkg pfm, name do
#      url = "https://libraries.io/api/#{pfm}/#{name}?api_key=f5ea575a1c184b18890d0b8d03d1ffeb"
#      case HTTPoison.get(url) do
#         {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#            { :ok, Jason.decode!(body) }
#         {:ok, %HTTPoison.Response{status_code: status}} ->
#            { :failure, status }
#         {:error, %HTTPoison.Error{reason: reason}} ->
#            { :error, reason }
#      end
#   end
#
#   def pkg_deps pfm, name do
#      url = "https://libraries.io/api/#{pfm}/#{name}/latest/dependencies?api_key=f5ea575a1c184b18890d0b8d03d1ffeb"
#      deps_req url, pfm
#   end
#
#   def pkg_deps pfm, name, version do
#      url = "https://libraries.io/api/#{pfm}/#{name}/#{version}/dependencies?api_key=f5ea575a1c184b18890d0b8d03d1ffeb"
#      deps_req url, pfm
#   end
#
#   def deps_req url, pfm do
#      case HTTPoison.get(url) do
#         {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
#            package = Jason.decode!(body)
#            deps = Enum.map(package["dependencies"], fn { x } -> pkg_deps(pfm, x["name"], x["latest_stable"]) end)
#            { :ok, deps }
#         {:ok, %HTTPoison.Response{status_code: status}} ->
#            { :failure, status }
#         {:error, %HTTPoison.Error{reason: reason}} ->
#            { :error, reason }
#      end
#   end
#
#   def make pfm, name do
#      """
#      { :ok, package } = pkg pfm, name
#      { version | rest } = package["versions"]
#      """
#      { :ok, package } = pkg_deps pfm, name
#   end
end
