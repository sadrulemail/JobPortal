using OfficeOpenXml;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class RIT_Show : System.Web.UI.Page
{
    string BranchID = "";
    string FileID = "";
    string BatchID = "";

    protected void cmdExport_Click(object sender, EventArgs e)
    {
        try
        {
            string FileName = Path.GetTempFileName();
            if (File.Exists(FileName)) File.Delete(FileName);
            FileInfo FI = new FileInfo(FileName);
            using (ExcelPackage xlPackage = new ExcelPackage(FI))
            {
                ExcelWorksheet worksheet = xlPackage.Workbook.Worksheets.Add("RIT");
                int StartRow = 1;
               
                worksheet.Cells[StartRow, 1].Value = "Item Name";
                worksheet.Cells[StartRow, 2].Value = "Item Value";               

                worksheet.Column(1).Width = 80;
                worksheet.Column(2).Width = 15;  

                DataView DV = (DataView)SqlItemListGrid.Select(DataSourceSelectArguments.Empty);
                for (int r = 0; r < DV.Table.Rows.Count; r++)
                {
                    int R = StartRow + r + 1;

                    if (DV.Table.Rows[r]["FieldName"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 1].Value = DV.Table.Rows[r]["FieldName"].ToString();
                        
                    }

                    if (DV.Table.Rows[r]["Value"] != DBNull.Value)
                    {
                        worksheet.Cells[R, 2].Value = DV.Table.Rows[r]["Value"].ToString();                        
                    }   
                }

                worksheet.Cells["A1:B1"].Style.Font.Bold = true;

                xlPackage.Workbook.Properties.Title = "RIT Reporting";
                xlPackage.Workbook.Properties.Author = "Administrator";
                xlPackage.Workbook.Properties.Company = "Trust Bank Limited";              

                xlPackage.Save();
            }
           
            byte[] content = File.ReadAllBytes(FileName);
            File.Delete(FileName);

            string oConnString = System.Configuration.ConfigurationManager.ConnectionStrings["Report_DBConnectionString"].ConnectionString;
            SqlConnection oConn = new SqlConnection(oConnString);
            SqlCommand oCommand = new SqlCommand("s_RIT_Complete_Batch", oConn);
            oCommand.CommandType = CommandType.StoredProcedure;

            oCommand.Parameters.AddWithValue("ByEmp", Session["EmpID"].ToString());
            oCommand.Parameters.AddWithValue("Batch", DropDownList3.SelectedValue.ToString());
            
            SqlDataAdapter da = new SqlDataAdapter(oCommand);
            DataSet ds = new DataSet();
            ds.Clear();
            da.Fill(ds);

            //Downloading File
            Response.Clear();
            Response.ClearContent();
            Response.ClearHeaders();
            Response.ContentType = "application/xlsx";
            Response.AddHeader("Content-Disposition", "attachment;filename=" + "RIT.xlsx");
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.BinaryWrite(content);
            Response.End();
        }
        catch (Exception ex)
        {
            //lblStatus.Text = ex.Message;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        TrustControl1.getUserRoles();
        if (!IsPostBack)
        {
            Title = string.Format("#{0} - RIT Batch", Request.QueryString["batch"]);
            lblTItle.Text = string.Format("RIT Batch: {0}", Request.QueryString["batch"]);

            BranchID = string.Format("{0}", Request.QueryString["branch"]);
            FileID = string.Format("{0}", Request.QueryString["fileid"]);
            BatchID = string.Format("{0}", Request.QueryString["batch"]);
        }
    }
    protected void SqlItemListGrid_Selected(object sender, SqlDataSourceStatusEventArgs e)
    {
        lblTotal.Text = string.Format("Total: <b>{0}</b>", e.AffectedRows);
        if (e.AffectedRows > 0)
            cmdExport.Visible = true;
        else
            cmdExport.Visible = false;
    }
    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.BackColor = System.Drawing.ColorTranslator.FromHtml(string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "BGCOLOR")));
        string Val = string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "Value"));
        
        if (e.Row.RowType == DataControlRowType.DataRow 
            && ((e.Row.RowState & DataControlRowState.Edit) > 0))
        {
            string DomainValues = string.Format("{0}", DataBinder.Eval(e.Row.DataItem, "DomainValues"));
            DropDownList dboValue = ((DropDownList)e.Row.FindControl("dboValue"));
            TextBox txtValue = ((TextBox)e.Row.FindControl("txtValue"));

            foreach (string s in DomainValues.Split('|'))
            {
                if (s.Trim().Length > 0)
                {
                    ListItem LI = new ListItem();
                    LI.Text = s;
                    LI.Value =s;
                    dboValue.Items.Add(LI);
                    if (s == Val) LI.Selected = true;
                }
            }
            dboValue.Visible = dboValue.Items.Count > 0;
            txtValue.Visible = !dboValue.Visible;                           
        }        
    }
    protected void DropDownList1_DataBound(object sender, EventArgs e)
    {
        if (Session["BRANCHID"].ToString() != "1")
            foreach (ListItem LI in DropDownList1.Items)
                if (LI.Value == "-1") LI.Enabled = false;
                else if (LI.Value == "1") LI.Enabled = false;

        foreach (ListItem LI in DropDownList1.Items)
            LI.Selected = false;

        foreach (ListItem LI in DropDownList1.Items)
            if (LI.Value == BranchID) LI.Selected = true;
    }
    protected void DropDownList2_DataBound(object sender, EventArgs e)
    {
        foreach (ListItem LI in DropDownList2.Items)
            LI.Selected = false;

        foreach (ListItem LI in DropDownList2.Items)
            if (LI.Value == FileID) LI.Selected = true;
    }
    protected void DropDownList3_DataBound(object sender, EventArgs e)
    {
        foreach (ListItem LI in DropDownList3.Items)
            LI.Selected = false;

        foreach (ListItem LI in DropDownList3.Items)
            if (LI.Value == BatchID) LI.Selected = true;
    }
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        RedirectUrl();
    }
    private void RedirectUrl()
    {
        Response.Redirect(string.Format("RIT_Show.aspx?batch={2}&branch={0}&fileid={1}"
            , DropDownList1.SelectedItem.Value
            , DropDownList2.SelectedItem.Value
            , DropDownList3.SelectedItem.Value
            ), true);
    }
    protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        RedirectUrl();
    }
    protected void DropDownList3_SelectedIndexChanged(object sender, EventArgs e)
    {
        RedirectUrl();
    }
    protected void GridView1_RowEditing(object sender, GridViewEditEventArgs e)
    {
        
    }
    protected void GridView1_RowUpdating1(object sender, GridViewUpdateEventArgs e)
    {
        string Val = "";
        try
        {
            DropDownList dboValue = ((DropDownList)GridView1.Rows[e.RowIndex].Cells[4].FindControl("dboValue"));
            if (dboValue.Visible)
                Val = dboValue.SelectedItem.Value;
        }
        catch (Exception) { }

        try
        {
            TextBox txtValue = ((TextBox)GridView1.Rows[e.RowIndex].Cells[4].FindControl("txtValue"));
            if (txtValue.Visible)
            Val = txtValue.Text.Trim();
        }
        catch (Exception) { }

        e.NewValues["Value"] = Val;
    }
}