using System;

public partial class Branch : System.Web.UI.UserControl
{
    private string _BranchID = string.Empty;

    public string BranchID
    {
        set
        {
            lblBranchID.Text = string.Format("{0}", value);
            _BranchID = string.Format("{0}", value);
            HoverMenuExtenderlblBranchID.DynamicContextKey = _BranchID;
        }
        get
        {
            return _BranchID.Trim().Replace("&nbsp;", "");
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
    }
}