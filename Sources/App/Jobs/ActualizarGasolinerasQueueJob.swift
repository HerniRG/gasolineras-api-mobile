import Vapor
import Queues
import Fluent

struct ActualizarGasolinerasQueueJob: AsyncJob, ScheduledJob {
    // Implementa ScheduledJob
    struct Payload: Codable {}
    
    func dequeue(_ context: QueueContext, _ payload: Payload) async throws {
        context.logger.info("Iniciando actualización de gasolineras vía Queues...")
        do {
            try await APIService.shared.fetchAndStoreGasolineras(on: context.application.db)
            context.logger.info("Actualización de gasolineras completada.")
        } catch {
            context.logger.error("Error actualizando gasolineras: \(error)")
            throw error // Re-lanza el error para el mecanismo de reintento
        }
    }
    
    func error(_ context: QueueContext, _ error: Error, _ payload: Payload) async throws {
        context.logger.error("Error en ActualizarGasolinerasQueueJob: \(error)")
    }
    
    // Método requerido por ScheduledJob (IMPLEMENTADO)
    func run(context: QueueContext) -> EventLoopFuture<Void> {
        let promise = context.eventLoop.makePromise(of: Void.self) // Para manejar la asincronía
        
        Task { // Usa un Task para ejecutar el código asíncrono
            do {
                try await self.dequeue(context, Payload()) // Llama al método dequeue
                promise.succeed(Void())
            } catch {
                context.logger.error("Error en ActualizarGasolinerasQueueJob (run): \(error)")
                promise.fail(error)
            }
        }
        
        return promise.futureResult
    }
    
    func schedule(using builder: ScheduleBuilder) {
        builder.daily().at(.midnight) // O la configuración de cron que necesites
    }
}
