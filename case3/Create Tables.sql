use tourism;

# Создание справочника стран
create table countries (
country_id int primary key,
country_name varchar(100) not null -- Название страны
);

# Создание справочника отелей
create table hotels (
hotel_id int not null,
country_id int not null, -- код страны
hotel_name varchar(100) not null, -- Наименование отеля
hotel_type varchar(30) not null, -- Тип отеля (гостиница, хостел и т.п.)
hotel_class varchar(5) not null, -- Класс отеля (количество звёзд) 
primary key (hotel_id),
-- Связываем по внешнему ключу с таблицей стран
foreign key (country_id) references countries(country_id)
);

# Создание справочника сотрудников
create table employees (
employee_id int primary key,
fio varchar(100) not null, -- ФИО сотрудника
phone varchar(20) not null -- Телефон сотрудника
);

# Создание справочника туров
create table tours (
tour_id int primary key,
tour_name varchar(100) not null, -- Название тура
price numeric(9,2) not null, -- Цена
depart_date date not null, -- Дата отправления
depart_city varchar(30) not null, -- Город отправления
operator varchar(50) not null, -- Туроператор 
days smallint not null, -- Кол-во дней
nights smallint not null, -- Кол-во ночей
tour_type varchar(100) not null, -- Тип тура (произвольная текстовая информация по туру)
country_id int not null, -- Код страны назначения
hotel_id int, -- Код отеля
-- Связываем по внешнему ключу с таблицами стран и отелей
foreign key (country_id) references countries(country_id),
foreign key (hotel_id) references hotels(hotel_id)
);

# Создание таблицы продаж туров
create table sales (
sale_id int primary key, -- Первичный ключ
sale_date date not null, -- Дата продажи
client_name varchar(100) not null, -- Имя клиента (ФИО или название организации)
client_passport varchar(100), -- Паспортные данные (для физлиц)
adults_count smallint not null, -- Количество взрослых
children_count smallint not null, -- Количество детей
tour_id int not null, -- Код тура
employee_id int not null, -- Код сотрудника, продавшего тур
-- Связываем по внешнему ключу с таблицами туров и работников
foreign key (tour_id) references tours(tour_id),
foreign key (employee_id) references employees(employee_id)
);
