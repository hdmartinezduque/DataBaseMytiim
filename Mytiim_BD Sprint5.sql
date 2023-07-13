/*
 * Hernan Martinez
 * 2023-06-20
 * Sprint #5
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
* 2023-06-22
* se crea tabla para gestion de notificaciones de encuestas
* se agregan inserts para status de encuestas y periodos
*/
insert into t_period (period_describe, period_start_period, period_end_period, period_start_poll, period_end_poll,period_status_id)
values('Q1-2022','2022-01-01','2022-04-30','2022-05-01','2022-05-15',13),
      ('Q2-2022','2022-05-01','2022-08-31','2022-09-01','2022-09-15',13),
      ('Q3-2022','2022-09-01','2022-12-31','2023-01-01','2023-01-15',13);


insert into t_period (period_describe, period_start_period, period_end_period, period_start_poll, period_end_poll,period_status_id)
values('Q1-2023','2023-01-01','2023-04-30','2023-05-01','2023-05-15',12),
      ('Q3-2023','2023-09-01','2023-12-31','2024-01-01','2024-01-15',12);

update t_period
set period_describe='Q2-2023', period_start_poll='2023-09-01', period_end_poll='2023-09-15'
where period_id=1;

update t_poll
set poll_describe='Seguimiento Continuo', poll_period_id=5, poll_status_id=15, poll_code='SC1Q12023'
where poll_id =1
;
insert into t_poll(poll_describe, poll_period_id, poll_status_id,poll_code)
values('Seguimiento Continuo',5,15,'SC2Q12023');

insert into t_poll(poll_describe, poll_period_id, poll_status_id,poll_code)
values('Cierre Periodo',5,15,'CPQ12023');

drop table if exists t_poll_user;
create table if not exists t_poll_user(
	poll_user_id serial4 not null,
	poll_user_user_id int not null,
	poll_user_poll_id int not null,
	poll_user_created_date date not null default now(),
	poll_user_status_id int not null,
	constraint pk_poll_user_id PRIMARY KEY (poll_user_id),
	constraint fk_poll_id foreign key(poll_user_poll_id) references t_poll(poll_id),
	constraint fk_status_id foreign key(poll_user_status_id) references t_status(status_id),
	constraint fk_user_id foreign key(poll_user_user_id) references t_user(user_id)
);



comment on column t_status.status_type is 'U=user, O=objective, Q=question, C=comment, T=period, P=poll, S=poll_user';
insert into t_status(status_id,status_describe,status_type)
values(16,'En curso','S'),(17,'Finalizada','S');

insert into t_poll_user(poll_user_user_id, poll_user_poll_id, poll_user_created_date, poll_user_status_id)
values(1,2,'2023-05-31',16);
insert into t_poll_user(poll_user_user_id, poll_user_poll_id, poll_user_created_date, poll_user_status_id)
values(1,1,'2023-06-15',17);
insert into t_poll_user(poll_user_user_id, poll_user_poll_id, poll_user_created_date, poll_user_status_id)
values(2,2,'2023-05-31',16);
insert into t_poll_user(poll_user_user_id, poll_user_poll_id, poll_user_created_date, poll_user_status_id)
values(2,1,'2023-06-15',16);
insert into t_poll_user(poll_user_user_id, poll_user_poll_id, poll_user_created_date, poll_user_status_id)
values(1,3,'2023-05-01',16);
insert into t_poll_user(poll_user_user_id, poll_user_poll_id, poll_user_created_date, poll_user_status_id)
values(2,3,'2023-05-01',16);

alter table t_poll_user add column poll_user_ended_date date;
update t_poll_user set poll_user_ended_date='2023-06-15' where poll_user_id=2;


/*
* Saul Echeveri
* 2023-06-22
* Se agrega los campos createdUpdate en las tablas t_user y t_objective para guardar la fecha de creación de los registros.
*/
ALTER TABLE t_user
ADD COLUMN user_created_date timestamp DEFAULT CURRENT_TIMESTAMP;

ALTER TABLE t_objective
ADD COLUMN objective_created_date timestamp DEFAULT CURRENT_TIMESTAMP;




/*
 * Hernan Martinez
 * 2023-06-26
 * Refactor t_comment_feedback correccion ortografica
 * 
*/

ALTER TABLE t_comment_feeback
RENAME TO t_comment_feedback;  

ALTER TABLE t_comment_feedback 
RENAME COLUMN comment_feeback_id TO comment_feedback_id;

ALTER TABLE t_comment_feedback 
RENAME COLUMN comment_feeback_comment_id TO comment_feedback_comment_id;

ALTER TABLE t_comment_feedback 
RENAME COLUMN comment_feeback_describe TO comment_feedback_describe;

ALTER TABLE t_comment_feedback 
RENAME COLUMN comment_feeback_user_from_id TO comment_feedback_user_from_id;

ALTER TABLE t_comment_feedback 
RENAME COLUMN comment_feeback_status_id TO comment_feedback_status_id;

ALTER TABLE t_comment_feedback 
RENAME COLUMN comment_feeback_type TO comment_feedback_type;


/*
* Saul Echeveri
* 2023-06-26
* Se agrega el campo user_leader_id y last_login en la tabla t_user para representar el lider del equipo y el 
* último ingreso al sistema respectivamente.
*/
ALTER TABLE t_user
ADD COLUMN user_leader_id int;

ALTER TABLE t_user 
ADD COLUMN user_last_login timestamp;

/*
* Alexander Alfaro
* 2023-06-27
* se agregan campos a la tabla t_poll
* se crea tabla para bitacora notificaciones automaticas
* se agrega campo de fecha de activación del usuario
*/
alter table t_poll add column poll_start date;
alter table t_poll add column poll_end date;
alter table t_poll add column poll_index int4;
update t_poll set poll_start='2023-01-31', poll_end='2023-01-31', poll_index=1 where poll_code like 'SC%';
update t_poll set poll_start='2023-01-01', poll_end='2023-04-30', poll_index=1,poll_code='CPQ32022' where poll_id=3;

drop table if exists t_notification_log;
create table if not exists t_notification_log(
	notification_log_id serial4 not null,
	notification_log_created_date timestamp default now(),
	notification_log_describe varchar(255) not null,
	constraint pk_log_id PRIMARY KEY (notification_log_id)
);
ALTER TABLE t_user ADD COLUMN user_activated_date date;

/*
* Saul Echeveri
* 2023-06-27
* Se agrega el campo commitment_user_id en la tabla t_commitment con su respectiva relacion a la tabla t_user.
* Se agrega el commitment_created_date en la tabla t_commitment para registar la fecha actual de los registros en dichas tablas.
*/
ALTER TABLE t_commitment 
ADD COLUMN commitment_user_id BIGINT;

ALTER TABLE t_commitment
ADD CONSTRAINT fk_commitment_user
FOREIGN KEY (commitment_user_id)
REFERENCES t_user (user_id);

ALTER TABLE t_commitment 
ADD COLUMN commitment_created_date TIMESTAMP;

/*
* Cristina Florez
* 2023-06-28
* Se agrega la columna comment_feedback_date a la tabla t_comment_feedback*/

ALTER TABLE public.t_comment_feedback ADD comment_feedback_date timestamp NOT NULL;
