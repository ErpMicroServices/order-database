create table if not exists order_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT order_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_type (id),
    CONSTRAINT order_type_pk PRIMARY key (id)
);

create table if not exists "order"
(
    id                                    uuid          DEFAULT uuid_generate_v4(),
    order_identifier                      varchar(255),
    order_date                            date,
    entry_date                            date not null default CURRENT_DATE,
    order_type_id                         uuid not null references order_type (id),
    placed_by_party_role_id               uuid,
    placed_using_contact_mechanism_id     uuid,
    taken_via_contact_mechanism_id        uuid,
    taken_by_party_role_id                uuid,
    billing_location_contact_mechanism_id uuid,
    with_requested_bill_to_party_role_id  uuid,
    CONSTRAINT order_pk PRIMARY key (id)
);

create table if not exists order_item
(
    id                                     uuid   DEFAULT uuid_generate_v4(),
    sequence_id                            bigint not null,
    quantity                               bigint default 1,
    unit_price                             numeric(12, 3),
    estimated_delivery_date                date,
    shipping_instructions                  text,
    item_description                       text,
    comment                                text,
    contact_mechanism_id                   uuid,
    corresponding_po_id                    uuid,
    ordered_with_id                        uuid references order_item (id),
    party_role_id                          uuid,
    product_id                             uuid,
    product_feature_id                     uuid,
    order_id                               uuid   not null references "order" (id),
    order_type_id                          uuid   not null references order_type (id),
    quote_item_id                          uuid,
    placing_customer_party_role_id         uuid,
    taken_by_party_role_id                 uuid,
    with_a_requested_bill_to_party_role_id uuid,
    CONSTRAINT order_item_pk PRIMARY key (id)
);

create table if not exists order_item_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT order_item_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_item_type (id),
    CONSTRAINT oreder_item_type_pk PRIMARY key (id)
);

create table if not exists order_item_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT order_item_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_item_role_type (id),
    CONSTRAINT oreder_item_role_type_pk PRIMARY key (id)
);

create table if not exists order_item_role
(
    id                   uuid DEFAULT uuid_generate_v4(),
    order_item_id        uuid not null references order_item (id),
    assigned_to_party_id uuid not null,
    described_by         uuid not null references order_item_role_type (id),
    CONSTRAINT order_item_role_pk PRIMARY key (id)
);

create table if not exists order_item_contact_mechanism
(
    id                                         uuid DEFAULT uuid_generate_v4(),
    used_with                                  uuid not null references order_item (id),
    used_for_contact_mechanism_purpose_type_id uuid not null,
    assigned_to_contact_mechansim              uuid not null,
    CONSTRAINT order_item_contact_mechanism_pk PRIMARY key (id)
);

create table if not exists order_contact_mechanism
(
    id                                         uuid DEFAULT uuid_generate_v4(),
    used_with                                  uuid not null references order_item (id),
    used_for_contact_mechanism_purpose_type_id uuid not null,
    assigned_to_contact_mechansim              uuid not null,
    CONSTRAINT order_contact_mechanism_pk PRIMARY key (id)
);

create table if not exists order_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT order_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_role_type (id),
    CONSTRAINT order_role_type_pk PRIMARY key (id)
);

create table if not exists order_role
(
    id                   uuid          DEFAULT uuid_generate_v4(),
    order_id             uuid not null references "order" (id),
    percent_contribution numeric(5, 2) default 1,
    assigned_to_party_id uuid not null,
    order_role_type_id   uuid not null references order_item_role_type (id),
    CONSTRAINT order_role_pk PRIMARY key (id)
);

create table if not exists sales_tax_lookup
(
    id                     uuid DEFAULT uuid_generate_v4(),
    sales_tax_percentage   numeric(5, 2) not null,
    geographic_boundary_id uuid          not null,
    product_category_id    uuid          not null,
    CONSTRAINT sales_tax_lookup_pk PRIMARY key (id)
);

