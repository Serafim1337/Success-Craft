public with sharing class reportLwcController {
    public reportLwcController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        
        return [SELECT Name, (SELECT Id, Name, Amount FROM Opportunities WHERE IsClosed=TRUE AND IsWon=TRUE)      
        FROM Account
        WITH SECURITY_ENFORCED];


        // WHERE Id IN (SELECT AccountId 
        // FROM Opportunity
        // WHERE IsWon=TRUE AND
        // IsClosed = TRUE)
    }
}
