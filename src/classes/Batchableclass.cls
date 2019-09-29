public class Batchableclass  implements Database.batchable<sobject> ,Database.Stateful{
    
    public list<account> accs = new list<account>();
    
    string query ;
    public Batchableclass(){
       accs = new list<account>(); 
    }
    
 
    
    public database.QueryLocator start(Database.BatchableContext info){ 
       return database.getQueryLocator([select id,name,Industry from account]); 
    }  
    
    
    public void execute(Database.BatchableContext info, List<Account> scope){
       List<Account> accsToUpdate = new List<Account>();
       for(Account a : scope){ 
           a.Name = 'BAluBatch records'; 
           a.NumberOfEmployees = 70; 
           system.debug('welcome');
           system.debug('testing 2');
           system.debug('testing 3');
           accsToUpdate.add(a); 
           if(a.Industry=='Banking'){
               accs.add(a);
           }
       } 
       update accsToUpdate; 
        // handler.methodname(scope);
        callout();
   }
    
    public  void finish(Database.BatchableContext info){ 
        system.debug('Accounts'+accs);
         AsyncApexJob a = [Select Id, Status,ExtendedStatus,NumberOfErrors,JobItemsProcessed, TotalJobItems, CreatedBy.Email from AsyncApexJob where Id =:info.getJobId()];
          
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
            String[] toAddresses = new String[] {a.CreatedBy.Email};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Match Merge Batch ' + a.Status);
            mail.setPlainTextBody('records processed ' + a.TotalJobItems +
           'with '+ a.NumberOfErrors + ' failures.');
        
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    } 
    
    public void callout(){
        
    }

}