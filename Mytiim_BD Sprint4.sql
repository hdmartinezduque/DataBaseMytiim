/*
 * Hernan Martinez
 * 2023-05-29
 * Sprint #4
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
* 2023-06-07
* se agrega inserts para roles de usuario
*/
insert into t_roll(roll_describe)
values('Empleado'),('Líder'),('Administrador');

insert into t_roll_user(roll_roll_user_id, roll_roll_id)
values(1,3);


/*
* Saul Echeverri
* 2023-06-13
* Se agregan las tablas tipo de encuestas y tipo de seguimiento/cierre de encuestas.
* Se agregan los insert para los tipos de encuesta
*/

drop table if exists t_poll_type;
create table if not exists t_poll_type (
  poll_type_id serial4 not null,
  poll_type_describe varchar(600) not null,
  constraint pk_poll_type_id PRIMARY KEY (poll_type_id)
);

drop table if exists t_follow_close_poll;
create table if not exists t_follow_close_poll (
  follow_close_poll_id serial4 not null,
  follow_close_poll_required BOOL not null default true,
  follow_close_poll_period_id int not null,
  follow_close_poll_question_id int not null,
  follow_close_poll_poll_type_id int not null,
  constraint pk_follow_close_poll_id PRIMARY KEY (follow_close_poll_id),
  constraint fk_period_id foreign key(follow_close_poll_period_id) references t_period(period_id),
  constraint fk_question_id foreign key(follow_close_poll_question_id) references t_question(question_id),
  constraint fk_poll_type_id foreign key(follow_close_poll_poll_type_id) references t_poll_type(poll_type_id)
);

insert into t_poll_type (poll_type_describe)
values ('Seguimiento'), ('Cierre periodo');



/*
* Alexander Alfaro
* 2023-06-14
* se agregan cambios alas tablas de question y follow_close_poll
*/
update t_answer_type
set answer_type_describe ='Abierta'
where answer_type_id = 1;
update t_answer_type
set answer_type_describe ='Cerrada Unica Respuesta'
where answer_type_id = 2;

insert into t_answer_type (answer_type_describe,answer_type_id)
values ('Cerrada Multiple Respuesta',3);

alter table t_question drop column question_typequestion;
alter table t_question add column question_options varchar(255);

update t_question set question_options='SI,NO',question_status_id=10 where question_describe='Tuviste algun bloqueo';

insert into t_question (question_describe, question_answer_type_id, question_options, question_status_id)
values('Como te sentiste este sprint',2,'Cansado,Presionado,Entusiasmado,Tranquilo',10);

ALTER TABLE t_follow_close_poll ALTER COLUMN follow_close_poll_period_id DROP NOT NULL;

/*
* Cristina Flórez
* 2023-06-15
* se permite NUll en el campo comment_objective_id de la tabla comment
*/
ALTER TABLE t_comment ALTER COLUMN comment_objective_id DROP NOT NULL;


/*
* Alexander Alfaro
* 2023-06-15
* se agrega campo de fecha de creacion en la tabla detail_poll
*/
alter table t_detail_poll add column detail_poll_answer_date timestamp;
alter table t_detail_poll drop column detail_poll_status;

