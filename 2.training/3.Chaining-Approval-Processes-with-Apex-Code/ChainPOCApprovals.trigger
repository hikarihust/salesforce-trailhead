trigger ChainPOCApprovals on Opportunity (after update) { 

    // the status value that indicates we should submit the opportunity into the second approval process
    static final String STATUS_PENDING_BU_APPROVAL = 'Pending Business Unit Approval';
    
    // loop through updated opportunities
    for(Opportunity newOpp : Trigger.New) {

        // get the pre-update version of the opportunity from the old record map
        Opportunity oldOpp = Trigger.OldMap.get(newOpp.Id);

        // if the Status has been updated to the value we care about
        if(newOpp.Status__c == STATUS_PENDING_BU_APPROVAL && oldOpp.Status__c != STATUS_PENDING_BU_APPROVAL) {       

            // create a request to submit the opportunity for approval
            Approval.ProcessSubmitRequest submitRequest = new Approval.ProcessSubmitRequest();
            submitRequest.setObjectId(newOpp.Id);

            // submit the opportunity for approval                           
            Approval.ProcessResult result = Approval.process(submitRequest);
        }
    }
}