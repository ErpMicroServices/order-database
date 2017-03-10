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
  quote_item_id uuid,
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

create table if not exists order_term_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT ordre_term_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT order_term_type_pk PRIMARY key(id)
);

create table if not exists order_term(
  id uuid DEFAULT uuid_generate_v4(),
  term_value double precision not null,
  condition_for_order_item uuid references order_item(id),
  condition_for_order uuid references "order"(id),
  described_by uuid not null references order_term_type(id),
  CONSTRAINT order_term_pk PRIMARY key(id)
);

create table if not exists order_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT order_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT order_status_type_pk PRIMARY key(id)
);

create table if not exists order_status(
  id uuid DEFAULT uuid_generate_v4(),
  status timestamp not null default CURRENT_TIMESTAMP,
  status_for_order_item uuid references order_item(id),
  status_for_order uuid references "order"(id),
  described_by uuid not null references order_status_type(id),
  CONSTRAINT order_status_pk PRIMARY key(id)
);

create table if not exists order_item_association(
  id uuid DEFAULT uuid_generate_v4(),
  sales_order_item uuid not null references order_item(id),
  purchase_order_item uuid not null references order_item(id),
  CONSTRAINT order_item_association_pk PRIMARY key(id)
);

create table if not exists requirement_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT requirement_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT requirement_role_type_pk PRIMARY key(id)
);

create table if not exists requirement_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT requirement_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT requirement_status_type_pk PRIMARY key(id)
);

create table if not exists requirement_status(
  id uuid DEFAULT uuid_generate_v4(),
  status_date date default current_date,
  CONSTRAINT requirement_status_pk PRIMARY key(id)
);

create table if not exists requirement_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT requirement_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT requirement_type_pk PRIMARY key(id)
);

create table if not exists desired_feature(
  id uuid DEFAULT uuid_generate_v4(),
  feautre_id uuid not null,
  optional_ind boolean default false,
  CONSTRAINT desired_feature_pk PRIMARY key(id)
);

create table if not exists requirement(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT requirement_role_type_description_not_empty CHECK (description <> ''),
  requirement_creation_date date default current_date,
  required_by date not null,
  estimated_budget double precision,
  quantity bigint,
  reason text,
  composed_of uuid references requirement(id),
  part_of uuid references requirement(id),
  needed_at_facility uuid,
  requesting_product uuid,
  CONSTRAINT requirement_pk PRIMARY key(id)
);
create table if not exists requirement_role(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  defined_by uuid not null references requirement_role_type(id),
  for_party uuid not null,
  related_to uuid not null references requirement(id),
  CONSTRAINT requirement_role_pk PRIMARY key(id)
);

create table if not exists order_requirement_commitment(
  id uuid DEFAULT uuid_generate_v4(),
  requirement_id uuid not null references requirement(id),
  order_item_id uuid not null,
  CONSTRAINT order_requirement_commitment_pk PRIMARY key(id)
);

create table if not exists request_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT request_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT request_type_pk PRIMARY key(id)
);

create table if not exists request(
  id uuid DEFAULT uuid_generate_v4(),
  request_date date not null,
  response_required_date date not null,
  description text not null CONSTRAINT request_description_not_empty CHECK (description <> ''),
  CONSTRAINT request_pk PRIMARY key(id)
);

create table if not exists request_item(
  id uuid DEFAULT uuid_generate_v4(),
  required_by_date date,
  quantity bigint,
  maximum_amount double precision,
  description text,
  request_id uuid not null references request(id),
  quote_item uuid,
  CONSTRAINT request_item_pk PRIMARY key(id)
);

create table if not exists request_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT request_role_description_not_empty CHECK (description <> ''),
  CONSTRAINT request_role_type_pk PRIMARY key(id)
);

create table if not exists request_role(
  id uuid DEFAULT uuid_generate_v4(),
  request_id uuid not null references request(id),
  request_role_type uuid not null references request_role_type(id),
  party_id uuid not null,
  CONSTRAINT request_role_pk PRIMARY key(id)
);

create table if not exists responding_party(
  id uuid DEFAULT uuid_generate_v4(),
  date_sent date default current_date,
  request_id uuid not null references request(id),
  sent_to_contact_mechanism_id uuid not null,
  party_id uuid not null,
  CONSTRAINT responding_party_pk PRIMARY key(id)
);

create table if not exists requirement_request(
  id uuid DEFAULT uuid_generate_v4(),
  request_item_id uuid not null references request_item (id),
  requirement_id uuid not null references requirement(id),
  CONSTRAINT _pk PRIMARY key(id)
);

create table if not exists quote_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT quote_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT quote_type_pk PRIMARY key(id)
);

create table if not exists quote(
  id uuid DEFAULT uuid_generate_v4(),
  issue_date date default current_date,
  valid_from_date date not null default current_date,
  valid_thru_date date,
  description text not null CONSTRAINT existse_description_not_empty CHECK (description <> ''),
  quote_type_id uuid not null references quote_type(id),
  issued_by_party_id uuid not null,
  given_to_party_id uuid not null,
  CONSTRAINT quote_pk PRIMARY key(id)
);

create table if not exists quote_role_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT quote_role_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT quote_role_type_pk PRIMARY key(id)
);

create table if not exists quote_role(
  id uuid DEFAULT uuid_generate_v4(),
  party_id uuid not null,
  described_by uuid not null references quote_role_type(id),
  quote_id uuid not null references quote(id),
  CONSTRAINT quote_role_pk PRIMARY key(id)
);

create table if not exists quote_term_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT quote_term_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT quote_term_type_pk PRIMARY key(id)
);

create table if not exists quote_term(
  id uuid DEFAULT uuid_generate_v4(),
  value text not null CONSTRAINT quote_term_value_not_empty CHECK (value <> ''),
  quote_item_id uuid,
  qutoe_id uuid,
  CONSTRAINT qutoe_term_pk PRIMARY key(id)
);

create table if not exists quote_item(
  id uuid DEFAULT uuid_generate_v4(),
  sequence bigint not null,
  quantity bigint default 1,
  quote_unit_price double precision,
  estimated_delivery_date date,
  comment text,
  product_id uuid,
  work_effort_id uuid,
  CONSTRAINT quote_item_pk PRIMARY key(id)
);
