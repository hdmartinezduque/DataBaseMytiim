/*
 * Hernan M
 * 2023-05-16
 * Se actualizan con los cambios propuestos según V2
 */


/*
 * Data documentation
 */

create temporary table tem_comment as (
select c.table_schema, st.relname as TableName, c.column_name, 
pgd.description
from pg_catalog.pg_statio_all_tables as st
inner join information_schema.columns c
on c.table_schema = st.schemaname
and c.table_name = st.relname
left join pg_catalog.pg_description pgd
on pgd.objoid=st.relid
and pgd.objsubid=c.ordinal_position
where pgd.description is not null );

SELECT 
c.table_name
, c.column_name
, c.column_default
, c.is_nullable
, c.data_type
, c.character_maximum_length
, concat(c.numeric_precision, '-', c.numeric_precision_radix) as numeric_precision
, c.udt_name  
, com.description as desc_comment
, ccu.constraint_name 
FROM information_schema.columns c left join tem_comment com
on c.column_name = com.column_name and c.table_name = com.tablename
left join information_schema.constraint_column_usage ccu on c.column_name = ccu.column_name 
and c.table_name = ccu.table_name 
WHERE c.table_schema = 'public' /*AND table_name = 't_user'*/
ORDER BY c.table_name ;

drop table tem_comment; 

/* 
select * from information_schema.constraint_table_usage ctu 
select * from information_schema.constraint_column_usage ccu 

 * Agregar Comentario 
 * 
 * */

/*
CREATE database MYTIIM
  WITH OWNER = postgres
       ENCODING = 'UTF8'
       TABLESPACE = pg_default
       LC_COLLATE = 'Spanish_Colombia.1252'
       LC_CTYPE = 'Spanish_Colombia.1252'
       CONNECTION LIMIT = -1;
*/

/*
 * Conditions: objects: 
 * Tables: t_table_name 
 * Columns: name_table_column_name 
 * constraint Primary key: pk_column_name
 * constraint Foreign key: pk_column_name
 * Views: v_view_name
 * Store Procedure: sp_store_procedure_name
 * Functions: f_function_name
 *  
 * table - t_objective (ok)
 * table - t_objective_type (ok)
 * table - t_parameter
 * table - t_roll
 * table - t_group - Usuario esta asociado a un grupo (Dependencia)
 * table - t_profile_group
 * table - t_user (ok)
 * table - profile
 * table - t-status (ok)
 * table - t_tranx
 * 
 * *
 * table - t_question
 * question_id Alfanumerico (asignado por el usuario)
 * question_textoExplicativo - enunciado para que las personas puedan entender la pregunta
 * question_enunciado
 * question_typequestion - Lista de opciones (Cerrada / Abierta)
 * question_textoOpcion1
 * question_textoOpcion2
 * question_textoOpcion3
 * question_textoOpcion4
 * question_textoOpcion5
 * question_textoOpcion6
 * question_textoOpcion7
 * question_textoOpcion8
 * question_textoOpcion9
 * question_textoOpcion10
 * 
 * ****Pensar como hacemos para un mejor manejo***
 * table - t-question_type ?
 * table - t_answertype
 * table - t_answerquestion
 * answerquestion_id
 * answerquestion_result
 * answerquestion_answertext
 * answerquestion_id_user
 * HU25
 * table - t_poll
 * poll_id
 * poll_question_id
 * poll_questionmandatory
 * poll_user_id
 * poll_type
 * 
 * 
 * 	constraint fk_user_status1 foreign key(user_table_status_id) references status(status_id)
 *  --------
 * 	-------
 * 	constraint fk_objective_type_status1 foreign key(objective_type_status_id) references status(status_id)
 *  --------
 *  constraint fk_objective_id_objective_type foreign key(objective_id_objective_type) references objective_type(id_objective_type)
 * */

/*
 * 
 * */

drop table if exists t_status;
create table if not exists t_status(
	status_id serial4 not null,
	status_describe varchar(255) not null,
	constraint pk_status_id PRIMARY KEY (status_id)
);

drop table if exists t_objective_type;
create table if not exists t_objective_type(
	objective_type_id serial4 not null,
	objective_type_describe varchar(255) not null,
	objective_type_status_id int not null,
	constraint pk_id_objective_type PRIMARY KEY (objective_type_id)
);


drop table if exists t_roll;
create table if not exists t_roll(
	roll_id serial4 not null,
	roll_describe varchar(255) not null,
	constraint pk_roll_id PRIMARY KEY (roll_id)
);


drop table if exists t_roll_user;
create table if not exists t_roll_user(
	roll_user_id serial4 not null,
	roll_roll_user_id int not null,
	roll_roll_id int not null,
	constraint pk_roll_user_id PRIMARY KEY (roll_user_id)
);

drop table if exists t_module;
create table if not exists t_module(
	module_id serial4 not null,
	module_describe varchar(255) not null,
	constraint pk_module_id PRIMARY KEY (module_id)
);

