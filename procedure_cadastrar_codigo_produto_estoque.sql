
DELIMITER $$

DROP PROCEDURE IF EXISTS `cadastrar_codigo_produto_estoque` $$

CREATE PROCEDURE `cadastrar_codigo_produto_estoque`(
nome varchar(30), 
preco double ,
kilograma double,
quantidade int
)
BEGIN
/*cria a variavel erro_sql e recebe FALSE por padrão*/
DECLARE erro_sql TINYINT DEFAULT FALSE; 
/* se ocorrer alguma excessão atribuir TRUE;*/
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET erro_sql = TRUE; 

/*validação caso algum parâmetro esteja vazio*/
IF(nome <> "" and preco <> "" and kilograma <> "" and quantidade <> "") THEN

	START TRANSACTION;
	SET @codigo = (SELECT barra + 1 AS valor FROM codigo ORDER BY id DESC LIMIT 1);
	INSERT INTO codigo values(NULL,ifnull(@codigo,default(barra)));
    /*validação caso aconteça algum erro*/
	IF erro_sql = true 
		THEN
		SELECT 'Erro ao inserir na tabela de código' AS Mensagem;
	ROLLBACK;
	ELSE
		INSERT INTO produto values(NULL, nome, preco, last_insert_id(), kilograma, now());
        /*validação caso aconteça algum erro*/
		IF erro_sql = true
			THEN
			SELECT 'Erro ao inserir na tabela de produto' AS Mensagem;
		ROLLBACK;
		ELSE
			INSERT INTO estoque values(null,last_insert_id(),quantidade);
            /*validação caso aconteça algum erro*/
			IF erro_sql = true
				THEN
				SELECT 'Erro ao inserir na tabela de estoque' AS Mensagem;
			ROLLBACK;
			ELSE
			 SELECT 'Cadastro efetuado com sucesso' AS Mensagem;
			  COMMIT;
			END IF;
		END IF;
	END IF;
ELSE
	SELECT 'Parâmetros vazios' AS Mensagem;
END IF;
                
END $$
DELIMITER ;