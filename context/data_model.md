## Collections (12)
- contract: title (String), scope (String), agreed_price (Double), currency (String), start_date (DateTime), end_date (DateTime), status (String), worker_id (String), created_at (DateTime), client_id (String), id (Integer), pdf_url (String)
  - Used by: ADMINCreateContractPage, ContractListPage, EditContractPage
- ticket: subject (String), status (String), priority (String), created_at (DateTime), created_by (String), description (String), category_id (String)
  - Used by: CLIENT_DAHSBOARD, EDITticketADMIN, TICKET_PAGE, TICKETuser_list, WORKER_DASHBOARD, ticket_conversation, ticket_dashboard, ticket_stats
- category_ticket: name (String), description (String), created_at (DateTime), cat_id (String)
  - Used by: ADMIN_CAT_TICKET, EDITticketADMIN, TICKET_PAGE, edit_categorie
- sub_ticket: message (String), sender_role (String), created_at (DateTime), file_path (String), ticket_id (String), sender_id (String), is_read (Boolean)
  - Used by: TICKET_PAGE, TICKETuser_list, ticket_conversation
- milestone: title (String), description (String), amount (Double), status (String), contract_id (DocumentReference)
  - Used by: MilestoneListPage
- worker_category: catgorie (String), Description (String), Statut (String), Ordre (Integer), Taux_horaire (Double), ICON (ImagePath)
  - Used by: AddWorkerCategory_page, EditWorkerCategory_page, WORKERCATEGORY_PAGE, traduction_description
- worker_prrofile: Professional_Title (String), Bio (String), Category (String), Experience (Integer), Hourlyrate (Double), Availability (String), location (String), id (DocumentReference), emailPro (String)
  - Used by: AddWorkerProfile_page, EditWorkerProfile_page, WORKERPROFILE_PAGE
- offer: price (Double), estimated_time_days (Integer), status (String), priority_level (String), message (String), created_at (DateTime), updated_at (DateTime), scope_summary (String), deliverables (String), acceptance_criteria (String), included_revisions (Integer), extra_revision_fee (Double), is_urgent (Boolean), rush_fee (Double), response_sla_hours (Integer), start_date_available (DateTime), delivery_date_estimated (DateTime), match_score (Double), proposed_budget (Double), proposed_deadline (DateTime), client_id (DocumentReference), service_request_id (DocumentReference), created_by_id (DocumentReference), client_has_negotiate (Boolean), worker_id (DocumentReference), worker_name (String), client_name (String), service_title (String), client_mail (String), worker_mail (String)
  - Used by: Admin_Offers, Client_Offers, Offer_Detail, Offer_Stats, Worker_Offers, addOffers, editOffer
- negotiation: subject (String), status (String), counter_price (Double), timeline_days (Integer), scope_details (String), deliverables_list (String), acceptance_criteria (String), included_revisions (Integer), extra_revision_fee (Double), priority_level (String), meeting_frequency (String), nda_required (Boolean), data_sensitivity_level (String), late_penalty_percent (Double), expires_at (DateTime), last_action_at (DateTime), created_at (DateTime), updated_at (DateTime), offer_id (DocumentReference), opened_by_id (DocumentReference), taget_user_id (DocumentReference)
- users: email (String), display_name (String), photo_url (ImagePath), uid (String), created_time (DateTime), phone_number (String), edited_time (DateTime), bio (String), user_name (String), password (String), profile (Boolean), role (String)
  - Used by: Admin_Offers, addOffers
- service: title (String), description (String), budget_min (Double), budget_max (Double), duration (Integer), category (DocumentReference), client (DocumentReference), level (String), status (String)
  - Used by: Admin_Offers, Select_Service_Request, addOffers, service_client, service_create, service_update
- portfolio_items: project_title (String), project_description (String), category (String), tools_used (String), project_url (String), thumbnail_url (ImagePath)
  - Used by: portflio_view, portfolio_items, portfolio_update, review_form, searchportfollio

## Enums (3)
- service_level: Junior, Senior, Expert
- service_status: open, pending
- role: user, system

## Data Structs (1)
- chat: message (String)

