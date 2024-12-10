//
//  Spanish.swift
//  GoferDriver
//
//  Created by trioangle1 on 23/11/19.
//  Copyright © 2019 Trioangle Technologies. All rights reserved.
//

import Foundation
class Spanish : LanguageProtocol{
    lazy var completedStatus : String =  { return "Terminado"}()
    lazy var endTripStatus : String =  { return "fin de viaje"}()
    lazy var beginTripStatus : String =  { return "Comience de viaje"}()
    lazy var cancelledStatus : String =  { return "Cancelado"}()
    lazy var reqStatus : String =  { return "Solicitud"}()
    lazy var pendingStatus : String =  { return "Pendiente"}()
    lazy var sheduledStatus : String =  { return "sheduled"}()
    lazy var paymentStatus : String =  { return "Pago"}()
    lazy var login : String =  { return "iniciar sesión"}()
    lazy var register : String =  { return "registro"}()
    lazy var signUp : String =  { return "Regístrate"}()
    lazy var online : String =  { return "En línea"}()
    lazy var DeclineServiceRequest : String =  { return "Etes-vous sûr de vouloir refuser cette demande de service?"}()
    lazy var quantity : String =  { return "Quantité"}()
    lazy var offline : String =  { return "Desconectado"}()
    lazy var checkStatus : String =  { return "Comprobar estado"}()
    lazy var totalTripAmount : String =  { return "TOTAL DE VIAJES CANTIDAD"}()
    lazy var totalPayout : String =  { return "pago total"}()
    lazy var tripsPayment : String =  { return "Viajes y Pagos"}()
    lazy var sunday : String =  { return "domingo"}()
    lazy var monday : String =  { return "lunes"}()
    lazy var tuesday : String =  { return "martes"}()
    lazy var wednesday : String =  { return "miércoles"}()
    lazy var thursday : String =  { return "jueves"}()
    lazy var friday : String =  { return "viernes"}()
    lazy var saturday : String =  { return "sábado"}()
    lazy var week : String =  { return "ESTA SEMANA"}()
    lazy var ok : String =  { return "Okay"}()
    lazy var m : String =  { return "METRO"}()
    lazy var tu : String =  { return "TU"}()
    lazy var w : String =  { return "W"}()
    lazy var th : String =  { return "TH"}()
    lazy var f : String =  { return "F"}()
    lazy var sa : String =  { return "SA"}()
    lazy var su : String =  { return "SU"}()
    lazy var noData : String =  { return "Vous n'avez pas fourni le service cette semaine"}()
    lazy var lastTrip : String =  { return "Último viaje"}()
    lazy var mostRecentPayout : String =  { return "desembolso más reciente:"}()
    lazy var lifetimeTrips : String =  { return "ADPIC VIDA"}()
    lazy var ratedTrips : String =  { return "ADPIC evaluar"}()
    lazy var fiveStarTrips : String =  { return "5 ESTRELLAS"}()
    lazy var yourCurrentRating : String =  { return "Usted no tiene ninguna calificación para mostrar"}()
    lazy var riderFeedBack : String =  { return "Comentarios del ciclista"}()
    lazy var checkOut : String =  { return "Consulte los comentarios de los usuarios y aprenda cómo mejorar"}()
    lazy var noVehicleAssigned : String =  { return "Ningún vehículo asignado"}()
    lazy var referral : String =  { return "Remisión"}()
    lazy var documents : String =  { return "Documentos"}()
    lazy var payout : String =  { return "Pagar"}()
    lazy var bankDetails : String =  { return "Detalles del banco"}()
    lazy var payToGofer : String =  { return "Pagar a Gofer"}()
    lazy var edit : String =  { return "EDITAR"}()
    lazy var view : String =  { return "VER"}()
    lazy var signOut : String =  { return "Desconectar"}()
    lazy var manualBookingReminder : String =  { return "Manual de Recordatorio de Reservas"}()
    lazy var manualBookingCancelled : String =  { return "Reservas Manual Cancelado"}()
    lazy var manualBookedForRide : String =  { return "Reserva realizada manualmente para el paseo"}()
    lazy var apply : String =  { return "APLICAR"}()
    lazy var amount : String =  { return "Cantidad"}()
    lazy var selectExtraFee : String =  { return "Seleccionar Descripción suplemento"}()
    lazy var applyExtraFee : String =  { return "Aplicar tarifa adicional"}()
    lazy var enterExtraFee : String =  { return "Rellena el texto de suplemento"}()
    lazy var enterOTP : String =  { return "Introduzca OTP para comenzar viaje"}()
    lazy var done : String =  { return "Hecho"}()
    lazy var cancel : String =  { return "Cancelar"}()
    lazy var weeklyStatement : String =  { return "DECLARACIÓN DE LA SEMANA"}()
    lazy var tripEarnings : String =  { return "GANANCIAS TRIP"}()
    lazy var baseFare : String =  { return "Tarifa base"}()
    lazy var accessFee : String =  { return "Tarifa de acceso"}()
    lazy var totalGoferDriverEarnings : String =  { return "Las ganancias del controlador total Gofer"}()
    lazy var cashCollected : String =  { return "efectivo cobrado"}()
    lazy var riderFaresEarned : String =  { return "tarifas jinete ganados y mantenidos."}()
    lazy var bankDeposit : String =  { return "Deposito bancario"}()
    lazy var completedTrips : String =  { return "viajes completados"}()
    lazy var dailyEarnings : String =  { return "ganancias diarias"}()
    lazy var noDailyEarnings : String =  { return "No hay ganancias diarias"}()
    lazy var bankDepositLbl : String =  { return "Deposito bancario"}()
    lazy var noTrips : String =  { return "Ningún viaje"}()
    lazy var tripDetail : String =  { return "DETALLE TRIP"}()
    lazy var tripID : String =  { return "Identificación de viaje"}()
    lazy var duration : String =  { return "DURACIÓN"}()
    lazy var distance : String =  { return "DISTANCIA"}()
    lazy var km : String =  { return "KM"}()
    lazy var mins : String =  { return "MINUTOS"}()
    lazy var tripHistory : String =  { return "Historial de disparos"}()
    lazy var pending : String =  { return "Pendiente"}()
    lazy var completed : String =  { return "Terminado"}()
    lazy var youHaveNoTrips : String =  { return "No tiene viajes de hoy"}()
    lazy var youHaveNoPastTrips : String =  { return "No tiene viajes anteriores"}()
    lazy var cancelRideVC : String =  { return "Cancelar el transporte"}()
    lazy var cancelReason : String =  { return "Cancelar razón"}()
    lazy var writeYourComment : String =  { return "Escriba su comentario ..."}()
    lazy var cancelTrip : String =  { return "CANCELAR TRIP"}()
    lazy var riderNoShow : String =  { return "Si no se presenta piloto"}()
    lazy var riderRequestedCancel : String =  { return "Piloto solicitó cancelar"}()
    lazy var wrongAddressShown : String =  { return "dirección incorrecta se muestra"}()
    lazy var involvedInAnAccident : String =  { return "Involucrado en un accidente"}()
    lazy var doNotChargeRider : String =  { return "No cargue jinete"}()
    lazy var minute : String =  { return "MINUTO"}()
    lazy var minutes : String =  { return "MINUTOS"}()
    lazy var cancellingRequest : String =  { return "Cancelación de Solicitud ..."}()
    lazy var cancelled : String =  { return "Cancelado"}()
    lazy var pleaseEnablePushNotification : String =  { return "Por favor, activa notificaciones push en la configuración de Solicitud."}()
    lazy var alreadyAccepted : String =  { return "Ya aceptada"}()
    lazy var alreadyAcceptedBySomeone : String =  { return "Ya aceptada por alguien"}()
    lazy var selectAPhoto : String =  { return "Seleccionar una foto"}()
    lazy var takePhoto : String =  { return "TOMAR FOTO"}()
    lazy var chooseFromLibrary : String =  { return "ELIGE DE LA BIBLIOTECA"}()
    lazy var firstName : String =  { return "Nombre de pila"}()
    lazy var lastName : String =  { return "Apellido"}()
    lazy var email : String =  { return "Email"}()
    lazy var phoneNumber : String =  { return "Número de teléfono"}()
    lazy var addressLineFirst : String =  { return "Dirección Línea 1"}()
    lazy var addressLineSecond : String =  { return "Dirección Línea 2"}()
    lazy var city : String =  { return "Ciudad"}()
    lazy var postalCode : String =  { return "Código postal"}()
    lazy var state : String =  { return "Estado"}()
    lazy var personalInformation : String =  { return "Informacion personal"}()
    lazy var address : String =  { return "Dirección"}()
    lazy var message : String =  { return "Mensaje"}()
    lazy var error : String =  { return "Error"}()
    lazy var deviceHasNoCamera : String =  { return "Dispositivo no tiene cámara"}()
    lazy var warning : String =  { return "Advertencia"}()
    lazy var pleaseGivePermission : String =  { return "Por favor, dar permiso de acceso foto."}()
    lazy var uploadFailed : String =  { return "Subida fallida. Inténtalo de nuevo"}()
    lazy var enRoute : String =  { return "En camino"}()
    lazy var navigate : String =  { return "NAVEGAR"}()
    lazy var cancelTripByDriver : String =  { return "cancel_trip_by_driver"}()
    lazy var cancelTrips : String =  { return "cancel_trip"}()
    lazy var hereYouCanChangeYourMap : String =  { return "Aquí puede cambiar su mapa"}()
    lazy var byClicking : String =  { return "Al hacer clic a continuación las acciones"}()
    lazy var googleMap : String =  { return "Mapa de Google"}()
    lazy var wazeMap : String =  { return "Waze Mapa"}()
    lazy var doYouWant : String =  { return "¿Quieres dirección de acceso?"}()
    lazy var pleaseInstallGoogleMapsApp : String =  { return "Por favor, instale los mapas de Google aplicación, entonces sólo se obtiene la dirección por este concepto."}()
    lazy var doYouWantToAccessdirection : String =  { return "¿Quieres dirección de acceso?"}()
    lazy var pleaseInstallWazeMapsApp : String =  { return "Por favor, instale los mapas de Waze aplicación, entonces sólo se obtiene la dirección por este concepto."}()
    lazy var networkDisconnected : String =  { return "red desconectada"}()
    lazy var rateYourRider : String =  { return "Califique su piloto"}()
    lazy var submit : String =  { return "ENVIAR"}()
    lazy var pickUp : String =  { return "RECOGER"}()
    lazy var contact : String =  { return "CONTACTO"}()
    lazy var help : String =  { return "Ayuda"}()
    lazy var about : String =  { return "Acerca de"}()
    lazy var callsOnly : String =  { return "SÓLO LLAMADAS"}()
    lazy var call : String =  { return "LLAMADA"}()
    lazy var messages : String =  { return "MENSAJE"}()
    lazy var vehicleInformation : String =  { return "INFORMACIÓN DEL VEHÍCULO"}()
    lazy var rider : String =  { return "Jinete"}()
    lazy var typeAMessage : String =  { return "Escriba un mensaje ..."}()
    lazy var noMessagesYet : String =  { return "No hay mensajes, sin embargo."}()
    lazy var country : String =  { return "País"}()
    lazy var currency : String =  { return "Moneda"}()
    lazy var bsb : String =  { return "BSB"}()
    lazy var accountNumber : String =  { return "Número de cuenta"}()
    lazy var accountHolderName : String =  { return "nombre del titular de la cuenta"}()
    lazy var addressOne : String =  { return "Dirección 1"}()
    lazy var addressTwo : String =  { return "Dirección 2"}()
    lazy var address1 : String =  { return "Adresse 1"}()
    lazy var address2 : String =  { return "Adresse 2"}()
    lazy var postal : String =  { return "Código postal"}()
    lazy var pleaseEnter : String =  { return "Por favor, introduzca el"}()
    lazy var ibanNumber : String =  { return "Número IBAN"}()
    lazy var sortCode : String =  { return "Código de clasificacion"}()
    lazy var branchCode : String =  { return "Código de sucursal"}()
    lazy var clearingCode : String =  { return "Código de compensación"}()
    lazy var transitNumber : String =  { return "Número de Tránsito"}()
    lazy var institutionNumber : String =  { return "Número institución"}()
    lazy var rountingNumber : String =  { return "Número rounting"}()
    lazy var bankName : String =  { return "Nombre del banco"}()
    lazy var branchName : String =  { return "Nombre rama"}()
    lazy var bankCode : String =  { return "Codigo bancario"}()
    lazy var accountOwnerName : String =  { return "Nombre de cuenta del propietario"}()
    lazy var pleaseUpdateDocument : String =  { return "Por favor, actualice un documento legal."}()
    lazy var gender : String =  { return "Género"}()
    lazy var male : String =  { return "Masculino"}()
    lazy var female : String =  { return "Hembra"}()
    lazy var payouts : String =  { return "pagos"}()
    lazy var choosePhoto : String =  { return "Escoge una foto"}()
    lazy var noCamera : String =  { return "Dispositivo no tiene cámara"}()
    lazy var alert : String =  { return "Alerta"}()
    lazy var cameraAccess : String =  { return "la cámara del acceso requerido para la captura de fotos!"}()
    lazy var allowCamera : String =  { return "permitir que la cámara"}()
    lazy var setupPayout : String =  { return "Configurar su método de pago UBER"}()
    lazy var uber : String =  { return "UBER"}()
    lazy var add : String =  { return "Añadir"}()
    lazy var emailID : String =  { return "Identificación de correo"}()
    lazy var pleaseEnterValidEmail : String =  { return "Por favor, introduzca el ID de correo válida"}()
    lazy var swiftCode : String =  { return "Código SWIFT / BIC"}()
    lazy var required : String =  { return "necesario"}()
    lazy var paid : String =  { return "PAGADO"}()
    lazy var waitingForPayment : String =  { return "A LA ESPERA DEL PAGO"}()
    lazy var proceed : String =  { return "PROCEDER"}()
    lazy var success : String =  { return "Éxito"}()
    lazy var riderPaid : String =  { return "Piloto pagado con éxito"}()
    lazy var paymentDetails : String =  { return "Detalles del pago"}()
    lazy var paypalEmail : String =  { return "PayPal correo electrónico de identificación"}()
    lazy var save : String =  { return "SALVAR"}()
    lazy var addNewPayout : String =  { return "Para añadir un nuevo sistema de pago. Crear un correo electrónico para su"}()
    lazy var account : String =  { return "cuenta."}()
    lazy var payment : String =  { return "Pago"}()
    lazy var addPayoutMethod : String =  { return "Agregar Pago Método"}()
    lazy var trip : String =  { return "Viaje"}()
    lazy var history : String =  { return "Historia"}()
    lazy var payStatements : String =  { return "Las declaraciones de pago"}()
    lazy var changeCreditCard : String =  { return "Cambio de crédito o tarjeta de débito"}()
    lazy var addCreditCard : String =  { return "Añadir crédito o tarjeta de débito"}()
    lazy var pleaseEnterValidCard : String =  { return "Por favor, introduzca los datos de tarjeta válida"}()
    lazy var pay : String =  { return "PAGA"}()
    lazy var change : String =  { return "CAMBIO"}()
    lazy var enterTheAmount : String =  { return "Introduce la cantidad"}()
    lazy var referralAmount : String =  { return "Cantidad de referencia"}()
    lazy var applied : String =  { return "Aplicado"}()
    lazy var addCard : String =  { return "AGREGAR TARJETA"}()
    lazy var yourPayToGofer : String =  { return "Su Pagar a Gofer"}()
    lazy var getUpto : String =  { return "Llegar a"}()
    lazy var forEveryFriend : String =  { return "por cada amigo que cabalga con"}()
    lazy var signUpGet : String =  { return "Registro y se les paga por cada referencia Regístrese y más de Espera de bonificación!"}()
    lazy var yourReferralCode : String =  { return "SU CÓDIGO DE REFERENCIA"}()
    lazy var yourInviteCode : String =  { return "Votre code d'invitation"}()
    lazy var forEveryFriendJobs : String =  { return "pour chaque ami qui emploi avec"}()
    lazy var shareMyCode : String =  { return "Compartir mi CÓDIGO"}()
    lazy var ReferralCopied : String =  { return "Remisión copian en Tarjeta de clip!"}()
    lazy var referralCodeCopied : String =  { return "Renvoi code Copié"}()
    lazy var useMyReferral : String =  { return "Usar mi Remisión"}()
    lazy var startYourJourney : String =  { return ". Comience su viaje en Gofer de aquí"}()
    lazy var noReferralsYet : String =  { return "Sin embargo Referidos"}()
    lazy var friendsIncomplete : String =  { return "AMIGOS - Incomplete"}()
    lazy var friendsCompleted : String =  { return "AMIGOS - REALIZADOS"}()
    lazy var earned : String =  { return "ganado:"}()
    lazy var referralExpired : String =  { return "Referencia de anuncio caducado"}()
    lazy var cash : String =  { return "EFECTIVO"}()
    lazy var paypal : String =  { return "PAYPAL"}()
    lazy var promoCode : String =  { return "Por favor, introduzca el código promocional"}()
    lazy var promotions : String =  { return "promociones"}()
    lazy var wallet : String =  { return "Billetera"}()
    lazy var stripeDetails : String =  { return "Detalles de la raya"}()
    lazy var addressKana : String =  { return "dirección Kana"}()
    lazy var addressKanji : String =  { return "dirección del kanji"}()
    lazy var yes : String =  { return "SÍ"}()
    lazy var no : String =  { return "NO"}()
    lazy var pleaseEnterExtraFare : String =  { return "Por favor, introduzca el precio adicional"}()
    lazy var pleaseSelectAnOption : String =  { return "Por favor seleccione una opción"}()
    lazy var pleaseEnterYourComment : String =  { return "Por favor, introduzca su comentario"}()
    lazy var stripe : String =  { return "Raya"}()
    lazy var defaults : String =  { return "Defecto"}()
    lazy var signIn : String =  { return "REGISTRARSE"}()
    lazy var lookRiderApp : String =  { return "BUSCAR EL JINETE APP?"}()
    lazy var close : String =  { return "CERCA"}()
    lazy var password : String =  { return "CONTRASEÑA"}()
    lazy var forgotPassword : String =  { return "¿Se te olvidó tu contraseña?"}()
    lazy var enablePushNotify : String =  { return "Por favor, activa notificaciones push en los ajustes para continuar inicio de sesión."}()
    lazy var resetPassword : String =  { return "RESTABLECER LA CONTRASEÑA"}()
    lazy var confirmPassword : String =  { return "CONFIRMAR CONTRASEÑA"}()
    lazy var selectVehicle : String =  { return "Seleccione su vehículo"}()
    lazy var chooseVehicle : String =  { return "Elegir el tipo de vehículo"}()
    lazy var vehicleName : String =  { return "Introduzca su nombre de vehículo"}()
    lazy var vehicleNumber : String =  { return "Introduzca su número de vehículos"}()
    lazy var continues : String =  { return "CONTINUAR"}()
    lazy var selectCountry : String =  { return "Seleccione un país"}()
    lazy var search : String =  { return "Buscar"}()
    lazy var uploadDoc : String =  { return "Por favor, subir sus documentos"}()
    lazy var verify : String =  { return "VERIFICAR"}()
    lazy var toDriveWith : String =  { return "Para conducir con"}()
    lazy var vehicleMust : String =  { return "su vehículo debe ser de 2000 o más reciente, y ser una de tamaño medio o sedán de tamaño completo que cómodamente 4-8 pasajeros."}()
    lazy var licenseBack : String =  { return "Licencia de conducir - (Volver / hacia atrás)"}()
    lazy var licenseFront : String =  { return "Licencia de conducir - (frontal)"}()
    lazy var licenseInsurance : String =  { return "Certificado de seguro de vehículos automóviles"}()
    lazy var licenseRc : String =  { return "Certificado de registro"}()
    lazy var licensePermit : String =  { return "Permiso carro contrato"}()
    lazy var docSection : String =  { return "Sección documento"}()
    lazy var takeYourPhoto : String =  { return "Tome una foto de su"}()
    lazy var readAllDetails : String =  { return "Por favor asegurarse de que podemos leer fácilmente todos los detalles."}()
    lazy var agreeTerms : String =  { return "Al continuar, confirmo que he leído y acepto los Términos y Condiciones y Política de Privacidad."}()
    lazy var termsConditions : String =  { return "Términos y condiciones"}()
    lazy var privacyPolicy : String =  { return "Política de privacidad"}()
    lazy var connectionLost : String =  { return "Red de conexión perdida"}()
    lazy var tryAgain : String =  { return "Inténtalo de nuevo"}()
    lazy var tapToAdd : String =  { return "Pulsar para añadir"}()
    lazy var mobileno : String =  { return "Número de teléfono móvil"}()
    lazy var refCode : String =  { return "Código de Referencia (Opcional)"}()
    lazy var likeResetPassword : String =  { return "¿Cómo te gustaría restablecer tu contraseña?"}()
    lazy var mobile : String =  { return "MÓVIL"}()
    lazy var mobileVerify : String =  { return "VERIFICACIÓN móvil"}()
    lazy var enterMobileno : String =  { return "Por favor, introduzca su número de móvil"}()
    lazy var resendOtp : String =  { return "Reenviar mensaje de OTP"}()
    lazy var enterOtp : String =  { return "Introduzca OTP"}()
    lazy var smsMobileVerify : String =  { return "Te hemos enviado el código de acceso a través de SMS para la verificación de número de teléfono móvil"}()
    lazy var didntReceiveOtp : String =  { return "Recibe di no a la Fiscalía?"}()
    lazy var otpAgain : String =  { return "Puede enviar de nuevo en OTP"}()
    lazy var nameOfBank : String =  { return "Nombre del banco"}()
    lazy var bankLocation : String =  { return "localización del Banco"}()
    lazy var pleaseGiveRating : String =  { return "Por favor, dar calificación"}()
    lazy var passwordMismatch : String =  { return "Contraseña no coincide"}()
    lazy var credentialsDontLook : String =  { return "Esas credenciales no se ven bien. Inténtalo de nuevo"}()
    lazy var nameEmail : String =  { return "Name@example.com"}()
    lazy var rateYourRide : String =  { return "Valorar su trabajo"}()
    lazy var beginTrip : String =  { return "COMENZAR TRIP"}()
    lazy var endTrip : String =  { return "VIAJE FIN"}()
    lazy var confirmArrived : String =  { return "CONFIRMAR que ha llegado"}()
    lazy var newVersionAvail : String =  { return "Nueva versión disponible"}()
    lazy var updateApp : String =  { return "Por favor, actualice nuestra aplicación para disfrutar de las últimas funciones!"}()
    lazy var visitAppStore : String =  { return "visita a la tienda de aplicaciones"}()
    lazy var internalServerError : String =  { return "Error interno del servidor, por favor, inténtelo de nuevo."}()
    lazy var dropOff : String =  { return "Bajar"}()
    lazy var onlinePay : String =  { return "Braintree"}()//pago en línea
    //MARK:- ErrorLocalizedDesc
    lazy var clientNotInitialized : String =  { return "El cliente no inicializado"}()
    lazy var jsonSerialaizationFailed : String =  { return "Serialización JSON falló"}()
    lazy var noInternetConnection : String =  { return "Sin conexión a Internet."}()
    lazy var cashTrip : String =  { return "viaje de dinero en efectivo"}()
    lazy var timelyEarnings : String =  { return "GANANCIAS A TIEMPO"}()
    
    
    //MARK:- Call
    lazy var connecting : String =  { return "Conexión"}()
    lazy var ringing : String =  { return "Zumbido"}()
    lazy var callEnded : String =  { return "Llamada terminada"}()
    
