import Fluent
import Vapor

final class PrecioGasolina: Model, Content, @unchecked Sendable {
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

    @Field(key: "precio_gasoleo_a")
    var precioGasoleoA: Double?

    @Field(key: "precio_gasoleo_premium")
    var precioGasoleoPremium: Double?

    @Field(key: "precio_glp")
    var precioGLP: Double?

    @Field(key: "precio_gnc")
    var precioGNC: Double?

    @Field(key: "precio_gnl")
    var precioGNL: Double?

    @Field(key: "precio_hidrogeno")
    var precioHidrogeno: Double?

    @Field(key: "precio_bioetanol")
    var precioBioetanol: Double?

    @Field(key: "precio_biodiesel")
    var precioBiodiesel: Double?

    @Field(key: "precio_ester_metilico")
    var precioEsterMetilico: Double?

    init() {}

    init(
        gasolineraID: Gasolinera.IDValue,
        fecha: Date,
        precioGasolina95: Double?,
        precioGasolina98: Double?,
        precioGasoleoA: Double?,
        precioGasoleoPremium: Double?,
        precioGLP: Double?,
        precioGNC: Double?,
        precioGNL: Double?,
        precioHidrogeno: Double?,
        precioBioetanol: Double?,
        precioBiodiesel: Double?,
        precioEsterMetilico: Double?
    ) {
        self.$gasolinera.id = gasolineraID
        self.fecha = fecha
        self.precioGasolina95 = precioGasolina95
        self.precioGasolina98 = precioGasolina98
        self.precioGasoleoA = precioGasoleoA
        self.precioGasoleoPremium = precioGasoleoPremium
        self.precioGLP = precioGLP
        self.precioGNC = precioGNC
        self.precioGNL = precioGNL
        self.precioHidrogeno = precioHidrogeno
        self.precioBioetanol = precioBioetanol
        self.precioBiodiesel = precioBiodiesel
        self.precioEsterMetilico = precioEsterMetilico
    }
}
