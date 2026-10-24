
-- 1.database tables creation


-- locations table
create table locations(
  location_id serial primary key,
  city varchar(50) not null,
  state varchar(50) not null,
  region varchar(30),
  urban_rural varchar(10)
);

-- banks table
create table banks(
   bank_id serial primary key,
   bank_name varchar(100) not null,
   bank_type varchar(30) not null
);

-- merchants table
create table merchants (
    merchant_id serial primary key,
    merchant_name varchar(100) not null,
    merchant_category varchar(50) not null,
    business_size varchar(20) not null,
    location_id int not null,

    constraint fk_merchant_location
    foreign key (location_id)
    references locations(location_id)
);

-- users table
create table users(
   user_id serial primary key,
   registration_date date not null,
   age_group varchar(20),
   location_id int not null,
   preferred_bank_id int not null,

   constraint fk_user_location
   foreign key (location_id)
   references locations(location_id),

   constraint fk_user_bank
   foreign key (preferred_bank_id)
   references banks(bank_id)
);

-- check created tables
select * from locations;
select * from banks;
select * from users;


-- 2. master data insertion

-- locations data
insert into locations
(city, state, region, urban_rural)
values
('Dehradun', 'Uttarakhand', 'North', 'Urban'),
('Haridwar', 'Uttarakhand', 'North', 'Urban'),
('Rishikesh', 'Uttarakhand', 'North', 'Urban'),
('Delhi', 'Delhi', 'North', 'Urban'),
('Jaipur', 'Rajasthan', 'North', 'Urban'),
('Lucknow', 'Uttar Pradesh', 'North', 'Urban'),
('Chandigarh', 'Chandigarh', 'North', 'Urban'),
('Mumbai', 'Maharashtra', 'West', 'Urban'),
('Pune', 'Maharashtra', 'West', 'Urban'),
('Ahmedabad', 'Gujarat', 'West', 'Urban'),
('Surat', 'Gujarat', 'West', 'Urban'),
('Bengaluru', 'Karnataka', 'South', 'Urban'),
('Chennai', 'Tamil Nadu', 'South', 'Urban'),
('Hyderabad', 'Telangana', 'South', 'Urban'),
('Kochi', 'Kerala', 'South', 'Urban'),
('Kolkata', 'West Bengal', 'East', 'Urban'),
('Bhubaneswar', 'Odisha', 'East', 'Urban'),
('Patna', 'Bihar', 'East', 'Urban'),
('Guwahati', 'Assam', 'North East', 'Urban'),
('Bhopal', 'Madhya Pradesh', 'Central', 'Urban');


-- banks data
insert into banks
(bank_name, bank_type)
values
('State Bank of India', 'Public'),
('Punjab National Bank', 'Public'),
('Bank of Baroda', 'Public'),
('Canara Bank', 'Public'),
('Union Bank of India', 'Public'),
('HDFC Bank', 'Private'),
('ICICI Bank', 'Private'),
('Axis Bank', 'Private'),
('Kotak Mahindra Bank', 'Private'),
('IndusInd Bank', 'Private'),
('IDFC FIRST Bank', 'Private'),
('Yes Bank', 'Private'),
('Federal Bank', 'Private'),
('AU Small Finance Bank', 'Small Finance'),
('Ujjivan Small Finance Bank', 'Small Finance');

-- check locations
select * 
from locations
order by location_id;

-- check banks
select * 
from banks
order by bank_id;


-- 3. users data generation


insert into users
    (registration_date, age_group, location_id, preferred_bank_id)
select
    date '2024-01-01' + floor(random() * 913)::int,
    case
        when random() < 0.10 then '18-24'
        when random() < 0.30 then '25-34'
        when random() < 0.55 then '35-44'
        when random() < 0.80 then '45-54'
        when random() < 0.95 then '55-64'
        else '65+'
    end,
    floor(random() * 20 + 1)::int,
    floor(random() * 15 + 1)::int
from generate_series(1, 10000);

-- check total users
select count(*) as total_users
from users;

-- check users by age group
select age_group, count(*) as users
from users
group by age_group
order by age_group;

-- check users by city
select 
    l.city,
    count(*) as total_users
from users u
join locations l
   on u.location_id = l.location_id
group by l.city
order by total_users desc;


-- 4. merchants data generation

insert into merchants
    (merchant_name, merchant_category, business_size, location_id)
select
    'Merchant_' || lpad(gs::text, 5, '0'),

    case floor(random() * 10)::int
        when 0 then 'Grocery'
        when 1 then 'Restaurant'
        when 2 then 'Fuel'
        when 3 then 'E-commerce'
        when 4 then 'Pharmacy'
        when 5 then 'Travel'
        when 6 then 'Utilities'
        when 7 then 'Education'
        when 8 then 'Government Services'
        else 'Retail'
    end,

    case
        when random() < 0.60 then 'Small'
        when random() < 0.90 then 'Medium'
        else 'Large'
    end,

    floor(random() * 20 + 1)::int

