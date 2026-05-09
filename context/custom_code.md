## Custom Code
### Functions
- getChatHistory(docs: List<Document<?>>) → List<String>
- countTicketsByStatus(tickets: List<Document<?>>, statusValue: String) → Integer
- getTicketChartData(tickets: List<Document<?>>) → List<Integer>
- averageOfferPrice(offers: List<Document<?>>) → Double
### Actions
- getPlaceName(latlng: LatLng) → String
- markMessagesAsRead(ticketRef: DocumentReference)
- exportTicketPDF(subject: String, status: String, category: String, chatHistory: List<String>)
- evaluateServicePrice(title: String, description: String, level: String, budgetMin: Double, budgetMax: Double)
- sendServiceEmail(title: String, clientEmail: String, budgetMin: Double, budgetMax: Double)
### Widgets
- OSMMap(dimensions: WidgetProperty)

