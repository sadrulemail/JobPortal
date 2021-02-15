<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPage.master"
    AutoEventWireup="true" CodeFile="RIT_Show.aspx.cs"
    Inherits="RIT_Show" %>

<%@ Register Src="EMP.ascx" TagName="EMP" TagPrefix="uc2" %>
<%@ Register Src="TrustControl.ascx" TagName="TrustControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <asp:Label ID="lblTItle" runat="server" Text="RIT Show"></asp:Label>
    <style >
        .max-width {
            max-width: 350px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder2" runat="Server">
    <uc1:TrustControl ID="TrustControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table class="Panel1">
                <tr>
                    <td style="padding-left: 7px">Branch:</td>
                    <td>
                        <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:TblUserDBConnectionString %>"
                            SelectCommand="SELECT BranchName, BranchID FROM [ViewBranch] where BranchID <> 1 and (CommonBranchID = @BranchID OR @BranchID = 1) order by BranchName" EnableCaching="false" CacheDuration="600">

                            <SelectParameters>
                                <asp:SessionParameter Name="BranchID" SessionField="BRANCHID" />
                            </SelectParameters>
                        </asp:SqlDataSource>
                        <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="SqlDataSource1" AutoPostBack="true"
                            ToolTip="Branch" DataTextField="BranchName" DataValueField="BranchID" AppendDataBoundItems="true" OnDataBound="DropDownList1_DataBound" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged">
                            <asp:ListItem Value="-1" Text="All Branch"></asp:ListItem>
                            <asp:ListItem Value="1" Text="Head Office"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="padding-left: 7px">File:</td>
                    <td>
                        <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:Report_DBConnectionString %>"
                            SelectCommand="SELECT  FileID, FileName FROM dbo.RITFileName" EnableCaching="false" CacheDuration="600"></asp:SqlDataSource>
                        <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="SqlDataSource2" AutoPostBack="true"
                            ToolTip="File" DataTextField="FileName" DataValueField="FileID" AppendDataBoundItems="true" OnDataBound="DropDownList2_DataBound" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged">
                            <asp:ListItem></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                    <td style="padding-left: 7px">File Date:</td>
                    <td>
                        <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:Report_DBConnectionString %>"
                            SelectCommand="SELECT BachID, FileDate FROM dbo.RITFileBach where FileID = @FileID ORDER BY FileDate DESC" EnableCaching="false" CacheDuration="600">
                            <SelectParameters>
                                <asp:QueryStringParameter Name="FileID" QueryStringField="fileid" />

                            </SelectParameters>

                        </asp:SqlDataSource>
                        <asp:DropDownList ID="DropDownList3" runat="server" DataSourceID="SqlDataSource3" AutoPostBack="true"
                            ToolTip="File Date" DataTextField="FileDate" DataTextFormatString="{0:dd/MM/yyyy}" DataValueField="BachID" AppendDataBoundItems="true" OnDataBound="DropDownList3_DataBound" OnSelectedIndexChanged="DropDownList3_SelectedIndexChanged">
                            <asp:ListItem></asp:ListItem>
                        </asp:DropDownList></td>
                </tr>
            </table>

            <asp:GridView ID="GridView1" CssClass="Grid" runat="server"
                AutoGenerateColumns="False"
                BackColor="White"
                BorderColor="#DEDFDE"
                BorderStyle="None"
                BorderWidth="1px"
                CellPadding="4"
                DataKeyNames="ID"
                DataSourceID="SqlItemListGrid"
                ForeColor="Black"
                GridLines="Vertical"
                AllowPaging="true"
                OnRowDataBound="GridView1_RowDataBound"
                AllowSorting="true"
                OnRowUpdating="GridView1_RowUpdating1">
                <AlternatingRowStyle BackColor="White" />
                <Columns>
                    <asp:TemplateField HeaderText="SL" SortExpression="SL">

                        <ItemTemplate>
                            <div title='Field:<%# Eval("FieldID") %>, ID:<%# Eval("ID") %>'><%# Eval("SL") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="FieldName" HeaderText="Field Name" SortExpression="FieldName" ReadOnly="true" ItemStyle-CssClass="max-width">
                        <ItemStyle CssClass="max-width" />
                    </asp:BoundField>
                    <asp:BoundField DataField="FieldDescription" HeaderText="Description" SortExpression="FieldDescription" ReadOnly="true" ItemStyle-CssClass="max-width">
                        <ItemStyle CssClass="max-width" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Value" SortExpression="Value">
                        <EditItemTemplate>
                            <asp:TextBox ID="txtValue" runat="server" Text='<%# Eval("Value") %>' MaxLength="500"></asp:TextBox>
                            <asp:RegularExpressionValidator runat="server" ID="RegularExpressionValidator1" ControlToValidate="txtValue" ValidationExpression='<%# Eval("RegEx") %>' ErrorMessage="Invalid Data" ForeColor="red" SetFocusOnError="true" Display="Dynamic"></asp:RegularExpressionValidator>
                            <asp:HiddenField runat="server" ID="hidDomainValues" Value='<%# Eval("DomainValues") %>' />
                            <asp:DropDownList ID="dboValue" runat="server"></asp:DropDownList>
                            <br />
                            <asp:LinkButton ID="lblUpdate" runat="server" CommandName="Update">Update</asp:LinkButton>
                            <asp:LinkButton ID="lblCancel" CausesValidation="false" runat="server" CommandName="Cancel">Cancel</asp:LinkButton>
                        </EditItemTemplate>
                        <ItemTemplate>
                            <%# Eval("Value") %>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="lblEdit" runat="server" CausesValidation="false" CommandName="Edit" Visible='<%# (bool)(Eval("isEditable")) %>'>Edit</asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                        </EditItemTemplate>

                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Insert On" SortExpression="InsertDT">
                        <ItemTemplate>
                            <%--<span title='<%# Eval("InsertDT", "{0:dddd, dd MMMM yyyy, hh:mm:ss tt}")%>'>
                                 <%# Eval("InsertDT")%></span><br />--%>
                            <div title='<%# Eval("InsertDT","{0:dddd \ndd MMMM, yyyy \nh:mm:ss tt}") %>'>
                                <%# TrustControl1.ToRecentDateTime(Eval("InsertDT")) %><br />
                                <time class='timeago' datetime='<%# Eval("InsertDT", "{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                            </div>

                        </ItemTemplate>
                        <ItemStyle Font-Size="90%" ForeColor="Gray" />
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="By" SortExpression="InsertBy">
                        <ItemTemplate>


                            <uc2:EMP ID="EMP1" runat="server" Username='<%# Eval("InsertBy") %>' />
                        </ItemTemplate>
                        <ItemStyle Font-Size="90%" ForeColor="Gray" HorizontalAlign="Center" />
                    </asp:TemplateField>

                </Columns>
                <PagerSettings Position="TopAndBottom" />
                <FooterStyle BackColor="#CCCC99" />
                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Left" CssClass="PagerStyle" />
                <RowStyle BackColor="#F7F7DE" VerticalAlign="Top" />
                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                <SortedAscendingCellStyle BackColor="#FBFBF2" />
                <SortedAscendingHeaderStyle BackColor="#848384" />
                <SortedDescendingCellStyle BackColor="#EAEAD3" />
                <SortedDescendingHeaderStyle BackColor="#575357" />
            </asp:GridView>

            <asp:SqlDataSource ID="SqlItemListGrid" runat="server" ConnectionString="<%$ ConnectionStrings:Report_DBConnectionString %>"
                SelectCommand="s_RIT_Select" SelectCommandType="StoredProcedure" OnSelected="SqlItemListGrid_Selected"
                ProviderName="<%$ ConnectionStrings:Report_DBConnectionString.ProviderName %>" UpdateCommand="s_RIT_Update" UpdateCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:ControlParameter ControlID="DropDownList3" Name="BachID" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="DropDownList1" Name="BranchID" PropertyName="SelectedValue" />
                    <%--<asp:QueryStringParameter Name="BachID" QueryStringField="batch" />
                    <asp:QueryStringParameter Name="BranchID" QueryStringField="Branch" />--%>
                </SelectParameters>

                <UpdateParameters>
                    <asp:Parameter Name="ID" Type="Int32" />
                    <asp:Parameter DefaultValue="" Name="Value" Type="String" />
                    <asp:SessionParameter Name="ByEmp" SessionField="EMPID" Type="String" />
                    <asp:Parameter DefaultValue=" " Direction="InputOutput" Size="255" Name="Msg" Type="String" />
                    <asp:Parameter DefaultValue="false" Direction="InputOutput" Name="Done" Type="Boolean" />
                </UpdateParameters>

            </asp:SqlDataSource>
            <br />
            <asp:Label ID="lblTotal" runat="server" Text=""></asp:Label>
            <asp:Button ID="cmdExport" runat="server" Text="Download as xlsx" Visible="false" Width="150px" Height="30px"
                Font-Bold="true" OnClick="cmdExport_Click" />
        </ContentTemplate>
         <Triggers>
            <asp:PostBackTrigger ControlID="cmdExport" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>


