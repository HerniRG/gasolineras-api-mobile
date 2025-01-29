import Fluent
import FluentPostgresDriver
import Vapor

// Importamos Queues y el driver para Redis
import Queues
import QueuesRedisDriver

public func configure(_ app: Application) async throws {
    // 1. Configurar PostgreSQL
    app.databases.use(.postgres(
        hostname: Environment.get("DATABASE_HOST") ?? "localhost",
        port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? 5432,
        username: Environment.get("DATABASE_USERNAME") ?? "postgres",
        password: Environment.get("DATABASE_PASSWORD") ?? "",
        database: Environment.get("DATABASE_NAME") ?? "gasolineras_db"
    ), as: .postgres)

    // 2. Migraciones
    app.migrations.add(CreateGasolinera())
    app.migrations.add(CreatePrecioGasolina())

    // 3. Configurar Queues con Redis
    // Asumiendo que Redis está en localhost:6379
    try app.queues.use(.redis(url: "redis://127.0.0.1:6379"))

    // Añadir el Job
    app.queues.add(ActualizarGasolinerasQueueJob())

    // Programar la ejecución diaria a medianoche (cron: 0 0 * * *)
    app.queues.schedule(ActualizarGasolinerasQueueJob().cron("0 0 * * *"))

    // Arrancar el worker en el mismo proceso (desarrollo / test local)
    try app.queues.startInProcessJobs(on: .default)
    try app.queues.startScheduledJobs()

    // Ejecutar las migraciones
    try await app.autoMigrate()

    // Rutas
    try routes(app)
}
