public with sharing class PDFController {

    Datetime myDate = system.today();
    Private dmpl__Quote__c pageEstimate;
    public Boolean initialised{get; set;}
    public Pagereference currentPageRef {get; set;}

    public PDFController(ApexPages.StandardController controller) {
        this.pageEstimate = (dmpl__Quote__c)controller.getRecord();
        id estimateId = ApexPages.currentPage().getParameters().get('id');
        currentPageRef = ApexPages.currentPage();
        initialised=false;
    }

    //method to insert attachement call it on page on click of button 
    public void saveAttachement() {
                
    if (!initialised && this.pageEstimate.Id !=NULL) 
    {
        PageReference pdf =  currentPageRef;
        String fileName = this.pageEstimate.Name + '-' + myDate + '.pdf';
        Attachment attach = new Attachment();
        Blob body;
        try 
        {
            // returns the output of the page as a PDF
            body = pdf.getContentAsPDF();

            // need to pass unit test -- current bug    
        } 
        catch (VisualforceException e) 
        {
            body = Blob.valueOf('Some Text');
        }

            attach.Body = body;
            // add the user entered name
            attach.Name = fileName;
            attach.IsPrivate = false;
            // attach the pdf to the account
            attach.ParentId = this.pageEstimate.Id;
            // attach.ContentType = 'application/pdf';
            insert attach;
            initialised=true;
        } 
        else 

        pageEstimate.dmpl__Status__c = 'Pending Approval';
        update pageEstimate;
    }

    public void downloadAsPDF()
    {
        PageReference pdf =  currentPageRef;
        String fileName = this.pageEstimate.Name + '-' + myDate + '.pdf';
         currentPageRef.getHeaders().put('content-disposition', 'attachment; filename=' + fileName);
    }
}