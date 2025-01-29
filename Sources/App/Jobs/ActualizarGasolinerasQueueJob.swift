import Vapor
import Queues
import Fluent

// Definimos un trabajo asíncrono para Vapor Queues
struct ActualizarGasolinerasQueueJob: AsyncJob {
    // El payload puede ser vacío si no necesitas pasar datos
    struct Payload: Codable {}

    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        context.logger.info("Iniciando actualización de gasolineras via Queues...")
        do {
            try await APIService.shared.fetchAndStoreGasolineras(on: context.application.db)
            context.logger.info("Actualización de gasolineras completada.")
        } catch {
            context.logger.error("Error al actualizar gasolineras: \\(error)")
            throw error
        }
    }

    // Manejo de errores (opcional)
    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        context.logger.error("Error en ActualizarGasolinerasQueueJob: \\(error)")
    }
}
