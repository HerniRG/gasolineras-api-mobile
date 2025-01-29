import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        return "API de Gasolineras está funcionando!"
    }

    // /api/gasolineras/*
    try app.group("api") { api in
        try api.register(collection: GasolinerasController())
    }
}