drop table if exists t_module_roll;
create table if not exists t_module_roll(
	module_roll_id serial4 not null,
	module_roll_module_id int not null,
	module_roll_roll_user_id int not null,
	module_roll_edit boolean default True,
	/*constraint pk_module_roll_id PRIMARY KEY (module_roll_id),*/
	constraint pk_module_roll_id PRIMARY KEY (module_roll_module_id, module_roll_roll_user_id)
);
/* check profile constraint */
drop table if exists t_user;
create table if not exists t_user(
	user_id serial4 not null,
	user_password varchar(255) not null,
	user_name varchar(255) not null,
	user_last_name varchar(255) not null,
	user_phone varchar(255) not null,
	user_profile_id int not null,
	user_email varchar(255) unique not null,
	user_group_id int not null,
	user_status_id int not null,
	constraint pk_user_id PRIMARY KEY (user_id)
);
comment on column t_user.user_email is 'Unique email to system';

drop table if exists t_group;
create table if not exists t_group(
	group_id serial4 not null,
	group_describe varchar(255) not null,
	group_code varchar(255),
	constraint pk_group_id PRIMARY KEY (group_id)
);

drop table if exists t_objective;
create table if not exists t_objective(
	objective_id serial4 not null,
	objective_describe varchar(255) not null,
	objective_objective_type_id int not null,
	objective_user_id int not null,
	objective_grupo_id int not null,
	objective_status_id int not null,
	constraint pk_objective_id PRIMARY KEY (objective_id)
	
);

drop table if exists t_commitment;
create table if not exists t_commitment(
	commitment_id serial4 not null,
	commitment_objective_id int not null,
	commitment_describe varchar(255) not null,
	commitment_date date not null,
	constraint pk_commitment_id PRIMARY KEY (commitment_id)
);

drop table if exists t_answer_type;
create table if not exists t_answer_type(
	answer_type_id serial4 not null,
	answer_type_describe varchar(30) not null,
	constraint pk_answer_type_id PRIMARY KEY (answer_type_id)
);

drop table if exists t_answer_value;
create table t_answer_value(
	answer_value_id serial4 not null,
	answer_type_id int not null,
	answer_value_describe varchar(600) not null,
	answer_value int not null,	
	constraint pk_answer_value_id PRIMARY KEY (answer_value_id)
);

drop table if exists t_question;
create table if not exists t_question(
	question_id serial4 not null,
	question_describe varchar(255) not null,
	question_answer_type_id int not null,
 	question_typequestion int not null,
 	question_textoOpcion1 varchar(255) not null,
 	question_textoOpcion2 varchar(255) not null,
 	question_textoOpcion3 varchar(255) not null,
 	question_textoOpcion4 varchar(255) not null,
 	question_textoOpcion5 varchar(255) not null,
 	question_textoOpcion6 varchar(255) not null,
 	question_textoOpcion7 varchar(255) not null,
 	question_textoOpcion8 varchar(255) not null,
 	question_textoOpcion9 varchar(255) not null,
 	question_textoOpcion10 varchar(255) not null,
 	question_status_id int not null,
 	constraint pk_question_id PRIMARY KEY (question_id)
);
/*
 * Cron identificar el periodo --- tabla periodo Q1-Q4 /->Periodos (4)
 * CPQ12023 Cierre del Periodo
 * SCQ12023 Seguimiento Continuo
 * SC / Semanal (52) , Quincela (26), Mes (12)
 * Identificar el periodo
 * Leer la tabla parametrica
 * Crear encuesta Seg. Continuo o Cierre de periodo
 * codigo de encuesta Alfanumerico
 * 
 * */
drop table if exists t_period;
create table if not exists t_period(
	period_id serial4 not null,
	period_describe varchar(255) not null,
	period_start_period date not null,
	period_end_period date not null,
	period_start_poll date not null,
	period_end_poll date not null,
	period_status_id int not null,
	constraint pk_period_id PRIMARY KEY (period_id)
);

drop table if exists t_poll;
create table if not exists t_poll(
	poll_id serial4 not null,
	poll_describe varchar(255) not null,
	poll_period_id int not null,
	poll_status int not null,
	poll_code varchar(10) not null,
	constraint pk_poll_id PRIMARY KEY (poll_id)
);

drop table if exists t_detail_poll;
create table if not exists t_detail_poll(
	detail_poll_id serial4 not null,
	detail_poll_poll_id int not null,
	detail_poll_question_id int not null,
	detail_poll_answer varchar(600) not null,
	detail_poll_user_id int not null,
	detail_poll_status int default 0, /*  */
	constraint pk_detail_poll_id PRIMARY KEY (detail_poll_id)
);

drop table if exists t_comment;
create table if not exists t_comment(
	comment_id serial4 not null,
	comment_describe varchar(600) not null,
	comment_user_from_id int not null,
	comment_user_to_id int not null,
	comment_status_id int not null,
	comment_date timestamp not null,
	comment_type boolean not null default True, 
	constraint pk_comment_id PRIMARY KEY (comment_id)
);
comment on column t_comment.comment_type is 'Public = True / Private = False';

