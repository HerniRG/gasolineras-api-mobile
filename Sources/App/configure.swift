import Vapor
import Queues
import Fluent
import FluentPostgresDriver
import QueuesRedisDriver

public func configure(_ app: Application) async throws {
    let databaseHost = Environment.get("DATABASE_HOST") ?? "localhost"
    let databasePortString = Environment.get("DATABASE_PORT")
    let databasePort = databasePortString.flatMap(Int.init(_:)) ?? 5432
    let databaseUsername = Environment.get("DATABASE_USERNAME") ?? "postgres"
    let databasePassword = Environment.get("DATABASE_PASSWORD") ?? ""
    let databaseName = Environment.get("DATABASE_NAME") ?? "gasolineras_db"

    // 1. Crear una PostgresConfiguration
    let pgConfig = PostgresConfiguration(
        hostname: databaseHost,
        port: databasePort,
        username: databaseUsername,
        password: databasePassword,
        database: databaseName
    )

    // 2. Usar .postgres(configuration:)
    app.databases.use(.postgres(
        configuration: pgConfig
    ), as: .psql)

    // Migraciones
    app.migrations.add(CreateGasolinera())
    app.migrations.add(CreatePrecioGasolina())

    // Configurar Queues con Redis
    try app.queues.use(.redis(url: "redis://localhost:6379"))

    // Programar el AsyncJob
    _ = app.queues.schedule(ActualizarGasolinerasQueueJob())

    try app.queues.startInProcessJobs(on: .default)
    try app.queues.startScheduledJobs()

    try await app.autoMigrate()
    try routes(app)
}
