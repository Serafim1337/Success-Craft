@RestResource(urlMapping='/Payment/*')
global with sharing class RestWebService {
    @HttpPost
    global static List<Payment__c> requestManager(List<PaymentClass> payments) {
    
        List<Payment__c> paymentsToInsert = new List<Payment__c>();
        for(PaymentClass p : payments) {
            Payment__c pa = new Payment__c(
                Opportunity__c = p.opportunity,
                Amount__c = p.amount,
                FirstName__c = p.firstName,
                LastName__c = p.lastName
            );
            paymentsToInsert.add(pa);
        }
        insert paymentsToInsert;
        return paymentsToInsert;
    }

    global class PaymentClass {
        public String opportunity;
        public Decimal amount;
        public String firstName;
        public String lastName;

        public PaymentClass(String opp, String am, String first, String last) {
            opportunity = opp;
            amount = Decimal.valueOf(am);
            firstName = first;
            lastName = last;
        }
    }
    
}



// Requests examples

// post https://successcraft56-dev-ed.lightning.force.com/services/apexrest/Payment

// Authorization : Bearer + access token
// Content-Type : application/json

// {
//     "payments":[
//         {
//             "opportunity" : "0065j00000f9fkAAAQ",
//             "amount" : "100020",
//             "firstName" : "First",
//             "lastName" : "Firstty"
//         },
//         {
//         "opportunity" : "0065j00000f9fkAAAQ",
//             "amount" : "1000430",
//             "firstName" : "Second",
//             "lastName" : "S"
//         }
//   ]
// }

// post https://login.salesforce.com/services/oauth2/token
// {
//     "grant_type":"password",
//     "client_id":"3MVG9pRzvMkjMb6mNS34mqMWBE0wqx9VEfyHcNAR8g1Qe9IYer5XMjy12QXsRp42raZSffMOdhP1pNjxpiuaw",
//     "client_secret":"A7005D64968C6B8E341CFF50799F56D87752BF1146C8142B6C12EF1BC0246DDE",
//     "username":"serafimevt@success-craft.com",
//     "password":"7777920Plamen"
//     }