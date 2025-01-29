// Sources/App/Models/Gasolinera.swift
import Foundation
import Fluent
import Vapor

final class Gasolinera: Model, Content {
    static let schema = "gasolineras"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "ideess")
    var ideess: String

    @Field(key: "rotulo")
    var rotulo: String

    @Field(key: "direccion")
    var direccion: String

    @Field(key: "localidad")
    var localidad: String

    @Field(key: "provincia")
    var provincia: String

    @Field(key: "horario")
    var horario: String

    @Field(key: "longitud")
    var longitud: Double?

    @Field(key: "latitud")
    var latitud: Double?

    // Relaciones
    @Children(for: \.$gasolinera)
    var precios: [PrecioGasolina]

    init() {}

    // Resto del modelo igual que antes
}