    //MARK:- Langugage reopens
    lazy var placehodlerMail : String =  { return "name@example.com"}()
    lazy var enterValidOTP : String =  { return "Introduzca OTP válida"}()
    lazy var locationService : String =  { return "Servicio de localización"}()
    lazy var tracking : String =  { return "Rastreo"}()
    lazy var camera : String =  { return "Cámara"}()
    lazy var photoLibrary : String =  { return "Librería fotográfica"}()
    lazy var service : String =  { return "Servicio"}()
    lazy var app : String =  { return "Aplicación"}()
    lazy var pleaseEnable : String =  { return "Por favor, activa"}()
    lazy var requires : String =  { return "requiere"}()
    lazy var _for : String =  { return "para"}()
    lazy var functionality : String =  { return "funcionalidad"}()
    lazy var noDataFound : String =  { return "Aucune donnée disponible"}()
    lazy var passwordValidationMsg : String =  { return "S'il vous plaît entrer au moins 6 caractères"}()
    // MARK:- Change Password VC
    lazy var successFullyUpdated : String =  { return "Mise à jour réussie"}()
    lazy var enterYourOldPassword : String =  { return "Entrez l'ancien mot de passe"}()
    lazy var enterYourNewPassword : String =  { return "Entrez un nouveau mot de passe"}()
    lazy var enterYourConformPassword : String =  { return "Mot de passe Entrez Conform"}()
    lazy var confirm : String =  { return "CONFIRMAR"}()
    
