using Test
import Pluto

@testset "Existing notebooks " begin
    server = Pluto.ServerSession()

    for path in readdir(joinpath(@__DIR__, "..", "notebook"), join=true)
        println(normpath(path))

        path = normpath(path)

        nb = @test_nowarn Pluto.load_notebook(path)

        client = Pluto.ClientSession(Symbol("client", rand(UInt16)), nothing)
        client.connected_notebook = nb

        server.connected_clients[client.id] = client

        # @test jl_is_runnable(server, nb)
    end
end