from generate_series(1, 2000) as gs;

-- check total merchants
select count(*) as total_merchants
from merchants;

-- check merchants by category
select
    merchant_category,
    count(*) as merchant_count
from merchants
group by merchant_category
order by merchant_count desc;


-- 5. devices table creation and data generation

create table devices (
    device_id serial primary key,
    user_id int not null,
    device_type varchar(20) not null,
    operating_system varchar(20) not null,
    network_type varchar(20) not null,

    constraint fk_device_user
        foreign key (user_id)
        references users(user_id)
);

-- devices data generation
insert into devices
    (device_type, operating_system, network_type, user_id)
select
    case
        when random() < 0.70 then 'mobile'
        when random() < 0.90 then 'tablet'
        else 'other'
    end,

    case
        when random() < 0.75 then 'android'
        when random() < 0.98 then 'ios'
        else 'other'
    end,

    case
        when random() < 0.60 then '4g'
        when random() < 0.85 then '5g'
        when random() < 0.95 then 'wifi'
        else '3g'
    end,

    floor(random() * 10000 + 1)::int

from generate_series(1, 12000);

-- check total devices
select count(*) as total_devices
from devices;


-- 6. failure reasons master data

create table failure_reasons (
    failure_reason_id serial primary key,
    failure_category varchar(50) not null,
    failure_reason varchar(100) not null
);

-- failure reasons data
insert into failure_reasons
    (failure_category, failure_reason)
values
    ('technical failure', 'server error'),
    ('technical failure', 'system unavailable'),
    ('bank-side failure', 'bank server unavailable'),
    ('bank-side failure', 'bank processing error'),
    ('network failure', 'network timeout'),
    ('network failure', 'poor network connectivity'),
    ('timeout', 'transaction timed out'),
    ('insufficient balance', 'insufficient account balance'),
    ('invalid upi pin', 'incorrect upi pin'),
    ('limit exceeded', 'daily transaction limit exceeded'),
    ('risk verification', 'transaction flagged for verification'),
    ('risk verification', 'suspicious transaction detected');

-- check failure reasons
select *
from failure_reasons
order by failure_reason_id;


-- 7. transactions table creation

create table transactions (
    transaction_id bigserial primary key,
    user_id int not null,
    merchant_id int not null,
    bank_id int not null,
    device_id int not null,
    location_id int not null,

    transaction_date timestamp not null,
    transaction_amount numeric(12,2) not null,

    transaction_status varchar(20) not null,

    failure_reason_id int,

    payment_channel varchar(20) not null,

    is_retry boolean not null default false,

    constraint fk_transaction_user
        foreign key (user_id)
        references users(user_id),

    constraint fk_transaction_merchant
        foreign key (merchant_id)
        references merchants(merchant_id),

    constraint fk_transaction_bank
        foreign key (bank_id)
        references banks(bank_id),

    constraint fk_transaction_device
        foreign key (device_id)
        references devices(device_id),

    constraint fk_transaction_location
        foreign key (location_id)
        references locations(location_id),

    constraint fk_transaction_failure_reason
        foreign key (failure_reason_id)
        references failure_reasons(failure_reason_id)
);


-- 8. transaction data generation

insert into transactions (
    user_id,
    merchant_id,
    bank_id,
    device_id,
    location_id,
    transaction_date,
    transaction_amount,
    transaction_status,
    failure_reason_id,
    payment_channel,
    is_retry
)
select
    floor(random() * 10000 + 1)::int,
    floor(random() * 2000 + 1)::int,
    floor(random() * 15 + 1)::int,
    floor(random() * 12000 + 1)::int,
    floor(random() * 20 + 1)::int,

    timestamp '2025-01-01 00:00:00'
        + random() * (timestamp '2025-12-31 23:59:59'
        - timestamp '2025-01-01 00:00:00'),

    round((random() * 49900 + 100)::numeric, 2),

    case
        when random() < 0.88 then 'success'
        else 'failed'
    end,

    case
        when random() < 0.12
        then floor(random() * 12 + 1)::int
        else null
    end,

    case floor(random() * 4)::int
        when 0 then 'upi_app'
        when 1 then 'qr'
        when 2 then 'upi_id'
        else 'collect_request'
    end,

    false

from generate_series(1, 100000);

-- check transaction count
select count(*) as total_transactions
from transactions;

-- check transaction status distribution
select
    transaction_status,
    count(*) as total_transactions
from transactions
group by transaction_status;


-- 9. transaction data quality fixes

-- check success transactions with failure reasons
select count(*) as incorrect_records
from transactions
where transaction_status = 'success'
and failure_reason_id is not null;

-- fix success transactions with failure reasons
update transactions
set failure_reason_id = null
where transaction_status = 'success'
and failure_reason_id is not null;


-- check failed transactions without failure reasons
select count(*) as failed_without_reason
from transactions
where transaction_status = 'failed'
and failure_reason_id is null;


