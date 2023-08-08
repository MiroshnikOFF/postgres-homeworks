-- Напишите запросы, которые выводят следующую информацию:
-- 1. Название компании заказчика (company_name из табл. customers) и ФИО сотрудника, работающего над заказом этой компании (см таблицу employees),
-- когда и заказчик и сотрудник зарегистрированы в городе London, а доставку заказа ведет компания United Package (company_name в табл shippers)

SELECT company_name AS customer, employee
FROM (SELECT customer_id, CONCAT(first_name, ' ', last_name) AS employee, city AS employee_city, ship_via
      FROM orders
      JOIN employees USING(employee_id)
     ) AS orders
JOIN customers USING(customer_id)
WHERE customers.city = orders.employee_city AND ship_via = (
                                                            SELECT shipper_id FROM shippers
                                                            WHERE company_name = 'United Package'
														   )


-- 2. Наименование продукта, количество товара (product_name и units_in_stock в табл products),
-- имя поставщика и его телефон (contact_name и phone в табл suppliers) для таких продуктов,
-- которые не сняты с продажи (поле discontinued) и которых меньше 25 и которые в категориях Dairy Products и Condiments.
-- Отсортировать результат по возрастанию количества оставшегося товара.

SELECT product_name, units_in_stock, contact_name, phone
FROM products
JOIN suppliers USING(supplier_id)
WHERE discontinued = 0 AND units_in_stock < 25 AND category_id IN (SELECT category_id
																   FROM categories
																   WHERE category_name IN
																   (
																	'Dairy Products',
																	'Condiments'
																   )
																  )
ORDER BY units_in_stock


-- 3. Список компаний заказчиков (company_name из табл customers), не сделавших ни одного заказа

SELECT company_name
FROM customers
WHERE customer_id NOT IN (SELECT customer_id
					  FROM orders
	                 )


-- 4. уникальные названия продуктов, которых заказано ровно 10 единиц (количество заказанных единиц см в колонке quantity табл order_details)
-- Этот запрос написать именно с использованием подзапроса.

SELECT DISTINCT(product_name)
FROM (SELECT product_id, quantity
	  FROM order_details
	 ) AS product_quantity
JOIN products USING(product_id)
WHERE product_quantity.quantity = 10

