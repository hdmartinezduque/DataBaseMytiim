/*
 * Hernan Martinez
 * 2023-07-05
 * Sprint #6
 * Archivo Version Incial, esta version es creada con el fin de llevar control de la version de los scripts de BD
 * Manual de Uso
 * 1. Abrir un espacio de comentarios definido entre "/*
 * 2. Definir el Usuario que realiza la modificación
 * 3. Fecha en la cual se realiza modificación
 * 4. Detalle o definicion de la modificación
 * 5. Anexar script para ser ejecutado
 * 6. Generar un Pull Request siguiendo el proceso establecido para actualización de ramas
 */



/*
* Alexander Alfaro
* 2023-07-05
* se agregan campos a la tabla t_objective
* se modifican los estados del periodo
*/
update t_period set period_status_id=12 where extract (year from period_start_period)=2023;
alter table t_objective add column objective_period_id int;
alter table t_objective add constraint FK_obj_period foreign key(objective_period_id) references t_period(period_id);
update t_objective set objective_period_id =1 where objective_id>0;


/*
* Alexander Alfaro
* 2023-07-06
* se hacen cambios a la tabla t_commitment
* se modifica la tabla t_followClose
* se agregan campos y tabla para mejorar la bitacora
*/
update t_period set period_status_id=12 where extract (year from period_start_period)=2023;

alter table t_objective add column objective_period_id int;
alter table t_objective add constraint FK_obj_period foreign key(objective_period_id) references t_period(period_id);
update t_objective set objective_period_id =2 where objective_id>0;

drop table if exists t_notification_type;
create table if not exists t_notification_type(
	notification_type_id serial4 not null,
	notification_type_describe varchar(255) not null,
	constraint pk_type_id PRIMARY KEY (notification_type_id)
);
insert into t_notification_type(notification_type_describe)
values('Creacion y notificacion automatica de encuestas');

alter table t_notification_log add column notification_log_type_id int;

ALTER TABLE public.t_follow_close_poll RENAME TO t_configuration_poll;
ALTER TABLE public.t_configuration_poll RENAME COLUMN follow_close_poll_id TO configuration_poll_id;
ALTER TABLE public.t_configuration_poll RENAME COLUMN follow_close_poll_required TO configuration_poll_required;
ALTER TABLE public.t_configuration_poll RENAME COLUMN follow_close_poll_period_id TO configuration_poll_period_id;
/*Este alter generar error en el sistema: ALTER TABLE public.t_configuration_poll RENAME COLUMN follow_close_poll_question_id TO configuration_poll_question_id;*/
ALTER TABLE public.t_configuration_poll RENAME COLUMN follow_close_poll_poll_type_id TO configuration_poll_poll_type_id;

alter table t_commitment drop column commitment_user_id;

/*
* Alexander Alfaro
* 2023-07-07
* se hacen cambios a la tabla de objetivos
* se agrega FK en  bitacora
*/

alter table t_objective add column objective_align_group_id int;
alter table t_objective add column objective_align_user_id int;
alter table t_objective add column objective_align_objective_id int;
alter table t_objective add constraint FK_obj_agroup_id foreign key(objective_align_group_id) references t_group(group_id);
alter table t_objective add constraint FK_obj_auser_id foreign key(objective_align_user_id) references t_user(user_id);
alter table t_objective add constraint FK_obj_aobj_id foreign key(objective_align_objective_id) references t_objective(objective_id);

alter table t_notification_log add constraint FK_log_type_id foreign key(notification_log_type_id) references t_notification_type(notification_type_id);

/*
* Alexander Alfaro
* 2023-07-07
* corregir error nombrado columna
*/
ALTER TABLE t_configuration_poll RENAME COLUMN configuration_poll_type_id TO configuration_poll_poll_type_id;

/*
* Alexander Alfaro
* 2023-07-10
* crear tabla configuracion de sistema
* corregit nombre columna en tabla de objetivos
*/

