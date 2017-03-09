create table if not exists order_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT order_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT order_type_pk PRIMARY key(id)
);

create table if not exists "order"(
  id uuid DEFAULT uuid_generate_v4(),
  order_date date,
  entry_date date not null default CURRENT_DATE,
  order_type_id uuid not null references order_type(id),
  CONSTRAINT order_pk PRIMARY key(id)
);

create table if not exists order_item(
  id uuid DEFAULT uuid_generate_v4(),
  sequence_id bigint not null,
  quantity bigint default 1,
  unit_price double precision,
  estimated_delivery_date date,
  shipping_instructions text,
  item_description text,
  comment text,
  corresponding_po_id text,
  ordered_with uuid references order_item(id),
  product_id uuid,
  product_feature uuid,
  order_id uuid not null references "order"(id),
  order_type_id uuid not null references order_type(id),
  CONSTRAINT order_item_pk PRIMARY key(id)
);

create table if not exists order_item_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT order_item_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT oreder_item_role_type_pk PRIMARY key(id)
);

create table if not exists order_item_role(
  id uuid DEFAULT uuid_generate_v4(),
  order_item_id uuid not null references order_item(id),
  assigned_to_party_id uuid not null,
  described_by uuid not null references order_item_role_type(id),
  CONSTRAINT order_item_role_pk PRIMARY key(id)
);

create table if not exists order_item_contact_mechanism(
  id uuid DEFAULT uuid_generate_v4(),
  used_with uuid not null references order_item(id),
  used_for_contact_mechanism_purpose_type_id uuid not null,
  assigned_to_contact_mechansim uuid not null,
  CONSTRAINT order_item_contact_mechanism_pk PRIMARY key(id)
);

create table if not exists order_contact_mechanism(
  id uuid DEFAULT uuid_generate_v4(),
  used_with uuid not null references order_item(id),
  used_for_contact_mechanism_purpose_type_id uuid not null,
  assigned_to_contact_mechansim uuid not null,
  CONSTRAINT order_contact_mechanism_pk PRIMARY key(id)
);

create table if not exists order_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT order_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT order_role_type_pk PRIMARY key(id)
);

create table if not exists order_role(
  id uuid DEFAULT uuid_generate_v4(),
  percent_contribution double precision default 1,
  assigned_to_party_id uuid not null,
  CONSTRAINT order_role_pk PRIMARY key(id)
);

create table if not exists sales_tax_lookup(
  id uuid DEFAULT uuid_generate_v4(),
  sales_tax_percentage double precision not null,
  geographic_boundary_id uuid not null,
  product_category_id uuid not null,
  CONSTRAINT sales_tax_lookup_pk PRIMARY key(id)
);

create table if not exists order_adjustment_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT order_adjustment_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT order_adjustment_type_pk PRIMARY key(id)
);

create table if not exists order_adjustment(
  id uuid DEFAULT uuid_generate_v4(),
  amount double precision,
  percentage double precision,
  affecting_order_item_id uuid references order_item(id),
  affecting_order_it uuid references "order"(id),
  described_by uuid not null references order_adjustment_type(id),
  CONSTRAINT order_adjustment_pk PRIMARY key(id)
);
