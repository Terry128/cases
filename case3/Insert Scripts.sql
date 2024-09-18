use tourism;


insert into countries (country_id,country_name)
values (1, 'Россия');
insert into countries (country_id,country_name)
values (2, 'Казахстан');
insert into countries (country_id,country_name)
values (3, 'Турция');


insert into hotels (hotel_id, country_id, hotel_name, hotel_type, hotel_class)
values (1, 1, 'Ренессанс, Москва', 'Отель', '5*');
insert into hotels (hotel_id, country_id, hotel_name, hotel_type, hotel_class)
values (2, 2, 'Турист, Астана', 'Гостиница', '3*');
insert into hotels (hotel_id, country_id, hotel_name, hotel_type, hotel_class)
values (3, 1, 'Сокос, Санкт-Петербург', 'Отель', '4*');
insert into hotels (hotel_id, country_id, hotel_name, hotel_type, hotel_class)
values (4, 3, 'Хилтон, Стамбул', 'Отель', '5*');
insert into hotels (hotel_id, country_id, hotel_name, hotel_type, hotel_class)
values (5, 3, 'Алания', 'Курортный отель', '4*');


insert into employees (employee_id, fio, phone)
values (1, 'Иванов Иван Иванович', '+71234567897');
insert into employees (employee_id, fio, phone)
values (2, 'Петров Петр Петрович', '+7987456321');


insert into tours (tour_id, tour_name, price, depart_date, depart_city, operator,
                   days, nights, tour_type, country_id, hotel_id)
values (1, 'Отдых в Алании', 15000.50, '2024-09-10', 'Москва', 'Tez Tour',
                   7, 6, 'Летний отдых у моря. Всё включено', 3, 5);
insert into tours (tour_id, tour_name, price, depart_date, depart_city, operator,
                   days, nights, tour_type, country_id, hotel_id)
values (2, 'Степная охота', 25000, '2024-08-22', 'Москва', 'Coral Travel',
                   3, 2, 'Охотничий тур', 2, Null);
           
           
insert into sales (sale_id, sale_date, client_name, client_passport, adults_count, 
                   children_count, tour_id, employee_id)
values (1, '2024-08-06', 'ООО "Рога и копыта"', Null, 6, 
                   0, 2, 1);   
insert into sales (sale_id, sale_date, client_name, client_passport, adults_count, 
                   children_count, tour_id, employee_id)
values (2, '2024-08-15', 'Семенов Семен Семенович', 'ХХ 1234567', 2, 
                   1, 1, 2);