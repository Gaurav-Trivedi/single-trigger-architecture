/**
* @Component Name   : AccountHelper
* @Developed By     : Gaurav Trivedi
* @Created Date     : July 14, 2016
* @Description      : This class provides functionality to work with Account based on the trigger context.
* **********************************************************************************************************************
*										Modification Log
* **********************************************************************************************************************
* 	Name				|	Version		|		Date		|					Discription
* **********************************************************************************************************************
*	Gaurav Trivedi 		|       1.0 	|	June 14, 2016	|	Initial Draft
*
* **********************************************************************************************************************
*/
public with sharing class AccountHelper extends TriggerService {
    public AccountHelper(
            Boolean isInsertIn ,
            Boolean isUpdateIn ,
            Boolean isUnDeleteIn ,
            Boolean isDeleteIn ,
            Boolean isAfterIn ,
            Boolean isBeforeIn ,
            Integer sizeIn ,
            String objectApiName ,
            List<sObject> newRecordListIn ,
            List<sObject> oldRecordListIn ,
            Map<Id,sObject> mapOfNewRecordsIn ,
            Map<Id,sObject> mapOfOldRecordsIn
    )
    {
        super(
                isInsertIn,
                isUpdateIn ,
                isUnDeleteIn,
                isDeleteIn,
                isAfterIn ,
                isBeforeIn ,
                sizeIn ,
                objectApiName,
                newRecordListIn ,
                oldRecordListIn ,
                mapOfNewRecordsIn ,
                mapOfOldRecordsIn );
    }
    /**
    * @function     :   handleAfterInsert
    * @description  :   Override the virtual class abstract method to call Domain logic
    * @return       :   void
    */
    public override void handleAfterInsert(){
        sendMustorMayTakeToSpecialist(newRecordList);
    }
    /**
    * @function     :   sendMustorMayTakeToSpecialist
    * @description  :   Actual business logic to process the data
    * @parm         :   {List<Account>} newRdList
    * @return       :   void
    */
    public void sendMustorMayTakeToSpecialist(List<Account> newRdList){
        // Do something here
    }
}