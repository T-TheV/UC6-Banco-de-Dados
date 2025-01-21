-- criar funcao pra calcular total de livros
create or replace function total_livros() returns int as $$
	
begin
	return(select count(id) as total_livros from livro);
end;
$$language plpgsql;

select * from total_livros()

create or replace function total_usuarios() returns int as $$

begin
	return(select count(id) as total_usuarios from usuario);
end;
$$language plpgsql;

select * from total_usuarios()

create or replace function mostrar_usuarios() returns table(id_usuario integer, nome_usuario varchar, email_usuario varchar, telefone_usuario varchar, endereco_usuario text, data_cadastro_usuario timestamp) as $$
begin
	return query 
	select usuario.id, usuario.nome, usuario.email, usuario.telefone, usuario.endereco, usuario.data_cadastro from usuario;
end;
$$language plpgsql;

select * from mostrar_usuarios()

--
create or replace function mostrar_usuarios_id(id_usuario integer) returns table(id_user integer, nome_usuario varchar, email_usuario varchar, telefone_usuario varchar, endereco_usuario text, data_cadastro_usuario timestamp) as $$
begin
	return query 
	select usuario.id, usuario.nome, usuario.email, usuario.telefone, usuario.endereco, usuario.data_cadastro
	from usuario
	where id = id_usuario;
end;
$$language plpgsql;

select * from mostrar_usuarios_id(3)

--
create or replace function mostrar_livros_id(id_book integer) returns table(id_livro integer, titulo varchar, id_autor integer, id_categoria integer, ano_publicacao integer, numero_paginas integer, disponivel boolean, id_unidade integer) as $$
begin
	return query 
	select *
	from livro
	where id = id_book;
end;
$$language plpgsql;

select * from mostrar_livros_id(118)

--create view
create view vw_listar_todos_livros as 
select *
from livro;
select * from vw_listar_todos_livros

--2. Crie uma view que exiba os livros disponíveis com título, unidade e categoria.

create view vw_listar_livros_atributos as
select livro.id AS id_livro,
livro.titulo,
unidade.nome AS unidade_nome,
categoria.nome AS categoria_nome
from livro
join unidade on livro.id_unidade = unidade.id
join categoria on livro.id_categoria = categoria.id;

select * from vw_listar_livros_atributos

--3. Crie uma view para listar os usuários e o total de empréstimos realizados por cada um.

CREATE VIEW vw_listar_usuario_total_emprestimos AS
SELECT 
    usuario.id AS id_usuario,
	usuario.nome as nome_usuario,
    COUNT(emprestimo.id) AS total_emprestimos
FROM 
    usuario
LEFT JOIN 
    emprestimo ON usuario.id = emprestimo.id_usuario
GROUP BY 
    usuario.id, usuario.nome;

select * from vw_listar_usuario_total_emprestimos

-- 4. Crie uma view que mostre os empréstimos atrasados com os nomes dos usuários e os títulos dos livros.
CREATE VIEW vw_listar_emprestimo_atrasados AS
SELECT 
    usuario.id AS id_usuario,
    usuario.nome AS nome_usuario,
    livro.titulo AS livro_titulo,
    emprestimo.data_emprestimo,
    emprestimo.data_devolucao
FROM 
    usuario
JOIN 
    emprestimo ON usuario.id = emprestimo.id_usuario
JOIN 
    livro ON emprestimo.id_livro = livro.id
WHERE 
    emprestimo.devolvido = 'false' 
    AND emprestimo.data_devolucao < CURRENT_DATE;

select * from vw_listar_emprestimo_atrasados

--