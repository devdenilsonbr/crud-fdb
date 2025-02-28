-- Criação das tabelas com melhorias

CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha TEXT NOT NULL, -- Senha deve ser armazenada como hash
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('usuario comum', 'adm')),
    preferencias_acessibilidade VARCHAR(255),
    localizacao_atual VARCHAR(100)
);

CREATE TABLE localizacao_usuario (
    id_localizacao SERIAL PRIMARY KEY,
    coordenadas VARCHAR(100),
    data_hora TIMESTAMP NOT NULL,
    id_usuario INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

CREATE TABLE transporte_publico (
    id_transporte SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50) NOT NULL CHECK (tipo IN ('ônibus', 'metrô', 'trem')),
    horario TIME NOT NULL,
    acessibilidade VARCHAR(100) NOT NULL
);

CREATE TABLE ponto_interesse (
    id_ponto SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(100) NOT NULL,
    locabilidade VARCHAR(100),
    disponibilidade VARCHAR(100)
);

CREATE TABLE rota (
    id_rota SERIAL PRIMARY KEY,
    distancia FLOAT NOT NULL CHECK (distancia >= 0),
    descricao TEXT NOT NULL,
    tipo_acessibilidade VARCHAR(100) NOT NULL,
    id_usuario INT NOT NULL,
    id_destino INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_destino) REFERENCES ponto_interesse(id_ponto) ON DELETE CASCADE
);

CREATE TABLE rota_transporte (
    id_rota INT NOT NULL,
    id_transporte INT NOT NULL,
    PRIMARY KEY (id_rota, id_transporte),
    FOREIGN KEY (id_rota) REFERENCES rota(id_rota) ON DELETE CASCADE,
    FOREIGN KEY (id_transporte) REFERENCES transporte_publico(id_transporte) ON DELETE CASCADE
);

CREATE TABLE avaliacao (
    id_avaliacao SERIAL PRIMARY KEY,
    nota FLOAT NOT NULL CHECK (nota BETWEEN 0 AND 5),
    comentario TEXT,
    data DATE NOT NULL DEFAULT CURRENT_DATE,
    id_usuario INT NOT NULL,
    id_rota INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_rota) REFERENCES rota(id_rota) ON DELETE CASCADE
);

CREATE TABLE rota_ponto (
    id_rota INT NOT NULL,
    id_ponto INT NOT NULL,
    PRIMARY KEY (id_rota, id_ponto),
    FOREIGN KEY (id_rota) REFERENCES rota(id_rota) ON DELETE CASCADE,
    FOREIGN KEY (id_ponto) REFERENCES ponto_interesse(id_ponto) ON DELETE CASCADE
);

CREATE TABLE relatorio_problema (
    id_problema SERIAL PRIMARY KEY,
    descricao TEXT NOT NULL,
    data DATE NOT NULL DEFAULT CURRENT_DATE,
    status VARCHAR(50) NOT NULL CHECK (status IN ('pendente', 'em andamento', 'resolvido')),
    prioridade VARCHAR(50) NOT NULL CHECK (prioridade IN ('baixa', 'média', 'alta')),
    id_usuario INT NOT NULL,
    id_ponto_rota INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_ponto_rota) REFERENCES rota_ponto(id_ponto) ON DELETE CASCADE
);

CREATE TABLE historico (
    id_historico SERIAL PRIMARY KEY,
    data TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    id_ponto_rota INT NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_ponto_rota) REFERENCES rota_ponto(id_ponto) ON DELETE CASCADE
);

-- Inserção de dados na tabela usuario
INSERT INTO usuario (nome, email, senha, tipo, preferencias_acessibilidade, localizacao_atual)
VALUES
    ('Lucas Almeida', 'lucas@xyz.com', '54321', 'usuario comum', 'nenhuma', 'Fortaleza'),
    ('Ana Beatriz', 'ana@abc.com', '98765', 'usuario comum', 'nenhuma', 'Recife'),
    ('Gabriel Souza', 'gabriel@def.com', '45678', 'usuario comum', 'nenhuma', 'Salvador'),
    ('Mariana Lima', 'mariana@ghi.com', '11223', 'usuario comum', 'nenhuma', 'Curitiba'),
    ('Felipe Costa', 'felipe@jkl.com', '33445', 'usuario comum', 'nenhuma', 'São Paulo'),
    ('Juliana Mendes', 'juliana@mno.com', '66789', 'usuario comum', 'nenhuma', 'Rio de Janeiro'),
    ('Rafael Santos', 'rafael@pqr.com', '99887', 'usuario comum', 'nenhuma', 'Belo Horizonte'),
    ('Camila Oliveira', 'camila@stu.com', '22446', 'usuario comum', 'nenhuma', 'Porto Alegre'),
    ('Bruno Ferreira', 'bruno@vwx.com', '77889', 'usuario comum', 'nenhuma', 'Manaus'),
    ('Matheus Narcizio', 'matheus@fbd.com', '12345', 'adm', 'nenhuma', 'Quixadá');
    
