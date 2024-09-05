-- Criar uma stored procedure "ver_extrato" para fornecer uma visão detalhada doe xtrado bancário de um cliente,
-- incluindo saldo atual e as informações das últimas 10 transações realizada.
-- Esta operação recebe como entrada o id do cliente e retorna uma mensagem com o saldo atual do cliente e uma lista das últimas 10 transações
-- contendo o ID da transação, o tipo de trasação (deposito ou retirada), uma breve descrição, o valor da trasação e a data em que foi realizada

CREATE OR REPLACE PROCEDURE ver_extrato(
    IN p_client_id UUID
)
LANGUAGE plpgsql
AS $$
DECLARE
    saldo_atual INTEGER;
    transacao RECORD;
    contador INTEGER := 0;
BEGIN
    SELECT saldo INTO saldo_atual
    FROM clients
    WHERE id = p_client_id;

    RAISE NOTICE 'Saldo atual do cliente: %', saldo_atual;

    RAISE NOTICE 'Últimas 10 trasanções';

    FOR transacao IN
        SELECT *
        FROM transactions
        WHERE client_id = p_client_id
        ORDER BY realizado_em DESC
        LIMIT 10
    LOOP
        contador := contador + 1;
        RAISE NOTICE 'ID: %, Tipo: %, Descrição: %, Valor: %, Data: %',
            transacao.id, transacao.tipo, transacao.descricao, transacao.valor, transacao.realizado_em;
        EXIT WHEN contador >= 10;
    END LOOP;
END;
$$;