drop table if exists t_configuration_system;
create table if not exists t_configuration_system(
	configuration_system_id int not null,
	configuration_system_describe varchar(255) not null,
	configuration_system_value varchar(255) not null,
	constraint pk_conf_system__id PRIMARY KEY (configuration_system_id)
);

insert into t_configuration_system(configuration_system_id,configuration_system_describe,configuration_system_value)
values(1,'Generar encuesta de seguimiento continuo en dias','14'),
      (2,'Url de la aplicacion','http://190.144.118.234'),
      (3,'Url logotipo para envio de correos','https://cidenet.com.co/wp-content/uploads/2022/09/cropped-Logo-cidenet-2022-full-color.png');

ALTER TABLE t_objective RENAME COLUMN objective_grupo_id TO objective_group_id;


/*
* Cristina Flórez
* 2023-07-11
* crear tablar para corregir servicio de ver comentarios con el user separado por coma.
*/

CREATE TABLE public.t_comment_user (
	comment_user_id serial4 NOT NULL,
	comment_user_comment_id int NOT NULL,
	comment_user_to_id int NOT NULL
);


ALTER TABLE public.t_comment_user ADD CONSTRAINT t_comment_user_pk PRIMARY KEY (comment_user_id);

ALTER TABLE public.t_comment_user ADD CONSTRAINT t_comment_user FOREIGN KEY (comment_user_comment_id) REFERENCES public.t_comment(comment_id);

ALTER TABLE public.t_comment_user ADD CONSTRAINT fk_comment_user_to_id FOREIGN KEY (comment_user_to_id) REFERENCES public.t_user(user_id);



/*
* Alexander Alfaro
* 2023-07-11
* corregir url imagen usado en envio de correos
*/
update t_configuration_system
set configuration_system_value='https://cidenet.com.co/resources-cidenet/logo.png'
where configuration_system_id = 3;

update t_user set user_activated_date='2023-06-01', user_last_login=now() where user_id>0;

UPDATE public.t_period
SET period_describe='Q2-2022', period_start_period='2022-05-01', period_end_period='2022-08-31', period_start_poll='2022-09-01', period_end_poll='2022-09-15', period_status_id=13
WHERE period_id=3;
UPDATE public.t_period
SET period_describe='Q3-2022', period_start_period='2022-09-01', period_end_period='2022-12-31', period_start_poll='2023-01-01', period_end_poll='2023-04-30', period_status_id=13
WHERE period_id=4;
UPDATE public.t_period
SET period_describe='Q1-2023', period_start_period='2023-01-01', period_end_period='2023-04-30', period_start_poll='2023-05-01', period_end_poll='2023-08-31', period_status_id=12
WHERE period_id=5;
UPDATE public.t_period
SET period_describe='Q2-2023', period_start_period='2023-05-01', period_end_period='2023-08-31', period_start_poll='2023-09-01', period_end_poll='2023-12-31', period_status_id=12
WHERE period_id=1;
UPDATE public.t_period
SET period_describe='Q3-2023', period_start_period='2023-09-01', period_end_period='2023-12-31', period_start_poll='2024-01-01', period_end_poll='2024-04-30', period_status_id=12
WHERE period_id=6;
UPDATE public.t_period
SET period_describe='Q1-2022', period_start_period='2022-01-01', period_end_period='2022-04-30', period_start_poll='2023-01-01', period_end_poll='2023-04-30', period_status_id=13
WHERE period_id=2;

/*
* Cristina Florez
* 2023-07-12
* Borrar FK y columna userTo de tabla comment
*/ 

ALTER TABLE public.t_comment DROP CONSTRAINT fk_comment_user_to_id;
ALTER TABLE public.t_comment DROP COLUMN comment_user_to_id;


/*
* Alexander Alfaro
* 2023-07-12
* agregar campo para tabla de comentarios
*/
ALTER TABLE t_comment ADD column comment_by_group bool;
update t_comment set comment_by_group=false where comment_by_group is null;