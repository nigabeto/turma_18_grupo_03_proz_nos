CREATE DATABASE Pizza_PROZ;

CREATE TABLE Cliente (
    Id_cliente SERIAL PRIMARY KEY,
    nome_cliente VARCHAR(50) NOT NULL,
    cpf_cliente VARCHAR(11) NOT NULL,
    telefone_cliente VARCHAR(13) NOT NULL
);

CREATE TABLE Endereco (
    Id_endereco SERIAL PRIMARY KEY,
    CEP VARCHAR(8) NOT NULL,
    endereco VARCHAR(100) NOT NULL,
    numero INT NOT NULL,
    bairro VARCHAR(30),
    cidade VARCHAR(30),
    complemento VARCHAR(20),
    fk_Cliente_Id_cliente INT,
    CONSTRAINT FK_Endereco_2 FOREIGN KEY (fk_Cliente_Id_cliente) REFERENCES Cliente (Id_cliente) ON DELETE CASCADE
);

CREATE TABLE Pedido (
    Id_pedido SERIAL PRIMARY KEY,
    data_pedido DATE NOT NULL,
	total_pedido DECIMAL(7,2) NOT NULL DEFAULT 0,
    fk_Cliente_Id_cliente INT,
    CONSTRAINT FK_Pedido_2 FOREIGN KEY (fk_Cliente_Id_cliente) REFERENCES Cliente (Id_cliente) ON DELETE CASCADE
);

CREATE TABLE Item (
    Id_item SERIAL PRIMARY KEY,
	nome_item VARCHAR(50) NOT NULL,
	tipo_item VARCHAR(30) NOT NULL,
    valor_item DECIMAL(7,2) NOT NULL
);

CREATE TABLE comanda (
    fk_Pedido_Id_pedido INT,
    fk_Item_Id_item INT,
    quantidade INT NOT NULL DEFAULT 1, -- Adicionando a coluna de quantidade
    CONSTRAINT FK_comanda_1 FOREIGN KEY (fk_Pedido_Id_pedido) REFERENCES Pedido (Id_pedido) ON DELETE CASCADE,
    CONSTRAINT FK_comanda_2 FOREIGN KEY (fk_Item_Id_item) REFERENCES Item (Id_item) ON DELETE CASCADE,
    CONSTRAINT PK_comanda PRIMARY KEY (fk_Pedido_Id_pedido, fk_Item_Id_item) -- Definindo uma chave primária composta
);

-- Criando o gatilho (trigger) para atualizar automaticamente o valor da coluna "total_pedido"
CREATE OR REPLACE FUNCTION atualizar_total_pedido()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Pedido
    SET total_pedido = (
        SELECT SUM(i.valor_item * c.quantidade)
        FROM comanda c
        JOIN Item i ON c.fk_Item_Id_item = i.Id_item
        WHERE c.fk_Pedido_Id_pedido = NEW.fk_Pedido_Id_pedido -- Corrigindo a referência ao Id_pedido
    )
    WHERE Id_pedido = NEW.fk_Pedido_Id_pedido; -- Corrigindo a referência ao Id_pedido

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER atualizar_total_pedido_trigger
AFTER INSERT ON comanda
FOR EACH ROW
EXECUTE FUNCTION atualizar_total_pedido();

--Cliente:
INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('João da Silva', '12365678901', '5511982926282');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('Maria Oliveira', '98765632109', '5511960378822');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('Jonas Alencar', '98765633727', '5511963828821');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('Pedro Santos', '03665632109', '5511960378822');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('Sandra Monteiro', '98815637200', '5511982827765');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('Patricia Novaes', '18782632122', '5511966578877');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)
VALUES ('Robson Trindade', '98766522105', '5511930573222');

INSERT INTO Cliente (nome_cliente, cpf_cliente, telefone_cliente)--8
VALUES ('Jaime Santos', '08766556135', '5511968576212');


--Endereco:
INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--1
VALUES ('03509000', 'Rua Antonio de barros', 123, 'Centro', 'Campinas', 'Apto 101', 1);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--2
VALUES ('87656321', 'Avenida Campos Sales', 26, 'Vila Maria', 'Campinas', 'Casa', 2);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--3
VALUES ('02706565', 'Praça Caetano Alves', 783, 'Vila Sonia', 'Campinas', 'Apto 207', 3);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--6
VALUES ('03509101', 'Avenida Joaquim Marra', 65, 'Cajueiro', 'Campinas', 'Casa', 6);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--5
VALUES ('03508767', 'Alameda Santos', 73, 'Morro Alto', 'Campinas', 'Casa 3', 5);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--6
VALUES ('03709772', 'Rua Albuquerque Lins', 626, 'Vila Matilde', 'Campinas', 'Apto 35', 6);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--7
VALUES ('03697122', 'Rua Santa Clara', 71, 'Penha', 'Campinas', 'Casa', 7);

