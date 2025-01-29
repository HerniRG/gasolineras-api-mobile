// Sources/App/Migrations/CreatePrecioGasolina.swift
import Fluent

struct CreatePrecioGasolina: Migration {
    func prepare(on database: Database) async throws {
        try await database.schema(PrecioGasolina.schema)
            .id()
            .field("gasolinera_id", .uuid, .required, .references(Gasolinera.schema, .id))
            .field("fecha", .date, .required)
            .field("precio_gasolina95", .double)
            .field("precio_gasolina98", .double)
            .field("precio_gasoleo_a", .double)
            .field("precio_gasoleo_premium", .double)
            .field("precio_glp", .double)
            .field("precio_gnc", .double)
            .field("precio_gnl", .double)
            .field("precio_hidrogeno", .double)
            .field("precio_bioetanol", .double)
            .field("precio_biodiesel", .double)
            .field("precio_ester_metilico", .double)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema(PrecioGasolina.schema).delete()
    }
}
