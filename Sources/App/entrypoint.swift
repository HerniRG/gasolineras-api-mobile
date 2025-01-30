import Vapor

@main
enum Entrypoint {
    static func main() async throws {
        // Detecta entorno
        var env = try Environment.detect()
        // Inicia logs
        try LoggingSystem.bootstrap(from: &env)
        
        // Crea la aplicación (async)
        let app = try await Application.make(env)
        
        do {
            // Configura la app (DB, migraciones, rutas, etc.)
            try await configure(app)
            // Ejecuta asincrónicamente la aplicación
            try await app.execute()
        } catch {
            // Si hubo error, repórtalo
            app.logger.report(error: error)
            // e intenta apagar la app
            try? await app.asyncShutdown()
            // y relanza el error
            throw error
        }

        // Si la ejecución llegó aquí sin errores, apaga la app
        try? await app.asyncShutdown()
    }
}