create table if not exists order_adjustment_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT order_adjustment_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_adjustment_type (id),
    CONSTRAINT order_adjustment_type_pk PRIMARY key (id)
);

create table if not exists order_adjustment
(
    id                       uuid DEFAULT uuid_generate_v4(),
    amount                   numeric(12, 3),
    percentage               numeric(5, 2),
    affecting_order_item_id  uuid references order_item (id),
    affecting_order_id       uuid references "order" (id),
    order_adjustment_type_id uuid not null references order_adjustment_type (id),
    CONSTRAINT order_adjustment_pk PRIMARY key (id)
);

create table if not exists order_term_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT ordre_term_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_term_type (id),
    CONSTRAINT order_term_type_pk PRIMARY key (id)
);

create table if not exists order_term
(
    id                          uuid DEFAULT uuid_generate_v4(),
    term_value                  numeric(12, 3) not null,
    condition_for_order_item_id uuid references order_item (id),
    condition_for_order_id      uuid references "order" (id),
    type_id                     uuid           not null references order_term_type (id),
    CONSTRAINT order_term_pk PRIMARY key (id)
);

create table if not exists order_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT order_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES order_status_type (id),
    CONSTRAINT order_status_type_pk PRIMARY key (id)
);

create table if not exists order_status
(
    id                       uuid               DEFAULT uuid_generate_v4(),
    status_changed           timestamp not null default CURRENT_TIMESTAMP,
    status_for_order_item_id uuid references order_item (id),
    status_for_order_id      uuid references "order" (id),
    order_status_type_id     uuid      not null references order_status_type (id),
    CONSTRAINT order_status_pk PRIMARY key (id)
);

create table if not exists order_item_association
(
    id                     uuid DEFAULT uuid_generate_v4(),
    sales_order_item_id    uuid not null references order_item (id),
    purchase_order_item_id uuid not null references order_item (id),
    CONSTRAINT order_item_association_pk PRIMARY key (id)
);

create table if not exists requirement_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT requirement_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES requirement_role_type (id),
    CONSTRAINT requirement_role_type_pk PRIMARY key (id)
);

create table if not exists requirement_status_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT requirement_status_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES requirement_status_type (id),
    CONSTRAINT requirement_status_type_pk PRIMARY key (id)
);

create table if not exists requirement_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT requirement_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES requirement_type (id),
    CONSTRAINT requirement_type_pk PRIMARY key (id)
);

create table if not exists desired_feature
(
    id           uuid    DEFAULT uuid_generate_v4(),
    feautre_id   uuid not null,
    optional_ind boolean default false,
    CONSTRAINT desired_feature_pk PRIMARY key (id)
);

create table if not exists requirement
(
    id                        uuid DEFAULT uuid_generate_v4(),
    description               text not null
        CONSTRAINT requirement_role_type_description_not_empty CHECK (description <> ''),
    requirement_creation_date date default current_date,
    required_by               date not null,
    estimated_budget          numeric(12, 3),
    quantity                  bigint,
    reason                    text,
    parent_requirement_id     uuid references requirement (id),
    facility_id               uuid,
    product_id                uuid,
    requirement_type_id       uuid not null references requirement_type (id),
    CONSTRAINT requirement_pk PRIMARY key (id)
);

create table if not exists requirement_status
(
    id                         uuid DEFAULT uuid_generate_v4(),
    status_date                date default current_date,
    requirement_id             uuid not null references requirement (id),
    requirement_status_type_id uuid not null references requirement_status_type (id),
    CONSTRAINT requirement_status_pk PRIMARY key (id)
);

create table if not exists requirement_role
(
    id                       uuid          DEFAULT uuid_generate_v4(),
    from_date                date not null default current_date,
    thru_date                date,
    requirement_role_type_id uuid not null references requirement_role_type (id),
    for_party_id             uuid not null,
    requirement_id           uuid not null references requirement (id),
    CONSTRAINT requirement_role_pk PRIMARY key (id)
);