drop table if exists t_comment_feeback;
create table if not exists t_comment_feeback(
	comment_feeback_id serial4 not null,
	comment_feeback_comment_id int not null,
	comment_feeback_describe varchar(600) not null,
	comment_feeback_user_from_id int not null,
	comment_feeback_status_id int not null,
	comment_feeback_type boolean not null default true,
	constraint pk_comment_feeback_id PRIMARY KEY (comment_feeback_id)
);
comment on column t_comment_feeback.comment_feeback_type is 'Public = True / Private = False';

/*
 * Rules
 * */

alter table t_objective_type add constraint fk_objective_type_status_id foreign key(objective_type_status_id) references t_status(status_id);

alter table t_module_roll add constraint fk_module_roll_module_id foreign key(module_roll_module_id) references t_module(module_id);
alter table t_module_roll add constraint fk_module_roll_roll_user_id foreign key(module_roll_roll_user_id) references t_user(user_id);

alter table t_user add constraint fk_user_group_id foreign key(user_group_id) references t_group(group_id);
alter table t_user add constraint fk_user_status_id foreign key(user_status_id) references t_status(status_id);

alter table t_objective add constraint fk_objective_objective_type_id foreign key(objective_objective_type_id) references t_objective_type(objective_type_id);
alter table t_objective add constraint fk_objective_user_id foreign key(objective_user_id) references t_user(user_id);
alter table t_objective add constraint fk_objective_grupo_id foreign key(objective_grupo_id) references t_group(group_id);
alter table t_objective add constraint fk_objective_status_id foreign key(objective_status_id) references t_status(status_id);

alter table t_commitment add constraint fk_commitment_objective_id foreign key(commitment_objective_id) references t_objective(objective_id);

alter table t_answer_value add constraint fk_answer_type_id foreign key(answer_type_id) references t_answer_type(answer_type_id);

--alter table t_question add constraint fk_objective_status_id foreign key(objective_status_id) references t_status(status_id);
alter table t_question add constraint fk_objective_status_id foreign key(question_status_id) references t_status(status_id);

alter table t_period add constraint fk_period_status_id foreign key(period_status_id) references t_status(status_id);

alter table t_poll add constraint fk_poll_period_id foreign key(poll_period_id) references t_period(period_id);

alter table t_detail_poll add constraint fk_detail_poll_poll_id foreign key(detail_poll_poll_id) references t_poll(poll_id);

alter table t_comment add constraint fk_comment_user_from_id foreign key(comment_user_from_id) references t_user(user_id);
alter table t_comment add constraint fk_comment_user_to_id foreign key(comment_user_to_id) references t_user(user_id);
alter table t_comment add constraint fk_comment_status_id foreign key(comment_status_id) references t_status(status_id);

alter table t_comment_feeback add constraint fk_comment_feeback_comment_id foreign key(comment_feeback_comment_id) references t_comment(comment_id);
alter table t_comment_feeback add constraint fk_comment_feeback_user_from_id foreign key(comment_feeback_user_from_id) references t_user(user_id);
alter table t_comment_feeback add constraint fk_comment_feeback_status_id foreign key(comment_feeback_status_id) references t_status(status_id);


INSERT INTO t_group
(group_describe, group_code)
VALUES('ARQUITECTURA', 'ARQUITECTURA');

INSERT INTO t_status 
(status_id, status_describe)
VALUES(1, 'ACTIVO');

INSERT INTO t_user
(user_password, user_name, user_last_name, user_phone, user_profile_id, user_email, user_group_id, user_status_id)
VALUES('7c4a8d09ca3762af61e59520943dc26494f8941b', 'Hernan', 'Martinez', '3126549921', 1, 'hmartinez@cidenet.com.co', 1, 1);

INSERT INTO t_objective_type
(objective_type_describe, objective_type_status_id)
VALUES('Desarrollo personal', 1); 

INSERT INTO t_objective_type
(objective_type_describe, objective_type_status_id)
VALUES('Desarrollo personal', 1);

INSERT INTO t_objective_type
(objective_type_describe, objective_type_status_id)
VALUES('Individual Grupal', 1);

INSERT INTO t_objective
(objective_describe, objective_objective_type_id, objective_user_id, objective_grupo_id, objective_status_id)
VALUES('APRENDER INGLES', 1, 1, 1, 1);


create or replace view v_objective as (select obj.objective_id
, obj.objective_describe 
, obj_type.objective_type_describe as objective_objective_type_id
, obj.objective_user_id 
, obj.objective_grupo_id
, st.status_describe as objective_status_id
from t_objective as obj inner join t_objective_type as obj_type 
on obj.objective_objective_type_id = obj_type.objective_type_id
inner join t_status st ON obj.objective_status_id = st.status_id 
);  