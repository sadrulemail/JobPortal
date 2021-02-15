using System;
using System.Web.UI.WebControls;


public partial class EMP : System.Web.UI.UserControl
{
    private string _Username = string.Empty;
    private string _Prefix = string.Empty;
    private string _Position = string.Empty;


    public string Username
    {
        set
        {
            lblUserID.Text = string.Format("{0}", value);
            _Username = lblUserID.Text;
            HoverMenuExtenderlblUserID.DynamicContextKey = _Username;
            if (lblUserID.Text.Length == 0)
                lblPrefix.Text = "";
        }
        get
        {
            return _Username.Trim().Replace("&nbsp;", "");
        }
    }

    public string Position
    {
        set
        {
            try
            {
                if (value.ToString().ToUpper() == "LEFT")
                    HoverMenuExtenderlblUserID.PopupPosition = AjaxControlToolkit.HoverMenuPopupPosition.Left;
            }
            catch (Exception)
            {
                HoverMenuExtenderlblUserID.PopupPosition = AjaxControlToolkit.HoverMenuPopupPosition.Right;
                UserInfo.Width = Unit.Empty;
            }
        }
    }

    public string Prefix
    {
        set
        {
            lblPrefix.Text = string.Format("{0}", value);
            _Prefix = lblPrefix.Text;
        }
        get
        {
            return _Prefix.Trim().Replace("&nbsp;", "");
        }
    }
}