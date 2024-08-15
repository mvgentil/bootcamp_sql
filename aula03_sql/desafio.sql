-- 1. Cria um relatório para todos os pedidos de 1996 e seus clientes (152 linhas)
-- existem maneiras de fazer isso, aqui vão algumas delas que funcionam no postgres:
SELECT * 
FROM orders as o
INNER JOIN customers as c on o.customer_id = c.customer_id
WHERE order_date BETWEEN '01-01-1996' AND '31-12-1996'

SELECT * 
FROM orders o
INNER JOIN customers c on o.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 1996

SELECT * 
FROM orders o
INNER JOIN customers c on o.customer_id = c.customer_id
WHERE DATE_PART('YEAR', o.order_date) = 1996


-- 2. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem funcionários (5 linhas)
SELECT  e.city AS cidade,
        COUNT(DISTINCT c.customer_id)  AS total_clientes, 
        COUNT(DISTINCT e.employee_id)  AS total_funcionarios 
FROM  employees e
LEFT JOIN customers c on e.city = c.city
GROUP BY cidade

-- 3. Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem clientes (69 linhas)
SELECT  c.city AS cidade,
        COUNT(DISTINCT e.employee_id)  AS total_funcionarios ,
        COUNT(DISTINCT c.customer_id)  AS total_clientes
FROM  customers c
LEFT JOIN employees e on e.city = c.city
GROUP BY cidade

-- 4.Cria um relatório que mostra o número de funcionários e clientes de cada cidade (71 linhas)
SELECT
	COALESCE(e.city, c.city) AS cidade,
	COUNT(DISTINCT e.employee_id) AS numero_de_funcionarios,
	COUNT(DISTINCT c.customer_id) AS numero_de_clientes
FROM employees e 
FULL JOIN customers c ON e.city = c.city
GROUP BY e.city, c.city
ORDER BY cidade;

-- 5. Cria um relatório que mostra a quantidade total de produtos encomendados.
-- Mostra apenas registros para produtos para os quais a quantidade encomendada é menor que 200 (5 linhas)
SELECT o.product_id, p.product_name, SUM(o.quantity) AS quantidade_total
FROM order_details o
JOIN products p ON p.product_id = o.product_id
GROUP BY o.product_id, p.product_name
HAVING SUM(o.quantity) < 200
ORDER BY quantidade_total DESC

-- 6. Cria um relatório que mostra o total de pedidos por cliente desde 31 de dezembro de 1996.
-- O relatório deve retornar apenas linhas para as quais o total de pedidos é maior que 15 (5 linhas)

SELECT c.customer_id, c.company_name, COUNT(o.order_id) as total_pedidos
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE order_date > '1996-12-31'
GROUP by c.customer_id, c.company_name
HAVING COUNT(o.order_id) > 15
ORDER BY total_pedidos DESC