-- validate transaction status and failure reason
select
    transaction_status,
    count(*) as total_transactions
from transactions
group by transaction_status
order by transaction_status;

select count(*) as incorrect_records
from transactions
where
    (transaction_status = 'success' and failure_reason_id is not null)
    or
    (transaction_status = 'failed' and failure_reason_id is null);

-- fix failed transactions without failure reasons
update transactions
set failure_reason_id = floor(random() * 12 + 1)::int
where transaction_status = 'failed'
and failure_reason_id is null;

-- final transaction consistency check
select count(*) as incorrect_records
from transactions
where
    (transaction_status = 'success' and failure_reason_id is not null)
    or
    (transaction_status = 'failed' and failure_reason_id is null);


-- 10. retry and transaction attempts

-- mark failed transactions for retry
update transactions
set is_retry = true
where transaction_id in (
    select transaction_id
    from transactions
    where transaction_status = 'failed'
    order by random()
    limit 10000
);

-- check retry transactions
select
    is_retry,
    count(*) as total_transactions
from transactions
group by is_retry
order by is_retry;


-- transaction attempts table
create table transaction_attempts (
    attempt_id bigserial primary key,
    transaction_id bigint not null,
    attempt_number int not null,
    attempt_time timestamp not null,
    attempt_status varchar(20) not null,
    failure_reason_id int,

    constraint fk_attempt_transaction
        foreign key (transaction_id)
        references transactions(transaction_id),

    constraint fk_attempt_failure_reason
        foreign key (failure_reason_id)
        references failure_reasons(failure_reason_id)
);

-- check total attempts before insertion
select count(*) as total_attempts
from transaction_attempts;


-- first transaction attempts
insert into transaction_attempts (
    transaction_id,
    attempt_number,
    attempt_time,
    attempt_status,
    failure_reason_id
)
select
    transaction_id,
    1,
    transaction_date,
    transaction_status,
    failure_reason_id
from transactions;


-- retry attempts
insert into transaction_attempts (
    transaction_id,
    attempt_number,
    attempt_time,
    attempt_status,
    failure_reason_id
)
select
    transaction_id,
    2,
    transaction_date + interval '1 minute' * floor(random() * 30 + 1),

    case
        when random() < 0.70 then 'success'
        else 'failed'
    end,

    case
        when random() < 0.70 then null
        else floor(random() * 12 + 1)::int
    end

from transactions
where is_retry = true;

-- check total attempts
select count(*) as total_attempts
from transaction_attempts;


-- update transaction status after successful retry
update transactions t
set
    transaction_status = 'success',
    failure_reason_id = null
from transaction_attempts a
where t.transaction_id = a.transaction_id
and a.attempt_number = 2
and a.attempt_status = 'success';


-- check retry successes
select count(*) as retry_successes
from transaction_attempts
where attempt_number = 2
and attempt_status = 'success';


-- final transaction consistency check
select count(*) as incorrect_records
from transactions
where
    (transaction_status = 'success' and failure_reason_id is not null)
    or
    (transaction_status = 'failed' and failure_reason_id is null);



-- 11. exploratory data analysis


-- overall transaction performance
select
    transaction_status,
    count(*) as total_transactions,
    round(
        count(*) * 100.0 /
        sum(count(*)) over (),
        2
    ) as percentage
from transactions
group by transaction_status
order by total_transactions desc;


-- failure category analysis
select
    fr.failure_category,
    count(*) as failed_transactions
from transactions t
join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id
where t.transaction_status = 'failed'
group by fr.failure_category
order by failed_transactions desc;


-- retry performance
select
    attempt_status,
    count(*) as retry_attempts,
    round(
        count(*) * 100.0 /
        sum(count(*)) over (),
        2
    ) as percentage
from transaction_attempts
where attempt_number = 2
group by attempt_status
order by retry_attempts desc;


-- bank-wise failure analysis
select
    b.bank_name,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join banks b
    on t.bank_id = b.bank_id
group by b.bank_id, b.bank_name
order by failure_rate desc;


-- city-wise failure analysis
select
    l.city,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join locations l
    on t.location_id = l.location_id
group by l.location_id, l.city
order by failure_rate desc;


-- failure reason analysis
select
    fr.failure_category,
    fr.failure_reason,
    count(*) as failed_transactions,
    round(
        count(*) * 100.0 /
        sum(count(*)) over (),
        2
    ) as failure_percentage
from transactions t
join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id
where t.transaction_status = 'failed'
group by
    fr.failure_category,
    fr.failure_reason
order by failed_transactions desc;


-- hourly transaction volume
select
    extract(hour from transaction_date) as transaction_hour,
    count(*) as total_transactions
from transactions
group by transaction_hour
order by total_transactions desc;


-- hourly failure rate
select
    extract(hour from transaction_date) as transaction_hour,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by transaction_hour
order by transaction_hour;


-- monthly transaction analysis
select
    extract(month from transaction_date) as transaction_month,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by extract(month from transaction_date)
order by transaction_month;


