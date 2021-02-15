using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CommonControl : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    public void ClientMsg(string MsgTxt, Control focusControl)
    {
        string script1 = "";
        if (focusControl != null)
            script1 = "$('#" + focusControl.ClientID + "').focus();";
        ScriptManager.RegisterClientScriptBlock(this.Page, this.Page.GetType(), "clientScript", "jAlert('" + MsgTxt + "','Trust Bank', function(r){" + script1 + "});", true);
    }

    public void ClientMsg(string MsgTxt)
    {
        ClientMsg(MsgTxt, null);
    }

    public string getIPAddress()
    {
        string Client_IP_Address = string.Empty;
        try
        {
            Client_IP_Address = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
        }
        catch (Exception)
        {
            try
            {
                Client_IP_Address = HttpContext.Current.Request.UserHostAddress;
            }
            catch (Exception)
            {
                Client_IP_Address = Request.ServerVariables["LOCAL_ADDR"].ToString();
            }
        }
        return Client_IP_Address;
    }

    public string getBrowserInfo()
    {
        string Client_BrowserInfo = string.Empty;
        try
        {
            Client_BrowserInfo = HttpContext.Current.Request.Browser.Browser;
        }
        catch (Exception) { }
        try
        {
            Client_BrowserInfo += ", " + HttpContext.Current.Request.Browser.Version;
        }
        catch (Exception) { }
        //try
        //{
        //    Client_BrowserInfo += ", JavaScript:" + HttpContext.Current.Request.Browser["JavaScriptVersion"];
        //}
        //catch (Exception) { }
        try
        {
            Client_BrowserInfo += ", " + HttpContext.Current.Request.Browser.Platform;
        }
        catch (Exception) { }
        return Client_BrowserInfo;
    }


    public string getValueOfKey(string KeyName)
    {
        try
        {
            return string.Format("{0}", System.Configuration.ConfigurationSettings.AppSettings[KeyName]);
        }
        catch (Exception) { return string.Empty; }
    }
}