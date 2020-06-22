/*
    Description: Class for Sales review report
*/
public class SalesReviewReportController {
  public Boolean blnExisting { get; set; }

  public List<SelectOption> lstAllRepsBySalesTeam { get; set; }
  public string strSelectedRep { get; set; }

  public List<SelectOption> lstYears { get; set; }
  public string strSelectedYear { get; set; }

  public List<SelectOption> lstQuarters { get; set; }
  public string strSelectedQuarter { get; set; }

  public List<SelectOption> lstMyOrMyTeamData { get; set; }
  public string strSelectedMyOrMyTeamData { get; set; }
  public Set<Id> VPForecastUserIds { get; set; }
  public Set<Id> UserIds { get; set; }

  public List<WrapperSalesReport> lstWrapperSalesReport { get; set; }

  public transient List<WrapperforcastResults> lstResultRepForcast { get; set; }
  public Integer intResultRepForcast { get; set; }
  public Integer inttotalRevenueRepForcast { get; set; }
  public transient List<WrapperforcastResults> lstResultManagerForcast {
    get;
    set;
  }
  public Integer intResultManagerForcast { get; set; }
  public Integer inttotalRevenueManagerForcast { get; set; }
  public transient List<WrapperforcastResults> lstResultVPForcast { get; set; }
  public Integer intResultVPForcast { get; set; }
  public Integer inttotalRevenueVPForcast { get; set; }
  public transient List<Wrapperforcastpipelinedata> lstResultPipelineForecast {
    get;
    set;
  }
  public transient List<WrapperforcastTrackActivity> lstwftrackingActivity {
    get;
    set;
  }

  public transient List<WrapperTopResults> lstResultTop10Closers { get; set; }
  public transient List<WrapperTopResults> lstResultTop10ZBOOpenDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10ZBOClosedDeals {
    get;
    set;
  }

  public transient List<WrapperTopResults> lstResultTop10ProspectOpenDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10ProspectClosedDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10ProductionOpenDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10ProductionClosedDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10ITOpenDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10ITClosedDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10EquipmentsOpenDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10EquipmentsClosedDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10MPSOpenDeals {
    get;
    set;
  }
  public transient List<WrapperTopResults> lstResultTop10MPSClosedDeals {
    get;
    set;
  }

  public Sales_Quota__c objSalesQuote { get; set; }
  public Sales_Quota__c objSalesQuoteQuarter { get; set; }

  public SummaryModel currentSummaryRep { get; set; }
  public SummaryModel currentSummaryZbo { get; set; }
  public avgSummaryModel monthlySummaryRep { get; set; }
  public avgSummaryModel monthlySummaryZbo { get; set; }
  public SummaryModel zboSummary { get; set; }
  public SummaryModel productionSummary { get; set; }
  public SummaryModel itServicesSummary { get; set; }
  public SummaryModel equipmentSummary { get; set; }
  public SummaryModel mpsSummary { get; set; }
  public Map<Id, User> userMap { get; set; }
  public Boolean isDataAvailable { get; set; }

  public Integer intgapCloseOpenRev { get; set; }
  public Integer intzboOpenRev { get; set; }
  public Integer intprodOpenRev { get; set; }
  public Integer intitServOpenRev { get; set; }
  public Integer inteqipOpenRev { get; set; }
  public Integer intmpsOpenRev { get; set; }

  public string gapCloseOpenRev { get; set; }
  public string zboOpenRev { get; set; }
  public string prodOpenRev { get; set; }
  public string itServOpenRev { get; set; }
  public string eqipOpenRev { get; set; }
  public string mpsOpenRev { get; set; }
  public string selectedRepSalesTeam { get; set; }
  public string currentUserSalesTeam { get; set; }

  public SalesReviewReportController() {
    blnExisting = false;
    UserIds = new Set<Id>();
    userMap = new Map<Id, User>();
    lstAllRepsBySalesTeam = new List<SelectOption>();
    List<User> lstCurrentUser = new List<User>(
      [
        SELECT Id, Name, TSGADX__Sales_Team__c
        FROM User
        WHERE Isactive = true AND Id = :UserInfo.getUserId()
      ]
    );
    if (lstCurrentUser.size() > 0) {
      userMap.put(lstCurrentUser[0].Id, lstCurrentUser[0]);
      strSelectedRep = lstCurrentUser[0].Id;
      lstAllRepsBySalesTeam.add(
        new selectoption(lstCurrentUser[0].Id, lstCurrentUser[0].Name)
      );
      if (string.isnotblank(lstCurrentUser[0].TSGADX__Sales_Team__c)) {
        Set<String> salesTeams = new Set<String>();
        if (lstCurrentUser[0].TSGADX__Sales_Team__c == 'All') {
          currentUserSalesTeam = lstCurrentUser[0].TSGADX__Sales_Team__c;
          selectedRepSalesTeam = lstCurrentUser[0].TSGADX__Sales_Team__c;
          Sales_Team_Setting__c st = Sales_Team_Setting__c.getOrgDefaults();
          if (st != null && st.Sales_Team__c != null) {
            salesTeams.addAll(
              st.Sales_Team__c.trim()
                .replaceAll('\r\n', '')
                .replaceAll('\n', '')
                .replaceAll('\r', '')
                .split(';')
            );
          }
        } else {
          salesTeams.add(lstCurrentUser[0].TSGADX__Sales_Team__c);
        }

        for (User objUser : [
          SELECT Id, Name, TSGADX__Sales_Team__c
          FROM User
          WHERE
            Isactive = true
            AND Id != :lstCurrentUser[0].Id
            AND TSGADX__Sales_Team__c IN :salesTeams
        ]) {
          lstAllRepsBySalesTeam.add(new selectoption(objUser.Id, objUser.Name));
          userMap.put(objUser.Id, objUser);
        }
      }
    }

    SelectOptionSorterNew.doSort(
      lstAllRepsBySalesTeam,
      SelectOptionSorterNew.FieldToSort.Label
    );

    //lstAllRepsBySalesTeam.sort();
    lstYears = new List<SelectOption>();
    Double year = -3;
    for (Integer I = 0; I < 5; I++) {
      string strYear = string.valueof(
        Integer.valueof(system.today().year() + year)
      );
      lstYears.add(new SelectOption(strYear, strYear));
      year++;
    }
    strSelectedYear = string.valueof(system.today().year());

    lstQuarters = new List<SelectOption>();
    lstQuarters.add(new selectoption('1', 'Q1'));
    lstQuarters.add(new selectoption('2', 'Q2'));
    lstQuarters.add(new selectoption('3', 'Q3'));
    lstQuarters.add(new selectoption('4', 'Q4'));

    Integer currentQtr = Decimal.valueOf(system.today().month())
      .divide(3.0, 0, System.RoundingMode.UP)
      .intValue();
    strSelectedQuarter = string.valueof(currentQtr);

    //My Or My Team Data
    lstMyOrMyTeamData = new List<SelectOption>();
    lstMyOrMyTeamData.add(new selectoption('1', 'My Data'));
    lstMyOrMyTeamData.add(new selectoption('2', 'My Team\'s Data'));

    //System.Debug('@@@@@@ ' + strSelectedMyOrMyTeamData);
    //System.Debug('@@@@@@@@ ' + apexpages.currentpage().getparameters().get('id'));

    if (strSelectedMyOrMyTeamData == null) {
      strSelectedMyOrMyTeamData = string.valueof(1);
    }

    fnBindTeamDataForVP(); // fill team user if exist

    SalesViewByRep();

    //disable Existing Action Plan
    fnBindMyOrMyTeamData();
    if (UserIds.size() == 1) {
      blnExisting = true;
    }
  }

  // Creating recursion function to get all underneth Role Hierarchy
  public Set<Id> findRoleHierarchy(
    Id RoleId,
    List<UserRole> lst,
    Set<Id> setRoleIds
  ) {
    for (UserRole ur : lst) {
      if (RoleId == ur.ParentRoleId) {
        //if(ur.Name.tolowercase().Contains('mom')){
        setRoleIds.add(ur.Id);
        //  }
        findRoleHierarchy(ur.Id, lst, setRoleIds);
      }
    }
    return setRoleIds;
  }
  public void fnBindMyOrMyTeamData() {
    UserIds = new Set<Id>();
    Set<Id> RoleIds = new Set<Id>();
    List<UserRole> lstUserRole = new List<UserRole>(
      [SELECT Id, Name, ParentRoleId FROM UserRole]
    );
    User objuser = [
      SELECT Id, Name, userroleId, userRole.name, userRole.ParentRoleId
      FROM User
      WHERE id = :strSelectedRep
      LIMIT 1
    ];

    userIds.add(objuser.Id);
    RoleIds = findRoleHierarchy(objuser.userroleId, lstUserRole, new Set<Id>());
    for (user obj : [
      SELECT Id, Name, userRole.name
      FROM User
      WHERE UserRoleId IN :RoleIds AND Isactive = true
      ORDER BY Name
    ]) {
      userIds.add(obj.Id);
    }
  }

  public void fnBindTeamDataForVP() {
    VPForecastUserIds = new Set<Id>();
    Set<Id> RoleIds = new Set<Id>();
    List<UserRole> lstUserRole = new List<UserRole>(
      [SELECT Id, Name, ParentRoleId FROM UserRole]
    );
    User objuser = [
      SELECT Id, Name, userroleId, userRole.name, userRole.ParentRoleId
      FROM User
      WHERE id = :strSelectedRep
      LIMIT 1
    ];

    VPForecastUserIds.add(objuser.Id);
    RoleIds = findRoleHierarchy(objuser.userroleId, lstUserRole, new Set<Id>());
    for (user obj : [
      SELECT Id, Name, userRole.name
      FROM User
      WHERE UserRoleId IN :RoleIds AND Isactive = true
      ORDER BY Name
    ]) {
      VPForecastUserIds.add(obj.Id);
    }
  }

  public void SalesViewByRepName() {
    fnBindMyOrMyTeamData();

    lstMyOrMyTeamData.clear();
    if (UserIds.size() > 1) {
      lstMyOrMyTeamData = new List<SelectOption>();
      lstMyOrMyTeamData.add(new selectoption('1', 'My Data'));
      lstMyOrMyTeamData.add(new selectoption('2', 'My Team\'s Data'));
    } else {
      lstMyOrMyTeamData = new List<SelectOption>();
      lstMyOrMyTeamData.add(new selectoption('1', 'My Data'));
    }
    strSelectedMyOrMyTeamData = '1';

    SalesViewByRep();
  }