INSERT INTO Endereco (CEP, endereco, numero, bairro, cidade, complemento, fk_Cliente_Id_cliente)--8
VALUES ('03355122', 'Rua Joana Campos', 97, 'Barreirinha', 'Campinas', 'Casa', 8);

--Item:
INSERT INTO Item (valor_item, nome_item, tipo_item)--1
VALUES (35.00, 'Marguerita', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--2
VALUES (29.75, 'Calabresa', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--3
VALUES (28.00, 'Portuguesa', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--6
VALUES (30.50, 'Presunto', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--5
VALUES (37.00, 'Camarão', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--6
VALUES (32.00, 'Atum', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--7
VALUES (31.70, 'Napolitana', 'Pizza');
INSERT INTO Item (valor_item, nome_item, tipo_item)--8
VALUES (5.75, 'Coca', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--9
VALUES (5.75, 'Guaraná', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--10
VALUES (5.75, 'Fanta', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--11
VALUES (8.75, 'Cerveja', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--12
VALUES (9.00, 'Suco de Laranja', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--13
VALUES (9.00, 'Suco de Abacaxi', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--16
VALUES (9.00, 'Suco de Limão', 'Bebida');
INSERT INTO Item (valor_item, nome_item, tipo_item)--15
VALUES (10.30, 'Torta Holandesa', 'Sobremesa');
INSERT INTO Item (valor_item, nome_item, tipo_item)--16
VALUES (12.20, 'Salada de Frutas', 'Sobremesa');
INSERT INTO Item (valor_item, nome_item, tipo_item)--17
VALUES (13.30, 'Mussi de Chocolate', 'Sobremesa');
INSERT INTO Item (valor_item, nome_item, tipo_item)--18
VALUES (13.30, 'Mussi de Limão', 'Sobremesa');
INSERT INTO Item (valor_item, nome_item, tipo_item)--19
VALUES (15.00, 'Pudim de Leite', 'Sobremesa');
INSERT INTO Item (valor_item, nome_item, tipo_item)--20
VALUES (11.00, 'Brigadeiro', 'Sobremesa');

--Pedido / Comanda:

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--1
VALUES ('2023-10-10', 1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 1 ORDER BY Id_pedido DESC LIMIT 1),1,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 1 ORDER BY Id_pedido DESC LIMIT 1),9,1);

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--2
VALUES ('2023-11-09', 2);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 2 ORDER BY Id_pedido DESC LIMIT 1),3,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 2 ORDER BY Id_pedido DESC LIMIT 1),13,1);

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--3
VALUES ('2023-12-22', 3);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 3 ORDER BY Id_pedido DESC LIMIT 1),6,2);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 3 ORDER BY Id_pedido DESC LIMIT 1),10,3);

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--6
VALUES ('2026-01-05', 6);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),7,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),19,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),12,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),16,1);


INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--5
VALUES ('2026-01-12', 5);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 5 ORDER BY Id_pedido DESC LIMIT 1),6,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 5 ORDER BY Id_pedido DESC LIMIT 1),11,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 5 ORDER BY Id_pedido DESC LIMIT 1),20,1);


INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--6
VALUES ('2026-01-17', 6);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),5,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),9,2);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 6 ORDER BY Id_pedido DESC LIMIT 1),18,2);

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--7
VALUES ('2024-02-07', 7);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 7 ORDER BY Id_pedido DESC LIMIT 1),3,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 7 ORDER BY Id_pedido DESC LIMIT 1),11,1);

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--8
VALUES ('2024-02-17', 8);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 8 ORDER BY Id_pedido DESC LIMIT 1),11,3);


INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--9
VALUES ('2024-02-25', 2);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 2 ORDER BY Id_pedido DESC LIMIT 1),2,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 2 ORDER BY Id_pedido DESC LIMIT 1),8,2);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 2 ORDER BY Id_pedido DESC LIMIT 1),17,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 2 ORDER BY Id_pedido DESC LIMIT 1),18,1);

INSERT INTO Pedido (data_pedido, fk_Cliente_Id_cliente)--10
VALUES ('2024-02-27', 5);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 5 ORDER BY Id_pedido DESC LIMIT 1),17,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 5 ORDER BY Id_pedido DESC LIMIT 1),15,1);
INSERT INTO comanda (fk_Pedido_Id_pedido, fk_Item_Id_item, quantidade)
VALUES ((SELECT Id_pedido FROM Pedido WHERE fk_Cliente_Id_cliente = 5 ORDER BY Id_pedido DESC LIMIT 1),13,2);


--QUERYS

--Listar todos os clientes ordenados por nome_cliente em ordem crescente:
SELECT * FROM Cliente
ORDER BY nome_cliente;

