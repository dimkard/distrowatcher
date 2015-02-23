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
 
function trimSpace(mystr) {
  if(String.prototype.trim) {  
    return mystr.trim();
  }
  else {
    return mystr.replace(/^\s+|\s+$/g,'');
  }
}
