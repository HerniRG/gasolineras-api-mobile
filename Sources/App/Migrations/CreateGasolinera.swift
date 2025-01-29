import Fluent

struct CreateGasolinera: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema("gasolineras")
            .id()
            .field("ideess", .string, .required)
            .field("rotulo", .string, .required)
            .field("direccion", .string, .required)
            .field("localidad", .string, .required)
            .field("provincia", .string, .required)
            .field("horario", .string, .required)
            .field("longitud", .double)
            .field("latitud", .double)
            .unique(on: "ideess")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema("gasolineras").delete()
    }
}