    lazy var home : String =  { return "CASA"}()
    lazy var trips : String =  { return "EXCURSIONES"}()
    lazy var earnings : String =  { return "GANANCIAS"}()
    lazy var ratings : String =  { return "CLASIFICACIONES"}()
    lazy var acount : String =  { return "CUENTA"}()

    lazy var swipeTo : String =  { return "Pase para"}()
    lazy var acceptingRequest : String =  { return "La aceptación de recogida ..."}()
    lazy var requestStatus : String =  { return "Solicitud"}()
    lazy var ratingStatus : String =  { return "Clasificación"}()
    lazy var scheduledStatus : String =  { return "programado"}()
    lazy var microphoneSerivce : String =  { return "servicio de micrófono"}()
    lazy var inAppCall : String =  { return "en la aplicación de llamada"}()
    lazy var choose : String =  { return "Escoger"}()
    lazy var choosePaymentMethod: String =  { return "Elige el método de pago"}()
    lazy var delete : String =  { return "Eliminar"}()
    lazy var whatLike2Do : String =  { return "Que te gustaría hacer ?"}()
    lazy var update : String =  { return "Actualizar"}()
    lazy var makeDefault : String =  { return "Hacer por defecto"}()
    lazy var min : String =  { return "min"}()
    lazy var hr : String =  { return "hora"}()
    lazy var hrs : String =  { return "horas"}()
    