create table if not exists order_requirement_commitment
(
    id             uuid DEFAULT uuid_generate_v4(),
    quantity       bigint,
    requirement_id uuid not null references requirement (id),
    order_item_id  uuid not null,
    CONSTRAINT order_requirement_commitment_pk PRIMARY key (id)
);

create table if not exists request_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT request_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES requirement_type (id),
    CONSTRAINT request_type_pk PRIMARY key (id)
);

create table if not exists request
(
    id                     uuid DEFAULT uuid_generate_v4(),
    request_date           date not null,
    response_required_date date not null,
    description            text not null
        CONSTRAINT request_description_not_empty CHECK (description <> ''),
    request_type_id        uuid not null references request_type (id),
    CONSTRAINT request_pk PRIMARY key (id)
);

create table if not exists request_item
(
    id               uuid DEFAULT uuid_generate_v4(),
    required_by_date date,
    quantity         bigint,
    maximum_amount   numeric(12, 3),
    description      text,
    request_id       uuid not null references request (id),
    quote_item_id    uuid,
    CONSTRAINT request_item_pk PRIMARY key (id)
);

create table if not exists request_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT request_role_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES request_role_type (id),
    CONSTRAINT request_role_type_pk PRIMARY key (id)
);

create table if not exists request_role
(
    id                   uuid DEFAULT uuid_generate_v4(),
    request_id           uuid not null references request (id),
    request_role_type_id uuid not null references request_role_type (id),
    party_id             uuid not null,
    CONSTRAINT request_role_pk PRIMARY key (id)
);

create table if not exists responding_party
(
    id                           uuid DEFAULT uuid_generate_v4(),
    date_sent                    date default current_date,
    request_id                   uuid not null references request (id),
    sent_to_contact_mechanism_id uuid not null,
    party_id                     uuid not null,
    contact_mechanism_id         uuid not null,
    CONSTRAINT responding_party_pk PRIMARY key (id)
);

create table if not exists requirement_request
(
    id              uuid DEFAULT uuid_generate_v4(),
    request_item_id uuid not null references request_item (id),
    requirement_id  uuid not null references requirement (id),
    CONSTRAINT _pk PRIMARY key (id)
);

create table if not exists quote_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT quote_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES quote_type (id),
    CONSTRAINT quote_type_pk PRIMARY key (id)
);

create table if not exists quote
(
    id                 uuid          DEFAULT uuid_generate_v4(),
    issue_date         date          default current_date,
    valid_from_date    date not null default current_date,
    valid_thru_date    date,
    description        text not null
        CONSTRAINT existse_description_not_empty CHECK (description <> ''),
    quote_type_id      uuid not null references quote_type (id),
    issued_by_party_id uuid not null,
    given_to_party_id  uuid not null,
    CONSTRAINT quote_pk PRIMARY key (id)
);

create table if not exists quote_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT quote_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES quote_role_type (id),
    CONSTRAINT quote_role_type_pk PRIMARY key (id)
);

create table if not exists quote_role
(
    id           uuid DEFAULT uuid_generate_v4(),
    party_id     uuid not null,
    described_by uuid not null references quote_role_type (id),
    quote_id     uuid not null references quote (id),
    CONSTRAINT quote_role_pk PRIMARY key (id)
);

create table if not exists quote_term_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT quote_term_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES quote_term_type (id),
    CONSTRAINT quote_term_type_pk PRIMARY key (id)
);

create table if not exists quote_term
(
    id            uuid DEFAULT uuid_generate_v4(),
    value         text not null
        CONSTRAINT quote_term_value_not_empty CHECK (value <> ''),
    quote_item_id uuid,
    qutoe_id      uuid,
    CONSTRAINT qutoe_term_pk PRIMARY key (id)
);

