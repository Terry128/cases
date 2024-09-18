use energo;


INSERT INTO `energo`.`abon_info`
(`abon_info_id`,
`session_id`,
`lic_schet`,
`address`,
`abon_fio`,
`schetchik_type`,
`schetchik_sn`,
`schetchik_phase`,
`schetchik_razr`,
`tariff_type`,
`last_control_date`,
`last_control_data`)
VALUES
(Null,
1001,
'2222222222',
'г. Москва, ул. Весенняя, д.7, кв.1',
'Иванов И.И.',
'ЭЭ8003',
'234234523525',
'1',
6,
'Одноставочный (газовые плиты)',
'2023-03-10',
2240);



INSERT INTO `energo`.`tariff`
(`tariff_id`,
`session_id`,
`tariff_name`,
`start_date`,
`end_date`,
`value`)
VALUES
(Null,
1001,
'Одноставочный (газовые плиты)',
'2023-01-01',
'2023-12-31',
6.43);

INSERT INTO `energo`.`tariff`
(`tariff_id`,
`session_id`,
`tariff_name`,
`start_date`,
`end_date`,
`value`)
VALUES
(Null,
1001,
'Одноставочный (газовые плиты)',
'2024-01-01',
'2024-06-30',
6.43);

INSERT INTO `energo`.`tariff`
(`tariff_id`,
`session_id`,
`tariff_name`,
`start_date`,
`end_date`,
`value`)
VALUES
(Null,
1001,
'Одноставочный (газовые плиты)',
'2024-07-01',
'2024-12-31',
6.99);


INSERT INTO `energo`.`schetchik`
(`schetchik_id`,
`session_id`,
`schetchik_type`,
`schetchik_sn`,
`schetchik_phase`,
`schetchik_razr`,
`inst_date`,
`inst_value`,
`rem_date`,
`rem_value`)
VALUES
(Null,
1001,
'СО-И446',
'768786786',
'1',
5,
'2018-01-15',
18607,
'2020-09-16',
20716);


INSERT INTO `energo`.`schetchik`
(`schetchik_id`,
`session_id`,
`schetchik_type`,
`schetchik_sn`,
`schetchik_phase`,
`schetchik_razr`,
`inst_date`,
`inst_value`,
`rem_date`,
`rem_value`)
VALUES
(Null,
1001,
'ЭЭ8003',
'234234523525',
'1',
6,
'2020-09-16',
0,
Null,
Null);



INSERT INTO `energo`.`control`
(`control_id`,
`session_id`,
`control_date`,
`control_value`)
VALUES
(Null,
1001,
'2022-03-04',
945);

INSERT INTO `energo`.`control`
(`control_id`,
`session_id`,
`control_date`,
`control_value`)
VALUES
(Null,
1001,
'2023-05-10',
2240);



INSERT INTO `energo`.`calc`
(`calc_id`,
`session_id`,
`calc_month`,
`start_value`,
`end_value`,
`w`,
`calc_detail`,
`paid_amount`,
`paid_w`)
VALUES
(Null,
1001,
'2024-07-01',
3608,
3695,
87,
'87*6.99 = 608.13',
608.13,
87);

INSERT INTO `energo`.`calc`
(`calc_id`,
`session_id`,
`calc_month`,
`start_value`,
`end_value`,
`w`,
`calc_detail`,
`paid_amount`,
`paid_w`)
VALUES
(Null,
1001,
'2024-08-01',
3695,
3784,
89,
'89*6.99 = 622.11',
622.11,
87);


INSERT INTO `energo`.`pays`
(`pay_id`,
`session_id`,
`pay_date`,
`amount`,
`penalty`)
VALUES
(Null,
1001,
'2024-07-23',
580.17,
0);

INSERT INTO `energo`.`pays`
(`pay_id`,
`session_id`,
`pay_date`,
`amount`,
`penalty`)
VALUES
(Null,
1001,
'2024-08-20',
608.13,
0);