-- monthly failure trend
with monthly_data as (
    select
        extract(month from transaction_date) as transaction_month,
        count(*) as total_transactions,
        count(*) filter (
            where transaction_status = 'failed'
        ) as failed_transactions,
        round(
            count(*) filter (
                where transaction_status = 'failed'
            ) * 100.0 / count(*),
            2
        ) as failure_rate
    from transactions
    group by extract(month from transaction_date)
)

select
    transaction_month,
    total_transactions,
    failed_transactions,
    failure_rate,
    lag(failure_rate) over (
        order by transaction_month
    ) as previous_month_failure_rate
from monthly_data
order by transaction_month;


-- month-over-month failure rate change
with monthly_data as (
    select
        extract(month from transaction_date) as transaction_month,
        round(
            count(*) filter (
                where transaction_status = 'failed'
            ) * 100.0 / count(*),
            2
        ) as failure_rate
    from transactions
    group by extract(month from transaction_date)
)

select
    transaction_month,
    failure_rate,
    lag(failure_rate) over (
        order by transaction_month
    ) as previous_month_failure_rate,
    round(
        failure_rate -
        lag(failure_rate) over (
            order by transaction_month
        ),
        2
    ) as failure_rate_change
from monthly_data
order by transaction_month;


-- city failure ranking
with city_data as (
    select
        l.city,
        count(*) as total_transactions,
        count(*) filter (
            where t.transaction_status = 'failed'
        ) as failed_transactions,
        round(
            count(*) filter (
                where t.transaction_status = 'failed'
            ) * 100.0 / count(*),
            2
        ) as failure_rate
    from transactions t
    join locations l
        on t.location_id = l.location_id
    group by l.location_id, l.city
)

select
    city,
    total_transactions,
    failed_transactions,
    failure_rate,
    rank() over (
        order by failure_rate desc
    ) as failure_rank
from city_data
order by failure_rank;


-- bank monthly trend
with bank_monthly_data as (
    select
        b.bank_name,
        extract(month from t.transaction_date) as transaction_month,
        count(*) as total_transactions,
        count(*) filter (
            where t.transaction_status = 'failed'
        ) as failed_transactions,
        round(
            count(*) filter (
                where t.transaction_status = 'failed'
            ) * 100.0 / count(*),
            2
        ) as failure_rate
    from transactions t
    join banks b
        on t.bank_id = b.bank_id
    group by
        b.bank_id,
        b.bank_name,
        extract(month from t.transaction_date)
)

select
    bank_name,
    transaction_month,
    total_transactions,
    failed_transactions,
    failure_rate,
    lag(failure_rate) over (
        partition by bank_name
        order by transaction_month
    ) as previous_month_failure_rate
from bank_monthly_data
order by bank_name, transaction_month;


-- failure category contribution
select
    fr.failure_category,
    count(*) as failed_transactions,
    round(
        count(*) * 100.0 /
        sum(count(*)) over (),
        2
    ) as failure_contribution_percentage
from transactions t
join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id
where t.transaction_status = 'failed'
group by fr.failure_category
order by failed_transactions desc;


