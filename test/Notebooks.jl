using Test
import Pluto

@testset "Existing notebooks " begin
    server = Pluto.ServerSession()

    project_dir = joinpath(@__DIR__, "..", "notebook")

    for path in readdir(project_dir)
        @testset "$path" begin
            path = normpath(joinpath(project_dir, path))

            nb = @test_nowarn Pluto.load_notebook(path)

            client = Pluto.ClientSession(Symbol("client", rand(UInt16)), nothing)
            client.connected_notebook = nb

            server.connected_clients[client.id] = client

            Pluto.update_run!(server, nb, nb.cells)
            for c in nb.cells
                @test c.errored == false
            end
        end
    end
end