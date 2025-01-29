// Sources/App/Controllers/GasolinerasController.swift
import Vapor

struct GasolinerasController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let gasolineras = routes.grouped("gasolineras")
        
        gasolineras.get(use: getGasolineras)
        gasolineras.get(":gasolineraID", use: getGasolinera)
        gasolineras.post("actualizar", use: actualizarGasolineras)
    }
}

extension GasolinerasController {
    
    @Sendable
    func getGasolineras(_ req: Request) async throws -> [Gasolinera] {
        // Obtiene todas las gasolineras desde la base de datos
        return try await Gasolinera.query(on: req.db).all()
    }
    
    @Sendable
    func getGasolinera(req: Request) async throws -> Gasolinera {
        let gasolineraID = try req.parameters.require("gasolineraID", as: UUID.self)
        guard let gasolinera = try await Gasolinera.find(gasolineraID, on: req.db) else {
            throw Abort(.notFound, reason: "Gasolinera con ID \(gasolineraID) no encontrada.")
        }
        return gasolinera
    }
    
    @Sendable
    func actualizarGasolineras(_ req: Request) async throws -> HTTPStatus {
        try await APIService.shared.fetchAndStoreGasolineras(on: req.db)
        return .ok
    }
}