    lazy var legalDocuments : String =  { return "Documento legal"}()
    lazy var language : String =  { return "Idioma"}()
    lazy var selectLanguage : String =  { return "Seleccione el idioma"}()
    lazy var active : String =  { return "Activo"}()
    lazy var gettingLocationTryAgain : String =  { return "Al obtener la ubicación, por favor, inténtelo de nuevo"}()
    lazy var settings : String =  { return "ajustes"}()
    lazy var goOnline : String =  { return "Ir en línea"}()
    lazy var goOffline : String =  { return "Salir de línea"}()
    
    lazy var manageVehicle : String =  { return "Manejo de Vehículos"}()
    lazy var yourTrips : String =  { return "sus Viajes"}()
    lazy var manageDocuments : String =  { return "administrar documentos"}()
    lazy var addEarnings : String =  { return "add ganancias"}()
    lazy var addPayouts : String =  { return "Añadir Pagos"}()
    
    lazy var editVehicle : String =  { return "Editar Vehículo"}()
    lazy var addVehicle : String =  { return "Añadir Vehículo"}()
    lazy var allProgressDiscard : String =  { return "se descartará toda su progreso!"}()
    lazy var make : String =  { return "Hacer"}()
    lazy var model : String =  { return "Modelo"}()
    lazy var year : String =  { return "Año"}()
    lazy var license : String =  { return "Número de licencia"}()
    lazy var color : String =  { return "Color"}()
    lazy var selectMake : String =  { return "Seleccione una marca"}()
    lazy var selectModel : String =  { return "Seleccionar un modelo"}()
    lazy var selectYear : String =  { return "Selecciona un año"}()
    lazy var pleaseSelectMake : String =  { return "Selecciona un Hacer"}()
    lazy var seat : String =  { return "Asiento"}()
    lazy var seats : String =  { return "Asientos"}()
    lazy var expiryDate : String =  { return "Fecha de caducidad"}()
    lazy var pleaseSelectOption : String =  { return "Por favor seleccione una opción"}()
    lazy var sureToDeleteVehicle : String =  { return "¿Seguro que desea eliminar este vehículo?"}()
    lazy var approved : String =  { return "Aprobado"}()
    lazy var rejected : String =  { return "Rechazado"}()
    lazy var addDocument : String =  { return "Añadir Documentos"}()
    lazy var riderBusy : String =  { return "Rider Busy. Por favor, tente novamente mais tarde."}()
    lazy var inTripComplete : String =  { return "Debido a que su viaje son, no se puede cambiar sus vehículos, por favor completado su visita"}()
    lazy var yourOnlineGoOffline : String =  { return "desde su son en línea, no se puede editar sus vehículos, por favor desconecta"}()
    lazy var vehicleIsNotActive : String =  { return "El vehículo no está activo."}()
    lazy var addNew : String =  { return "Añadir nuevo"}()
    lazy var poolRequest : String =  { return "Solicitud piscina"}()
    lazy var person : String =  { return "Persona"}()
    lazy var persons : String =  { return "personas"}()
    lazy var pleaseCompleteTrips : String =  { return "Por favor completar su viaje"}()
    lazy var inTrip : String =  { return "en viaje"}()
    lazy var manageServices : String =  { return "gestionar los servicios"}()
    lazy var manageHome : String =  { return "director del Home"}()
    lazy var loginText : String =  { return "Iniciar sesión"}()
    lazy var appName : String =  { return "Proveedor GoferHandy"}()
    lazy var welcomeText : String = { return "Bienvenue \n Le fournisseur de services GoferHandy App"}()
    lazy var welcomeLoginText : String =  { return "Bienvenido a inicio"}()
    lazy var yourJob : String =  { return "Tu trabajo"}()
    lazy var tapToChange : String =  { return "Toque para cambiar"}()
    lazy var dontHaveAcc : String =  { return "¿No tienes una cuenta?"}()
    lazy var alreadyHaveAcc : String =  { return "Ya tienes una cuenta ? Registrarse"}()
    lazy var tocText : String =  { return "Estoy de acuerdo con los Términos y Condiciones y Política de Privacidad."}()
    lazy var logout : String =  { return "Cerrar sesión"}()
    lazy var pleaseSetLocation : String =  { return "S'il vous plaît définir votre position"}()
    lazy var of : String =  { return "de"}()
    lazy var rUSureToLogOut : String =  { return "¿Estás seguro de que quieres cerrar sesión?"}()
    lazy var searchLocation : String =  { return "Rechercher Lieu"}()
    lazy var areYouSureToDelete : String =  { return "¿Está seguro de que quiere borrar la imagen?"}()
    lazy var specialInstruction : String =  { return "Instruction spécifique"}()
    lazy var deleteAnyWay : String =  { return "AnyWay de eliminación"}()
    lazy var managePayouts : String =  { return "administrar Pagos"}()
    lazy var liveTrack : String =  { return "en direct piste"}()
    lazy var jobProgress : String =  { return "Les progrès d'emploi"}()
    lazy var requestedService : String =  { return "service demandé"}()
    lazy var cancelBooking : String =  { return "Annuler la réservation"}()
    lazy var liveTracking : String =  { return "Suivi en direct"}()
    lazy var arrive : String =  { return "Llegar"}()
    lazy var beginJob : String =  { return "Comience Trabajo"}()
    lazy var endJob : String =  { return "fin de empleo"}()
    lazy var slideTo : String =  { return "Para deslizar"}()

    lazy var areYouSure : String =  { return "Êtes-vous sûr"}()
    lazy var areYouSureYouWantToExit : String =  { return "Êtes-vous sûr de vouloir quitter ?"}()
    lazy var sec : String =  { return "Seconde"}()
    lazy var driverEarnings : String =  { return "Total des gains"}()
    lazy var payStatement : String =  { return "Bulletins de paie"}()

}
extension Spanish {
    func isRTLLanguage() -> Bool {
        return false
    }
}
