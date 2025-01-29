// Sources/App/Models/RespuestaAPI.swift
import Foundation

struct RespuestaAPI: Codable {
    let listaEESSPrecio: [GasolineraData]
    let nota: String?
    let fecha: String

    enum CodingKeys: String, CodingKey {
        case listaEESSPrecio = "ListaEESSPrecio"
        case nota = "Nota"
        case fecha = "Fecha"
    }
}

struct GasolineraData: Codable {
    let id: String
    let rotulo: String
    let direccion: String
    let localidad: String
    let provincia: String
    let horario: String
    let precioGasolina95: Double?
    let precioGasolina98: Double?
    let precioGasoleoA: Double?
    let precioGasoleoPremium: Double?
    let precioGLP: Double?
    let precioGNC: Double?
    let precioGNL: Double?
    let precioHidrogeno: Double?
    let precioBioetanol: Double?
    let precioBiodiesel: Double?
    let precioEsterMetilico: Double?
    let longitud: Double?
    let latitud: Double?
    
    enum CodingKeys: String, CodingKey {
        case id = "IDEESS"
        case rotulo = "Rótulo"
        case direccion = "Dirección"
        case localidad = "Localidad"
        case provincia = "Provincia"
        case horario = "Horario"
        case precioGasolina95 = "Precio Gasolina 95 E5"
        case precioGasolina98 = "Precio Gasolina 98 E5"
        case precioGasoleoA = "Precio Gasoleo A"
        case precioGasoleoPremium = "Precio Gasoleo Premium"
        case precioGLP = "Precio GLP"
        case precioGNC = "Precio Gas Natural Comprimido"
        case precioGNL = "Precio Gas Natural Licuado"
        case precioHidrogeno = "Precio Hidrogeno"
        case precioBioetanol = "Precio Bioetanol"
        case precioBiodiesel = "Precio Biodiesel"
        case precioEsterMetilico = "Precio Éster metílico"
        case longitud = "Longitud (WGS84)"
        case latitud = "Latitud"
    }
}
