use `5to_Trivago` ;
DELIMITER $$
SELECT 'Creando SF' AS 'Estado'$$


drop function if exists verificacion_usuario$$
create function verificacion_usuario(
mail varchar(60),
    contra char(64)
)returns bool reads sql data
begin
declare correcto bool;
if(
exists(
select *
        from Usuario U
        where U.Mail = mail and U.Contraseña = sha2(contra, 256)
)
)
then
set correcto = true;
else
set correcto = false;
end if;
return correcto;
end$$

drop function if exists verificacion_mail_registrado$$
create function verificacion_mail_registrado(unMail varchar(60))
returns bool reads sql data
begin
declare existe bool;
    set existe = false;
    if(
exists(
select *
            from Usuario
            where Mail = unMail
)
)
    then
set existe = true;
end if;
    return true;
end$$

drop function if exists DisponibilidadFecha$$
create function DisponibilidadFecha(unIdHabitacion int unsigned, unaEntrada datetime, unaSalida datetime )
returns bool reads sql data
begin
declare disponible bool;
    set disponible = true;
    if(
exists(
select *
            from Reserva
            where (Entrada >= unaEntrada and Entrada <= unaSalida)
            or (Entrada <= unaEntrada and Salida >= unaEntrada)
            and idHabitacion = unIdHabitacion
            and unaEntrada < now()
        )
    )
then
set disponible = false;
end if;
    return disponible;
end$$

drop PROCEDURE if EXISTS `ListarCiudadPorPais`$$
CREATE Procedure ListarCiudadPorPais(in paisid int UNSIGNED)
begin
    SELECT * from Ciudad WHERE idPais = paisid;
end$$

drop function if exists HabitacionesDisponiblesTipo$$
create function HabitacionesDisponiblesTipo(unIdTipo int unsigned, unidHotel int unsigned, unaEntrada datetime, unaSalida datetime)
returns tinyint unsigned reads sql data
begin
declare disponibles tinyint unsigned ;
select count(*) into disponibles
from Habitacion
where idHotel = unIdHotel and idTipo = unIdTipo;
return disponibles;
end$$

drop PROCEDURE if EXISTS EliminarComentarios $$
CREATE PROCEDURE EliminarComentarios(unIdHotel int UNSIGNED)
begin
    /*DELETE from Comentario
    WHERE idComentario IN
        (SELECT idComentario
        from Comentario
        inner join Habitacion H using(idHabitacion)
        WHERE H.idHotel = unIdHotel);*/
    DELETE  C
    FROM    Comentario C
    JOIN    Habitacion using(idHabitacion)
    WHERE   idHotel = unIdHotel;

end$$
drop Procedure if EXISTS EliminarReservas$$

create PROCEDURE EliminarReservas(unIdHotel int UNSIGNED)
begin
    DELETE  R
    FROM    `Reserva` R
    JOIN    Habitacion using(idHabitacion)
    WHERE   idHotel = unIdHotel;

end$$

drop Procedure if EXISTS EliminarHabitaciones$$
CREATE Procedure EliminarHabitaciones(unIdHotel int UNSIGNED)
begin
DELETE FROM Habitacion WHERE idHotel = unIdHotel;
END$$


drop PROCEDURE if EXISTS EliminarHotel$$
create PROCEDURE EliminarHotel(unIdHotel int UNSIGNED)
BEGIN
START TRANSACTION;
CALL EliminarComentarios(unIdHotel);
CALL EliminarReservas(unIdHotel);
CALL EliminarHabitaciones(unIdHotel);
DELETE FROM Hotel where idHotel = unIdHotel;
COMMIT;
END$$