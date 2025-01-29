import Foundation
import Fluent

struct APIService {
    static let shared = APIService()
    private init() {}

    func fetchAndStoreGasolineras(on db: Database) async throws {
        let urlString = "https://sedeaplicaciones.minetur.gob.es/ServiciosRESTCarburantes/PreciosCarburantes/EstacionesTerrestres/"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Verificar código de respuesta HTTP
        if let httpResponse = response as? HTTPURLResponse {
            guard (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }

        // Decodificar JSON
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        let respuestaAPI = try decoder.decode(RespuestaAPI.self, from: data)

        // Fecha actual
        let now = Date()
        // Fecha límite de 30 días atrás
        let cutoffDate = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now

        for gasolineraData in respuestaAPI.listaEESSPrecio {
            // Buscar o crear la gasolinera
            let gasolinera = try await Gasolinera.query(on: db)
                .filter(\.$ideess == gasolineraData.id)
                .first() ?? Gasolinera(
                    ideess: gasolineraData.id,
                    rotulo: gasolineraData.rotulo,
                    direccion: gasolineraData.direccion,
                    localidad: gasolineraData.localidad,
                    provincia: gasolineraData.provincia,
                    horario: gasolineraData.horario,
                    longitud: gasolineraData.longitud,
                    latitud: gasolineraData.latitud
                )

            if gasolinera.id == nil {
                try await gasolinera.save(on: db)
            }

            // Crear un nuevo registro de precios
            let precio = PrecioGasolina(
                gasolineraID: try gasolinera.requireID(),
                fecha: now,
                precioGasolina95: gasolineraData.precioGasolina95,
                precioGasolina98: gasolineraData.precioGasolina98,
                precioGasoleoA: gasolineraData.precioGasoleoA,
                precioGasoleoPremium: gasolineraData.precioGasoleoPremium,
                precioGLP: gasolineraData.precioGLP,
                precioGNC: gasolineraData.precioGNC,
                precioGNL: gasolineraData.precioGNL,
                precioHidrogeno: gasolineraData.precioHidrogeno,
                precioBioetanol: gasolineraData.precioBioetanol,
                precioBiodiesel: gasolineraData.precioBiodiesel,
                precioEsterMetilico: gasolineraData.precioEsterMetilico
            )
            try await precio.save(on: db)
        }

        // Eliminar registros de precios anteriores a 30 días
        try await PrecioGasolina.query(on: db)
            .filter(\.$fecha < cutoffDate)
            .delete()
    }
}
