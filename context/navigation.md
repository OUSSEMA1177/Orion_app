## Navigation Graph
```
ADMINCreateContractPage → ContractListPage
ADMIN_CAT_TICKET → edit_categorie, ticket_homepage
ADMIN_PAGE → ticket_homepage
AddMilestonePage (no outgoing navigation)
AddWorkerCategory_page → WORKERCATEGORY_PAGE
AddWorkerProfile_page → FIRST_PAGE, WORKERPROFILE_PAGE
Admin_Offers → FIRST_PAGE, Offer_Stats, editOffer
CLIENT_DAHSBOARD → TICKETuser_list
Client_Offers → FIRST_PAGE, Offer_Detail
Client_OffersModel → FIRST_PAGE
ContractListPage → ADMINCreateContractPage, EditContractPage
EDITticketADMIN → ticket_dashboard
EditContractPage → ContractListPage
EditMilestonePage (no outgoing navigation)
EditWorkerCategory_page → WORKERCATEGORY_PAGE
EditWorkerProfile_page → WORKERPROFILE_PAGE
FIRST_PAGE [initial] → ADMIN_PAGE, AddWorkerProfile_page, Admin_Offers, CLIENT_DAHSBOARD, Client_Offers, ContractListPage, WORKERCATEGORY_PAGE, WORKERPROFILE_PAGE, WORKER_DASHBOARD, Worker_Offers, portfolio_items, service_client, ticket_homepage
FORGET_PASSWORD → LOGIN
LOGIN → FORGET_PASSWORD, SIGNUP
MilestoneListPage (no outgoing navigation)
Offer_Detail → FIRST_PAGE
Offer_Stats → Admin_Offers
SIGNUP → CLIENT_DAHSBOARD, LOGIN, WORKER_DASHBOARD
Select_Service_Request → FIRST_PAGE, addOffers
TICKET_PAGE → TICKETuser_list, ticket_dashboard
TICKETuser_list → TICKET_PAGE, WORKER_DASHBOARD, ticket_conversation
WORKERCATEGORY_PAGE → AddWorkerCategory_page, EditWorkerCategory_page, traduction_description
WORKERPROFILE_PAGE → AddWorkerProfile_page, EditWorkerProfile_page, FIRST_PAGE
WORKER_DASHBOARD → FIRST_PAGE, TICKETuser_list
Worker_Offers → FIRST_PAGE, Select_Service_Request
addOffers → Worker_Offers
chatbot (no outgoing navigation)
editOffer → Admin_Offers
edit_categorie → ADMIN_CAT_TICKET
portflio_view → chatbot, portfolio_items, portfolio_update, review_form, searchportfollio
portfolio_items → chatbot, portflio_view
portfolio_update → portflio_view
review_form (no outgoing navigation)
searchportfollio → review_form
service_admin (no outgoing navigation)
service_client → service_create, service_update
service_create (no outgoing navigation)
service_update (no outgoing navigation)
ticket_conversation → TICKETuser_list, ticket_dashboard
ticket_dashboard → EDITticketADMIN, ticket_conversation, ticket_homepage, ticket_stats
ticket_homepage → ADMIN_CAT_TICKET, FIRST_PAGE, TICKET_PAGE, ticket_dashboard
ticket_stats → ticket_dashboard
traduction_description → WORKERCATEGORY_PAGE
```