-- Inserção de dados na tabela localizacao_usuario
INSERT INTO localizacao_usuario (coordenadas, data_hora, id_usuario)
VALUES
    ('-23.550520, -46.633308', '2024-02-01 10:00:00', 4),
    ('-22.906847, -43.172897', '2024-02-02 11:00:00', 6),
    ('-19.916681, -43.934493', '2024-02-03 12:00:00', 2),
    ('-15.826691, -47.921822', '2024-02-04 13:00:00', 3),
    ('-12.971399, -38.501632', '2024-02-05 14:00:00', 5),
    ('-8.047562, -34.877018', '2024-02-06 15:00:00', 1),
    ('-3.731862, -38.526669', '2024-02-07 16:00:00', 8),
    ('-30.034647, -51.217658', '2024-02-08 17:00:00', 7),
    ('-1.455754, -48.490179', '2024-02-09 18:00:00', 9),
    ('-25.428954, -49.267137', '2024-02-10 19:00:00', 10);

-- Inserção de dados na tabela transporte_publico
INSERT INTO transporte_publico (nome, tipo, horario, acessibilidade)
VALUES
    ('Ônibus 101', 'Ônibus', '06:30:00', 'Acessível para cadeirantes'),
    ('Metrô Linha 1', 'Metrô', '07:15:00', 'Elevadores disponíveis'),
    ('BRT Expresso', 'BRT', '08:00:00', 'Rampa de acesso'),
    ('VLT Centro', 'VLT', '09:45:00', 'Espaço para cadeirantes'),
    ('Ônibus 202', 'Ônibus', '11:20:00', 'Acessível para cegos e surdos'),
    ('Metrô Linha 2', 'Metrô', '13:10:00', 'Plataforma adaptada'),
    ('Bonde Histórico', 'Bonde', '15:30:00', 'Sem acessibilidade'),
    ('Ferry Boat', 'Ferry', '17:00:00', 'Acessível para cadeirantes e idosos'),
    ('Ônibus Noturno', 'Ônibus', '22:45:00', 'Acessível para todos'),
    ('Metrô Linha 3', 'Metrô', '23:55:00', 'Elevadores e rampas disponíveis');

-- Inserção de dados na tabela ponto_interesse
INSERT INTO ponto_interesse (nome, tipo, locabilidade, disponibilidade)
VALUES
    ('Parque Central', 'Parque', 'Área urbana', '24 horas'),
    ('Museu de Arte', 'Museu', 'Centro da cidade', 'Ter-Sáb 10:00 - 18:00'),
    ('Biblioteca Municipal', 'Biblioteca', 'Bairro universitário', 'Seg-Sex 08:00 - 20:00'),
    ('Shopping Plaza', 'Shopping', 'Zona comercial', 'Diariamente 10:00 - 22:00'),
    ('Estádio Nacional', 'Estádio', 'Região metropolitana', 'Eventos programados'),
    ('Praia do Sol', 'Praia', 'Litoral', 'Livre acesso'),
    ('Teatro Municipal', 'Teatro', 'Centro histórico', 'Conforme programação'),
    ('Zoológico da Cidade', 'Zoológico', 'Área verde', 'Qua-Dom 09:00 - 17:00'),
    ('Centro de Convenções', 'Centro de Eventos', 'Região central', 'Conforme eventos'),
    ('Mirante da Serra', 'Mirante', 'Área montanhosa', '06:00 - 18:00');

-- Inserção de dados na tabela rota
INSERT INTO rota (distancia, descricao, tipo_acessibilidade, id_usuario, id_destino)
VALUES
    (2.5, 'Caminho até o parque', 'Rampa para cadeirantes', 1, 1),
    (5.2, 'Rota até o museu', 'Elevadores disponíveis', 2, 2),
    (3.8, 'Trilha para a biblioteca', 'Acesso pavimentado', 3, 3),
    (1.5, 'Rota curta para o shopping', 'Totalmente acessível', 4, 4),
    (7.3, 'Percurso até o estádio', 'Sem acessibilidade', 5, 5),
    (4.0, 'Caminho para a praia', 'Rampa de acesso', 6, 6),
    (6.5, 'Trilha até o teatro', 'Apenas escadas', 7, 7),
    (3.2, 'Rota até o zoológico', 'Rampas e piso tátil', 8, 8),
    (5.7, 'Percurso até o centro de convenções', 'Acessível para todos', 9, 9),
    (8.0, 'Trilha até o mirante', 'Parcialmente acessível', 10, 10);

