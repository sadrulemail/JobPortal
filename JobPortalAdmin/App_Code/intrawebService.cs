using System;
using System.Collections.Generic;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

/// <summary>
/// Web Services for Trust intaweb Applications
/// 
/// Developed By:
/// Muhammad Ashik Iqbal
/// Software Development Team
/// 
/// Created on: 25 May 2009
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[System.Web.Script.Services.ScriptService]
public class intrawebService : WebService
{
    public intrawebService ()
    {
    }

    [WebMethod]
    public string[] GetRosterEmpList(string prefixText, int count)
    {
        List<string> items = new List<string>(count);

        if (count == 0) count = 15;
        BuildItemsFromDatabase(prefixText, count, items);
        return items.ToArray();
    }

    [WebMethod]
    public string[] GetRoutingNumberList(string prefixText, int count)
    {
        List<string> items = new List<string>(count);

        if (count == 0) count = 15;
        BuildRoutingNumbersDatabase(prefixText, count, items);
        return items.ToArray();
    }

    private static void BuildRoutingNumbersDatabase(string prefixText, int count, List<string> items)
    {
        SqlConnection.ClearAllPools();
        string Query = "EXEC sp_BEFTN_Codes_Search_Service '" + prefixText + "'";
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlDataReader oR = oCommand.ExecuteReader();
        //if (oR.HasRows)
        //    HeaderFooter = true;            
        //BuildHeader();    
        while (oR.Read() && count-- > 0)
        {
            items.Add(oR["INFO"].ToString());
        }
        oR.Close();
    }
        
    private static void BuildItemsFromDatabase(string prefixText, int count, List<string> items)
    {
        SqlConnection.ClearAllPools();
        string Query = "EXEC usp_UserRole_Show " + getApplicationID() + ", '" + prefixText + "'";
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlDataReader oR = oCommand.ExecuteReader();
        //if (oR.HasRows)
        //    HeaderFooter = true;            
        //BuildHeader();    
        while (oR.Read() && count-- > 0)
        {
            items.Add(oR["EMPINFO"].ToString());
        }
        oR.Close();
    }

    [WebMethod]
    public string[] GetAuthorityEmp(string prefixText, int count)
    {
        List<string> items = new List<string>(count);

        if (count == 0) count = 15;
        BuildAuthorityEmpItemsFromDatabase(prefixText, count, items, getApplicationID());
        return items.ToArray();
    }
    private static void BuildAuthorityEmpItemsFromDatabase(string prefixText, int count, List<string> items, int AppID)
    {
        SqlConnection.ClearAllPools();
        string Query = "SELECT TOP " + count + " EMPID, EMPINFO FROM ViewAuthoEMP WHERE EMPINFO LIKE '%" + prefixText + "%' AND ApplicationID = '" + AppID + "' ORDER BY EMPNAME";
        SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["TblUserDBConnectionString"].ConnectionString);
        SqlCommand oCommand = new SqlCommand(Query, oConn);
        if (oConn.State == ConnectionState.Closed) oConn.Open();

        SqlDataReader oR = oCommand.ExecuteReader();
        //if (oR.HasRows)
        //    HeaderFooter = true;            
        //BuildHeader();    
        while (oR.Read())
        {
            items.Add(oR["EMPINFO"].ToString());
        }
        oR.Close();
    }
    private static int getApplicationID()
    {
        int ApplicationID = -1;
        try
        {
            ApplicationID = int.Parse(System.Configuration.ConfigurationManager.AppSettings["ApplicationID"].ToString().Trim());
        }
        catch (Exception)
        {
            return 0;
        }
        return ApplicationID;
    }
    protected string toJS(object value)
    {
        try
        {
            return HttpUtility.JavaScriptStringEncode(value.ToString().Replace("\n", ""));
        }
        catch (Exception)
        {
            return "";
        }
    }
}
