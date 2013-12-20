function sendNotification(summary, body) {	
    engine = dataEngine("notifications");
    service = engine.serviceForSource("notification");
    op = service.operationDescription("createNotification");
    op["appName"] = "distrowatcher";
    op["appIcon"] = "preferences-desktop-notification";
    op["summary"] = summary;
    op["body"] = body;
    op["timeout"] = 2000;
    service.startOperationCall(op);
}
 
