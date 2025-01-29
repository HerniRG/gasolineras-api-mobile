// Sources/App/Models/PrecioGasolina.swift
import Fluent
import Vapor

final class PrecioGasolina: Model, Content {
    static let schema = "precios_gasolina"
    
    @ID(key: .id)
    var id: UUID?

    @Parent(key: "gasolinera_id")
    var gasolinera: Gasolinera

    @Field(key: "fecha")
    var fecha: Date

    @Field(key: "precio_gasolina95")
    var precioGasolina95: Double?

    @Field(key: "precio_gasolina98")
    var precioGasolina98: Double?

    // Añade otros campos de precios según sea necesario

    init() {}

    init(id: UUID? = nil, gasolineraID: Gasolinera.IDValue, fecha: Date, precioGasolina95: Double?, precioGasolina98: Double?) {
        self.id = id
        self.$gasolinera.id = gasolineraID
        self.fecha = fecha
        self.precioGasolina95 = precioGasolina95
        self.precioGasolina98 = precioGasolina98
    }
}