-- retry success analysis
select
    count(*) as total_retry_transactions,
    count(*) filter (
        where a.attempt_status = 'success'
    ) as retry_successful,
    count(*) filter (
        where a.attempt_status = 'failed'
    ) as retry_failed,
    round(
        count(*) filter (
            where a.attempt_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as retry_success_rate
from transaction_attempts a
where a.attempt_number = 2;


-- retry failure reason analysis
select
    fr.failure_category,
    fr.failure_reason,
    count(*) as retry_transactions,
    count(*) filter (
        where a.attempt_status = 'success'
    ) as retry_successful,
    round(
        count(*) filter (
            where a.attempt_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as retry_success_rate
from transaction_attempts a
join transactions t
    on a.transaction_id = t.transaction_id
join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id
where a.attempt_number = 2
group by
    fr.failure_category,
    fr.failure_reason
order by retry_success_rate desc;


-- network failure analysis
select
    d.network_type,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join devices d
    on t.device_id = d.device_id
group by d.network_type
order by failure_rate desc;


-- device type failure analysis
select
    d.device_type,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join devices d
    on t.device_id = d.device_id
group by d.device_type
order by failure_rate desc;


-- payment channel failure analysis
select
    payment_channel,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by payment_channel
order by failure_rate desc;


-- age group failure analysis
select
    u.age_group,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join users u
    on t.user_id = u.user_id
group by u.age_group
order by failure_rate desc;


-- transaction amount analysis
select
    case
        when transaction_amount < 500 then '0-499'
        when transaction_amount < 2000 then '500-1999'
        when transaction_amount < 5000 then '2000-4999'
        when transaction_amount < 10000 then '5000-9999'
        else '10000+'
    end as amount_band,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by
    case
        when transaction_amount < 500 then '0-499'
        when transaction_amount < 2000 then '500-1999'
        when transaction_amount < 5000 then '2000-4999'
        when transaction_amount < 10000 then '5000-9999'
        else '10000+'
    end
order by failure_rate desc;


-- success vs failure amount analysis
select
    transaction_status,
    count(*) as total_transactions,
    round(avg(transaction_amount), 2) as average_transaction_amount,
    round(min(transaction_amount), 2) as minimum_amount,
    round(max(transaction_amount), 2) as maximum_amount
from transactions
group by transaction_status
order by transaction_status;


-- daily transaction trend
select
    date(transaction_date) as transaction_date,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by date(transaction_date)
order by transaction_date;


-- rolling 7-day failure rate
with daily_data as (
    select
        date(transaction_date) as transaction_date,
        count(*) as total_transactions,
        count(*) filter (
            where transaction_status = 'failed'
        ) as failed_transactions
    from transactions
    group by date(transaction_date)
)

select
    transaction_date,
    total_transactions,
    failed_transactions,
    round(
        sum(failed_transactions) over (
            order by transaction_date
            rows between 6 preceding and current row
        ) * 100.0
        /
        sum(total_transactions) over (
            order by transaction_date
            rows between 6 preceding and current row
        ),
        2
    ) as rolling_7_day_failure_rate
from daily_data
order by transaction_date;


-- bank failure trend
with bank_monthly as (
    select
        b.bank_name,
        extract(month from t.transaction_date) as transaction_month,
        round(
            count(*) filter (
                where t.transaction_status = 'failed'
            ) * 100.0 / count(*),
            2
        ) as failure_rate
    from transactions t
    join banks b
        on t.bank_id = b.bank_id
    group by
        b.bank_id,
        b.bank_name,
        extract(month from t.transaction_date)
),

bank_trend as (
    select
        bank_name,
        transaction_month,
        failure_rate,
        lag(failure_rate) over (
            partition by bank_name
            order by transaction_month
        ) as previous_failure_rate
    from bank_monthly
)

select
    bank_name,
    transaction_month,
    failure_rate,
    previous_failure_rate,
    round(
        failure_rate - previous_failure_rate,
        2
    ) as change_in_failure_rate,
    case
        when failure_rate > previous_failure_rate then 'worsened'
        when failure_rate < previous_failure_rate then 'improved'
        else 'unchanged'
    end as trend
from bank_trend
where previous_failure_rate is not null
order by bank_name, transaction_month;


-- monthly failure category analysis
select
    extract(month from t.transaction_date) as transaction_month,
    fr.failure_category,
    count(*) as failed_transactions
from transactions t
join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id
where t.transaction_status = 'failed'
group by
    extract(month from t.transaction_date),
    fr.failure_category
order by
    transaction_month,
    failed_transactions desc;


-- overall kpi analysis
select
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'success'
    ) as successful_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as success_rate,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions;


-- transaction value analysis
select
    count(*) as total_transactions,
    round(sum(transaction_amount), 2) as total_transaction_value,
    round(avg(transaction_amount), 2) as average_transaction_value,
    round(min(transaction_amount), 2) as minimum_transaction_value,
    round(max(transaction_amount), 2) as maximum_transaction_value
from transactions;


-- merchant category failure analysis
select
    m.merchant_category,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join merchants m
    on t.merchant_id = m.merchant_id
group by m.merchant_category
order by failure_rate desc;


-- region-wise failure analysis
select
    l.region,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join locations l
    on t.location_id = l.location_id
group by l.region
order by failure_rate desc;


-- bank type failure analysis
select
    b.bank_type,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join banks b
    on t.bank_id = b.bank_id
group by b.bank_type
order by failure_rate desc;


-- user activity analysis
select
    user_id,
    count(*) as total_transactions,
    round(avg(transaction_amount), 2) as average_transaction_amount,
    round(sum(transaction_amount), 2) as total_transaction_value,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions
from transactions
group by user_id
order by total_transactions desc
limit 20;


-- user activity segmentation
with user_activity as (
    select
        user_id,
        count(*) as total_transactions
    from transactions
    group by user_id
)

select
    case
        when total_transactions <= 5 then 'low activity'
        when total_transactions <= 15 then 'medium activity'
        else 'high activity'
    end as activity_level,
    count(*) as total_users,
    round(avg(total_transactions), 2) as average_transactions_per_user
from user_activity
group by
    case
        when total_transactions <= 5 then 'low activity'
        when total_transactions <= 15 then 'medium activity'
        else 'high activity'
    end
order by average_transactions_per_user desc;


-- high-value user analysis
select
    user_id,
    count(*) as total_transactions,
    round(sum(transaction_amount), 2) as total_transaction_value,
    round(avg(transaction_amount), 2) as average_transaction_amount,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions
from transactions
group by user_id
order by total_transaction_value desc
limit 20;


-- retry vs non-retry performance
select
    case
        when is_retry = true then 'retry'
        else 'non-retry'
    end as transaction_type,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'success'
    ) as successful_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as success_rate
from transactions
group by is_retry
order by success_rate desc;


-- monthly transaction value analysis
select
    extract(month from transaction_date) as transaction_month,
    count(*) as total_transactions,
    round(sum(transaction_amount), 2) as total_transaction_value,
    round(avg(transaction_amount), 2) as average_transaction_amount,
    round(
        sum(transaction_amount) filter (
            where transaction_status = 'success'
        ),
        2
    ) as successful_transaction_value
from transactions
group by extract(month from transaction_date)
order by transaction_month;


-- hourly failure analysis
select
    extract(hour from transaction_date) as transaction_hour,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by extract(hour from transaction_date)
order by failure_rate desc;


-- state-wise failure analysis
select
    l.state,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join locations l
    on t.location_id = l.location_id
group by l.state
order by failure_rate desc;


-- monthly success and transaction value
select
    extract(month from transaction_date) as transaction_month,
    count(*) as total_transactions,
    round(sum(transaction_amount), 2) as total_transaction_value,
    count(*) filter (
        where transaction_status = 'success'
    ) as successful_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as success_rate,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by extract(month from transaction_date)
order by transaction_month;


-- high-failure user analysis
select
    user_id,
    count(*) as total_transactions,
    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions
group by user_id
having count(*) >= 5
order by failure_rate desc, total_transactions desc
limit 20;


-- bank and payment channel analysis
select
    b.bank_name,
    t.payment_channel,
    count(*) as total_transactions,
    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,
    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate
from transactions t
join banks b
    on t.bank_id = b.bank_id
group by
    b.bank_id,
    b.bank_name,
    t.payment_channel
order by
    failure_rate desc;


-- 12. data quality checks

-- check duplicate transaction ids
select
    transaction_id,
    count(*) as record_count
from transactions
group by transaction_id
having count(*) > 1;


-- check missing values
select
    count(*) filter (where user_id is null) as missing_user_id,
    count(*) filter (where merchant_id is null) as missing_merchant_id,
    count(*) filter (where bank_id is null) as missing_bank_id,
    count(*) filter (where device_id is null) as missing_device_id,
    count(*) filter (where location_id is null) as missing_location_id,
    count(*) filter (where transaction_date is null) as missing_transaction_date,
    count(*) filter (where transaction_amount is null) as missing_amount,
    count(*) filter (where transaction_status is null) as missing_status
from transactions;


-- check invalid transaction amounts
select
    count(*) as invalid_amount_records
from transactions
where transaction_amount <= 0;


-- check transaction status and failure reason consistency
select
    count(*) as incorrect_records
from transactions
where
    (transaction_status = 'success' and failure_reason_id is not null)
    or
    (transaction_status = 'failed' and failure_reason_id is null);


-- check orphan transaction records
select
    count(*) as orphan_records
from transactions t
left join users u
    on t.user_id = u.user_id
left join merchants m
    on t.merchant_id = m.merchant_id
left join banks b
    on t.bank_id = b.bank_id
left join devices d
    on t.device_id = d.device_id
left join locations l
    on t.location_id = l.location_id
where
    u.user_id is null
    or m.merchant_id is null
    or b.bank_id is null
    or d.device_id is null
    or l.location_id is null;


-- check duplicate transaction attempts
select
    transaction_id,
    attempt_number,
    count(*) as attempt_count
from transaction_attempts
group by
    transaction_id,
    attempt_number
having count(*) > 1;


-- check attempt numbers
select
    attempt_number,
    count(*) as total_attempts
from transaction_attempts
group by attempt_number
order by attempt_number;


-- check attempt status and failure reason consistency
select
    count(*) as incorrect_attempt_records
from transaction_attempts
where
    (attempt_status = 'success' and failure_reason_id is not null)
    or
    (attempt_status = 'failed' and failure_reason_id is null);


-- detailed attempt consistency check
select
    attempt_status,
    count(*) as total_records,
    count(*) filter (
        where failure_reason_id is null
    ) as null_failure_reason,
    count(*) filter (
        where failure_reason_id is not null
    ) as has_failure_reason
from transaction_attempts
group by attempt_status
order by attempt_status;


-- fix failed attempts without failure reasons
update transaction_attempts
set failure_reason_id = floor(random() * 12 + 1)::int
where attempt_status = 'failed'
and failure_reason_id is null;


-- fix successful attempts with failure reasons
update transaction_attempts
set failure_reason_id = null
where attempt_status = 'success'
and failure_reason_id is not null;


-- final attempt consistency check
select
    count(*) as incorrect_attempt_records
from transaction_attempts
where
    (attempt_status = 'success' and failure_reason_id is not null)
    or
    (attempt_status = 'failed' and failure_reason_id is null);


-- 13. analytical views for power bi

-- overall kpi view
create or replace view vw_transaction_summary as
select
    count(*) as total_transactions,

    count(*) filter (
        where transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where transaction_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as success_rate,

    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        sum(transaction_amount),
        2
    ) as total_transaction_value,

    round(
        avg(transaction_amount),
        2
    ) as average_transaction_value

from transactions;

select *
from vw_transaction_summary;


-- monthly performance view
create or replace view vw_monthly_performance as
select
    extract(month from transaction_date)::int as transaction_month,

    count(*) as total_transactions,

    count(*) filter (
        where transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where transaction_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as success_rate,

    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        sum(transaction_amount),
        2
    ) as total_transaction_value

from transactions
group by extract(month from transaction_date)
order by transaction_month;

select *
from vw_monthly_performance;


-- bank performance view
create or replace view vw_bank_performance as
select
    b.bank_name,
    b.bank_type,

    count(*) as total_transactions,

    count(*) filter (
        where t.transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        sum(t.transaction_amount),
        2
    ) as total_transaction_value

from transactions t
join banks b
    on t.bank_id = b.bank_id

group by
    b.bank_id,
    b.bank_name,
    b.bank_type;

select *
from vw_bank_performance
order by failure_rate desc;


-- city performance view
create or replace view vw_city_performance as
select
    l.city,
    l.state,
    l.region,
    l.urban_rural,

    count(*) as total_transactions,

    count(*) filter (
        where t.transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        sum(t.transaction_amount),
        2
    ) as total_transaction_value

from transactions t
join locations l
    on t.location_id = l.location_id

group by
    l.location_id,
    l.city,
    l.state,
    l.region,
    l.urban_rural;

select *
from vw_city_performance
order by failure_rate desc;


-- failure analysis view
create or replace view vw_failure_analysis as
select
    fr.failure_category,
    fr.failure_reason,

    count(*) as failed_transactions,

    round(
        count(*) * 100.0 /
        sum(count(*)) over (),
        2
    ) as failure_contribution_percentage,

    round(
        sum(t.transaction_amount),
        2
    ) as failed_transaction_value

from transactions t
join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id

where t.transaction_status = 'failed'

group by
    fr.failure_category,
    fr.failure_reason;

select *
from vw_failure_analysis
order by failed_transactions desc;


-- retry analysis view
create or replace view vw_retry_analysis as
select
    a.attempt_status as retry_outcome,

    count(*) as total_retries,

    round(
        count(*) * 100.0 /
        sum(count(*)) over (),
        2
    ) as retry_percentage

from transaction_attempts a
where a.attempt_number = 2

group by a.attempt_status;

select *
from vw_retry_analysis
order by total_retries desc;


-- retry summary view
create or replace view vw_retry_summary as
select
    count(*) as total_retries,

    count(*) filter (
        where attempt_status = 'success'
    ) as successful_retries,

    count(*) filter (
        where attempt_status = 'failed'
    ) as failed_retries,

    round(
        count(*) filter (
            where attempt_status = 'success'
        ) * 100.0 / count(*),
        2
    ) as retry_success_rate

from transaction_attempts
where attempt_number = 2;

select *
from vw_retry_summary;


-- channel & hourly performance view
create or replace view vw_channel_hourly_performance as
select
    payment_channel,
    extract(hour from transaction_date)::int as transaction_hour,

    count(*) as total_transactions,

    count(*) filter (
        where transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        sum(transaction_amount),
        2
    ) as total_transaction_value

from transactions

group by
    payment_channel,
    extract(hour from transaction_date);

select *
from vw_channel_hourly_performance
order by
    payment_channel,
    transaction_hour;


-- device & network performance
create or replace view vw_device_network_performance as
select
    d.device_type,
    d.operating_system,
    d.network_type,

    count(*) as total_transactions,

    count(*) filter (
        where t.transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        avg(t.transaction_amount),
        2
    ) as average_transaction_amount

from transactions t
join devices d
    on t.device_id = d.device_id

group by
    d.device_type,
    d.operating_system,
    d.network_type;

select *
from vw_device_network_performance
order by failure_rate desc;


-- age-group performance
create or replace view vw_age_group_performance as
select
    u.age_group,

    count(*) as total_transactions,

    count(*) filter (
        where t.transaction_status = 'success'
    ) as successful_transactions,

    count(*) filter (
        where t.transaction_status = 'failed'
    ) as failed_transactions,

    round(
        count(*) filter (
            where t.transaction_status = 'failed'
        ) * 100.0 / count(*),
        2
    ) as failure_rate,

    round(
        avg(t.transaction_amount),
        2
    ) as average_transaction_amount,

    round(
        sum(t.transaction_amount),
        2
    ) as total_transaction_value

from transactions t
join users u
    on t.user_id = u.user_id

group by
    u.age_group;

select *
from vw_age_group_performance
order by failure_rate desc;




create or replace view vw_bank_failure_category as
select
    b.bank_name,
    fr.failure_category,
    count(*) as failed_transactions
from transactions t
left join banks b
    on t.bank_id = b.bank_id
left join failure_reasons fr
    on t.failure_reason_id = fr.failure_reason_id
where t.transaction_status = 'failed'
group by
    b.bank_name,
    fr.failure_category
order by
    b.bank_name,
    failed_transactions desc;







create or replace view vw_merchant_category_performance as
select
    m.merchant_category,

    count(*) as total_transactions,

    count(
        case
            when t.transaction_status = 'failed'
            then 1
        end
    ) as failed_transactions,

    round(
        count(
            case
                when t.transaction_status = 'failed'
                then 1
            end
        ) * 100.0
        / nullif(count(*), 0),
        2
    ) as failure_rate,

    round(
        avg(t.transaction_amount),
        2
    ) as average_transaction_amount

from transactions t

left join merchants m
    on t.merchant_id = m.merchant_id

group by
    m.merchant_category

order by
    failure_rate desc;







create or replace view vw_transaction_amount_performance as
select
    case
        when transaction_amount < 500
            then 'below 500'
        when transaction_amount < 1000
            then '500 - 999'
        when transaction_amount < 2000
            then '1000 - 1999'
        when transaction_amount < 5000
            then '2000 - 4999'
        else '5000+'
    end as amount_band,

    count(*) as total_transactions,

    count(
        case
            when transaction_status = 'failed'
            then 1
        end
    ) as failed_transactions,

    round(
        count(
            case
                when transaction_status = 'failed'
                then 1
            end
        ) * 100.0
        / nullif(count(*), 0),
        2
    ) as failure_rate,

    round(
        avg(transaction_amount),
        2
    ) as average_transaction_amount

from transactions

group by
    case
        when transaction_amount < 500
            then 'below 500'
        when transaction_amount < 1000
            then '500 - 999'
        when transaction_amount < 2000
            then '1000 - 1999'
        when transaction_amount < 5000
            then '2000 - 4999'
        else '5000+'
    end;



select *
from vw_transaction_amount_performance;







create or replace view vw_user_activity_performance as
with user_activity as (
    select
        user_id,
        count(*) as total_transactions,
        count(
            case
                when transaction_status = 'failed'
                then 1
            end
        ) as failed_transactions
    from transactions
    group by user_id
)

select
    case
        when total_transactions <= 5
            then 'low activity'
        when total_transactions <= 15
            then 'medium activity'
        else 'high activity'
    end as activity_level,

    count(*) as total_users,

    sum(total_transactions) as total_transactions,

    sum(failed_transactions) as failed_transactions,

    round(
        sum(failed_transactions) * 100.0
        / nullif(sum(total_transactions), 0),
        2
    ) as failure_rate

from user_activity

group by
    case
        when total_transactions <= 5
            then 'low activity'
        when total_transactions <= 15
            then 'medium activity'
        else 'high activity'
    end;




select *
from vw_user_activity_performance;









create or replace view vw_transaction_amount_performance as
select
    case
        when transaction_amount < 500
            then 'below 500'
        when transaction_amount < 1000
            then '500 - 999'
        when transaction_amount < 2000
            then '1000 - 1999'
        when transaction_amount < 5000
            then '2000 - 4999'
        else '5000+'
    end as amount_band,

    count(*) as total_transactions,

    count(
        case
            when transaction_status = 'failed'
            then 1
        end
    ) as failed_transactions,

    round(
        count(
            case
                when transaction_status = 'failed'
                then 1
            end
        ) * 100.0
        / nullif(count(*), 0),
        2
    ) as failure_rate,

    round(
        avg(transaction_amount),
        2
    ) as average_transaction_amount,

    case
        when transaction_amount < 500 then 1
        when transaction_amount < 1000 then 2
        when transaction_amount < 2000 then 3
        when transaction_amount < 5000 then 4
        else 5
    end as amount_band_order

from transactions

group by
    case
        when transaction_amount < 500
            then 'below 500'
        when transaction_amount < 1000
            then '500 - 999'
        when transaction_amount < 2000
            then '1000 - 1999'
        when transaction_amount < 5000
            then '2000 - 4999'
        else '5000+'
    end,

    case
        when transaction_amount < 500 then 1
        when transaction_amount < 1000 then 2
        when transaction_amount < 2000 then 3
        when transaction_amount < 5000 then 4
        else 5
    end;



select *
from vw_transaction_amount_performance;








create or replace view vw_operational_risk_combinations as
select
    b.bank_name,
    t.payment_channel,
    d.network_type,

    count(*) as total_transactions,

    count(
        case
            when t.transaction_status = 'failed'
            then 1
        end
    ) as failed_transactions,

    round(
        count(
            case
                when t.transaction_status = 'failed'
                then 1
            end
        ) * 100.0
        / nullif(count(*), 0),
        2
    ) as failure_rate

from transactions t

left join banks b
    on t.bank_id = b.bank_id

left join devices d
    on t.device_id = d.device_id

group by
    b.bank_name,
    t.payment_channel,
    d.network_type

having count(*) >= 50

order by
    failure_rate desc;




create or replace view vw_top_operational_risks as
select *
from vw_operational_risk_combinations
order by
    failure_rate desc
limit 10;



