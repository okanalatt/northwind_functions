-- ============================================================
-- 1. nw_get_product_price
-- Açıklama: Ürün ID'sine göre fiyat döndürür. Eğer ürün yoksa 0 döner.
-- Tablo: products
-- Parametre: p_product_id INTEGER
-- Dönüş: numeric(12,2)
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_product_price(p_product_id INTEGER)
RETURNS numeric(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_price numeric(12,2);
BEGIN
    SELECT unit_price INTO v_price
    FROM products
    WHERE product_id = p_product_id;

    RETURN COALESCE(v_price, 0);
END;
$$;

-- Test Çağrıları:
SELECT nw_get_product_price(1); -- Beklenen: 18.00 (ProductID=1 fiyatı)
SELECT nw_get_product_price(9999); -- Beklenen: 0.00 (Ürün yok)


-- ============================================================
-- 2. nw_get_customer_order_count
-- Açıklama: Müşterinin toplam sipariş sayısını döndürür.
-- Tablo: orders
-- Parametre: p_customer_id TEXT
-- Dönüş: INTEGER
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_customer_order_count(p_customer_id TEXT)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM orders
    WHERE customer_id = p_customer_id;

    RETURN COALESCE(v_count, 0);
END;
$$;

select * from orders
-- Test Çağrıları:
SELECT nw_get_customer_order_count('ALFKI'); -- Beklenen: >0
SELECT nw_get_customer_order_count('XXXX'); -- Beklenen: 0


-- ============================================================
-- 3. nw_get_order_total
-- Açıklama: Siparişin toplam tutarını hesaplar.
-- Tablo: order_details
-- Parametre: p_order_id INTEGER
-- Dönüş: numeric(12,2)
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_order_total(p_order_id INTEGER)
RETURNS numeric(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total numeric(12,2);
BEGIN
    SELECT SUM((unit_price * quantity) * (1 - discount)) INTO v_total
    FROM order_details
    WHERE order_id = p_order_id;

    RETURN COALESCE(v_total, 0);
END;
$$;

-- Test Çağrıları:
SELECT nw_get_order_total(10248); -- Beklenen: Toplam sipariş tutarı
SELECT nw_get_order_total(9999);  -- Beklenen: 0.00


-- ============================================================
-- 4. nw_get_employee_fullname
-- Açıklama: Çalışanın tam adını döndürür (Firstname + Lastname)
-- Tablo: employees
-- Parametre: p_employee_id INTEGER
-- Dönüş: TEXT
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_employee_fullname(p_employee_id INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_name TEXT;
BEGIN
    SELECT first_name || ' ' || last_name INTO v_name
    FROM employees
    WHERE employee_id = p_employee_id;

    RETURN COALESCE(v_name, 'Çalışan bulunamadı');
END;
$$;

-- Test Çağrıları:
SELECT nw_get_employee_fullname(1); -- Beklenen: "Nancy Davolio"
SELECT nw_get_employee_fullname(999); -- Beklenen: "Çalışan bulunamadı"


-- ============================================================
-- 5. nw_get_category_product_count
-- Açıklama: Kategori ID’ye göre ürün sayısını döndürür.
-- Tablo: products
-- Parametre: p_category_id INTEGER
-- Dönüş: INTEGER
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_category_product_count(p_category_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM products
    WHERE category_id = p_category_id;

    RETURN COALESCE(v_count, 0);
END;
$$;

-- Test Çağrıları:
SELECT nw_get_category_product_count(1); -- Beklenen: >0
SELECT nw_get_category_product_count(999); -- Beklenen: 0


-- ============================================================
-- 6. nw_get_supplier_name
-- Açıklama: Tedarikçi ID’ye göre şirket adını döndürür.
-- Tablo: suppliers
-- Parametre: p_supplier_id INTEGER
-- Dönüş: TEXT
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_supplier_name(p_supplier_id INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_name TEXT;
BEGIN
    SELECT company_name INTO v_name
    FROM suppliers
    WHERE supplier_id = p_supplier_id;

    RETURN COALESCE(v_name, 'Tedarikçi bulunamadı');
END;
$$;

-- Test Çağrıları:
SELECT nw_get_supplier_name(1); -- Beklenen: "Exotic Liquids"
SELECT nw_get_supplier_name(999); -- Beklenen: "Tedarikçi bulunamadı"


-- ============================================================
-- 7. nw_get_top_product_by_category
-- Açıklama: Kategoriye göre en pahalı ürünü döndürür.
-- Tablo: products
-- Parametre: p_category_id INTEGER
-- Dönüş: TEXT
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_top_product_by_category(p_category_id INTEGER)
RETURNS TEXT
LANGUAGE plpgsql
AS $$
DECLARE
    v_name TEXT;
BEGIN
    SELECT product_name INTO v_name
    FROM products
    WHERE category_id = p_category_id
    ORDER BY unit_price DESC
    LIMIT 1;

    RETURN COALESCE(v_name, 'Ürün yok');
END;
$$;

-- Test Çağrıları:
SELECT nw_get_top_product_by_category(1); -- Beklenen: En pahalı ürün adı
SELECT nw_get_top_product_by_category(999); -- Beklenen: "Ürün yok"


-- ============================================================
-- 8. nw_get_average_product_price
-- Açıklama: Tüm ürünlerin ortalama fiyatını döndürür.
-- Tablo: products
-- Parametre: Yok
-- Dönüş: numeric(12,2)
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_average_product_price()
RETURNS numeric(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_avg numeric(12,2);
BEGIN
    SELECT AVG(unit_price)::numeric(12,2) INTO v_avg
    FROM products;

    RETURN COALESCE(v_avg, 0);
END;
$$;

-- Test Çağrıları:
SELECT nw_get_average_product_price(); -- Beklenen: Ortalama fiyat
-- (Boş veri olsa bile 0.00 döner)


-- ============================================================
-- 9. nw_get_orders_in_period
-- Açıklama: Belirtilen tarih aralığındaki sipariş sayısını döndürür.
-- Tablo: orders
-- Parametre: p_start DATE, p_end DATE
-- Dönüş: INTEGER
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_orders_in_period(p_start DATE, p_end DATE)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM orders
    WHERE order_date BETWEEN p_start AND p_end;

    RETURN COALESCE(v_count, 0);
END;
$$;

-- Test Çağrıları:
SELECT nw_get_orders_in_period('1996-07-01', '1996-07-31'); -- Beklenen: Ay içi sipariş sayısı
SELECT nw_get_orders_in_period('2100-01-01', '2100-12-31'); -- Beklenen: 0


-- ============================================================
-- 10. nw_get_customer_total_spent
-- Açıklama: Bir müşterinin tüm siparişlerinden harcadığı toplam tutarı döndürür.
-- Tablo: orders, order_details
-- Parametre: p_customer_id TEXT
-- Dönüş: numeric(12,2)
-- ============================================================
CREATE OR REPLACE FUNCTION nw_get_customer_total_spent(p_customer_id TEXT)
RETURNS numeric(12,2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_total numeric(12,2);
BEGIN
    SELECT SUM((od.unit_price * od.quantity) * (1 - od.discount)) INTO v_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    WHERE o.customer_id = p_customer_id;

    RETURN COALESCE(v_total, 0);
END;
$$;

-- Test Çağrıları:
SELECT nw_get_customer_total_spent('ALFKI'); -- Beklenen: Müşterinin toplam harcaması
SELECT nw_get_customer_total_spent('XXXX'); -- Beklenen: 0.00