create table if not exists quote_item
(
    id                      uuid   DEFAULT uuid_generate_v4(),
    sequence                bigint not null,
    quantity                bigint default 1,
    quote_unit_price        numeric(12, 3),
    estimated_delivery_date date,
    comment                 text,
    product_id              uuid,
    work_effort_id          uuid,
    CONSTRAINT quote_item_pk PRIMARY key (id)
);

create table if not exists agreement_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT agreement_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES agreement_type (id),
    CONSTRAINT agreement_type_pk PRIMARY key (id)
);

create table if not exists agreement
(
    id                    uuid          DEFAULT uuid_generate_v4(),
    agreement_date        date not null,
    from_date             date not null default current_date,
    thru_date             date,
    description           text not null
        constraint agreement_description_not_empty check (description <> ''),
    "text"                text not null
        constraint agreement_text_not_empty check ("text" <> ''),
    party_relationship_id uuid not null,
    CONSTRAINT agreement_pk PRIMARY key (id)
);

create table if not exists agreement_role_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT agreement_role_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES agreement_role_type (id),
    CONSTRAINT agreement_role_type_pk PRIMARY key (id)
);

create table if not exists agreement_role
(
    id           uuid DEFAULT uuid_generate_v4(),
    agreement_id uuid not null references agreement (id),
    described_by uuid not null references agreement_role_type (id),
    party_id     uuid not null,
    CONSTRAINT agreement_role_pk PRIMARY key (id)
);

create table if not exists agreement_item_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT agreement_item_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES agreement_item_type (id),
    CONSTRAINT agreement_item_type_pk PRIMARY key (id)
);

create table if not exists agreement_item
(
    id              uuid DEFAULT uuid_generate_v4(),
    sequence        bigint not null,
    agreement_text  text   not null,
    agreement_image text,
    CONSTRAINT agreement_item_pk PRIMARY key (id)
);

create table if not exists agreement_organization_applicability
(
    id                uuid DEFAULT uuid_generate_v4(),
    agreement_item_id uuid not null references agreement (id),
    party_id          uuid not null,
    CONSTRAINT agreeement_organization_applicability_pk PRIMARY key (id)
);

create table if not exists agreement_product_applicability
(
    id                uuid DEFAULT uuid_generate_v4(),
    agreement_item_id uuid not null references agreement (id),
    product_id        uuid not null,
    CONSTRAINT agreement_product_applicability_pk PRIMARY key (id)
);

create table if not exists agreement_geographical_applicability
(
    id                     uuid DEFAULT uuid_generate_v4(),
    agreement_item_id      uuid not null references agreement (id),
    geographic_boundary_id uuid not null,
    CONSTRAINT agreement_geographical_applicability_pk PRIMARY key (id)
);

create table if not exists addendum
(
    id                             uuid DEFAULT uuid_generate_v4(),
    creation_date                  date default current_date,
    effective_date                 date not null,
    "text"                         text not null
        CONSTRAINT addendum_text_not_empty CHECK (text <> ''),
    modification_of_agreement_item uuid references agreement_item (id),
    modification_of_agreement      uuid references agreement (id),
    CONSTRAINT addendum_pk PRIMARY key (id)
);

create table if not exists agreement_term_type
(
    id          uuid DEFAULT uuid_generate_v4(),
    description text not null
        CONSTRAINT agreement_term_type_description_not_empty CHECK (description <> ''),
    parent_id   UUID REFERENCES agreement_term_type (id),
    CONSTRAINT agreement_term_type_pk PRIMARY key (id)
);

create table if not exists agreement_term
(
    id                uuid          DEFAULT uuid_generate_v4(),
    from_date         date not null default current_date,
    thru_date         date,
    value             text not null,
    agreement_item_id uuid references agreement_item (id),
    agreement_id      uuid,
    CONSTRAINT agreement_term_pk PRIMARY key (id)
);
