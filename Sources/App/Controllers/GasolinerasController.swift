import Vapor
import Fluent

struct GasolinerasController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let gasolineras = routes.grouped("gasolineras")

        gasolineras.get(use: getGasolineras)
        gasolineras.get(":gasolineraID", use: getGasolinera)
        gasolineras.post("actualizar", use: actualizarGasolineras)
    }

    // GET /api/gasolineras
    @Sendable
    func getGasolineras(_ req: Request) async throws -> [Gasolinera] {
        // Obtiene todas las gasolineras
        // (Podrías añadir joins para obtener el precio actual si lo deseas)
        return try await Gasolinera.query(on: req.db).all()
    }

    // GET /api/gasolineras/:id
    @Sendable
    func getGasolinera(_ req: Request) async throws -> Gasolinera {
        let gasolineraID = try req.parameters.require("gasolineraID", as: UUID.self)
        guard let gasolinera = try await Gasolinera.find(gasolineraID, on: req.db) else {
            throw Abort(.notFound, reason: "Gasolinera con ID \(gasolineraID) no encontrada.")
        }
        // Podrías cargar sus precios: try await gasolinera.$precios.load(on: req.db)
        return gasolinera
    }

    // POST /api/gasolineras/actualizar
    @Sendable
    func actualizarGasolineras(_ req: Request) async throws -> HTTPStatus {
        try await APIService.shared.fetchAndStoreGasolineras(on: req.db)
        return .ok
    }
}
