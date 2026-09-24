#PROYECTO DE ANALISIS DE SEGUROS

--ESTO ES PARTE DE "JUGAR CON LA IA" PARA FOMENTAR EL ANALISIS CRITICO DE UN CASO DE NEGOCIO TARDE ALREDEDOR DE 5H SIN AYUDA SOLAMENTE CONFIRMANDO ALGUNOS DATOS PARA SABER QUE IBAMOS POR EL CAMINO CORRECTO.

-- EMPECE CON UN ENFOQUE ERRONEO PORQUE NO PREGUNTE ¿QUE LE LLAMAMOS PERDIDAS?, ¿QUE TIPO DE POLIZAS MANEJAMOS?, ¿EN LA EXPERIENCIA HA NOTADO ALGUN INCREMENTO EN ALGUNA POLIZA EN PARTICULAR?,  Y COMENCE CON EL ANALISIS SIMPLEMENTE TOMANDO EN CUENTA TODA LA DATA PENSADO QUE TODO LO PAGADO Y LOS NUMEROS ERA SINONIMO DE PERDIDA, ERROR PERDIDA LE LLAMABAN A LAS POLIZAS QUE HABIAN SIDO PAGADAS CON INDICIO DE FRAUDE POR ESO TENEMOS CIFRAS GRANDISIMAS AL PRINCIPIO


--¿En qué tipos de pólizas o perfiles de clientes estamos teniendo las pérdidas más altas por reclamos?

--1	Motor	      6.047286367552E12
--2	Health	    4.547595741296E12
--3	Property	  1.866652336624E12
--4	Crop	      1.528501669632E12
--5	Travel	    1.173670924896E12

--TOP 5 RANGO ETARIO, ESTADO DE OCUPACION Y PUNTAJE PROMEDIO
--1	Retired  	45  3.5697928E7 722.57
--2	Salaried	38	3.5055834E7 685.1
--3	Retired	  42	3.4365438E7 707.41
--4	Business	43	3.3165156E7 706.7
--5	Farmer	  50	3.2504694E7 694.85


--Mira, te hablo con la mano en el corazón! Lo que más me quita el sueño en este preciso instante son los reclamos aprobados en seguros de autos (Motor) y salud (Health). Los reportes globales me muestran que ahí es donde se está concentrando el grueso de la plata que estamos pagando, ¡las cifras están disparadas!

---------------------------------------------------------------------------------
--REVISAMOS EL ESTADO INDICADORES DE FRAUDE (TARDE ALREDEDOR DE 3H SOLAMENTE ESCRIBIR ESA CONSULTA BASICA PERO CON LOGICA DE NEGOCIO)
--    STATUS  FRAUD_FLAG TOTAL_ENTREGADO  AVG_DIAS_RESPUESTA
--1	Pending	0	  2.18208424E8     null
--2	Rejected	0	  9.4381568E7      null
--3	Pending	1	  1.115991E7       null
--4	Rejected	1	  4390548.0        null
--5	Settled	0	  1.126845925E9    61.56   (esta nos interesa para saber la magnitud de dinero que se ha entregado sin riesgo de fraude)
--6	Settled	1	  6.1384329E7      61.19   (este nos interesa 61 millones entregados con Fraud_flag = 1, Significaba que ya habia descubierto donde se estaba yendo el dinero) 

SELECT status, fraud_flag, sum(settlement_amount) AS TOTAL_ENTREGADO, ROUND(AVG(days_to_settle),2) AS AVG_DIAS_RESPUESTA
FROM `portfolioproyect-505419.fraudeseguros.Reclamos`
group by status, fraud_flag;

-----------------------------------------------------------------------------
-- AQUI YA BUSCABA SABER CUAL TIPO DE POLIZA TENIA MAS CASOS CON PROBLEMAS DE FRAUDE.
--1	Motor	      2.818127E7	58.8
--2	Health	2.4021605E7	62.47
--3	Property	9660705.0	64.33
--4	Crop	      8468520.0	64.56
--5	Travel	6602687.0	57.34

SELECT P.policy_type, SUM(R.settlement_amount) AS SUMA, ROUND(AVG(R.days_to_settle),2) AS AVG_DIAS_RESPUESTA
FROM `portfolioproyect-505419.fraudeseguros.Poliza_Seguros` P
JOIN `portfolioproyect-505419.fraudeseguros.Reclamos` R
ON P.policy_id = R.policy_id
WHERE R.fraud_flag = 1
GROUP BY P.policy_type
ORDER BY SUMA DESC;
----------------------------------------------------------------------
--NO TENEMOS RECLAMOS DUPLICADOS
SELECT claim_id, count(claim_id) as conteo
FROM `portfolioproyect-505419.fraudeseguros.Reclamos` 
group by claim_id
having count(claim_id) > 1
order by conteo desc;
---------------------------------------------------------------------
--revisando permanencia de cliente con la poliza
SELECT tenure_months,count(customer_id) as conteo_cliente
FROM `portfolioproyect-505419.fraudeseguros.Poliza_Seguros`
GROUP BY tenure_months
order by tenure_months asc;
----------------------------------------------------------
--contando las polizas de seguros son 10,000
SELECT 
count(*)
FROM `portfolioproyect-505419.fraudeseguros.Poliza_Seguros`;
------------------------------------
--Contando los reclamos son 2,000
SELECT  count(*)
FROM `portfolioproyect-505419.fraudeseguros.Reclamos`;

--------------------------------------------------------------------------------
--Contando cliente son 5,000
SELECT  count(*)
FROM `portfolioproyect-505419.fraudeseguros.Cliente`;
-----------------------------------------------------------------------------------
--AQUI ESTABA DUDANDO DE LA CONSULTA, POR ESO DECIDI SACAR LOS DISTINTOS DE VARIAS COLUMNAS PARA SABER SI CONCORDABAN CON LAS CONSULTAS ANTERIORES Y SI AHI YA QUEDE MAS TRANQUILO SABIENDO QUE AL TENER LOS DISTINTOS MANEJABAN LOS MISMO MONTOS.

--Revisar reclamos unicos y cuanto se ha pagado. concuerda con el monto que vimos anteriormente
SELECT distinct claim_id,customer_id,claim_date,claim_amount, status, fraud_flag, sum(settlement_amount) as MontoEntregado,
SUM(SUM(settlement_amount)) OVER() AS total_general

FROM `portfolioproyect-505419.fraudeseguros.Reclamos`
WHERE status = "Settled" and fraud_flag = 1
group by claim_id,customer_id,claim_date,claim_amount, status, fraud_flag; 
-------------------------------------------------------------------------------
--AGRUPAR POR AÑOS FUE LA ULTIMA FORMA DE REVISAR LA TENDENCIA DE LOS DATOS, AQUI YA VEMOS QUE LO MAS FUERTE PASO EN EL AÑO 2025 DONDE SE 25 MILL EN POLIZAS CON POSIBLE FRAUDE.

--REVISAMOS LOS MONTOS ENTEGADOS POR AÑO DE LAS POLIZAS QUE FUERON PAGADAS CON SOSPECHA DE FRAUDE
--1	2024	2.362971E7
--2	2025	2.5951364E7
--3	2026	1.1803255E7
SELECT extract(year from claim_date) as year, sum(settlement_amount) as Total_entregado
FROM `portfolioproyect-505419.fraudeseguros.Reclamos`
WHERE status = "Settled" and fraud_flag = 1  
group by year
order by year; 