--Listar todos os clientes e seus respectivos endereços, contendo apenas os campos nome_cliente, endereço e número:
SELECT c.nome_cliente, e.endereco, e.numero
FROM Cliente c
JOIN Endereco e ON c.Id_cliente = e.fk_Cliente_Id_cliente;

--Listar todos os pedidos em ordem crescente por data_pedido, contendo o Id do pedido, data_pedido, nome_cliente e total_pedido:
SELECT p.Id_pedido, p.data_pedido, c.nome_cliente, p.total_pedido
FROM Pedido p
JOIN Cliente c ON p.fk_Cliente_Id_cliente = c.Id_cliente
ORDER BY p.data_pedido ASC;

--Listar todos os pedidos contendo Id do pedido, data_pedido, os itens que compõem estes pedidos de acordo com as suas respectivas comandas e valor total do pedido:
SELECT p.Id_pedido, p.data_pedido, STRING_AGG(i.nome_item, ', ') AS itens_pedido, p.total_pedido
FROM Pedido p
JOIN comanda c ON p.Id_pedido = c.fk_Pedido_Id_pedido
JOIN Item i ON c.fk_Item_Id_item = i.Id_item
GROUP BY p.Id_pedido, p.data_pedido, p.total_pedido;

--Listar qual foi o maior pedido considerando valor total_pedido, contendo número do pedido, data do pedido, cliente e valor total:
SELECT p.Id_pedido, p.data_pedido, c.nome_cliente, p.total_pedido
FROM Pedido p
JOIN Cliente c ON p.fk_Cliente_Id_cliente = c.Id_cliente
ORDER BY p.total_pedido DESC
LIMIT 1;

--Listar quais clientes incluíram cerveja em seus pedidos:
SELECT DISTINCT c.nome_cliente
FROM Cliente c
JOIN Pedido p ON c.Id_cliente = p.fk_Cliente_Id_cliente
JOIN comanda cm ON p.Id_pedido = cm.fk_Pedido_Id_pedido
JOIN Item i ON cm.fk_Item_Id_item = i.Id_item
WHERE i.nome_item = 'Cerveja';

--Listar quais clientes fizeram pedidos com apenas um item em sua comanda, contendo nome do cliente, numero do pedido e item pedido.
SELECT c.nome_cliente, p.Id_pedido, i.nome_item AS item_pedido
FROM Cliente c
JOIN Pedido p ON c.Id_cliente = p.fk_Cliente_Id_cliente
JOIN (
    SELECT fk_Pedido_Id_pedido, COUNT(*) AS num_itens
    FROM comanda
    GROUP BY fk_Pedido_Id_pedido
    HAVING COUNT(*) = 1
) AS comandas_um_item ON p.Id_pedido = comandas_um_item.fk_Pedido_Id_pedido
JOIN comanda cm ON p.Id_pedido = cm.fk_Pedido_Id_pedido
JOIN Item i ON cm.fk_Item_Id_item = i.Id_item;

--Listar qual foi o pedido com maior valor total_pedido, contendo número do pedido, data do pedido e os itens das comandas que compõem este pedido:
SELECT p.Id_pedido, p.data_pedido, STRING_AGG(i.nome_item, ', ') AS itens_pedido
FROM Pedido p
JOIN comanda c ON p.Id_pedido = c.fk_Pedido_Id_pedido
JOIN Item i ON c.fk_Item_Id_item = i.Id_item
GROUP BY p.Id_pedido, p.data_pedido, p.total_pedido
ORDER BY p.total_pedido DESC
LIMIT 1;

--Listar quais pedidos possuem comanda onde as quantidades de itens são maiores que 1, contendo número do pedido, data do pedido, cliente e item da comanda:
SELECT p.Id_pedido, p.data_pedido, cl.nome_cliente, i.nome_item, c.quantidade
FROM Pedido p
JOIN comanda c ON p.Id_pedido = c.fk_Pedido_Id_pedido
JOIN Item i ON c.fk_Item_Id_item = i.Id_item
JOIN Cliente cl ON p.fk_Cliente_Id_cliente = cl.Id_cliente
WHERE c.quantidade > 1;

--Listar quais pedidos possuem comanda onde foi solicitado o tipo de item = sobremesa, mostrando o número do pedido, data do pedido, cliente e item da comanda:
SELECT p.Id_pedido, p.data_pedido, cl.nome_cliente, i.nome_item
FROM Pedido p
JOIN comanda c ON p.Id_pedido = c.fk_Pedido_Id_pedido
JOIN Item i ON c.fk_Item_Id_item = i.Id_item
JOIN Cliente cl ON p.fk_Cliente_Id_cliente = cl.Id_cliente
WHERE i.tipo_item = 'Sobremesa';