  public void SalesViewByRep() {
    if (
      String.isNotBlank(currentUserSalesTeam) && currentUserSalesTeam == 'All'
    )
      selectedRepSalesTeam = userMap.get(strSelectedRep).TSGADX__Sales_Team__c;

    isDataAvailable = false;
    lstWrapperSalesReport = new List<WrapperSalesReport>();
    objSalesQuote = new Sales_Quota__c();
    objSalesQuoteQuarter = new Sales_Quota__c();

    Date QstartDate;
    Date QendDate;

    Date startOfYear = date.newInstance(Integer.valueof(strSelectedYear), 1, 1);
    if (strSelectedQuarter == '1') {
      QstartDate = startOfYear;
    } else if (strSelectedQuarter == '2') {
      QstartDate = startOfYear.addMonths(3);
    } else if (strSelectedQuarter == '3') {
      QstartDate = startOfYear.addMonths(6);
    } else if (strSelectedQuarter == '4') {
      QstartDate = startOfYear.addMonths(9);
    }
    QendDate = QstartDate.addMonths(3) - 1;

    if (strSelectedMyOrMyTeamData == '1') {
      UserIds = new Set<Id>();
      userIds.add(strSelectedRep);
    } else if (strSelectedMyOrMyTeamData == '2') {
      fnBindMyOrMyTeamData();
    }

    Integer curMonth = Date.Today().Month();

    AggregateResult[] groupedOpenQuaterlyDeals = [
      SELECT
        RecordType.Name recordtypename,
        SUM(Hardware_Revenue_Dollars__c) eqipRevenue,
        SUM(TSGADX__Price__c) price,
        Sum(TSGADX__MPS_Revenue__c) mpsrevenue
      FROM TSGADX__Deal__c
      WHERE
        RecordType.Name IN (
          'Propect Deal',
          'Production Deals',
          'IT Services',
          'Equipment Deals',
          'MPS Deals'
        )
        AND (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c >= :QstartDate
        AND TSGADX__Close_Date__c <= :QendDate
      GROUP BY RecordType.Name
    ];

    AggregateResult[] groupedWonQuaterlyDeals = [
      SELECT
        RecordType.Name recordtypename,
        SUM(Hardware_Revenue_Dollars__c) eqipRevenue,
        SUM(TSGADX__Price__c) price,
        Sum(TSGADX__MPS_Revenue__c) mpsrevenue
      FROM TSGADX__Deal__c
      WHERE
        RecordType.Name IN (
          'Propect Deal',
          'Production Deals',
          'IT Services',
          'Equipment Deals',
          'MPS Deals'
        )
        AND (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Won__c = true
        AND TSGADX__Close_Date__c >= :QstartDate
        AND TSGADX__Close_Date__c <= :QendDate
      GROUP BY RecordType.Name
    ];

    AggregateResult[] groupedOpenDeals = [
      SELECT
        RecordType.Name recordtypename,
        SUM(Hardware_Revenue_Dollars__c) eqipRevenue,
        SUM(TSGADX__Price__c) price,
        Sum(TSGADX__MPS_Revenue__c) mpsrevenue
      FROM TSGADX__Deal__c
      WHERE
        RecordType.Name IN (
          'Propect Deal',
          'Production Deals',
          'IT Services',
          'Equipment Deals',
          'MPS Deals'
        )
        AND (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
      GROUP BY RecordType.Name
    ];

    AggregateResult[] groupedWonDeals = [
      SELECT
        RecordType.Name recordtypename,
        SUM(Hardware_Revenue_Dollars__c) eqipRevenue,
        SUM(TSGADX__Price__c) price,
        Sum(TSGADX__MPS_Revenue__c) mpsrevenue
      FROM TSGADX__Deal__c
      WHERE
        RecordType.Name IN (
          'Propect Deal',
          'Production Deals',
          'IT Services',
          'Equipment Deals',
          'MPS Deals'
        )
        AND (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Won__c = true
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
      GROUP BY RecordType.Name
    ];

    map<string, Decimal> mapOfPricesforOpenDeal = new Map<string, decimal>();
    map<string, Decimal> mapOfPricesforWonDeal = new Map<string, decimal>();
    map<string, Decimal> mapOfPricesforQuaterlyOpenDeal = new Map<string, decimal>();
    map<string, Decimal> mapOfPricesforQuaterlyWonDeal = new Map<string, decimal>();
    for (AggregateResult ar : groupedOpenDeals) {
      if (
        ar != null &&
        ar.get('recordtypename') != null &&
        (ar.get('price') != null ||
        ar.get('mpsrevenue') != null)
      ) {
        string recordTypeName = string.valueof(ar.get('recordtypename'));
        Decimal decAmount = 0, decmpsrevenue = 0, deceqipRevenue = 0;
        if (
          ar.get('price') != null &&
          !string.isblank(string.valueof(ar.get('price')))
        ) {
          decAmount = Decimal.valueof(string.valueof(ar.get('price')));
        }
        if (
          ar.get('mpsrevenue') != null &&
          !string.isblank(string.valueof(ar.get('mpsrevenue')))
        ) {
          decmpsrevenue = Decimal.valueof(string.valueof(ar.get('mpsrevenue')));
        }
        if (
          ar.get('eqipRevenue') != null &&
          !string.isblank(string.valueof(ar.get('eqipRevenue')))
        ) {
          deceqipRevenue = Decimal.valueof(
            string.valueof(ar.get('eqipRevenue'))
          );
        }
        if (recordTypeName == 'MPS Deals') {
          //system.debug('objWSR :::: '+Decimal.valueof(string.valueof(ar.get('mpsrevenue'))));
          mapOfPricesforOpenDeal.put(recordTypeName, decmpsrevenue);
        } else {
          if (recordTypeName == 'Equipment Deals') {
            mapOfPricesforOpenDeal.put(recordTypeName, deceqipRevenue);
          } else {
            mapOfPricesforOpenDeal.put(recordTypeName, decAmount);
          }
        }
      }
    }

    for (AggregateResult ar : groupedWonDeals) {
      if (
        ar != null &&
        ar.get('recordtypename') != null &&
        (ar.get('price') != null ||
        ar.get('mpsrevenue') != null)
      ) {
        string recordTypeName = string.valueof(ar.get('recordtypename'));
        Decimal decAmount = 0, decmpsrevenue = 0, deceqipRevenue = 0;
        if (
          ar.get('price') != null &&
          !string.isblank(string.valueof(ar.get('price')))
        ) {
          decAmount = Decimal.valueof(string.valueof(ar.get('price')));
        }
        if (
          ar.get('mpsrevenue') != null &&
          !string.isblank(string.valueof(ar.get('mpsrevenue')))
        ) {
          decmpsrevenue = Decimal.valueof(string.valueof(ar.get('mpsrevenue')));
        }
        if (
          ar.get('eqipRevenue') != null &&
          !string.isblank(string.valueof(ar.get('eqipRevenue')))
        ) {
          deceqipRevenue = Decimal.valueof(
            string.valueof(ar.get('eqipRevenue'))
          );
        }
        if (recordTypeName == 'MPS Deals') {
          mapOfPricesforWonDeal.put(recordTypeName, decmpsrevenue);
        } else {
          if (recordTypeName == 'Equipment Deals') {
            mapOfPricesforWonDeal.put(recordTypeName, deceqipRevenue);
          } else {
            mapOfPricesforWonDeal.put(recordTypeName, decAmount);
          }
        }
      }
    }

    for (AggregateResult ar : groupedOpenQuaterlyDeals) {
      if (
        ar != null &&
        ar.get('recordtypename') != null &&
        (ar.get('price') != null ||
        ar.get('mpsrevenue') != null)
      ) {
        string recordTypeName = string.valueof(ar.get('recordtypename'));
        Decimal decAmount = 0, decmpsrevenue = 0, deceqipRevenue = 0;
        if (
          ar.get('price') != null &&
          !string.isblank(string.valueof(ar.get('price')))
        ) {
          decAmount = Decimal.valueof(string.valueof(ar.get('price')));
        }
        if (
          ar.get('mpsrevenue') != null &&
          !string.isblank(string.valueof(ar.get('mpsrevenue')))
        ) {
          decmpsrevenue = Decimal.valueof(string.valueof(ar.get('mpsrevenue')));
        }
        if (
          ar.get('eqipRevenue') != null &&
          !string.isblank(string.valueof(ar.get('eqipRevenue')))
        ) {
          deceqipRevenue = Decimal.valueof(
            string.valueof(ar.get('eqipRevenue'))
          );
        }

        if (recordTypeName == 'MPS Deals') {
          //system.debug('objWSR :::: '+Decimal.valueof(string.valueof(ar.get('mpsrevenue'))));
          mapOfPricesforQuaterlyOpenDeal.put(recordTypeName, decmpsrevenue);
        } else {
          if (recordTypeName == 'Equipment Deals') {
            mapOfPricesforQuaterlyOpenDeal.put(recordTypeName, deceqipRevenue);
          } else {
            mapOfPricesforQuaterlyOpenDeal.put(recordTypeName, decAmount);
          }
        }
      }
    }

    for (AggregateResult ar : groupedWonQuaterlyDeals) {
      if (
        ar != null &&
        ar.get('recordtypename') != null &&
        (ar.get('price') != null ||
        ar.get('mpsrevenue') != null)
      ) {
        string recordTypeName = string.valueof(ar.get('recordtypename'));
        Decimal decAmount = 0, decmpsrevenue = 0, deceqipRevenue = 0;
        if (
          ar.get('price') != null &&
          !string.isblank(string.valueof(ar.get('price')))
        ) {
          decAmount = Decimal.valueof(string.valueof(ar.get('price')));
        }
        if (
          ar.get('mpsrevenue') != null &&
          !string.isblank(string.valueof(ar.get('mpsrevenue')))
        ) {
          decmpsrevenue = Decimal.valueof(string.valueof(ar.get('mpsrevenue')));
        }
        if (
          ar.get('eqipRevenue') != null &&
          !string.isblank(string.valueof(ar.get('eqipRevenue')))
        ) {
          deceqipRevenue = Decimal.valueof(
            string.valueof(ar.get('eqipRevenue'))
          );
        }

        if (recordTypeName == 'MPS Deals') {
          mapOfPricesforQuaterlyWonDeal.put(recordTypeName, decmpsrevenue);
        } else {
          if (recordTypeName == 'Equipment Deals') {
            mapOfPricesforQuaterlyWonDeal.put(recordTypeName, deceqipRevenue);
          } else {
            mapOfPricesforQuaterlyWonDeal.put(recordTypeName, decAmount);
          }
        }
      }
    }

    List<Sales_Quota__c> lstSalesQuota = new List<Sales_Quota__c>(
      [
        SELECT
          Id,
          Name,
          Production__c,
          IT_Services__c,
          Equipment__c,
          MPS__c,
          BEQI__c,
          Market_Share__c,
          EDA_Opportunity__c,
          FM_Audit_Hdwr__c,
          FM_Audit_Svc__c,
          FM_Audit_Printer__c,
          ACTION_PLAN_Q1__c,
          TRAINING_NEEDS_Q1__c,
          ASSISTANCE_NEEDED_Q1__c,
          ACTION_PLAN_Q2__c,
          TRAINING_NEEDS_Q2__c,
          ASSISTANCE_NEEDED_Q2__c,
          ACTION_PLAN_Q3__c,
          TRAINING_NEEDS_Q3__c,
          ASSISTANCE_NEEDED_Q3__c,
          ACTION_PLAN_Q4__c,
          TRAINING_NEEDS_Q4__c,
          ASSISTANCE_NEEDED_Q4__c
        FROM Sales_Quota__c
        WHERE Rep_Name__c = :strSelectedRep AND Year__c = :strSelectedYear
        ORDER BY LastModifiedDate
        LIMIT 1
      ]
    );

    Sales_Quota__c objSQ = new Sales_Quota__c();

    if (lstSalesQuota.size() > 0) {
      List<UserRecordAccess> lstUserRecordAccess = new List<UserRecordAccess>(
        [
          SELECT RecordId, HasReadAccess, HasEditAccess
          FROM UserRecordAccess
          WHERE
            UserId = :UserInfo.getUserId()
            AND RecordId = :lstSalesQuota[0].Id
        ]
      );
      if (
        lstUserRecordAccess.size() > 0 && lstUserRecordAccess[0].HasEditAccess
      ) {
        //system.debug('Has access');
        objSQ = lstSalesQuota[0];
        objSalesQuote = objSQ;
      } else {
        ApexPages.Message myMsg = new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'You don\'t have access to see the Sales Quota of this user.'
        );
        ApexPages.addMessage(myMsg);
        return;
      }
    } else {
      boolean canCreate = Schema.sObjectType.Sales_Quota__c.isCreateable();

      if (canCreate) {
        objSalesQuote.Rep_Name__c = strSelectedRep;
        objSalesQuote.name = strSelectedRep + strSelectedYear;
        objSalesQuote.Year__c = strSelectedYear;
      } else {
        ApexPages.Message myMsg = new ApexPages.Message(
          ApexPages.Severity.ERROR,
          'You don\'t have access to create a new Sales Quota record.'
        );
        ApexPages.addMessage(myMsg);
        return;
      }
    }

    //prospect deal
    /*if(objSQ.Prospect__c != null){
                    WrapperSalesReport objWSR = new WrapperSalesReport();
                    objWSR.dealtype = 'Prospect';
                    objWSR.annualQuotas = objSQ.Prospect__c;
                    objWSR.quartlyQuotas = objSQ.Prospect__c/4;
                    if(mapOfPricesforQuaterlyOpenDeal.containskey('Propect Deal')){
                        objWSR.quartlySales = mapOfPricesforQuaterlyOpenDeal.get('Propect Deal');
                        objWSR.quartlySalesPercent = objWSR.quartlySales*100/objWSR.quartlyQuotas;
                        objWSR.quartlySalesPercent = objWSR.quartlySalesPercent.setScale(0);
                    }
                    if(mapOfPricesforQuaterlyWonDeal.containskey('Propect Deal')){
                        objWSR.quartlyWon = mapOfPricesforQuaterlyWonDeal.get('Propect Deal');
                        objWSR.quartlyWonPercent = objWSR.quartlyWon*100/objWSR.quartlyQuotas;
                        objWSR.quartlyWonPercent = objWSR.quartlyWonPercent.setScale(0);
                    }
                    if(mapOfPricesforOpenDeal.containskey('Propect Deal')){
                        objWSR.ytdSales = mapOfPricesforOpenDeal.get('Propect Deal');
                        objWSR.ytdSalesPercent = objWSR.ytdSales*100/objWSR.annualQuotas;
                        objWSR.ytdSalesPercent = objWSR.ytdSalesPercent.setScale(0);
                    }
                    if(mapOfPricesforWonDeal.containskey('Propect Deal')){
                        objWSR.ytdWon = mapOfPricesforWonDeal.get('Propect Deal');
                        objWSR.ytdWonPercent = objWSR.ytdWon*100/objWSR.annualQuotas;
                        objWSR.ytdWonPercent = objWSR.ytdWonPercent.setScale(0);
                    }
                    lstWrapperSalesReport.add(objWSR);
                } else {
                    WrapperSalesReport objWSR = new WrapperSalesReport();
                    objWSR.dealtype = 'Prospect';
                    lstWrapperSalesReport.add(objWSR);
                }*/

    //production deal
    if (objSQ.Production__c != null) {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'Production';
      objWSR.annualQuotas = objSQ.Production__c.setScale(0).format();

      objWSR.annualProrated = (objSQ.Production__c *
        curMonth /
        12)
        .setScale(0)
        .format();

      objWSR.quartlyQuotas = (objSQ.Production__c / 4).setScale(0).format();
      if (
        mapOfPricesforQuaterlyOpenDeal.containskey('Production Deals') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlySales = mapOfPricesforQuaterlyOpenDeal.get(
            'Production Deals'
          )
          .setScale(0)
          .format();
        objWSR.quartlySalesPercent =
          Integer.valueof(objWSR.quartlySales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlySalesPercent = objWSR.quartlySalesPercent.setScale(0);
      }
      if (
        mapOfPricesforQuaterlyWonDeal.containskey('Production Deals') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlyWon = mapOfPricesforQuaterlyWonDeal.get(
            'Production Deals'
          )
          .setScale(0)
          .format();
        objWSR.quartlyWonPercent =
          Integer.valueof(objWSR.quartlyWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlyWonPercent = objWSR.quartlyWonPercent.setScale(0);
      }
      if (
        mapOfPricesforOpenDeal.containskey('Production Deals') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdSales = mapOfPricesforOpenDeal.get('Production Deals')
          .setScale(0)
          .format();
        objWSR.ytdSalesPercent =
          Integer.valueof(objWSR.ytdSales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualQuotas.replace(',', ''));
        objWSR.ytdSalesPercent = objWSR.ytdSalesPercent.setScale(0);
      }
      if (
        mapOfPricesforWonDeal.containskey('Production Deals') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdWon = mapOfPricesforWonDeal.get('Production Deals')
          .setScale(0)
          .format();
        objWSR.ytdWonPercent =
          Integer.valueof(objWSR.ytdWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualProrated.replace(',', ''));
        objWSR.ytdWonPercent = objWSR.ytdWonPercent.setScale(0);
      }
      lstWrapperSalesReport.add(objWSR);
    } else {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'Production';
      lstWrapperSalesReport.add(objWSR);
    }
    //it serivces deal
    if (objSQ.IT_Services__c != null) {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'Software';
      objWSR.annualQuotas = objSQ.IT_Services__c.setScale(0).format();

      objWSR.annualProrated = (objSQ.IT_Services__c *
        curMonth /
        12)
        .setScale(0)
        .format();

      objWSR.quartlyQuotas = (objSQ.IT_Services__c / 4).setScale(0).format();
      if (
        mapOfPricesforQuaterlyOpenDeal.containskey('IT Services') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlySales = mapOfPricesforQuaterlyOpenDeal.get('IT Services')
          .setScale(0)
          .format();
        objWSR.quartlySalesPercent =
          Integer.valueof(objWSR.quartlySales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlySalesPercent = objWSR.quartlySalesPercent.setScale(0);
      }
      if (
        mapOfPricesforQuaterlyWonDeal.containskey('IT Services') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlyWon = mapOfPricesforQuaterlyWonDeal.get('IT Services')
          .setScale(0)
          .format();
        objWSR.quartlyWonPercent =
          Integer.valueof(objWSR.quartlyWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlyWonPercent = objWSR.quartlyWonPercent.setScale(0);
      }
      if (
        mapOfPricesforOpenDeal.containskey('IT Services') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdSales = mapOfPricesforOpenDeal.get('IT Services')
          .setScale(0)
          .format();
        objWSR.ytdSalesPercent =
          Integer.valueof(objWSR.ytdSales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualQuotas.replace(',', ''));
        objWSR.ytdSalesPercent = objWSR.ytdSalesPercent.setScale(0);
      }
      if (
        mapOfPricesforWonDeal.containskey('IT Services') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdWon = mapOfPricesforWonDeal.get('IT Services')
          .setScale(0)
          .format();
        objWSR.ytdWonPercent =
          Integer.valueof(objWSR.ytdWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualProrated.replace(',', ''));
        objWSR.ytdWonPercent = objWSR.ytdWonPercent.setScale(0);
      }
      lstWrapperSalesReport.add(objWSR);
    } else {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'Software';
      lstWrapperSalesReport.add(objWSR);
    }

    //equipments deal
    if (objSQ.Equipment__c != null) {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'Equipment';
      objWSR.annualQuotas = objSQ.Equipment__c.setScale(0).format();

      objWSR.annualProrated = (objSQ.Equipment__c *
        curMonth /
        12)
        .setScale(0)
        .format();

      objWSR.quartlyQuotas = (objSQ.Equipment__c / 4).setScale(0).format();
      if (
        mapOfPricesforQuaterlyOpenDeal.containskey('Equipment Deals') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlySales = mapOfPricesforQuaterlyOpenDeal.get(
            'Equipment Deals'
          )
          .setScale(0)
          .format();
        objWSR.quartlySalesPercent =
          Integer.valueof(objWSR.quartlySales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlySalesPercent = objWSR.quartlySalesPercent.setScale(0);
      }
      if (
        mapOfPricesforQuaterlyWonDeal.containskey('Equipment Deals') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlyWon = mapOfPricesforQuaterlyWonDeal.get('Equipment Deals')
          .setScale(0)
          .format();
        objWSR.quartlyWonPercent =
          Integer.valueof(objWSR.quartlyWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlyWonPercent = objWSR.quartlyWonPercent.setScale(0);
      }
      if (
        mapOfPricesforOpenDeal.containskey('Equipment Deals') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdSales = mapOfPricesforOpenDeal.get('Equipment Deals')
          .setScale(0)
          .format();
        objWSR.ytdSalesPercent =
          Integer.valueof(objWSR.ytdSales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualQuotas.replace(',', ''));
        objWSR.ytdSalesPercent = objWSR.ytdSalesPercent.setScale(0);
      }
      if (
        mapOfPricesforWonDeal.containskey('Equipment Deals') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdWon = mapOfPricesforWonDeal.get('Equipment Deals')
          .setScale(0)
          .format();
        objWSR.ytdWonPercent =
          Integer.valueof(objWSR.ytdWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualProrated.replace(',', ''));
        objWSR.ytdWonPercent = objWSR.ytdWonPercent.setScale(0);
      }
      lstWrapperSalesReport.add(objWSR);
    } else {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'Equipment';
      lstWrapperSalesReport.add(objWSR);
    }

    //mps deal
    if (objSQ.MPS__c != null) {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'MPS';
      objWSR.annualQuotas = objSQ.MPS__c.setScale(0).format();

      objWSR.annualProrated = (objSQ.MPS__c *
        curMonth /
        12)
        .setScale(0)
        .format();

      objWSR.quartlyQuotas = (objSQ.MPS__c / 4).setScale(0).format();
      if (
        mapOfPricesforQuaterlyOpenDeal.containskey('MPS Deals') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlySales = mapOfPricesforQuaterlyOpenDeal.get('MPS Deals')
          .setScale(0)
          .format();
        objWSR.quartlySalesPercent =
          Integer.valueof(objWSR.quartlySales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlySalesPercent = objWSR.quartlySalesPercent.setScale(0);
      }
      if (
        mapOfPricesforQuaterlyWonDeal.containskey('MPS Deals') &&
        Integer.valueof(objWSR.quartlyQuotas.replace(',', '')) != 0
      ) {
        objWSR.quartlyWon = mapOfPricesforQuaterlyWonDeal.get('MPS Deals')
          .setScale(0)
          .format();
        objWSR.quartlyWonPercent =
          Integer.valueof(objWSR.quartlyWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.quartlyQuotas.replace(',', ''));
        objWSR.quartlyWonPercent = objWSR.quartlyWonPercent.setScale(0);
      }
      if (
        mapOfPricesforOpenDeal.containskey('MPS Deals') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdSales = mapOfPricesforOpenDeal.get('MPS Deals')
          .setScale(0)
          .format();
        objWSR.ytdSalesPercent =
          Integer.valueof(objWSR.ytdSales.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualQuotas.replace(',', ''));
        objWSR.ytdSalesPercent = objWSR.ytdSalesPercent.setScale(0);
      }
      if (
        mapOfPricesforWonDeal.containskey('MPS Deals') &&
        Integer.valueof(objWSR.annualQuotas.replace(',', '')) != 0
      ) {
        objWSR.ytdWon = mapOfPricesforWonDeal.get('MPS Deals')
          .setScale(0)
          .format();
        objWSR.ytdWonPercent =
          Integer.valueof(objWSR.ytdWon.replace(',', '')) *
          100 /
          Integer.valueof(objWSR.annualProrated.replace(',', ''));
        objWSR.ytdWonPercent = objWSR.ytdWonPercent.setScale(0);
      }
      system.debug('objWSR :::: ' + objWSR);
      lstWrapperSalesReport.add(objWSR);
    } else {
      WrapperSalesReport objWSR = new WrapperSalesReport();
      objWSR.dealtype = 'MPS';
      lstWrapperSalesReport.add(objWSR);
    }

    //sum of all types of deal - Annual Prorated Quota
    WrapperSalesReport objAProrated = new WrapperSalesReport();

    //sum of all types of deal - Dollar Volume
    WrapperSalesReport objWDVolumne = new WrapperSalesReport();
    objWDVolumne.dealType = 'Dollar Volume';
    Integer aQuota = 0;
    Integer QQuota = 0;
    Integer QSales = 0;
    Integer QWon = 0;
    Integer YSales = 0;
    Integer YWon = 0;
    for (WrapperSalesReport objWS : lstWrapperSalesReport) {
      if (objWS.dealtype != 'MPS') {
        if (Integer.valueof(objWS.annualQuotas.replace(',', '')) != null) {
          aQuota += Integer.valueof(objWS.annualQuotas.replace(',', ''));
        }
        if (Integer.valueof(objWS.quartlyQuotas.replace(',', '')) != null) {
          QQuota += Integer.valueof(objWS.quartlyQuotas.replace(',', ''));
        }
        if (Integer.valueof(objWS.quartlySales.replace(',', '')) != null) {
          QSales += Integer.valueof(objWS.quartlySales.replace(',', ''));
        }
        if (Integer.valueof(objWS.quartlyWon.replace(',', '')) != null) {
          QWon += Integer.valueof(objWS.quartlyWon.replace(',', ''));
        }
        if (Integer.valueof(objWS.ytdSales.replace(',', '')) != null) {
          YSales += Integer.valueof(objWS.ytdSales.replace(',', ''));
        }
        if (Integer.valueof(objWS.ytdWon.replace(',', '')) != null) {
          YWon += Integer.valueof(objWS.ytdWon.replace(',', ''));
        }
      }
    }
    objWDVolumne.annualQuotas = aQuota.format();

    objWDVolumne.annualProrated = (aQuota * curMonth / 12).format();

    objWDVolumne.quartlyQuotas = QQuota.format();
    objWDVolumne.quartlySales = QSales.format();
    objWDVolumne.quartlyWon = QWon.format();
    objWDVolumne.ytdSales = YSales.format();
    objWDVolumne.ytdWon = YWon.format();

    objAProrated.dealType = 'Annual Prorated Quota';
    objAProrated.annualQuotas = (aQuota * curMonth / 12).format();

    objAProrated.annualProrated = (aQuota *
      curMonth /
      12 *
      curMonth /
      12)
      .format();

    objAProrated.ytdWon = YWon.format();

    if (QQuota != 0) {
      objWDVolumne.quartlySalesPercent = QSales * 100 / QQuota;
      objWDVolumne.quartlySalesPercent = objWDVolumne.quartlySalesPercent.setScale(
        0
      );

      objWDVolumne.quartlyWonPercent = QWon * 100 / QQuota;
      objWDVolumne.quartlyWonPercent = objWDVolumne.quartlyWonPercent.setScale(
        0
      );
    }

    if (aQuota != 0) {
      objWDVolumne.ytdSalesPercent = YSales * 100 / aQuota;
      objWDVolumne.ytdSalesPercent = objWDVolumne.ytdSalesPercent.setScale(0);

      objWDVolumne.ytdWonPercent = YWon * 100 / (aQuota * curMonth / 12);
      objWDVolumne.ytdWonPercent = objWDVolumne.ytdWonPercent.setScale(0);

      objAProrated.ytdWonPercent = YWon * 100 / (aQuota * curMonth / 12);
      objAProrated.ytdWonPercent = objAProrated.ytdWonPercent.setScale(0);
    }
    lstWrapperSalesReport.add(objWDVolumne);

    lstWrapperSalesReport.add(objAProrated);

    //} else {
    //    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You don\'t have access for this user.');
    //    ApexPages.addMessage(myMsg);
    //    return;
    //}
    //} //else {
    //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Sales Quota not found for this user.');
    //ApexPages.addMessage(myMsg);
    //return;
    //objSalesQuote.Rep_Name__c = strSelectedRep ;
    //objSalesQuote.name = strSelectedRep + strSelectedYear;
    //objSalesQuote.Year__c = strSelectedYear;

    // }

    intgapCloseOpenRev = 0;
    intzboOpenRev = 0;
    intprodOpenRev = 0;
    intitServOpenRev = 0;
    inteqipOpenRev = 0;
    intmpsOpenRev = 0;

    gapCloseOpenRev = '';
    zboOpenRev = '';
    prodOpenRev = '';
    itServOpenRev = '';
    eqipOpenRev = '';
    mpsOpenRev = '';

    //top 10 closers
    lstResultTop10Closers = new List<WrapperTopResults>();
    map<Integer, string> mapMonths = new Map<Integer, string>{
      1 => 'January',
      2 => 'February',
      3 => 'March',
      4 => 'April',
      5 => 'May',
      6 => 'June',
      7 => 'July',
      8 => 'August',
      9 => 'September',
      10 => 'October',
      11 => 'November',
      12 => 'December'
    };
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10Closers.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );

      if (deal.TSGADX__Total_Dollars__c != null) {
        intgapCloseOpenRev =
          intgapCloseOpenRev + integer.valueof(deal.TSGADX__Total_Dollars__c);
      }
    }
    gapCloseOpenRev = intgapCloseOpenRev.format();

    //ZBO Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    zboSummary = getSummary(
      [
        SELECT Count(Id) totalDeals, TSGADX__Sales_Stage__c
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
            strSelectedYear
          )
          AND TSGADX__Type__c IN ('New Placement', 'ZBO')
        GROUP BY TSGADX__Sales_Stage__c
      ]
    );

    //production Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    productionSummary = getSummary(
      [
        SELECT Count(Id) totalDeals, TSGADX__Sales_Stage__c
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
            strSelectedYear
          )
          AND RecordType.DeveloperName = 'Production_Deals'
        GROUP BY TSGADX__Sales_Stage__c
      ]
    );

    //IT Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    itServicesSummary = getSummary(
      [
        SELECT Count(Id) totalDeals, TSGADX__Sales_Stage__c
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
            strSelectedYear
          )
          AND RecordType.DeveloperName = 'IT_Services'
        GROUP BY TSGADX__Sales_Stage__c
      ]
    );

    //Equipment Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    equipmentSummary = getSummary(
      [
        SELECT Count(Id) totalDeals, TSGADX__Sales_Stage__c
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
            strSelectedYear
          )
          AND RecordType.DeveloperName = 'Equipment_Deals'
        GROUP BY TSGADX__Sales_Stage__c
      ]
    );

    //MPS Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    mpsSummary = getSummary(
      [
        SELECT Count(Id) totalDeals, TSGADX__Sales_Stage__c
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
            strSelectedYear
          )
          AND RecordType.DeveloperName = 'MPS_Deals'
        GROUP BY TSGADX__Sales_Stage__c
      ]
    );

    //monthly Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    //Integer curMonth = Date.Today().Month();
    List<AggregateResult> lstsummmodelAvgRepZbo = new List<AggregateResult>(
      [
        SELECT
          Count(Id) totalDeals,
          TSGADX__Sales_Stage__c,
          TSGADX__Type__c type
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          //AND CALENDAR_MONTH(TSGADX__Close_Date__c) <= :curMonth AND
          //CALENDAR_YEAR(TSGADX__Close_Date__c) =: Integer.valueof(strSelectedYear)
          AND TSGADX__Close_Date__c >= :Date.today()
            .addmonths(-11)
            .toStartOfMonth()
          AND TSGADX__Close_Date__c <= :(Date.today()
              .addmonths(1)
              .toStartOfMonth())
            .adddays(-1)
        GROUP BY TSGADX__Sales_Stage__c, TSGADX__Type__c
      ]
    );
    monthlySummaryRep = getAvgSummaryRepZbo(lstsummmodelAvgRepZbo, false);
    monthlySummaryZbo = getAvgSummaryRepZbo(lstsummmodelAvgRepZbo, true);

    //Current Deals
    //Calculation Ratio Win/Loss, Agreegating Total Win Lost and Lost to Competition
    List<AggregateResult> lstsummmodelRepZbo = new List<AggregateResult>(
      [
        SELECT
          Count(Id) totalDeals,
          TSGADX__Sales_Stage__c,
          TSGADX__Type__c type
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          //AND CALENDAR_MONTH(TSGADX__Close_Date__c) <= :curMonth AND
          //CALENDAR_YEAR(TSGADX__Close_Date__c) =: Integer.valueof(strSelectedYear)
          AND TSGADX__Close_Date__c >= :Date.today()
            .addmonths(-11)
            .toStartOfMonth()
          AND TSGADX__Close_Date__c <= :(Date.today()
              .addmonths(1)
              .toStartOfMonth())
            .adddays(-1)
        GROUP BY TSGADX__Sales_Stage__c, TSGADX__Type__c
      ]
    );
    currentSummaryRep = getSummaryRepZbo(lstsummmodelRepZbo, false);
    currentSummaryZbo = getSummaryRepZbo(lstsummmodelRepZbo, true);
    //monthlySummaryRep = getAvgSummaryRepZbo(lstsummmodelRepZbo,false);
    //monthlySummaryZbo = getAvgSummaryRepZbo(lstsummmodelRepZbo,true);

    //Rep Forcast
    Sales_Team_Setting__c salesTeamcustomsetting = Sales_Team_Setting__c.getOrgDefaults();
    List<string> lstForecastCategory = new List<string>();
    if (
      salesTeamcustomsetting != null &&
      salesTeamcustomsetting.Forecast_Category__c != null
    ) {
      lstForecastCategory = salesTeamcustomsetting.Forecast_Category__c.split(
        ','
      );
    }

    intResultRepForcast = 0;
    inttotalRevenueRepForcast = 0;
    lstResultRepForcast = new List<WrapperforcastResults>();
    for (
      TSGADX__Deal__c deal : [
        SELECT
          Id,
          Name,
          TSGADX__Sales_Team__c,
          RecordType.DeveloperName,
          TSGADX__Type__c,
          TSGADX__Total_Dollars__c,
          TSGADX__Agedays__c,
          TSGADX__Deal_Activity_Monitor__c,
          TSGADX__Sales_Stage__c,
          TSGADX__Close_Date__c,
          Next_Steps__c,
          RecordType.Name,
          Hardware_Revenue_Dollars__c,
          Owner.Name,
          TSGADX__Price__c,
          Deal_Activity_Monitor_Color__c,
          TSGADX__Forecast_Category__c,
          (
            SELECT Id
            FROM Events
            WHERE type = '*RT Proposal Presentation/Demo - 15'
          ),
          (
            SELECT Id
            FROM Tasks
            WHERE type = '*RT Proposal Presentation/Demo - 15'
          )
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Close_Date__c != null
          //TSGADX__Sales_Stage__c not in ('Lost' , 'Lost to Competition') AND //, 'Won'
          AND (TSGADX__Sales_Stage__c IN ('Won')
          OR TSGADX__Forecast_Category__c IN :lstForecastCategory)
          AND TSGADX__Close_Date__c = THIS_Month
        //TSGADX__Close_Date__c >=: QstartDate and TSGADX__Close_Date__c <=: QendDate
        //TSGADX__Close_Date__c <=: ((Date.today().AddMonths(3).toStartOfMonth()).addMonths(1)).AddDays(-1))
        //TSGADX__Close_Date__c <=: (Date.today().AddMonths(3).toStartOfMonth()).AddDays(-1))
        ORDER BY
          Deal_Activity_Monitor_Color_Order__c ASC,
          TSGADX__Total_Dollars__c DESC
        LIMIT 999
      ]
    ) {
      //if(deal.TSGADX__Forecast_Category__c == 'Probable' || deal.TSGADX__Sales_Stage__c == 'Won' ){
      WrapperforcastResults wrpobj;
      if (deal.TSGADX__Type__c.tolowercase() == 'replacement') {
        wrpobj = new WrapperforcastResults(deal, currentSummaryRep);
      } else {
        wrpobj = new WrapperforcastResults(deal, currentSummaryZbo);
      }
      lstResultRepForcast.add(wrpobj);

      if (wrpobj.automatedForcastrev != null) {
        intResultRepForcast =
          intResultRepForcast + integer.valueof(wrpobj.automatedForcastrev);
      }

      if (wrpobj.totalRevenue != null) {
        inttotalRevenueRepForcast =
          inttotalRevenueRepForcast + integer.valueof(wrpobj.totalRevenue);
      }
      //}
    }
    if (lstResultRepForcast.size() > 0) {
      WrapperforcastResults wrpobj;
      wrpobj = new WrapperforcastResults();
      wrpobj.OwnerName = 'Total';
      wrpobj.automatedForcastPercent = intResultRepForcast.format();
      wrpobj.revenue = inttotalRevenueRepForcast.format();
      lstResultRepForcast.add(wrpobj);
    }

    //Manager Forcast
    intResultManagerForcast = 0;
    inttotalRevenueManagerForcast = 0;
    lstResultManagerForcast = new List<WrapperforcastResults>();
    for (
      TSGADX__Deal__c deal : [
        SELECT
          Id,
          Name,
          TSGADX__Sales_Team__c,
          RecordType.DeveloperName,
          TSGADX__Type__c,
          TSGADX__Total_Dollars__c,
          TSGADX__Agedays__c,
          TSGADX__Deal_Activity_Monitor__c,
          TSGADX__Sales_Stage__c,
          TSGADX__Close_Date__c,
          Next_Steps__c,
          RecordType.Name,
          Hardware_Revenue_Dollars__c,
          Owner.Name,
          TSGADX__Price__c,
          Deal_Activity_Monitor_Color__c,
          (
            SELECT Id
            FROM Events
            WHERE type = '*RT Proposal Presentation/Demo - 15'
          ),
          (
            SELECT Id
            FROM Tasks
            WHERE type = '*RT Proposal Presentation/Demo - 15'
          )
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Close_Date__c != null
          //TSGADX__Sales_Stage__c not in ('Lost' , 'Lost to Competition') AND //, 'Won'
          AND (TSGADX__Sales_Stage__c IN ('Won')
          OR TSGADX__Forecast_Category__c IN :lstForecastCategory)
          AND TSGADX__Close_Date__c = THIS_Month
          //TSGADX__Close_Date__c >=: QstartDate and TSGADX__Close_Date__c <=: QendDate
          //TSGADX__Close_Date__c <=: (Date.today().toStartOfMonth().AddMonths(3)).AddDays(-1))
          //TSGADX__Close_Date__c <=: ((Date.today().AddMonths(3).toStartOfMonth()).addMonths(1)).AddDays(-1))
          AND Manager_Forecast__c = true
        ORDER BY
          Deal_Activity_Monitor_Color_Order__c,
          TSGADX__Total_Dollars__c DESC
      ]
    ) {
      WrapperforcastResults wrpobj;
      if (deal.TSGADX__Type__c.tolowercase() == 'replacement') {
        wrpobj = new WrapperforcastResults(deal, currentSummaryRep);
      } else {
        wrpobj = new WrapperforcastResults(deal, currentSummaryZbo);
      }
      lstResultManagerForcast.add(wrpobj);

      if (wrpobj.automatedForcastrev != null) {
        intResultManagerForcast =
          intResultManagerForcast + integer.valueof(wrpobj.automatedForcastrev);
      }

      if (wrpobj.totalRevenue != null) {
        inttotalRevenueManagerForcast =
          inttotalRevenueManagerForcast + integer.valueof(wrpobj.totalRevenue);
      }
    }
    if (lstResultManagerForcast.size() > 0) {
      WrapperforcastResults wrpobj;
      wrpobj = new WrapperforcastResults();
      wrpobj.OwnerName = 'Total';
      wrpobj.automatedForcastPercent = intResultManagerForcast.format();
      wrpobj.revenue = inttotalRevenueManagerForcast.format();
      lstResultManagerForcast.add(wrpobj);
    }

    //VP Forcast
    intResultVPForcast = 0;
    inttotalRevenueVPForcast = 0;
    lstResultVPForcast = new List<WrapperforcastResults>();
    for (
      TSGADX__Deal__c deal : [
        SELECT
          Id,
          Name,
          TSGADX__Sales_Team__c,
          RecordType.DeveloperName,
          TSGADX__Type__c,
          TSGADX__Total_Dollars__c,
          TSGADX__Agedays__c,
          TSGADX__Deal_Activity_Monitor__c,
          TSGADX__Sales_Stage__c,
          TSGADX__Close_Date__c,
          Next_Steps__c,
          RecordType.Name,
          Hardware_Revenue_Dollars__c,
          Owner.Name,
          TSGADX__Price__c,
          Deal_Activity_Monitor_Color__c,
          (
            SELECT Id
            FROM Events
            WHERE type = '*RT Proposal Presentation/Demo - 15'
          ),
          (
            SELECT Id
            FROM Tasks
            WHERE type = '*RT Proposal Presentation/Demo - 15'
          )
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :VPForecastUserIds)
          AND TSGADX__Close_Date__c != null
          //TSGADX__Sales_Stage__c not in ('Lost' , 'Lost to Competition') AND //, 'Won'
          AND (TSGADX__Sales_Stage__c IN ('Won')
          OR TSGADX__Forecast_Category__c IN :lstForecastCategory)
          AND TSGADX__Close_Date__c = THIS_Month
          //TSGADX__Close_Date__c >=: QstartDate and TSGADX__Close_Date__c <=: QendDate
          //TSGADX__Close_Date__c <=: (Date.today().toStartOfMonth().AddMonths(3)).AddDays(-1))
          //TSGADX__Close_Date__c <=: ((Date.today().AddMonths(3).toStartOfMonth()).addMonths(1)).AddDays(-1))
          AND VP_Forecast__c = true
        ORDER BY
          Deal_Activity_Monitor_Color_Order__c,
          TSGADX__Total_Dollars__c DESC
      ]
    ) {
      WrapperforcastResults wrpobj;
      if (deal.TSGADX__Type__c.tolowercase() == 'replacement') {
        wrpobj = new WrapperforcastResults(deal, currentSummaryRep);
      } else {
        wrpobj = new WrapperforcastResults(deal, currentSummaryZbo);
      }
      lstResultVPForcast.add(wrpobj);

      if (wrpobj.automatedForcastrev != null) {
        intResultVPForcast =
          intResultVPForcast + integer.valueof(wrpobj.automatedForcastrev);
      }

      if (wrpobj.totalRevenue != null) {
        inttotalRevenueVPForcast =
          inttotalRevenueVPForcast + integer.valueof(wrpobj.totalRevenue);
      }
    }
    if (lstResultVPForcast.size() > 0) {
      WrapperforcastResults wrpobj;
      wrpobj = new WrapperforcastResults();
      wrpobj.OwnerName = 'Total';
      wrpobj.automatedForcastPercent = intResultVPForcast.format();
      wrpobj.revenue = inttotalRevenueVPForcast.format();
      lstResultVPForcast.add(wrpobj);
    }

    //Pipeline Forcast
    Map<string, Wrapperforcastpipelinedata> mappipelineforecast = new Map<string, Wrapperforcastpipelinedata>();
    lstResultPipelineForecast = new List<Wrapperforcastpipelinedata>();
    Wrapperforcastpipelinedata wfp = new Wrapperforcastpipelinedata();
    wfp.color = 'Total # of Deals';
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Sales_Team__c,
        RecordType.DeveloperName,
        TSGADX__Type__c,
        TSGADX__Total_Dollars__c,
        TSGADX__Agedays__c,
        TSGADX__Deal_Activity_Monitor__c,
        TSGADX__Sales_Stage__c,
        TSGADX__Close_Date__c,
        Next_Steps__c,
        RecordType.Name,
        Hardware_Revenue_Dollars__c,
        Owner.Name,
        TSGADX__Price__c,
        Deal_Activity_Monitor_Color__c,
        OwnerId
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c >= :Date.today()
        AND TSGADX__Close_Date__c <= :Date.today().addYears(5)
        AND Deal_Activity_Monitor_Color__c IN ('Red', 'Green', 'Yellow')
      ORDER BY Deal_Activity_Monitor_Color_Order__c ASC
    ]) {
      Wrapperforcastpipeline wrpobj;
      if (deal.TSGADX__Type__c.tolowercase() == 'replacement') {
        wrpobj = new Wrapperforcastpipeline(deal, currentSummaryRep);
      } else {
        wrpobj = new Wrapperforcastpipeline(deal, currentSummaryZbo);
      }
      //system.debug('@@@wrp@@@ ' + wrpobj);
      if (mappipelineforecast.containskey(wrpobj.color)) {
        mappipelineforecast.put(
          wrpobj.color,
          new Wrapperforcastpipelinedata(
            wrpobj,
            mappipelineforecast.get(wrpobj.color)
          )
        );
      } else {
        mappipelineforecast.put(
          wrpobj.color,
          new Wrapperforcastpipelinedata(
            wrpobj,
            new Wrapperforcastpipelinedata()
          )
        );
      }

      if (wrpobj.indexrange == 0) {
        wfp.revenue0++;
        wfp.strrevenue0 = string.valueof(wfp.revenue0);
      } else if (wrpobj.indexrange == 1) {
        wfp.revenue30++;
        wfp.strrevenue30 = string.valueof(wfp.revenue30);
      } else if (wrpobj.indexrange == 2) {
        wfp.revenue91++;
        wfp.strrevenue91 = string.valueof(wfp.revenue91);
      }
      if (wrpobj.indexrange == 3) {
        wfp.revenue181++;
        wfp.strrevenue181 = string.valueof(wfp.revenue181);
      }
      if (wrpobj.indexrange == 4) {
        wfp.revenue365++;
        wfp.strrevenue365 = string.valueof(wfp.revenue365);
      }
      if (wrpobj.indexrange == 5) {
        wfp.revenue731++;
        wfp.strrevenue731 = string.valueof(wfp.revenue731);
      }
      if (wrpobj.indexrange == 6) {
        wfp.revenue1096++;
        wfp.strrevenue1096 = string.valueof(wfp.revenue1096);
      }
      if (wrpobj.indexrange == 7) {
        wfp.revenue1461++;
        wfp.strrevenue1461 = string.valueof(wfp.revenue1461);
      }
    }

    if (mappipelineforecast.size() > 0) {
      for (Wrapperforcastpipelinedata wd : mappipelineforecast.values()) {
        lstResultPipelineForecast.add(wd);
      }
      lstResultPipelineForecast.add(wfp);
    }

    //Activity Details
    string strtype = label.TaskEventSalesForcasetType;
    List<string> lstType = new List<string>();
    lstType = strtype.split(',');

    List<Task> lstTask = new List<Task>(
      [
        SELECT Id, OwnerId, ActivityDate, Type
        FROM Task
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND ActivityDate != null
          AND Type IN :lstType
          AND ActivityDate >= :Date.today().AddMonths(-2).toStartOfMonth()
          AND ActivityDate <= :((Date.today().addYears(5).toStartOfMonth())
              .addMonths(1))
            .AddDays(-1)
      ]
    );

    List<Event> lstEvent = new List<Event>(
      [
        SELECT Id, OwnerId, ActivityDate, Type
        FROM Event
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND ActivityDate != null
          AND Type IN :lstType
          AND ActivityDate >= :Date.today().AddMonths(-2).toStartOfMonth()
          AND ActivityDate <= :((Date.today().addYears(5).toStartOfMonth())
              .addMonths(1))
            .AddDays(-1)
      ]
    );

    WrapperforcastTrackActivity wftrackingActivity = new WrapperforcastTrackActivity();
    for (sobject o : lstTask) {
      wftrackingActivity = fnCalculateActivityDetails(
        o,
        wftrackingActivity,
        true
      );
    }
    for (sobject o : lstEvent) {
      wftrackingActivity = fnCalculateActivityDetails(
        o,
        wftrackingActivity,
        false
      );
    }
    lstwftrackingActivity = new List<WrapperforcastTrackActivity>();
    lstwftrackingActivity.add(wftrackingActivity);

    //top 10 ZBO Open Deals
    lstResultTop10ZBOOpenDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND TSGADX__Type__c IN ('New Placement', 'ZBO')
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10ZBOOpenDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );

      if (deal.TSGADX__Total_Dollars__c != null) {
        intzboOpenRev =
          intzboOpenRev + integer.valueof(deal.TSGADX__Total_Dollars__c);
      }
    }

    zboOpenRev = intzboOpenRev.format();

    //top 10 ZBO Closed Deals
    lstResultTop10ZBOClosedDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND TSGADX__Type__c IN ('New Placement', 'ZBO')
        AND TSGADX__Won__c = true
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10ZBOClosedDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
    }

    /*
        //top 10 Prospect Open Deals
        lstResultTop10ProspectOpenDeals = new List<WrapperTopResults>();
        for(TSGADX__Deal__c deal: [select Id,Name,TSGADX__Total_Dollars__c,TSGADX__Proposal_Date__c,TSGADX__Close_Date__c,TSGADX__Price__c,RecordType.Name,
                    Next_Steps__c, TSGADX__Type__c 
                    from TSGADX__Deal__c 
                    Where OwnerId =: strSelectedRep and TSGADX__Sales_Stage__c not in ('Lost' , 'Lost to Competition', 'Won') and TSGADX__Close_Date__c != null and CALENDAR_YEAR(TSGADX__Close_Date__c) =: Integer.valueof(strSelectedYear) 
                    and RecordType.DeveloperName = 'Prospect' order by TSGADX__Total_Dollars__c desc Limit 10]){
            lstResultTop10ProspectOpenDeals.add(new WrapperTopResults(deal, mapMonths.get(deal.TSGADX__Close_Date__c.month())));
        }
        
        //top 10 Prospect Closed Deals
        lstResultTop10ProspectClosedDeals = new List<WrapperTopResults>();
        for(TSGADX__Deal__c deal: [select Id,Name,TSGADX__Total_Dollars__c,TSGADX__Proposal_Date__c,TSGADX__Close_Date__c,TSGADX__Price__c,RecordType.Name  from TSGADX__Deal__c 
                    Where OwnerId =: strSelectedRep and TSGADX__Close_Date__c != null and CALENDAR_YEAR(TSGADX__Close_Date__c) =: Integer.valueof(strSelectedYear) 
                    and RecordType.DeveloperName = 'Prospect' and TSGADX__Won__c = true order by TSGADX__Total_Dollars__c desc Limit 10]){
            lstResultTop10ProspectClosedDeals.add(new WrapperTopResults(deal, mapMonths.get(deal.TSGADX__Close_Date__c.month())));
        }
        */

    //top 10 Production Open Deals
    lstResultTop10ProductionOpenDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'Production_Deals'
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10ProductionOpenDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );

      if (deal.TSGADX__Price__c != null) {
        intprodOpenRev =
          intprodOpenRev + integer.valueof(deal.TSGADX__Price__c);
      }
    }
    prodOpenRev = intprodOpenRev.format();

    //top 10 Production Closed Deals
    lstResultTop10ProductionClosedDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'Production_Deals'
        AND TSGADX__Won__c = true
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10ProductionClosedDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
    }

    //top 10 IT Services Open Deals
    lstResultTop10ITOpenDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'IT_Services'
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10ITOpenDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );

      if (deal.TSGADX__Total_Dollars__c != null) {
        intitServOpenRev =
          intitServOpenRev + integer.valueof(deal.TSGADX__Total_Dollars__c);
      }
    }

    itServOpenRev = intitServOpenRev.format();

    //top 10 IT Services Closed Deals
    lstResultTop10ITClosedDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'IT_Services'
        AND TSGADX__Won__c = true
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10ITClosedDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
    }

    //top 10 Equipments Open Deals
    lstResultTop10EquipmentsOpenDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'Equipment_Deals'
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10EquipmentsOpenDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
      if (deal.Hardware_Revenue_Dollars__c != null) {
        inteqipOpenRev =
          inteqipOpenRev + integer.valueof(deal.Hardware_Revenue_Dollars__c);
      }
    }

    eqipOpenRev = inteqipOpenRev.format();

    //top 10 Equipments Closed Deals
    lstResultTop10EquipmentsClosedDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'Equipment_Deals'
        AND TSGADX__Won__c = true
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10EquipmentsClosedDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
    }

    //top 10 MPS Open Deals
    lstResultTop10MPSOpenDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Sales_Stage__c NOT IN ('Lost', 'Lost to Competition', 'Won')
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'MPS_Deals'
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10MPSOpenDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
      if (deal.TSGADX__Total_Dollars__c != null) {
        intmpsOpenRev =
          intmpsOpenRev + integer.valueof(deal.TSGADX__Total_Dollars__c);
      }
    }
    mpsOpenRev = intmpsOpenRev.format();

    //top 10 MPS Closed Deals
    lstResultTop10MPSClosedDeals = new List<WrapperTopResults>();
    for (TSGADX__Deal__c deal : [
      SELECT
        Id,
        Name,
        TSGADX__Total_Dollars__c,
        TSGADX__Proposal_Date__c,
        TSGADX__Close_Date__c,
        TSGADX__Price__c,
        RecordType.Name,
        Next_Steps__c,
        TSGADX__Type__c,
        Hardware_Revenue_Dollars__c
      FROM TSGADX__Deal__c
      WHERE
        (OwnerId = :strSelectedRep
        OR OwnerId IN :UserIds)
        AND TSGADX__Close_Date__c != null
        AND CALENDAR_YEAR(TSGADX__Close_Date__c) = :Integer.valueof(
          strSelectedYear
        )
        AND RecordType.DeveloperName = 'MPS_Deals'
        AND TSGADX__Won__c = true
      ORDER BY TSGADX__Total_Dollars__c DESC
      LIMIT 10
    ]) {
      lstResultTop10MPSClosedDeals.add(
        new WrapperTopResults(
          deal,
          mapMonths.get(deal.TSGADX__Close_Date__c.month())
        )
      );
    }

    isDataAvailable = true;
  }

  public WrapperforcastTrackActivity fnCalculateActivityDetails(
    Sobject o,
    WrapperforcastTrackActivity w,
    Boolean istask
  ) {
    Date dtActivityDate = system.today();
    if (o.get('ActivityDate') != null) {
      dtActivityDate = Date.Valueof(o.get('ActivityDate'));
    }
    string strActivityType = '';
    if (o.get('Type') != null) {
      strActivityType = string.valueof(o.get('Type'));
    }

    //current week
    Datetime dt = DateTime.newInstance(
      system.today(),
      Time.newInstance(0, 0, 0, 0)
    );
    integer currentweek = Integer.valueof(dt.format('w'));
    integer currentyear = Integer.valueof(dt.format('Y'));
    integer currentmonth = Integer.valueof(dt.format('M'));
    Datetime activitydt = DateTime.newInstance(
      dtActivityDate,
      Time.newInstance(0, 0, 0, 0)
    );
    integer currentActivityweek = Integer.valueof(activitydt.format('w'));
    integer currentActivityyear = Integer.valueof(activitydt.format('Y'));
    integer currentActivitymonth = Integer.valueof(activitydt.format('M'));

    Integer intdays = (system.today()).daysBetween(dtActivityDate);

    if (istask) {
      if (
        currentweek == currentActivityweek &&
        currentActivityyear == currentyear
      ) {
        w.taskthisweek++;
      }

      if (
        (currentweek - 1) == currentActivityweek &&
        currentActivityyear == currentyear
      ) {
        w.tasklastweek++;
      }

      if (
        currentmonth == currentActivitymonth &&
        currentActivityyear == currentyear
      ) {
        w.taskthismonth++;
      }

      if (intdays > 60 && intdays <= 180) {
        w.task61++;
      } else if (intdays > 180 && intdays <= 365) {
        w.task181++;
      } else if (intdays > 365 && intdays <= 730) {
        w.task2year++;
      } else if (intdays > 730 && intdays <= 1095) {
        w.task3year++;
      } else if (intdays > 1095 && intdays <= 1460) {
        w.task4year++;
      } else if (intdays > 1460 && intdays <= 1825) {
        w.task5year++;
      }
    } else {
      if (
        currentweek == currentActivityweek &&
        currentActivityyear == currentyear
      ) {
        w.appointmentthisweek++;
        if (strActivityType == '*RT Proposal Presentation/Demo - 15') {
          w.Proposalsthisweek++;
        }
        if (
          strActivityType == '*RT BTR Survey Request - 0' ||
          strActivityType == '*RT Client Review - 10'
        ) {
          w.BTRthisweek++;
        }
      }

      if (
        (currentweek - 1) == currentActivityweek &&
        currentActivityyear == currentyear
      ) {
        w.appointmentlastweek++;
        if (strActivityType == '*RT Proposal Presentation/Demo - 15') {
          w.Proposalslastweek++;
        }
        if (
          strActivityType == '*RT BTR Survey Request - 0' ||
          strActivityType == '*RT Client Review - 10'
        ) {
          w.BTRlastweek++;
        }
      }

      if (
        currentmonth == currentActivitymonth &&
        currentActivityyear == currentyear
      ) {
        w.appointmentthismonth++;
        if (strActivityType == '*RT Proposal Presentation/Demo - 15') {
          w.Proposalsthismonth++;
        }
        if (
          strActivityType == '*RT BTR Survey Request - 0' ||
          strActivityType == '*RT Client Review - 10'
        ) {
          w.BTRthismonth++;
        }
      }

      if (
        ((currentmonth - 1) == currentActivitymonth &&
        currentActivityyear == currentyear) ||
        ((currentmonth - 1) == 0 &&
        (currentyear - 1) == currentActivityyear &&
        currentActivitymonth == 12)
      ) {
        w.appointmentlastmonth++;
        if (strActivityType == '*RT Proposal Presentation/Demo - 15') {
          w.Proposalslastmonth++;
        }
        if (
          strActivityType == '*RT BTR Survey Request - 0' ||
          strActivityType == '*RT Client Review - 10'
        ) {
          w.BTRlastmonth++;
        }
      }
    }

    return w;
  }

  public void updateQuotas() {
    try {
      if (objSalesQuote != null) {
        for (WrapperSalesReport objWSR : lstWrapperSalesReport) {
          string dealType = objWSR.dealtype;
          /*if(dealType == 'Prospect'){
                        objSalesQuote .Prospect__c = objWSR.annualQuotas;
                    } else*/
          if (dealType == 'Production') {
            objSalesQuote.Production__c = Integer.valueof(
              objWSR.annualQuotas.replace(',', '')
            );
          } else if (dealType == 'IT Services') {
            objSalesQuote.IT_Services__c = Integer.valueof(
              objWSR.annualQuotas.replace(',', '')
            );
          } else if (dealType == 'Equipment') {
            objSalesQuote.Equipment__c = Integer.valueof(
              objWSR.annualQuotas.replace(',', '')
            );
          } else if (dealType == 'MPS') {
            objSalesQuote.MPS__c = Integer.valueof(
              objWSR.annualQuotas.replace(',', '')
            );
          }
        }

        //to update person name and date a note added
        objSalesQuote.ACTION_PLAN_Q1__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ACTION_PLAN_Q1__c,
          objSalesQuote.ACTION_PLAN_Q1__c
        );
        objSalesQuote.TRAINING_NEEDS_Q1__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.TRAINING_NEEDS_Q1__c,
          objSalesQuote.TRAINING_NEEDS_Q1__c
        );
        objSalesQuote.ASSISTANCE_NEEDED_Q1__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ASSISTANCE_NEEDED_Q1__c,
          objSalesQuote.ASSISTANCE_NEEDED_Q1__c
        );

        objSalesQuote.ACTION_PLAN_Q2__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ACTION_PLAN_Q2__c,
          objSalesQuote.ACTION_PLAN_Q2__c
        );
        objSalesQuote.TRAINING_NEEDS_Q2__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.TRAINING_NEEDS_Q2__c,
          objSalesQuote.TRAINING_NEEDS_Q2__c
        );
        objSalesQuote.ASSISTANCE_NEEDED_Q2__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ASSISTANCE_NEEDED_Q2__c,
          objSalesQuote.ASSISTANCE_NEEDED_Q2__c
        );

        objSalesQuote.ACTION_PLAN_Q3__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ACTION_PLAN_Q3__c,
          objSalesQuote.ACTION_PLAN_Q3__c
        );
        objSalesQuote.TRAINING_NEEDS_Q3__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.TRAINING_NEEDS_Q3__c,
          objSalesQuote.TRAINING_NEEDS_Q3__c
        );
        objSalesQuote.ASSISTANCE_NEEDED_Q3__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ASSISTANCE_NEEDED_Q3__c,
          objSalesQuote.ASSISTANCE_NEEDED_Q3__c
        );

        objSalesQuote.ACTION_PLAN_Q4__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ACTION_PLAN_Q4__c,
          objSalesQuote.ACTION_PLAN_Q4__c
        );
        objSalesQuote.TRAINING_NEEDS_Q4__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.TRAINING_NEEDS_Q4__c,
          objSalesQuote.TRAINING_NEEDS_Q4__c
        );
        objSalesQuote.ASSISTANCE_NEEDED_Q4__c = fnsalesquotetextarea(
          objSalesQuoteQuarter.ASSISTANCE_NEEDED_Q4__c,
          objSalesQuote.ASSISTANCE_NEEDED_Q4__c
        );

        upsert objSalesQuote;

        SalesViewByRep();
      }
    } catch (Exception ex) {
      Apexpages.addMessages(ex);
    }
  }

  public string fnsalesquotetextarea(string newval, string oldvalue) {
    if (!string.isblank(newval)) {
      if (!string.isblank(oldvalue)) {
        oldvalue +=
          '\r\n --- ' +
          UserInfo.getName() +
          ' ' +
          system.today().format() +
          ' --- \r\n' +
          newval;
      } else {
        oldvalue =
          '--- ' +
          UserInfo.getName() +
          ' ' +
          system.today().format() +
          ' --- \r\n' +
          newval;
      }
    }
    return oldvalue;
  }

  public SummaryModel getSummaryRepZbo(
    List<AggregateResult> agrResults,
    Boolean isZbo
  ) {
    SummaryModel sm = new SummaryModel();
    for (AggregateResult agr : agrResults) {
      string strtype = string.valueof(agr.get('type'));

      if (
        isZbo &&
        (strtype.tolowercase() != 'zbo' &&
        strtype.tolowercase() != 'new placement')
      ) {
        continue;
      }
      if (!isZbo && strtype.tolowercase() != 'replacement') {
        continue;
      }

      Integer dealCount = Integer.ValueOf(agr.get('totalDeals'));

      if (agr.get('TSGADX__Sales_Stage__c') == 'Lost') {
        sm.totalLost += dealCount;
      }

      if (agr.get('TSGADX__Sales_Stage__c') == 'Lost to Competition') {
        sm.totalLostToComp += dealCount;
      }

      if (agr.get('TSGADX__Sales_Stage__c') == 'Won') {
        sm.totalWon += dealCount;
      }
    }

    Integer totalWinLost = sm.totalLost + sm.totalLostToComp + sm.totalWon;

    if (totalWinLost > 0) {
      sm.totalCount = totalWinLost;
    }

    //Integer totalLost = sm.totalLost+sm.totalLostToComp;
    Integer totalLost = sm.totalLostToComp; // removed push calculation from win%
    if (totalLost > 0) {
      sm.winPercent = ((sm.totalWon * 100) / (totalLost + sm.totalWon));
      //sm.lostPercent = 100-sm.winPercent;
    } else if (sm.totalWon > 0) {
      sm.winPercent = 100;
    }

    return sm;
  }

  //Method to summarize deal data by stage and get win/lost % ratio
  public SummaryModel getSummary(List<AggregateResult> agrResults) {
    SummaryModel sm = new SummaryModel();
    for (AggregateResult agr : agrResults) {
      Integer dealCount = Integer.ValueOf(agr.get('totalDeals'));

      if (agr.get('TSGADX__Sales_Stage__c') == 'Lost') {
        sm.totalLost = dealCount;
      }
      if (agr.get('TSGADX__Sales_Stage__c') == 'Lost to Competition') {
        sm.totalLostToComp = dealCount;
      }
      if (agr.get('TSGADX__Sales_Stage__c') == 'Won') {
        sm.totalWon = dealCount;
      }
    }

    Integer totalWinLost = sm.totalLost + sm.totalLostToComp + sm.totalWon;

    if (totalWinLost > 0) {
      sm.totalCount = totalWinLost;
    }

    Integer totalLost = sm.totalLost + sm.totalLostToComp;
    if (totalLost > 0) {
      sm.winPercent = ((sm.totalWon * 100) / (totalLost + sm.totalWon));
      //sm.lostPercent = 100-sm.winPercent;
    } else if (sm.totalWon > 0) {
      sm.winPercent = 100;
    }

    return sm;
  }

  public avgSummaryModel getAvgSummaryRepZBO(
    List<AggregateResult> agrResults,
    Boolean isZbo
  ) {
    //Integer mnth = Date.Today().Month();
    Integer mnth = 12;

    avgSummaryModel sm = new avgSummaryModel();
    for (AggregateResult agr : agrResults) {
      string strtype = string.valueof(agr.get('type'));
      if (
        isZbo &&
        (strtype.tolowercase() != 'zbo' &&
        strtype.tolowercase() != 'new placement')
      ) {
        continue;
      }
      if (!isZbo && strtype.tolowercase() != 'replacement') {
        continue;
      }

      Integer dealCount = Integer.ValueOf(agr.get('totalDeals'));

      if (agr.get('TSGADX__Sales_Stage__c') == 'Lost') {
        sm.totalLost += dealCount;
      }
      if (agr.get('TSGADX__Sales_Stage__c') == 'Lost to Competition') {
        sm.totalLostToComp += dealCount;
      }
      if (agr.get('TSGADX__Sales_Stage__c') == 'Won') {
        sm.totalWon += dealCount;
      }
    }

    //Decimal totalLost = sm.totalLost + sm.totalLostToComp;
    Decimal totalLost = sm.totalLostToComp; // removed pushed calculation from Win %
    if (totalLost > 0) {
      sm.winPercent = ((sm.totalWon * 100) / (totalLost + sm.totalWon))
        .setscale(2);
      //sm.lostPercent = 100-sm.winPercent;
    } else if (sm.totalWon > 0) {
      sm.winPercent = 100;
    }

    Decimal totalWinLost = sm.totalLost + sm.totalLostToComp + sm.totalWon;

    if (totalWinLost > 0) {
      sm.totalCount = (totalWinLost / mnth).setscale(2);
    }

    if (sm.totalLost > 0) {
      sm.totalLost = (sm.totalLost / mnth).setscale(2);
    }

    if (sm.totalLostToComp > 0) {
      sm.totalLostToComp = (sm.totalLostToComp / mnth).setscale(2);
    }

    if (sm.totalWon > 0) {
      sm.totalWon = (sm.totalWon / mnth).setscale(2);
    }

    //system.debug(sm.totalLost);
    //system.debug(sm.totalLostToComp);
    //system.debug(sm.totalWon);

    return sm;
  }

  //Method to summarize deal data by stage and get win/lost % ratio for monthly avg
  /*public avgSummaryModel getAvgSummary(List<AggregateResult> agrResults){

        Integer mnth = Date.Today().Month();

        avgSummaryModel sm = new avgSummaryModel();
        for(AggregateResult agr: agrResults){
            Integer dealCount = Integer.ValueOf(agr.get('totalDeals'));

            if(agr.get('TSGADX__Sales_Stage__c') == 'Lost')
                sm.totalLost = dealCount;
            if(agr.get('TSGADX__Sales_Stage__c') == 'Lost to Competition')
                sm.totalLostToComp = dealCount;
            if(agr.get('TSGADX__Sales_Stage__c') == 'Won')
                sm.totalWon = dealCount;       
        }

        Decimal totalLost = sm.totalLost+sm.totalLostToComp;

        if(totalLost >0){            
            sm.winPercent = ((sm.totalWon*100)/(totalLost+sm.totalWon)).setscale(2);
            //sm.lostPercent = 100-sm.winPercent;
        }else if(sm.totalWon > 0){
            sm.winPercent = 100;
        }

        Decimal totalWinLost = sm.totalLost+sm.totalLostToComp+sm.totalWon;

        if(totalWinLost>0)
        {
            sm.totalCount = (totalWinLost/mnth).setscale(2);
        }

        if(sm.totalLost>0)
        sm.totalLost = (sm.totalLost/mnth).setscale(2);

        if(sm.totalLostToComp>0)
        sm.totalLostToComp = (sm.totalLostToComp/mnth).setscale(2);

        if(sm.totalWon>0)
        sm.totalWon = (sm.totalWon/mnth).setscale(2);

        system.debug(sm.totalLost);
        system.debug(sm.totalLostToComp);
        system.debug(sm.totalWon);       
        
        return sm;
    }*/

  public PageReference printSalesReport() {
    SalesViewByRep();
    return Page.SalesReviewReportPrint;
  }

  //using for showing summary calculation like rationm total won/lost e.t.c
  public class SummaryModel {
    public Integer totalLost { get; set; }
    public Integer totalLostToComp { get; set; }
    public Integer totalWon { get; set; }
    public Decimal winPercent { get; set; }
    public Decimal lostPercent { get; set; }
    public Integer totalCount { get; set; }

    public SummaryModel() {
      totalLost = 0;
      totalLostToComp = 0;
      totalWon = 0;
      winPercent = 0;
      lostPercent = 0;
      totalCount = 0;
    }
  }

  //using for showing summary calculation like rationm total won/lost e.t.c
  public class avgSummaryModel {
    public Decimal totalLost { get; set; }
    public Decimal totalLostToComp { get; set; }
    public Decimal totalWon { get; set; }
    public Decimal winPercent { get; set; }
    public Decimal lostPercent { get; set; }
    public Decimal totalCount { get; set; }

    public avgSummaryModel() {
      totalLost = 0;
      totalLostToComp = 0;
      totalWon = 0;
      winPercent = 0;
      lostPercent = 0;
      totalCount = 0;
    }
  }

  public class WrapperSalesReport {
    public string dealtype { get; set; }
    public string annualQuotas { get; set; }
    public string quartlyQuotas { get; set; }
    public string quartlySales { get; set; }
    public decimal quartlySalesPercent { get; set; }
    public string quartlyWon { get; set; }
    public decimal quartlyWonPercent { get; set; }
    public string ytdSales { get; set; }
    public decimal ytdSalesPercent { get; set; }
    public string ytdWon { get; set; }
    public string annualProrated { get; set; }
    public decimal ytdWonPercent { get; set; }

    public WrapperSalesReport() {
      dealtype = '';
      annualQuotas = '0';
      quartlyQuotas = '0';
      quartlySales = '0';
      quartlySalesPercent = 0;
      quartlyWon = '0';
      quartlyWonPercent = 0;
      ytdSales = '0';
      ytdSalesPercent = 0;
      ytdWon = '0';
      annualProrated = '0';
      ytdWonPercent = 0;
    }
  }

  public class Wrapperforcastpipelinedata {
    public string color { get; set; }
    public Decimal revenue0 { get; set; }
    public Decimal revenue30 { get; set; }
    public Decimal revenue91 { get; set; }
    public Decimal revenue181 { get; set; }
    public Decimal revenue365 { get; set; }
    public Decimal revenue731 { get; set; }
    public Decimal revenue1096 { get; set; }
    public Decimal revenue1461 { get; set; }
    public string strrevenue0 { get; set; }
    public string strrevenue30 { get; set; }
    public string strrevenue91 { get; set; }
    public string strrevenue181 { get; set; }
    public string strrevenue365 { get; set; }
    public string strrevenue731 { get; set; }
    public string strrevenue1096 { get; set; }
    public string strrevenue1461 { get; set; }
    public Wrapperforcastpipelinedata() {
      this.revenue0 = 0;
      this.revenue30 = 0;
      this.revenue91 = 0;
      this.revenue181 = 0;
      this.revenue365 = 0;
      this.revenue731 = 0;
      this.revenue1096 = 0;
      this.revenue1461 = 0;
      this.strrevenue0 = '0';
      this.strrevenue30 = '0';
      this.strrevenue91 = '0';
      this.strrevenue181 = '0';
      this.strrevenue365 = '0';
      this.strrevenue731 = '0';
      this.strrevenue1096 = '0';
      this.strrevenue1461 = '0';
    }
    public Wrapperforcastpipelinedata(
      Wrapperforcastpipeline w,
      Wrapperforcastpipelinedata wd
    ) {
      this.color = w.color;
      this.revenue0 = wd.revenue0 + w.revenue0;
      this.revenue30 = wd.revenue30 + w.revenue30;
      this.revenue91 = wd.revenue91 + w.revenue91;
      this.revenue181 = wd.revenue181 + w.revenue181;
      this.revenue365 = wd.revenue365 + w.revenue365;
      this.revenue731 = wd.revenue731 + w.revenue731;
      this.revenue1096 = wd.revenue1096 + w.revenue1096;
      this.revenue1461 = wd.revenue1461 + w.revenue1461;

      this.strrevenue0 = this.revenue0.setScale(0).format();
      this.strrevenue30 = this.revenue30.setScale(0).format();
      this.strrevenue91 = this.revenue91.setScale(0).format();
      this.strrevenue181 = this.revenue181.setScale(0).format();
      this.strrevenue365 = this.revenue365.setScale(0).format();
      this.strrevenue731 = this.revenue731.setScale(0).format();
      this.strrevenue1096 = this.revenue1096.setScale(0).format();
      this.strrevenue1461 = this.revenue1461.setScale(0).format();
    }
  }

  public class WrapperforcastTrackActivity {
    public integer appointmentlastweek { get; set; }
    public integer appointmentthisweek { get; set; }
    public integer Proposalslastweek { get; set; }
    public integer Proposalsthisweek { get; set; }
    public integer BTRlastweek { get; set; }
    public integer BTRthisweek { get; set; }
    public integer appointmentlastmonth { get; set; }
    public integer appointmentthismonth { get; set; }
    public integer Proposalslastmonth { get; set; }
    public integer Proposalsthismonth { get; set; }
    public integer BTRlastmonth { get; set; }
    public integer BTRthismonth { get; set; }
    public integer tasklastweek { get; set; }
    public integer taskthisweek { get; set; }
    public integer taskthismonth { get; set; }
    public integer task61 { get; set; }
    public integer task181 { get; set; }
    public integer task2year { get; set; }
    public integer task3year { get; set; }
    public integer task4year { get; set; }
    public integer task5year { get; set; }

    public WrapperforcastTrackActivity() {
      this.appointmentlastweek = 0;
      this.appointmentthisweek = 0;
      this.Proposalslastweek = 0;
      this.Proposalsthisweek = 0;
      this.BTRlastweek = 0;
      this.BTRthisweek = 0;
      this.appointmentlastmonth = 0;
      this.appointmentthismonth = 0;
      this.Proposalslastmonth = 0;
      this.Proposalsthismonth = 0;
      this.BTRlastmonth = 0;
      this.BTRthismonth = 0;
      this.tasklastweek = 0;
      this.taskthisweek = 0;
      this.taskthismonth = 0;
      this.task61 = 0;
      this.task181 = 0;
      this.task2year = 0;
      this.task3year = 0;
      this.task4year = 0;
      this.task5year = 0;
    }
  }

  public class Wrapperforcastpipeline {
    public Date closedate { get; set; }
    public Decimal revenue { get; set; }
    public string color { get; set; }
    public integer indexrange { get; set; }
    public string ownername { get; set; }
    public Id ownerid { get; set; }
    public Decimal revenue0 { get; set; }
    public Decimal revenue30 { get; set; }
    public Decimal revenue91 { get; set; }
    public Decimal revenue181 { get; set; }
    public Decimal revenue365 { get; set; }
    public Decimal revenue731 { get; set; }
    public Decimal revenue1096 { get; set; }
    public Decimal revenue1461 { get; set; }

    public Wrapperforcastpipeline() {
    }
    public Wrapperforcastpipeline(
      TSGADX__Deal__c deal,
      SummaryModel currentSummary
    ) {
      this.ownername = deal.owner.name;
      this.ownerid = deal.ownerid;
      this.revenue = 0;
      this.revenue0 = 0;
      this.revenue30 = 0;
      this.revenue91 = 0;
      this.revenue181 = 0;
      this.revenue365 = 0;
      this.revenue731 = 0;
      this.revenue1096 = 0;
      this.revenue1461 = 0;
      if (deal.RecordType.Name == 'Production Deals') {
        if (deal.TSGADX__Price__c != null) {
          this.revenue = deal.TSGADX__Price__c.setScale(0);
        }
      } else {
        if (deal.RecordType.Name == 'Equipment Deals') {
          if (deal.TSGADX__Price__c != null) {
            this.revenue = deal.Hardware_Revenue_Dollars__c;
          }
        } else {
          if (deal.TSGADX__Total_Dollars__c != null) {
            this.revenue = deal.TSGADX__Total_Dollars__c;
          }
        }
      }
      this.color = deal.Deal_Activity_Monitor_Color__c;
      this.closedate = deal.TSGADX__Close_Date__c;

      Integer intdays = 0;
      if (deal.TSGADX__Close_Date__c != null) {
        intdays = (system.today()).daysBetween(deal.TSGADX__Close_Date__c);
      }
      if (intdays > 0 && intdays <= 30) {
        this.revenue0 = this.revenue;
        this.indexrange = 0;
      } else if (intdays > 30 && intdays <= 90) {
        this.revenue30 = this.revenue;
        this.indexrange = 1;
      } else if (intdays > 90 && intdays <= 180) {
        this.revenue91 = this.revenue;
        this.indexrange = 2;
      } else if (intdays > 180 && intdays <= 365) {
        this.revenue181 = this.revenue;
        this.indexrange = 3;
      } else if (intdays > 365 && intdays <= 730) {
        this.revenue365 = this.revenue;
        this.indexrange = 4;
      } else if (intdays > 730 && intdays <= 1095) {
        this.revenue731 = this.revenue;
        this.indexrange = 5;
      } else if (intdays > 1095 && intdays <= 1460) {
        this.revenue1096 = this.revenue;
        this.indexrange = 6;
      } else if (intdays > 1460 && intdays <= 1825) {
        this.revenue1461 = this.revenue;
        this.indexrange = 7;
      }
    }
  }

  public class WrapperforcastResults {
    public TSGADX__Deal__c objDeal { get; set; }
    public string OwnerName { get; set; }
    public string newplacementreplacement { get; set; }
    public string revenue { get; set; }
    public string automatedForcastPercent { get; set; }
    public Decimal automatedForcastrev { get; set; }
    public Decimal totalRevenue { get; set; }
    public string proposalDone { get; set; }
    public WrapperforcastResults() {
    }
    public WrapperforcastResults(
      TSGADX__Deal__c deal,
      SummaryModel currentSummary
    ) {
      this.objDeal = deal;
      this.OwnerName = deal.owner.name;
      if (this.objDeal.TSGADX__Type__c == 'Replacement') {
        this.newplacementreplacement = 'Replacement';
      } else {
        this.newplacementreplacement = 'ZBO';
      }

      if (deal.RecordType.Name == 'Production Deals') {
        if (deal.TSGADX__Price__c != null) {
          this.revenue = deal.TSGADX__Price__c.setScale(0).format();
        } else {
          this.revenue = '0';
        }
      } else {
        if (deal.RecordType.Name == 'Equipment Deals') {
          if (deal.TSGADX__Price__c != null) {
            this.revenue = deal.Hardware_Revenue_Dollars__c.setScale(0)
              .format();
          } else {
            this.revenue = '0';
          }
        } else {
          if (deal.TSGADX__Total_Dollars__c != null) {
            this.revenue = deal.TSGADX__Total_Dollars__c.setScale(0).format();
          } else {
            this.revenue = '0';
          }
        }
      }
      this.totalRevenue = decimal.valueof(this.revenue.replace(',', ''));
      this.automatedForcastrev = ((decimal.valueof(
          this.revenue.replace(',', '')
        ) * currentSummary.winPercent) / 100)
        .setScale(0);
      this.automatedForcastPercent = automatedForcastrev.format();

      if (!deal.tasks.isEmpty() || !deal.events.isEmpty()) {
        this.proposalDone = 'Yes';
      } else {
        this.proposalDone = 'No';
      }
    }
  }

  public class WrapperTopResults {
    public TSGADX__Deal__c objDeal { get; set; }
    public string revenue { get; set; }
    public boolean proposal { get; set; }
    public string closingmonth { get; set; }

    public WrapperTopResults(TSGADX__Deal__c deal, string cmonth) {
      this.objDeal = deal;
      if (deal.RecordType.Name == 'Production Deals') {
        if (deal.TSGADX__Price__c != null) {
          this.revenue = deal.TSGADX__Price__c.setScale(0).format();
        } else {
          this.revenue = '0';
        }
      } else if (deal.RecordType.Name == 'Equipment Deals') {
        if (deal.TSGADX__Price__c != null) {
          this.revenue = deal.Hardware_Revenue_Dollars__c.setScale(0).format();
        } else {
          this.revenue = '0';
        }
      } else {
        if (deal.TSGADX__Total_Dollars__c != null) {
          this.revenue = deal.TSGADX__Total_Dollars__c.setScale(0).format();
        } else {
          this.revenue = '0';
        }
      }
      this.proposal = false;
      if (deal.TSGADX__Proposal_Date__c != null) {
        this.proposal = true;
      }
      this.closingmonth = cmonth;
    }
  }

  public class wrpSalesData {
    public string fieldName1 { get; set; }
    public string fieldNameValue1 { get; set; }
    public string fieldName2 { get; set; }
    public string fieldNameValue2 { get; set; }
    public string fieldName3 { get; set; }
    public string fieldNameValue3 { get; set; }
    public string fieldName4 { get; set; }
    public string fieldNameValue4 { get; set; }
    public string fieldName5 { get; set; }
    public string fieldNameValue5 { get; set; }
  }

  private List<wrpSalesData> findTotalSales() {
    List<AggregateResult> lstData = new List<AggregateResult>(
      [
        SELECT
          Count(Id) totalDeals,
          TSGADX__Sales_Stage__c,
          TSGADX__Type__c type,
          RecordType.DeveloperName Category
        FROM TSGADX__Deal__c
        WHERE
          (OwnerId = :strSelectedRep
          OR OwnerId IN :UserIds)
          AND TSGADX__Sales_Stage__c IN ('Lost', 'Lost to Competition', 'Won')
          AND TSGADX__Close_Date__c != null
          AND TSGADX__Close_Date__c >= :Date.today()
            .addmonths(-11)
            .toStartOfMonth()
          AND TSGADX__Close_Date__c <= :(Date.today()
              .addmonths(1)
              .toStartOfMonth())
            .adddays(-1)
        GROUP BY
          TSGADX__Sales_Stage__c,
          TSGADX__Type__c,
          RecordType.DeveloperName

      ]
    );

    SummaryModel currentSummaryRep1 = getSummaryRepZbo(lstData, false);
    SummaryModel currentSummaryZbo1 = getSummaryRepZbo(lstData, true);
    avgSummaryModel monthlySummaryRep1 = getAvgSummaryRepZbo(lstData, false);
    avgSummaryModel monthlySummaryZbo1 = getAvgSummaryRepZbo(lstData, true);

    return null;
  }
}
