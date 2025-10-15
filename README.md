# 📊 Northwind Fonksiyonları (PostgreSQL)

Bu proje, **Northwind veritabanı** üzerinde sık kullanılan sorguların PL/pgSQL fonksiyonları haline getirilmiş versiyonlarını içerir.  
Tüm fonksiyonlar `nw_` önekiyle başlar.

## 📌 Fonksiyon Listesi

| Fonksiyon Adı                      | Açıklama                                                   | Dönüş Tipi        |
|------------------------------------|-----------------------------------------------------------|-------------------|
| `nw_get_product_price`            | Ürün fiyatı döndürür.                                     | numeric(12,2)     |
| `nw_get_customer_order_count`     | Müşteri sipariş sayısını döndürür.                         | integer           |
| `nw_get_order_total`             | Siparişin toplam tutarını hesaplar.                         | numeric(12,2)     |
| `nw_get_employee_fullname`       | Çalışanın tam adını döndürür.                               | text              |
| `nw_get_category_product_count`  | Kategorideki ürün sayısını döndürür.                         | integer           |
| `nw_get_supplier_name`          | Tedarikçi adını döndürür.                                  | text              |
| `nw_get_top_product_by_category`| Kategorideki en pahalı ürünü bulur.                          | text              |
| `nw_get_average_product_price`  | Ortalama ürün fiyatını döndürür.                             | numeric(12,2)     |
| `nw_get_orders_in_period`       | Belirtilen tarih aralığındaki sipariş sayısını verir.        | integer           |
| `nw_get_customer_total_spent`   | Müşterinin toplam harcamasını hesaplar.                      | numeric(12,2)     |

## 🧪 Test

Her fonksiyonun altında örnek test çağrıları yer almaktadır.  
Örnek kullanım:
```sql
SELECT nw_get_product_price(1);
SELECT nw_get_customer_order_count('ALFKI');