-- Inserção de dados na tabela rota_transporte
INSERT INTO rota_transporte (id_rota, id_transporte)
VALUES
    (1, 1),
    (2, 2),
    (3, 3),
    (4, 4),
    (5, 5),
    (6, 6),
    (7, 7),
    (8, 8),
    (9, 9),
    (10, 10);
    
-- Inserção de dados na tabela avaliacao
INSERT INTO avaliacao (nota, comentario, data, id_usuario, id_rota)
VALUES
    (4.5, 'Rota muito boa, bem sinalizada.', '2024-02-01', 1, 1),
    (3.0, 'Acessibilidade poderia ser melhor.', '2024-02-02', 2, 2),
    (5.0, 'Excelente percurso, sem problemas.', '2024-02-03', 3, 3),
    (2.5, 'Houve algumas dificuldades na rota.', '2024-02-04', 4, 4),
    (4.0, 'A rota foi tranquila, mas um pouco longa.', '2024-02-05', 5, 5),
    (3.5, 'Rota razoável, mas poderia melhorar.', '2024-02-06', 6, 6),
    (5.0, 'A melhor rota até agora, super tranquila!', '2024-02-07', 7, 7),
    (2.0, 'A rota foi um pouco difícil de navegar.', '2024-02-08', 8, 8),
    (4.2, 'Boa rota, mas com alguns obstáculos.', '2024-02-09', 9, 9),
    (3.8, 'Acessibilidade boa, mas poderia ter mais pontos de descanso.', '2024-02-10', 10, 10),
	(3.0, 'Trilha até o zoológico', 'Acesso pavimentado', 2, 8),
	(5.0, 'Caminho até o museu', 'Rampas para cadeirantes', 5, 2),
	(2.0, 'Percuso até o teatro', 'Parcialmente acessível', 1, 7);

-- Inserção de dados na tabela rota_ponto
INSERT INTO rota_ponto (id_rota, id_ponto)
VALUES
    (1, 1),
    (1, 2),
    (2, 3),
    (2, 4),
    (3, 5),
    (3, 6),
    (4, 7),
    (4, 8),
    (5, 9),
    (5, 10);

-- Inserção de dados na tabela relatorio_problema
INSERT INTO relatorio_problema (descricao, data, status, prioridade, id_usuario, id_ponto_rota)
VALUES
    ('Lixo acumulado na entrada do parque', '2024-02-01', 'pendente', 'alta', 1, 1),
    ('Problema na sinalização de trânsito no museu', '2024-02-02', 'em andamento', 'média', 2, 2),
    ('Falta de acessibilidade no zoológico', '2024-02-03', 'resolvido', 'alta', 3, 3),
    ('Escada quebrada no shopping', '2024-02-04', 'pendente', 'média', 4, 4),
    ('Iluminação insuficiente no estádio', '2024-02-05', 'em andamento', 'baixa', 5, 5),
    ('Vias esburacadas no centro de convenções', '2024-02-06', 'pendente', 'alta', 6, 6),
    ('Acessibilidade inadequada na praia', '2024-02-07', 'resolvido', 'alta', 7, 7),
    ('Problema de segurança no teatro', '2024-02-08', 'pendente', 'média', 8, 8),
    ('Falta de limpeza no mirante', '2024-02-09', 'em andamento', 'baixa', 9, 9),
    ('Problema de sinalização na biblioteca', '2024-02-10', 'resolvido', 'baixa', 10, 10);

-- Inserção de dados na tabela historico
INSERT INTO historico (data, id_usuario, id_ponto_rota)
VALUES
    ('2024-02-01 10:00:00', 1, 1),
    ('2024-02-02 11:00:00', 2, 2),
    ('2024-02-03 12:00:00', 3, 3),
    ('2024-02-04 13:00:00', 4, 4),
    ('2024-02-05 14:00:00', 5, 5),
    ('2024-02-06 15:00:00', 6, 6),
    ('2024-02-07 16:00:00', 7, 7),
    ('2024-02-08 17:00:00', 8, 8),
    ('2024-02-09 18:00:00', 9, 9),
    ('2024-02-10 19:00:00', 10, 10);


