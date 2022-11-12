-- ������� 2

create or replace function foo1(date_one date, date_two date, out sum_payment numeric) as $$
  begin 
	 if date_one is null or date_two is null
	   then raise exception '������� ��� ����';
	 elseif date_one > date_two
	   then raise exception '���� ��������� ������ ���� ������';
	  elseif date_one = date_two
	   then raise exception '���� ������ ����������';
	 elseif date_one > (select max(payment_date) from payment)
	   then raise exception '���� ������ ��� ��������� ����';
	 elseif date_two < (select min(payment_date) from payment)
	   then raise exception '���� ��������� ��� ��������� ����';
	 else 
			select sum(amount)
			from payment p
			where payment_date::date between date_one and date_two into sum_payment;
	end if;
  end;
$$
language plpgsql

select foo1('2005-08-22', '2005-12-10')


-- ������� 3

create table not_active_customer (
	id serial,
	customer_id int,
	not_active_date timestamp default now()
	)
	
	create trigger n_a
	after update on customer
	for each row
	when (new.active = '0')
	execute function foo2()
	
	
	create or replace function foo2() returns trigger as $$
	begin 
		if TG_OP = 'UPDATE'
		then insert into not_active_customer(customer_id) values (new.customer_id);
	end if;
    return new;
	end; $$
	language plpgsql