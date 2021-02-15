<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style type="text/css">
        .style2
        {
            font-size: x-large;
            font-weight: bold;
            color: silver;
        }
        .style3
        {
            font-size: small;
        }
        .style5
        {
            color: #666666;
        }
        .ROW2
        {
            background-image: url( 'Images/bg7.gif' );
            background-position: top;
            background-repeat: repeat-x;
            background-color: White;
            cursor: default;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    Home
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:Panel ID="Panel1" runat="server" Style="text-align: left">
        <table>
            <tr>
                <td valign="top" style="padding: 10px 0px 30px 10px" colspan="2">
                    <table style="font-weight: bold;" cellpadding="10px">
                        <tr>
                            <td align="center">
                                <a href="ChequeRequisition.aspx" class="Link" title="New Requisition">
                                    <img src="Images/cheque.png" class="imagebutton" /><br />
                                    New Request</a>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td valign="bottom">
                    <div class="style2">
                        you logged in as</div>
                    <table cellspacing="0" class="Panel1 ui-corner-all" cellpadding="10px">
                        <tr>
                            <td>
                                <b><span class="style3"><span class="style5">Branch:<br />
                                </span>
                                    <asp:DropDownList ID="cboBranch" runat="server" AppendDataBoundItems="True" DataSourceID="SqlDataSourceBranch"
                                        BackColor="Yellow" Font-Bold="true" ForeColor="Navy" DataTextField="BranchName"
                                        DataValueField="BranchID" Enabled="False" OnDataBound="cboBranch_DataBound">
                                        <asp:ListItem Value="0">All Branch</asp:ListItem>
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceBranch" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                        SelectCommand="SELECT [BranchID], [BranchName] FROM [ViewBranch] where BranchID = @BranchID">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="BranchID" SessionField="BRANCHID" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </span></b>
                            </td>
                            <td>
                                <b><span class="style3"><span class="style5">Department:<br />
                                </span>
                                    <asp:DropDownList ID="cboDept" runat="server" DataSourceID="SqlDataSourceDepartment"
                                        BackColor="Yellow" Font-Bold="true" ForeColor="Navy" DataTextField="Department"
                                        DataValueField="DeptID" Enabled="False" OnDataBound="cboDept_DataBound">
                                    </asp:DropDownList>
                                    <asp:SqlDataSource ID="SqlDataSourceDepartment" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                                        SelectCommand="SELECT [DeptID], [Department] FROM [viewDept] WHERE DeptID = @DeptID">
                                        <SelectParameters>
                                            <asp:SessionParameter Name="DeptID" SessionField="DEPTID" />
                                        </SelectParameters>
                                    </asp:SqlDataSource>
                                </span></b>
                            </td>
                        </tr>
                    </table>
                </td>
                <td rowspan="2" valign="bottom">
                    <asp:HyperLink runat="server" ID="ApplicationLogoBig" ImageUrl="" CssClass="applogobig" Style="margin: 100px;"></asp:HyperLink>
                </td>
            </tr>
        </table>
    </asp:Panel>
    <p>
        <br />
    </p>
    <p>
    </p>
</asp:Content>
