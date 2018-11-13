/**
* @Component Name   : TriggerService
* @Developed By     : Gaurav Trivedi
* @Created Date     : June 14, 2016
* @Description      : Handles trigger call for all events with context variables.
* **********************************************************************************************************************
*										Modification Log
* **********************************************************************************************************************
* 	Name				|	Version		|		Date		|					Discription
* **********************************************************************************************************************
*	Gaurav Trivedi 		|       1.0 	|	June 14, 2016	|	Initial Draft
*
* **********************************************************************************************************************
* NOTE: DO NOT CHANGE THIS CLASS UNTIL WE WANT TO ADD COMMON METHOD FOR TRIGGERS
*/
public with sharing virtual class TriggerService {
    public boolean isInsert, isUpdate, isDelete, isUnDelete, isBefore, isAfter;
    public Integer recordSize { get; set; }
    public string sObjectName { get; set; }
    public List<sObject> newRecordList { get; set; }
    public List<sObject> oldRecordList { get; set; }
    public Map<Id, sObject> mapOfOldRecords { get; set; }
    public Map<Id, sObject> mapOfNewRecords { get; set; }

    public TriggerService() {
    }
    public TriggerService(Boolean isInsertIn, Boolean isUpdateIn, Boolean isUnDeleteIn, Boolean isDeleteIn,
            Boolean isAfterIn, Boolean isBeforeIn, Integer sizeIn, String objectApiName, List<sObject> newRecordListIn,
            List<sObject> oldRecordListIn, Map<Id, sObject> mapOfNewRecordsIn, Map<Id, sObject> mapOfOldRecordsIn) {
        this.isInsert = isInsertIn ;
        this.isUpdate = isUpdateIn ;
        this.isUnDelete = isUnDeleteIn ;
        this.isDelete = isDeleteIn ;
        this.isAfter = isAfterIn ;
        this.isBefore = isBeforeIn ;
        this.recordSize = sizeIn ;
        this.sObjectName = objectApiName ;
        this.newRecordList = newRecordListIn ;
        this.oldRecordList = oldRecordListIn ;
        this.mapOfNewRecords = mapOfNewRecordsIn ;
        this.mapOfOldRecords = mapOfOldRecordsIn ;
    }
    /**
    * @function     :   processTrigger
    * @description  :   Public method to execute any functionality contained in the extension classes
    * @return       :   void
    */
    public virtual void processTrigger() {
        User user = [SELECT Id, ByPassAllProcess__c FROM User WHERE Id =: UserInfo.getUserId()];
        if (byPassTrigger() <> null && !user.ByPassAllProcess__c) {
            if (this.isBefore && byPassTrigger().isBefore__c == this.isBefore && ((this.isInsert &&
                    byPassTrigger().isInsert__c == this.isInsert) || (this.isUpdate && byPassTrigger().isUpdate__c ==
                    this.isUpdate))) {
                handlePrePopulationAndValidation() ;
            }
            if (this.isBefore && byPassTrigger().isBefore__c == this.isBefore) {
                if (this.isInsert && byPassTrigger().isInsert__c == this.isInsert) {
                    handleBeforeInsert();
                } else if (this.isUpdate && byPassTrigger().isUpdate__c == this.isUpdate) {
                    handleBeforeUpdate();
                } else if (this.isDelete && byPassTrigger().isDelete__c == this.isDelete) {
                    handleBeforeDelete();
                }
            } else if (this.isAfter && byPassTrigger().isAfter__c == this.isAfter) {
                if (this.isInsert && byPassTrigger().isInsert__c == this.isInsert) {
                    handleAfterInsert();
                } else if (byPassTrigger().isUpdate__c == this.isUpdate) {
                    handleAfterUpdate();
                } else if (byPassTrigger().isUnDelete__c == this.isUnDelete) {
                    handleAfterUndelete();
                } else if (byPassTrigger().isDelete__c == this.isDelete) {
                    handleAfterDelete();
                }
            } else {
                return;
            }
        } else if(byPassTrigger() == null){
            newRecordList[0].addError('Please create custom metadata for ' + sObjectName + ' object first. Thanks!');
        }
    }

    /**
    * @function(s)  :   handleBeforeInsert
    * @description  :   These methods should be overridden against the event of trigger. So, all the
    *                   developers should use this when needed.
    * @return       :   void
    */
    public virtual void handleBeforeInsert() {
    }
    /**
   * @function(s)  :   handleBeforeUpdate
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handleBeforeUpdate() {
    }
    /**
   * @function(s)  :   handleBeforeDelete
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handleBeforeDelete() {
    }
    /**
   * @function(s)  :   handleAfterInsert
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handleAfterInsert() {
    }
    /**
   * @function(s)  :   handleAfterUpdate
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handleAfterUpdate() {
    }
    /**
   * @function(s)  :   handleAfterDelete
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handleAfterDelete() {
    }
    /**
   * @function(s)  :   handleAfterUndelete
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handleAfterUndelete() {
    }
    /**
   * @function(s)  :   handlePrePopulationAndValidation
   * @description  :   These methods should be overridden against the event of trigger. So, all the
   *                   developers should use this when needed.
   * @return       :   void
   */
    public virtual void handlePrePopulationAndValidation() {
    }

    /**
    * @function     :   isChangedCondition
    * @description  :   To check for change in field values (compared with old and new) condition by
    *                   passing the list of fields (API Names only)
    * @parm         :   {sObject} currentObject, {List} fields
    * @return       :   boolean
    */
    public boolean isChangedCondition(sObject currentObject, List<String> fields) {
        boolean retRes = false ;
        sObject oldRecordCopy = mapOfOldRecords.get((String) currentObject.get('Id')) ;
        for (String s : fields) {
            if (currentObject.get(s) != oldRecordCopy.get(s)) {
                retRes = true ;
                break ;
            }
        }
        return retRes ;
    }
    /**
    * @function     :   isChangedCondition
    * @description  :   To check for change in field values (compared with old and new) condition by
    *                   passing the field (API Names only)
    * @parm         :   {sObject} currentObject, {String} field
    * @return       :   boolean
    */
    public boolean isChangedCondition(sObject currentObject, String field) {
        sObject oldRecordCopy = null;
        if (mapOfOldRecords <> null) {
            oldRecordCopy = mapOfOldRecords.get((String) currentObject.get('Id')) ;
        }
        return mapOfOldRecords == null || currentObject.get(field) != oldRecordCopy.get(field);
    }
    /**
    * @function     :   getRecTypeId
    * @description  :   Get record type Id by passing the object as "Account.sObjectType" and record type name
    * @parm         :   {SObjectType} sObjectType, {String} recordTypeName
    * @return       :   Id
    */
    public static Id getRecTypeId(SObjectType sObjectType, String recordTypeName) {
        Map<String, schema.recordtypeinfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosByName();
        return (Id) recordTypeInfo.get(recordTypeName).getRecordTypeId();
    }
    /**
    * @function     :   getRecTypeName
    * @description  :   Get record type Name by passing the object as "Account.sObjectType" and record type Id
    * @parm         :   {SObjectType} sObjectType, {Id} recTypeId
    * @return       :   String
    */
    public static String getRecTypeName(SObjectType sObjectType, Id recTypeId) {
        Map<Id, schema.recordtypeinfo> recordTypeInfo = sObjectType.getDescribe().getRecordTypeInfosById();
        return recordTypeInfo.get(recTypeId).getName();
    }
    /**
    * @function     :   checkNullEqualIgnore
    * @description  :   To check is the value is not null and equals to expected value
    * @parm         :   {sObject} currentObject, {String} field
    * @return       :   boolean
    */
    public static boolean checkNullEqualIgnore(String dbValue, String expectedValue) {
        return dbValue <> null && dbValue.equalsIgnoreCase(expectedValue);
    }
    /**
    * @function     :   createException
    * @description  :   To create an Exception records or by pass
    * @parm         :   {Exception} e, {Boolean} insertExc
    * @return       :   boolean
    */
    public void createException(Exception e, Boolean insertExc) {
        String exc = 'Cause : ' + e.getCause() + ', Message: ' + e.getMessage() + ', Stack Trace: ' + e.getStackTraceString();
        if (insertExc) {
            //Write a logic to create exception record
            System.debug('Write a logic to create exception record : '+insertExc);
        } else {
            for (sObject s : newRecordList) {
                s.addError(exc);
            }
            System.debug('Exceptions: ' + exc);
        }
    }
    /**
    * @function     :   byPassTrigger
    * @description  :   To byPass triggger using metadata configuration
    * @return       :   TriggerByPass__mdt
    */
    private TriggerByPass__mdt byPassTrigger() {
        List<TriggerByPass__mdt> triggerBypassList = new List<TriggerByPass__mdt>();
        triggerBypassList = [SELECT isBefore__c, isAfter__c, isInsert__c, isUpdate__c, isDelete__c, isUnDelete__c FROM
                TriggerByPass__mdt WHERE isActive__c = TRUE AND Object_API_Name__c = :this.sObjectName];
        return !triggerBypassList.isEmpty() ? triggerBypassList[0] : null;
    }
}