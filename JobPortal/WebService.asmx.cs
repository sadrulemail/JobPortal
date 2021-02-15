using System;
using System.Collections.Generic;
using System.Web.Services;
using System.Data.SqlClient;
using System.Data;
using AjaxControlToolkit;
using System.Collections.Specialized;

namespace JobPortal
{
    /// <summary>
    /// Summary description for WebService
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.Web.Script.Services.ScriptService]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    // [System.Web.Script.Services.ScriptService]
    public class WebService : System.Web.Services.WebService
    {

        public WebService()
        {

            //Uncomment the following line if using designed components 
            //InitializeComponent(); 
        }

        [WebMethod]
        public string[] GetSearchResult(
            string prefixText,
            int count)
        {
            List<string> items = new List<string>(count);

            if (count == 0) count = 15;
            BuildItemsFromDatabase(prefixText, count, items);
            return items.ToArray();
        }


        private static void BuildItemsFromDatabase(
            string prefixText,
            int count,
            List<string> items)
        {
            string Query = "SELECT TOP " + count + " EMPID, EMP FROM ViewEMP WHERE EMPINFO LIKE '%" + prefixText + "%' AND ServiceStatus = '1' ORDER BY EMPNAME";
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["JobPortalConnectionString"].ConnectionString);
            SqlCommand oCommand = new SqlCommand(Query, oConn);
            if (oConn.State == ConnectionState.Closed) oConn.Open();

            SqlDataReader oR = oCommand.ExecuteReader();
            //if (oR.HasRows)
            //    HeaderFooter = true;            
            //BuildHeader();    
            while (oR.Read())
            {
                var html = string.Format("<table width='300px'><tr><td valign='top'>{0}</td><td valign='top' align='right'><img width='60px' src='EmpImage.aspx?EMPID={1}&W=60' ></td></tr></table>", oR["EMP"], oR["EMPID"]);
                var item = AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(oR["EMPID"].ToString(), html);
                //items.Add(item);
                items.Add(item);

            }
            oR.Close();
        }

        [WebMethod]
        public CascadingDropDownNameValue[] GetDropDownContents_District(
            string knownCategoryValues,
            string category)
        {
            //knownCategoryValues = knownCategoryValues.Replace("undefined:", "").Replace(";", "");
            StringDictionary kv = CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues);
            int DIV_CODE;
            if (!kv.ContainsKey("undefined") ||
            !Int32.TryParse(kv["undefined"], out DIV_CODE))
            {
                return null;
            }

            string Query = "SELECT DIST_CODE, DIST_NAME FROM [dbo].[BD_District] WHERE DIV_CODE = '" + DIV_CODE + "' ORDER BY DIST_NAME";
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["JobPortalConnectionString"].ConnectionString);
            SqlCommand oCommand = new SqlCommand(Query, oConn);
            if (oConn.State == ConnectionState.Closed) oConn.Open();

            List<CascadingDropDownNameValue> values = new List<CascadingDropDownNameValue>();

            SqlDataReader oR = oCommand.ExecuteReader();
            while (oR.Read())
            {
                values.Add(new CascadingDropDownNameValue(oR["DIST_NAME"].ToString(), oR["DIST_CODE"].ToString()));
            }
            oR.Close();
            oConn.Close();


            return values.ToArray();
        }

        [WebMethod]
        public CascadingDropDownNameValue[] GetDropDownContents_Thana(
            string knownCategoryValues,
            string category)
        {
            StringDictionary kv = CascadingDropDown.ParseKnownCategoryValuesString(knownCategoryValues);
            int DIST_CODE;
            if (!kv.ContainsKey("District") ||
            !Int32.TryParse(kv["District"], out DIST_CODE))
            {
                return null;
            }

            string Query = "SELECT [THANA_CODE],[THANA_NAME] FROM [dbo].[BD_Thana] WHERE DIST_CODE = '" + DIST_CODE + "' ORDER BY THANA_NAME";
            SqlConnection oConn = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["JobPortalConnectionString"].ConnectionString);
            SqlCommand oCommand = new SqlCommand(Query, oConn);
            if (oConn.State == ConnectionState.Closed) oConn.Open();

            List<CascadingDropDownNameValue> values = new List<CascadingDropDownNameValue>();

            SqlDataReader oR = oCommand.ExecuteReader();
            while (oR.Read())
            {
                values.Add(new CascadingDropDownNameValue(oR["THANA_NAME"].ToString(), oR["THANA_CODE"].ToString()));
            }
            oR.Close();
            oConn.Close();

            return values.ToArray();
        }
    }
}
