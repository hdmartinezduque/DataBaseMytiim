/*
 * Hernan Martinez
 * 2023-05-23
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
* 2023-05-24
* se agregan status , se modifica la tabla question y se insertan registros en tabla question
*/
comment on column t_status.status_type is 'U=user, O=objective, Q=question, C=comment';

insert into t_status(status_id,status_describe,status_type)
values(8,'ACTIVO','C'),(9,'INACTIVO','C'),(10,'ACTIVA','Q'),(11,'INACTIVA','Q');

insert into t_answer_type (answer_type_describe)
values ('Texto'),('Verdadero/Falso');

ALTER TABLE t_question ALTER COLUMN question_textoopcion1 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion2 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion3 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion4 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion5 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion6 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion7 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion8 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion9 DROP NOT NULL;
ALTER TABLE t_question ALTER COLUMN question_textoopcion10 DROP NOT NULL;

insert into t_question (question_describe, question_answer_type_id, question_typequestion, question_status_id)
values('Cumpliste los comrpomisos en la fecha estimada',1,0,10);

insert into t_question (question_describe, question_answer_type_id, question_typequestion, question_status_id)
values('Tuviste algun bloqueo',2,0,10);


/*
* Cristina Flórez
* 2023-05-26
* se agrega columna a la tabla comment y su relación.
*/

ALTER TABLE public.t_comment ADD comment_objective_id int4 NOT NULL;

ALTER TABLE public.t_comment ADD CONSTRAINT fk_comment_objective_id FOREIGN KEY (comment_objective_id) REFERENCES public.t_objective(objective_id);


/*
* Alexander Alfaro
* 2023-05-26
* se agrega tabla para preguntas de encuesta, y se agrega registro para el periodo y la encuesta general
* se eliminan columnas de la tabla de preguntas
*/
ALTER TABLE t_question DROP COLUMN question_textoopcion1;
ALTER TABLE t_question DROP COLUMN question_textoopcion2;
ALTER TABLE t_question DROP COLUMN question_textoopcion3;
ALTER TABLE t_question DROP COLUMN question_textoopcion4;
ALTER TABLE t_question DROP COLUMN question_textoopcion5;
ALTER TABLE t_question DROP COLUMN question_textoopcion6;
ALTER TABLE t_question DROP COLUMN question_textoopcion7;
ALTER TABLE t_question DROP COLUMN question_textoopcion8;
ALTER TABLE t_question DROP COLUMN question_textoopcion9;
ALTER TABLE t_question DROP COLUMN question_textoopcion10;

drop table if exists t_poll_question;
create table if not exists t_poll_question(
	poll_question_id serial4 not null,
	poll_question_poll_id int not null,
	poll_question_question_id int not null,
	poll_question_required bool not null default false,
	constraint pk_poll_question_id PRIMARY KEY (poll_question_id),
	constraint fk_poll_id foreign key(poll_question_poll_id) references t_poll(poll_id),
	constraint fk_question_id foreign key(poll_question_question_id) references t_question(question_id)
);

comment on column t_status.status_type is 'U=user, O=objective, Q=question, C=comment, T=period, P=poll';

insert into t_status(status_id,status_describe,status_type)
values(12,'ACTIVO','T'),(13,'INACTIVO','T'),(14,'ACTIVA','P'),(15,'INACTIVA','P');

insert into t_period (period_describe, period_start_period, period_end_period, period_start_poll, period_end_poll,period_status_id)
values('Q2','2023-05-01','2023-08-31','2023-05-01','2023-08-31',12),
('Q3','2023-09-01','2023-12-31','2023-09-01','2023-12-31',13),
('Q1','2023-01-01','2023-04-30','2023-01-01','2023-04-31',14);


ALTER TABLE t_poll DROP COLUMN poll_status;
ALTER TABLE t_poll ADD COLUMN poll_status_id int;
ALTER TABLE t_poll ADD constraint fk_status_id foreign key(poll_status_id) references t_status(status_id);

insert into t_poll(poll_describe, poll_period_id, poll_status_id,poll_code)
values('Encuesta General',1,14,'EG');

