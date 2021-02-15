<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeBehind="MyCV.aspx.cs" Inherits="JobPortal.MyCV"
    EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="UserControl.ascx" TagName="UserControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="CpTitle" runat="server">
    <script type="text/javascript">
        function storeCoords(c) {
            $('#ctl00_CpBody_TabContainer1_tabpanelPic_X').val(c.x);
            $('#ctl00_CpBody_TabContainer1_tabpanelPic_Y').val(c.y);
            $('#ctl00_CpBody_TabContainer1_tabpanelPic_W').val(c.w);
            $('#ctl00_CpBody_TabContainer1_tabpanelPic_H').val(c.h);
        };
        function getReadableFileSizeString(fileSizeInBytes) {
            var i = -1;
            var byteUnits = [' KB', ' MB', ' GB', ' TB', 'PB', 'EB', 'ZB', 'YB'];
            do {
                fileSizeInBytes = fileSizeInBytes / 1024;
                i++;
            } while (fileSizeInBytes > 1024);
            return Math.max(fileSizeInBytes, 0.1).toFixed(2) + byteUnits[i];
        }
        function AsyncFileUpload1_StartUpload(sender, args) {
            var filename = args.get_fileName();
            var ext = filename.substring(filename.lastIndexOf(".") + 1);
            if (ext.toLowerCase() == 'jpg') {
                $('#ctl00_CpBody_TabContainer1_tabpanelPic_lblUploadStatus').html("<b>" + args.get_fileName() + "</b> is uploading...");
            }
            else {
                $('#UploadBtn').hide('Slow');
                $('#ctl00_CpBody_TabContainer1_tabpanelPic_lblUploadStatus').html("Only JPG files can be uploaded.");
                throw {
                    name: "Invalid File Type",
                    level: "Error",
                    message: "Only <b>JPG</b> files can be uploaded. ",
                    htmlMessage: "Only JPG files can be uploaded. "
                }
                return false;
            }
        }
        function UploadError(sender, args) {
            $('#ctl00_CpBody_TabContainer1_tabpanelPic_lblUploadStatus').html(args.get_errorMessage() + "File Uploading Error. Please try again.");
            $('#UploadBtn').hide('Slow');
        }
        function UploadComplete(sender, args) {
            var filename = args.get_fileName();
            var TryAgain = '<br /><br /><a href="Profile_Upload.aspx" class="Button">Try Again</a>';
            var contentType = args.get_contentType();
            var text = "Size of " + filename + " is " + args.get_length() + " bytes";
            if (contentType.length > 0) {
                text += " and content type is '" + contentType + "'.";
            }
            if (contentType != 'image/jpeg') {
                $('#UploadBtn').hide();
                $('#ctl00_CpBody_TabContainer1_tabpanelPic_lblUploadStatus').html('Only JPG files are allowed to upload.' + TryAgain);
            }
            else if (args.get_length() > (1024 * 1024 * 2)) {
                $('#UploadBtn').hide();
                $('#ctl00_CpBody_TabContainer1_tabpanelPic_lblUploadStatus').html('File size must be less than 2 MB.' + TryAgain);
            }
            else {
                $('#UploadBtn').show('Slow');
                $('#ctl00_CpBody_TabContainer1_tabpanelPic_lblUploadStatus').html('<b>' + filename + '</b> is successfully uploaded. (' + getReadableFileSizeString(args.get_length()) + ')<br>');
            }
        }
    </script>
    <style>
        .AsyncFileUploadField input {
            width: 98% !important;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="CpBody" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
    <uc1:UserControl ID="UserControl1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:TabContainer ID="TabContainer1" runat="server" CssClass="tabVertical" OnDemand="false"
                EnableViewState="true"
                Width="930px" ActiveTabIndex="0" OnActiveTabChanged="TabContainer1_ActiveTabChanged"
                UseVerticalStripPlacement="true" VerticalStripWidth="200px">

                <asp:TabPanel runat="server" ID="tabPersonal">
                    <HeaderTemplate>
                        Personal Info
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Personal and Contact Info</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewPersonal" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered" GridLines="None"
                                DataSourceID="SqlDataSourcePersonal" DataKeyNames="ID" OnItemCommand="DetailsViewPersonal_ItemCommand"
                                OnDataBound="DetailsViewPersonal_DataBound">

                                <EmptyDataTemplate>
                                    To add your personal and contact info please click:
                            <asp:LinkButton runat="server" ID="cmdNewPersonal" CommandName="New" Visible='<%# getIsEditable() %>'>
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            Address
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Present" SortExpression="Present_Address">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPresent_Address" runat="server" Text='<%# Eval("Present_Address") %>'></asp:Label>
                                            <br />
                                            Location:
                                            <div class="location-path">
                                                <%# Eval("DIV_NAME","<span title='Division'>{0}</span>")%>
                                                <%# Eval("DIST_NAME", "» <span title='District'>{0}</span>")%>
                                                <%# Eval("THANA_NAME", "» <span title='Thana'>{0}</span>")%>
                                            </div>
                                            Contact No.:
                                            <%# Eval("Present_ContactNo")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPresentAddress" runat="server" Text='<%# Bind("Present_Address") %>'
                                                Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPadd" runat="server" ControlToValidate="txtPresentAddress"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            <div style="padding-top: 10px">
                                                Location:
                                                <br />
                                                <asp:SqlDataSource ID="SqlDataSourceDivision" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT DIV_CODE, DIV_NAME FROM [dbo].[BD_Division]"></asp:SqlDataSource>
                                                <asp:DropDownList ID="dboDivision2" runat="server" AppendDataBoundItems="true" AutoPostBack="True"
                                                    DataSourceID="SqlDataSourceDivision" DataTextField="DIV_NAME" DataValueField="DIV_CODE"
                                                    OnSelectedIndexChanged="dboDivision2_SelectedIndexChanged1" SelectedValue='<%# Eval("Div_Code") %>'>
                                                    <asp:ListItem Text="Select Division" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDiv" runat="server" ControlToValidate="dboDivision2"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:HiddenField ID="hidDistrict" runat="server" Value='<%# Eval("Dist_Code") %>' />
                                                <asp:HiddenField ID="hidThana" runat="server" Value='<%# Eval("Present_ThanaID") %>' />
                                                <asp:SqlDataSource ID="SqlDataSourceDistrict" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT DIST_CODE, DIST_NAME FROM [dbo].[BD_District] WHERE DIV_CODE = @DIV_CODE ORDER BY DIST_NAME">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="dboDivision2" Name="DIV_CODE" PropertyName="SelectedValue" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:DropDownList ID="dboDistrict2" runat="server" AutoPostBack="True" CausesValidation="false"
                                                    DataSourceID="SqlDataSourceDistrict" DataTextField="DIST_Name" DataValueField="DIST_CODE"
                                                    EnableViewState="true" OnDataBound="dboDistrict2_DataBound" OnSelectedIndexChanged="dboDistrict2_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:SqlDataSource ID="SqlDataSourceThana" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT [THANA_CODE],[THANA_NAME] FROM [dbo].[BD_Thana] WHERE DIST_CODE = @DIST_CODE ORDER BY THANA_NAME">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="dboDistrict2" Name="DIST_CODE" PropertyName="SelectedValue" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:DropDownList ID="dboThana2" runat="server" DataSourceID="SqlDataSourceThana"
                                                    DataTextField="THANA_NAME" DataValueField="THANA_CODE" OnDataBound="dboThana2_DataBound">
                                                </asp:DropDownList>
                                            </div>
                                            <div style="padding-top: 10px">
                                                Contact No.
                                                <br />
                                                <asp:TextBox ID="txtPCNo" Width="200px" MaxLength="100" runat="server" Text='<%# Bind("Present_ContactNo") %>'></asp:TextBox>
                                            </div>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtPresentAddress" runat="server" Text='<%# Bind("Present_Address") %>'
                                                Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPadd" runat="server" ControlToValidate="txtPresentAddress"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            <div style="padding-top: 10px">
                                                Location:
                                                <br />
                                                <asp:SqlDataSource ID="SqlDataSourceDivision" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT DIV_CODE, DIV_NAME FROM [dbo].[BD_Division]"></asp:SqlDataSource>
                                                <asp:DropDownList ID="dboDivision2" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSourceDivision"
                                                    DataTextField="DIV_NAME" DataValueField="DIV_CODE" SelectedValue='<%# Eval("Div_Code") %>'>
                                                    <asp:ListItem Text="Select Division" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDiv" runat="server" ControlToValidate="dboDivision2"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:DropDownList ID="dboDistrict2" runat="server" SelectedValue='<%# Eval("Dist_Code") %>'>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDist" runat="server" ControlToValidate="dboDistrict2"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:CascadingDropDown ID="CascadingDropDown1" runat="server" Category="District"
                                                    LoadingText="Loading..." ParentControlID="dboDivision2" PromptText="Select District"
                                                    ServiceMethod="GetDropDownContents_District" ServicePath="WebService.asmx" TargetControlID="dboDistrict2" />
                                                <asp:DropDownList ID="dboThana2" runat="server" SelectedValue='<%# Eval("Thana_Code") %>'>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorThana" runat="server" ControlToValidate="dboThana2"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:CascadingDropDown ID="CascadingDropDown2" runat="server" Category="Thana" LoadingText="Loading..."
                                                    ParentControlID="dboDistrict2" PromptText="Select Thana" ServiceMethod="GetDropDownContents_Thana"
                                                    ServicePath="WebService.asmx" TargetControlID="dboThana2" />
                                            </div>
                                            <div style="padding-top: 10px">
                                                Contact No.
                                                <br />
                                                <asp:TextBox ID="txtPCNo" Width="200px" MaxLength="100" runat="server" Text='<%# Bind("Present_ContactNo") %>'></asp:TextBox>
                                            </div>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Permanent" SortExpression="Permanent_Address">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPemanentAddress" runat="server" Text='<%# Eval("Permanent_Address") %>'></asp:Label>
                                            <br />
                                            Location:
                                            <div class="location-path">
                                                <%# Eval("DIV_NAME","<span title='Division'>{0}</span>")%>
                                                <%# Eval("DIST_NAME", "» <span title='District'>{0}</span>")%>
                                                <%# Eval("THANA_NAME", "» <span title='Thana'>{0}</span>")%>
                                            </div>
                                            Contact No.:
                                            <%# Eval("Permanent_ContactNo")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPermanentAddress" runat="server" Text='<%# Bind("Permanent_Address") %>'
                                                Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPradd" runat="server" ControlToValidate="txtPermanentAddress"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            <div style="padding-top: 10px">
                                                Location:
                                                <br />
                                                <asp:SqlDataSource ID="SqlDataSourceDivisionP" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT DIV_CODE, DIV_NAME FROM [dbo].[BD_Division]"></asp:SqlDataSource>
                                                <asp:DropDownList ID="dboDivisionP" runat="server" AppendDataBoundItems="true" AutoPostBack="True"
                                                    DataSourceID="SqlDataSourceDivisionP" DataTextField="DIV_NAME" DataValueField="DIV_CODE"
                                                    OnSelectedIndexChanged="dboDivisionP_SelectedIndexChanged1" SelectedValue='<%# Eval("Per_DIV_CODE") %>'>
                                                    <asp:ListItem Text="Select Division" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDivP" runat="server" ControlToValidate="dboDivisionP"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:HiddenField ID="hidDistrictP" runat="server" Value='<%# Eval("Per_Dist_Code") %>' />
                                                <asp:HiddenField ID="hidThanaP" runat="server" Value='<%# Eval("Permanent_ThanaID") %>' />
                                                <asp:SqlDataSource ID="SqlDataSourceDistrictP" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT DIST_CODE, DIST_NAME FROM [dbo].[BD_District] WHERE DIV_CODE = @DIV_CODE ORDER BY DIST_NAME">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="dboDivisionP" Name="DIV_CODE" PropertyName="SelectedValue" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:DropDownList ID="dboDistrictP" runat="server" AutoPostBack="True" CausesValidation="false"
                                                    DataSourceID="SqlDataSourceDistrictP" DataTextField="DIST_Name" DataValueField="DIST_CODE"
                                                    EnableViewState="true" OnDataBound="dboDistrictP_DataBound" OnSelectedIndexChanged="dboDistrictP_SelectedIndexChanged">
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDistP" runat="server" ControlToValidate="dboDistrictP"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:SqlDataSource ID="SqlDataSourceThanaP" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT [THANA_CODE],[THANA_NAME] FROM [dbo].[BD_Thana] WHERE DIST_CODE = @DIST_CODE ORDER BY THANA_NAME">
                                                    <SelectParameters>
                                                        <asp:ControlParameter ControlID="dboDistrictP" Name="DIST_CODE" PropertyName="SelectedValue" />
                                                    </SelectParameters>
                                                </asp:SqlDataSource>
                                                <asp:DropDownList ID="dboThanaP" runat="server" DataSourceID="SqlDataSourceThanaP"
                                                    DataTextField="THANA_NAME" DataValueField="THANA_CODE" OnDataBound="dboThanaP_DataBound">
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorThanaP" runat="server" ControlToValidate="dboThanaP"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            </div>
                                            <div style="padding-top: 10px">
                                                Contact No.
                                                <br />
                                                <asp:TextBox ID="txtPRNo" Width="200px" MaxLength="100" runat="server" Text='<%# Bind("Permanent_ContactNo") %>'></asp:TextBox>
                                            </div>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtPermanentAddress" runat="server" Text='<%# Bind("Permanent_Address") %>'
                                                Width="300px" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPradd" runat="server" ControlToValidate="txtPermanentAddress"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            <div style="padding-top: 10px">
                                                Location:<br>
                                                <asp:SqlDataSource ID="SqlDataSourceDivisionP" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                    SelectCommand="SELECT DIV_CODE, DIV_NAME FROM [dbo].[BD_Division]"></asp:SqlDataSource>
                                                <asp:DropDownList ID="dboDivisionP" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSourceDivisionP"
                                                    DataTextField="DIV_NAME" DataValueField="DIV_CODE" SelectedValue='<%# Eval("Div_Code") %>'>
                                                    <asp:ListItem Text="Select Division" Value=""></asp:ListItem>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDivP" runat="server" ControlToValidate="dboDivisionP"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:DropDownList ID="dboDistrictP" runat="server" SelectedValue='<%# Eval("Dist_Code") %>'>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorDistP" runat="server" ControlToValidate="dboDistrictP"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:CascadingDropDown ID="CascadingDropDownP" runat="server" Category="District"
                                                    LoadingText="Loading..." ParentControlID="dboDivisionP" PromptText="Select District"
                                                    ServiceMethod="GetDropDownContents_District" ServicePath="WebService.asmx" TargetControlID="dboDistrictP" />
                                                <asp:DropDownList ID="dboThanaP" runat="server" SelectedValue='<%# Eval("Thana_Code") %>'>
                                                </asp:DropDownList>
                                                <asp:RequiredFieldValidator ID="RequiredFieldValidatorThanaP" runat="server" ControlToValidate="dboThanaP"
                                                    ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                                <asp:CascadingDropDown ID="CascadingDropDownP2" runat="server" Category="Thana" LoadingText="Loading..."
                                                    ParentControlID="dboDistrictP" PromptText="Select Thana" ServiceMethod="GetDropDownContents_Thana"
                                                    ServicePath="WebService.asmx" TargetControlID="dboThanaP" />
                                            </div>
                                            <div style="padding-top: 10px">
                                                Contact No.
                                                <br />
                                                <asp:TextBox ID="txtPRNo" Width="200px" MaxLength="100" runat="server" Text='<%# Bind("Permanent_ContactNo") %>'></asp:TextBox>
                                            </div>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            Personal Information
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Full Name" SortExpression="FullName">
                                        <ItemTemplate>
                                            <%# Eval("FullName")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtFullName" Width="380px" runat="server" Text='<%# Bind("FullName") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFullName" runat="server" ControlToValidate="txtFullName"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtFullName" Width="380px" runat="server" Text='<%# Bind("FullName") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFullName1" runat="server" ControlToValidate="txtFullName"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Mobile" SortExpression="Mobile">
                                        <ItemTemplate>
                                            <%# Eval("Mobile")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMobile" CssClass="form-control" clientid="txtMobile" Text='<%# Bind("Mobile") %>' runat="server" required></asp:TextBox>
                                            <span id="valid-msg" class="hide glyphicon glyphicon-ok form-control-feedback text-right"></span>
                                            <span id="error-msg" class="hide glyphicon glyphicon-remove form-control-feedback text-right"></span>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtMobile" CssClass="form-control" clientid="txtMobile" Text='<%# Bind("Mobile") %>' runat="server" required></asp:TextBox>
                                            <span id="valid-msg" class="hide glyphicon glyphicon-ok form-control-feedback text-right"></span>
                                            <span id="error-msg" class="hide glyphicon glyphicon-remove form-control-feedback text-right"></span>

                                        </InsertItemTemplate>
                                    </asp:TemplateField>



                                    <asp:TemplateField HeaderText="Date of Birth" SortExpression="DOB">
                                        <ItemTemplate>
                                            <%# Eval("DOB", "{0:dd/MM/yyyy}")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox CssClass="Date-DOB" ID="txtDOB" Width="80px" runat="server" Text='<%# Bind("DOB","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDOB" runat="server" ControlToValidate="txtDOB"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            Gender:
                                            <asp:DropDownList ID="cboGender" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Gender") %>'>
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Male" Value="Male"></asp:ListItem>
                                                <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorGender" runat="server" ControlToValidate="cboGender"
                                                ValidationGroup="tabPersonal" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            Religion:
                                            <asp:DropDownList ID="cboReligion" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Religion") %>'>
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Islam" Value="Islam"></asp:ListItem>
                                                <asp:ListItem Text="Hinduism" Value="Hinduism"></asp:ListItem>
                                                <asp:ListItem Text="Buddhism" Value="Buddhism"></asp:ListItem>
                                                <asp:ListItem Text="Christianity" Value="Christianity"></asp:ListItem>
                                                <asp:ListItem Text="Others" Value="Others"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorReligion" runat="server" ControlToValidate="cboReligion"
                                                ValidationGroup="tabPersonal" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox CssClass="Date-DOB" ID="txtDOB" Width="80px" runat="server" Text='<%# Bind("DOB","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDOB" runat="server" ControlToValidate="txtDOB"
                                                ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            Gender:
                                            <asp:DropDownList ID="cboGender" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Gender") %>'>
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Male" Value="Male"></asp:ListItem>
                                                <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorGender" runat="server" ControlToValidate="cboGender"
                                                ValidationGroup="tabPersonal" ErrorMessage="*"></asp:RequiredFieldValidator>
                                            Religion:
                                            <asp:DropDownList ID="cboReligion" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Religion") %>'>
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                                <asp:ListItem Text="Islam" Value="Islam"></asp:ListItem>
                                                <asp:ListItem Text="Hinduism" Value="Hinduism"></asp:ListItem>
                                                <asp:ListItem Text="Buddhism" Value="Buddhism"></asp:ListItem>
                                                <asp:ListItem Text="Christianity" Value="Christianity"></asp:ListItem>
                                                <asp:ListItem Text="Others" Value="Others"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorReligion" runat="server" ControlToValidate="cboReligion"
                                                ValidationGroup="tabPersonal" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Marital Status" SortExpression="Marital_Status_ID">
                                        <ItemTemplate>
                                            <%# Eval("Marital_Status_ID")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboMStatus" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSourceMStatus"
                                                DataTextField="MaritalStatusName" DataValueField="ID" SelectedValue='<%# Bind("Marital_Status_ID") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceMStatus" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT ID, MaritalStatusName FROM [MaritalStatus] ORDER BY OrderCol"></asp:SqlDataSource>
                                            &nbsp; &nbsp; Place of Birth:
                                            <asp:DropDownList ID="cboPlaceofBirth" runat="server" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourcePlaceofBirth" DataTextField="DIST_NAME" DataValueField="DIST_CODE"
                                                SelectedValue='<%# Bind("Placeof_Birth") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourcePlaceofBirth" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT DIST_CODE, DIST_NAME FROM [BD_District] order by DIST_NAME"></asp:SqlDataSource>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboMStatus" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSourceMStatus"
                                                DataTextField="MaritalStatusName" DataValueField="ID" SelectedValue='<%# Bind("Marital_Status_ID") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceMStatus" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT ID, MaritalStatusName FROM [MaritalStatus]"></asp:SqlDataSource>
                                            &nbsp; &nbsp; Place of Birth:
                                            <asp:DropDownList ID="cboPlaceofBirth" runat="server" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourcePlaceofBirth" DataTextField="DIST_NAME" DataValueField="DIST_CODE"
                                                SelectedValue='<%# Bind("Placeof_Birth") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourcePlaceofBirth" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT DIST_CODE, DIST_NAME FROM [BD_District] order by DIST_NAME"></asp:SqlDataSource>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            Family Information
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Father Name" SortExpression="Father_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblFather" runat="server" Text='<%# Bind("Father_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtFather" runat="server" Text='<%# Bind("Father_Name") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFather" runat="server" ControlToValidate="txtFather"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtFather" runat="server" Text='<%# Bind("Father_Name") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFather" runat="server" ControlToValidate="txtFather"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Mother Name" SortExpression="Mother_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMother" runat="server" Text='<%# Bind("Mother_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMother" runat="server" Text='<%# Bind("Mother_Name") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorMother" runat="server" ControlToValidate="txtMother"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtMother" runat="server" Text='<%# Bind("Mother_Name") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorMother" runat="server" ControlToValidate="txtMother"
                                                ValidationGroup="tabPersonal" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Spouse Name" SortExpression="Spouse_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSpouse" runat="server" Text='<%# Bind("Spouse_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtSpouse" runat="server" Text='<%# Bind("Spouse_Name") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtSpouse" runat="server" Text='<%# Bind("Spouse_Name") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <%--<asp:TemplateField HeaderText="No. of Children" SortExpression="NChildren_Boy">
                                        <ItemTemplate>
                                            Boy:
                                            <%# Eval("NChildren_Boy")%>
                                            Girl:
                                            <%# Eval("NChildren_Girl")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            Boy:
                                            <asp:TextBox ID="txtBoy" Width="40px" runat="server" Text='<%# Bind("NChildren_Boy") %>'></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderBoy" runat="server"
                                                Enabled="True" TargetControlID="txtBoy" ValidChars="123456789"></asp:FilteredTextBoxExtender>
                                            &nbsp;&nbsp;&nbsp;&nbsp; Girl:
                                            <asp:TextBox ID="txtGirl" Width="40px" runat="server" Text='<%# Bind("NChildren_Girl") %>'></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="txtGirl_FilteredTextBoxExtender" runat="server"
                                                Enabled="True" TargetControlID="txtGirl" ValidChars="123456789"></asp:FilteredTextBoxExtender>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            Boy:
                                            <asp:TextBox ID="txtBoy" Width="40px" runat="server" Text='<%# Bind("NChildren_Boy") %>' MaxLength="1"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="FilteredTextBoxExtenderBoy" runat="server"
                                                Enabled="True" TargetControlID="txtBoy" ValidChars="123456789"></asp:FilteredTextBoxExtender>
                                            &nbsp;&nbsp;&nbsp;&nbsp; Girl:
                                            <asp:TextBox ID="txtGirl" Width="40px" runat="server" Text='<%# Bind("NChildren_Girl") %>' MaxLength="1"></asp:TextBox>
                                            <asp:FilteredTextBoxExtender ID="txtGirl_FilteredTextBoxExtender" runat="server"
                                                Enabled="True" TargetControlID="txtGirl" ValidChars="123456789"></asp:FilteredTextBoxExtender>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>--%>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            Additional Information
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Facebook URL" SortExpression="FB_URL">
                                        <ItemTemplate>
                                            <%# Eval("FB_URL","<a href='{0}' target='_blank'>{0}</a>") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtFBURL" runat="server" Text='<%# Bind("FB_URL") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtFBURL"
                                                ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtFBURL" runat="server" Text='<%# Bind("FB_URL") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtFBURL"
                                                ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Google+ URL" SortExpression="Google_URL">
                                        <ItemTemplate>
                                            <asp:Label ID="lblGoogleURL" runat="server" Text='<%# Bind("Google_URL") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtGoogleURL" runat="server" Text='<%# Bind("Google_URL") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidatortxtGoogleURL" runat="server"
                                                ControlToValidate="txtGoogleURL" ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtGoogleURL" runat="server" Text='<%# Bind("Google_URL") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidatortxtGoogleURL" runat="server"
                                                ControlToValidate="txtGoogleURL" ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="LinkedIn URL" SortExpression="Linkedin_URL">
                                        <ItemTemplate>
                                            <asp:Label ID="lblLinkedinURL" runat="server" Text='<%# Bind("Linkedin_URL") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtLinkedinURL" runat="server" Text='<%# Bind("Linkedin_URL") %>'
                                                Width="400px" MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator_txtLinkedinURL" runat="server"
                                                ControlToValidate="txtLinkedinURL" ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtLinkedinURL" runat="server" Text='<%# Bind("Linkedin_URL") %>'
                                                Width="400px" MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator_txtLinkedinURL" runat="server"
                                                ControlToValidate="txtLinkedinURL" ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Website" SortExpression="Website">
                                        <ItemTemplate>
                                            <asp:Label ID="lblWebsite" runat="server" Text='<%# Bind("Website") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtWebsite" runat="server" Text='<%# Bind("Website") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator_txtWebsite" runat="server"
                                                ControlToValidate="txtWebsite" ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtWebsite" runat="server" Text='<%# Bind("Website") %>' Width="400px"
                                                MaxLength="200"></asp:TextBox>
                                            <asp:RegularExpressionValidator ID="RegularExpressionValidator_txtWebsite" runat="server"
                                                ControlToValidate="txtWebsite" ErrorMessage="Invalid" ValidationExpression="http(s)?://([\w-]+\.)+[\w-]+(/[\w- ./?%&amp;=]*)?">
                                            </asp:RegularExpressionValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditPersonal" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="ButtonPersonal" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdatePersonal" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabPersonal" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdatePersonal_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdatePersonal"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="ButtonPersonal" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertPersonal" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabPersonal" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertPersonal_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertPersonal"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelPersonal" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ControlStyle Width="80px" />
                                    </asp:TemplateField>
                                </Fields>

                            </asp:DetailsView>
                            <asp:DataList ID="DataListPersonal" runat="server" DataSourceID="SqlDataSourcePersonalGrid"
                                Width="100%" OnItemDataBound="DataListPersonal_ItemDataBound"
                                ShowFooter="False" ShowHeader="False" BorderStyle="None"
                                ForeColor="Black" DataKeyField="ID" OnDeleteCommand="DataListPersonal_DeleteCommand"
                                OnItemCommand="DataListPersonal_ItemCommand">
                                <ItemStyle BackColor="White" />
                                <ItemTemplate>
                                    <table class="table table-responsive table-condensed table-hover table-bordered">
                                        <tr>
                                            <th colspan="2" class="td-header">Address
                                                <div style="float: right">
                                                    <asp:LinkButton ID="cmdPersonalEdit" runat="server" CommandName="Select" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Edit" CausesValidation="false" Visible='<%# getIsEditable() %>'>
                                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                                    </asp:LinkButton>

                                                </div>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Present
                                            </td>
                                            <td>
                                                <div>
                                                    <%# Eval("Present_Address").ToString().Replace("\n","<br />") %>
                                                </div>
                                                <div>
                                                    <%# Eval("Present_ContactNo", " Contact No.: {0}")%>
                                                </div>
                                                <div style="white-space: nowrap; margin-top: 7px">
                                                    <img src="Images/green-dot.png" width="16" height="16" />
                                                    <div class="location-path" style="border-top: 1px dashed silver;">
                                                        <%# Eval("DIV_NAME","<span title='Division'>{0}</span>")%>
                                                        <%# Eval("DIST_NAME", "» <span title='District'>{0}</span>")%>
                                                        <%# Eval("THANA_NAME", "» <span title='Thana'>{0}</span>")%>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Permanent
                                            </td>
                                            <td>
                                                <div>
                                                    <%# Eval("Permanent_Address").ToString().Replace("\n", "<br />") %>
                                                </div>
                                                <div>
                                                    <%# Eval("Permanent_ContactNo", " Contact No.: {0}")%>
                                                </div>
                                                <div style="white-space: nowrap; margin-top: 7px">
                                                    <img src="Images/green-dot.png" width="16" height="16" />
                                                    <div class="location-path" style="border-top: 1px dashed silver;">
                                                        <%# Eval("DIV_NAME_PR","<span title='Division'>{0}</span>")%>
                                                        <%# Eval("DIST_NAME_PR", "» <span title='District'>{0}</span>")%>
                                                        <%# Eval("THANA_NAME_PR", "» <span title='Thana'>{0}</span>")%>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr style="height: 20px;">
                                            <th colspan="2" class="td-header">Personal Information
                                            </th>
                                        </tr>
                                        <tr>
                                            <td>Full Name</td>
                                            <td><%# Eval("FullName")%></td>
                                        </tr>
                                        <tr>
                                            <td>Mobile</td>
                                            <td><%# Eval("Mobile","+{0}")%></td>
                                        </tr>
                                        <tr>
                                            <td>Date of Birth
                                            </td>
                                            <td>
                                                <%# Eval("DOB", "{0:dd/MM/yyyy}")%>
                                                (<%# UserControl1.getAge(Eval("DOB"))%>)
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Gender
                                            </td>
                                            <td>
                                                <%# Eval("Gender")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Religion
                                            </td>
                                            <td>
                                                <%# Eval("Religion")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Maritual Status
                                            </td>
                                            <td>
                                                <%# Eval("MaritalStatusName")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Place of Birth
                                            </td>
                                            <td>
                                                <%# Eval("PLACE_OF_BIRTH")%>
                                            </td>
                                        </tr>
                                        <tr style="height: 20px;">
                                            <th colspan="2" class="td-header">Family Information
                                            </th>
                                        </tr>
                                        <tr>
                                            <td class="nowrap">Father's Name
                                            </td>
                                            <td>
                                                <%# Eval("Father_Name")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="nowrap">Mother's Name
                                            </td>
                                            <td>
                                                <%# Eval("Mother_Name")%>
                                            </td>
                                        </tr>
                                        <tr id="trspouse" runat="server" visible='<%# (string.Format("{0}", Eval("Spouse_Name")) == "" ? false : true) %>'>
                                            <td>Spouse Name
                                            </td>
                                            <td>
                                                <%# Eval("Spouse_Name")%>
                                            </td>
                                        </tr>

                                        <tr id="traddinfo" runat="server" style="height: 20px;"
                                            visible='<%# (string.Format("{0}", Eval("FB_URL")) == "" && string.Format("{0}", Eval("Google_URL")) == "" && string.Format("{0}", Eval("Linkedin_URL")) == "" && string.Format("{0}", Eval("Website")) == ""  ? false : true) %>'>
                                            <th colspan="2" class="td-header">Additional Information
                                            </th>
                                        </tr>
                                        <tr id="trfb" runat="server" visible='<%# (string.Format("{0}", Eval("FB_URL")) == "" ? false : true) %>'>
                                            <td>Facebook
                                            </td>
                                            <td>
                                                <%# Eval("FB_URL","<a href='{0}' target='_blank'>{0}</a>") %>
                                            </td>
                                        </tr>

                                        <tr id="trgoogle" runat="server" visible='<%# (string.Format("{0}", Eval("Google_URL")) == "" ? false : true) %>'>
                                            <td>Google+
                                            </td>
                                            <td>
                                                <%# Eval("Google_URL", "<a href='{0}' target='_blank'>{0}</a>")%>
                                            </td>
                                        </tr>
                                        <tr id="trlinkedln" runat="server" visible='<%# (string.Format("{0}", Eval("Linkedin_URL")) == "" ? false : true) %>'>
                                            <td>LinkedIn
                                            </td>
                                            <td>
                                                <%# Eval("Linkedin_URL", "<a href='{0}' target='_blank'>{0}</a>")%>
                                            </td>
                                        </tr>
                                        <tr id="trwebsite" runat="server" visible='<%# (string.Format("{0}", Eval("Website")) == "" ? false : true) %>'>
                                            <td>Website
                                            </td>
                                            <td>
                                                <%# Eval("Website", "<a href='{0}' target='_blank'>{0}</a>")%>
                                            </td>
                                        </tr>
                                        <tr class="silver">
                                            <td>Modify
                                            </td>
                                            <td>on <span title='<%# Eval("DT","{0:dddd \ndd, MMMM yyyy \nh:mm:ss tt}")%>'>
                                                <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                                                <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                            </span>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:SqlDataSource ID="SqlDataSourcePersonalGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM v_CV WHERE UserID=@UserID ORDER BY ID DESC"
                                OnSelected="SqlDataSourcePersonalGrid_Selected">

                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourcePersonal" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM v_CV WHERE ID=@ID" UpdateCommand="s_CV_Edit"
                                OnUpdated="SqlDataSourcePersonal_Updated" UpdateCommandType="StoredProcedure"
                                InsertCommand="s_CV_Add" InsertCommandType="StoredProcedure" OnInserted="SqlDataSourcePersonal_Inserted"
                                OnInserting="SqlDataSourcePersonal_Inserting" OnUpdating="SqlDataSourcePersonal_Updating">
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="DataListPersonal" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Present_Address" Type="String" />
                                    <asp:Parameter Name="Present_ThanaID" Type="Int32" />
                                    <asp:Parameter Name="Present_ContactNo" Type="String" />
                                    <asp:Parameter Name="Permanent_Address" Type="String" />
                                    <asp:Parameter Name="Permanent_ThanaID" Type="Int32" />
                                    <asp:Parameter Name="Permanent_ContactNo" Type="String" />
                                    <asp:Parameter Name="DOB" Type="DateTime" />
                                    <asp:Parameter Name="Gender" Type="String" />
                                    <asp:Parameter Name="Religion" Type="String" />
                                    <asp:Parameter Name="Marital_Status_ID" Type="String" />
                                    <asp:Parameter Name="Placeof_Birth" Type="Int32" />
                                    <asp:Parameter Name="FullName" Type="String" />
                                    <asp:Parameter Name="Father_Name" Type="String" />
                                    <asp:Parameter Name="Mother_Name" Type="String" />
                                    <asp:Parameter Name="Spouse_Name" Type="String" />
                                    <asp:Parameter Name="NChildren_Boy" Type="Int32" />
                                    <asp:Parameter Name="NChildren_Girl" Type="Int32" />
                                    <asp:Parameter Name="FB_URL" Type="String" />
                                    <asp:Parameter Name="Linkedin_URL" Type="String" />
                                    <asp:Parameter Name="Google_URL" Type="String" />
                                    <asp:Parameter Name="Website" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Present_Address" Type="String" />
                                    <asp:Parameter Name="Present_ThanaID" Type="Int32" />
                                    <asp:Parameter Name="Present_ContactNo" Type="String" />
                                    <asp:Parameter Name="Permanent_Address" Type="String" />
                                    <asp:Parameter Name="Permanent_ThanaID" Type="Int32" />
                                    <asp:Parameter Name="Permanent_ContactNo" Type="String" />
                                    <asp:Parameter Name="DOB" Type="DateTime" />
                                    <asp:Parameter Name="Gender" Type="String" />
                                    <asp:Parameter Name="Religion" Type="String" />
                                    <asp:Parameter Name="Marital_Status_ID" Type="String" />
                                    <asp:Parameter Name="Placeof_Birth" Type="Int32" />
                                    <asp:Parameter Name="FullName" Type="String" />
                                    <asp:Parameter Name="Father_Name" Type="String" />
                                    <asp:Parameter Name="Mother_Name" Type="String" />
                                    <asp:Parameter Name="Spouse_Name" Type="String" />
                                    <asp:Parameter Name="NChildren_Boy" Type="Int32" />
                                    <asp:Parameter Name="NChildren_Girl" Type="Int32" />
                                    <asp:Parameter Name="FB_URL" Type="String" />
                                    <asp:Parameter Name="Linkedin_URL" Type="String" />
                                    <asp:Parameter Name="Google_URL" Type="String" />
                                    <asp:Parameter Name="Website" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabpanelCareerObjective" HeaderText="Objectives">
                    <HeaderTemplate>
                        Career Objectives
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Career Objectives & Other Expertises</h4>
                        <div class="tab-body">

                            <asp:SqlDataSource ID="SqlDataSourceObjectivesGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_CareerObjective_Browse" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:SqlDataSource ID="SqlDataSourceCareerObjective" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_CareerObjective_Browse" SelectCommandType="StoredProcedure" UpdateCommand="s_CareerObjective_Update"
                                OnUpdated="SqlDataSourceCareerObjective_Updated" UpdateCommandType="StoredProcedure"
                                InsertCommand="s_CareerObjective_insert" InsertCommandType="StoredProcedure" OnInserted="SqlDataSourceCareerObjective_Inserted">
                                <SelectParameters>
                                    <asp:SessionParameter Name="UserID" SessionField="USERID" />
                                </SelectParameters>
                                <InsertParameters>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:Parameter Name="Career_Objective_Desc" Type="String" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:Parameter Name="Career_Objective_Desc" Type="String" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue=" " Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                            <asp:DetailsView ID="DetailsViewCareerObjective" runat="server" DefaultMode="ReadOnly" AutoGenerateRows="False"
                                CssClass="table table-bordered table-condensed table-responsive table-hover"
                                DataSourceID="SqlDataSourceCareerObjective" DataKeyNames="ID" OnDataBinding="DetailsViewCareerObjective_DataBound"
                                OnItemCommand="DetailsViewCareerObjective_ItemCommand">
                                <Fields>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Career Objectives
                                             <div style="float: right">
                                                 <asp:LinkButton ID="cmdEditCareerObjective" runat="server" CausesValidation="false"
                                                     CommandName="Edit" ToolTip="Edit">
                                                    <img alt="" height="16" width="16" src='Images/edit.png' border="0" />
                                                 </asp:LinkButton>
                                             </div>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Career Objectives" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Career_Objective_Desc").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtCareerObjective" runat="server" Text='<%# Bind("Career_Objective_Desc") %>'
                                                Width="95%" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCareerObjective" runat="server"
                                                ControlToValidate="txtCareerObjective" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtCareerObjective" runat="server" Text='<%# Bind("Career_Objective_Desc") %>'
                                                Width="95%" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCareerObjective1" runat="server"
                                                ControlToValidate="txtCareerObjective" ValidationGroup="tabCareerObjective" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Extracurricular Activities
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Extracurricular Activities" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Extracurricular_Activities").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtExtracurricular_Activities" runat="server" Text='<%# Bind("Extracurricular_Activities") %>'
                                                Width="95%" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorExtracurricular_Activities" runat="server"
                                                ControlToValidate="txtExtracurricular_Activities" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtExtracurricular_Activities" runat="server" Text='<%# Bind("Extracurricular_Activities") %>'
                                                Width="95%" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCareerObjective1dada" runat="server"
                                                ControlToValidate="txtExtracurricular_Activities" ValidationGroup="tabCareerObjective" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" Wrap="false" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Personal Expertise
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Personal Expertise" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Personal_Expertise").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPersonal_Expertise" runat="server" Text='<%# Bind("Personal_Expertise") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPersonal_Expertise" runat="server"
                                                ControlToValidate="txtPersonal_Expertise" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtPersonal_Expertise" runat="server" Text='<%# Bind("Personal_Expertise") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPersonal_Expertise" runat="server"
                                                ControlToValidate="txtPersonal_Expertise" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Computer Skills
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Computer Skills" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Computer_Skills").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtComputer_Skills" runat="server" Text='<%# Bind("Computer_Skills") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorComputer_Skills" runat="server"
                                                ControlToValidate="txtComputer_Skills" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtComputer_Skills" runat="server" Text='<%# Bind("Computer_Skills") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorComputer_Skills" runat="server"
                                                ControlToValidate="txtComputer_Skills" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Personal Interest
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Personal Interest" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Personal_Interest").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPersonal_Interest" runat="server" Text='<%# Bind("Personal_Interest") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPersonal_Interest" runat="server"
                                                ControlToValidate="txtPersonal_Interest" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtPersonal_Interest" runat="server" Text='<%# Bind("Personal_Interest") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPersonal_Interest" runat="server"
                                                ControlToValidate="txtPersonal_Interest" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Strength
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Strength" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Strength").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtStrength" runat="server" Text='<%# Bind("Strength") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorStrength" runat="server"
                                                ControlToValidate="txtStrength" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtStrength" runat="server" Text='<%# Bind("Strength") %>'
                                                Width="95%" TextMode="MultiLine" Rows="2"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorStrength" runat="server"
                                                ControlToValidate="txtStrength" ErrorMessage="*" ValidationGroup="tabCareerObjective"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateCareerObjective" runat="server" CausesValidation="true"
                                                CommandName="Update" ValidationGroup="tabCareerObjective" Text="Update" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateCareerObjective_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateCareerObjective"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="ButtonCareerObjective" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertCareerObjective" runat="server" CausesValidation="true" ValidationGroup="tabCareerObjective" CommandName="Insert"
                                                Text="Save" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertCareerObjective_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertCareerObjective"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelCareerObjective" runat="server" CausesValidation="false"
                                                CommandName="Cancel" Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ControlStyle Width="80px" />
                                        <ItemStyle BackColor="White" />
                                    </asp:TemplateField>

                                </Fields>
                                <EmptyDataTemplate>
                                    To add your career objectives please click:
                            <asp:LinkButton runat="server" ID="cmdAddObjectives" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                            </asp:DetailsView>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabEducation">
                    <HeaderTemplate>
                        Education
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Education</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewEducation" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceEducation" CellPadding="4" DataKeyNames="ID"
                                GridLines="None" OnItemCommand="DetailsViewEducation_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your academic qualification please click:
                            <asp:LinkButton runat="server" ID="cmdAddEducation" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Degree" SortExpression="Degree">
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboDegree" runat="server" DataSourceID="SqlDataSourceDegree"
                                                DataTextField="Degree_Name" DataValueField="ID_Degree" SelectedValue='<%# Bind("ID_Degree") %>'
                                                AppendDataBoundItems="true">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDegree" runat="server" ControlToValidate="cboDegree"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabEducation"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceDegree" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT [ID_Degree],[Degree_Name] FROM [Degree] where type='E' ORDER BY OrderCol ASC"></asp:SqlDataSource>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboDegree" runat="server" DataSourceID="SqlDataSourceDegree"
                                                DataTextField="Degree_Name" DataValueField="ID_Degree" SelectedValue='<%# Bind("ID_Degree") %>'
                                                AppendDataBoundItems="true">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDegree" runat="server" ControlToValidate="cboDegree"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabEducation"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceDegree" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT [ID_Degree],[Degree_Name] FROM [Degree] where type='E' ORDER BY OrderCol ASC"></asp:SqlDataSource>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exam/Degree Title" SortExpression="Exam_Degree_Title">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Exam_Degree_Title") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtTitle" runat="server" Width="450px" Text='<%# Bind("Exam_Degree_Title") %>'
                                                MaxLength="255"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTitle" runat="server" ControlToValidate="txtTitle"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabEducation"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtTitle" runat="server" Width="450px" Text='<%# Bind("Exam_Degree_Title") %>'
                                                MaxLength="255"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTitle" runat="server" ControlToValidate="txtTitle"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabEducation"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Board" SortExpression="Board">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBoard" runat="server" Text='<%# Eval("Board") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtBoard" runat="server" Width="450px" Text='<%# Bind("Board") %>'
                                                MaxLength="255"></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtBoard" runat="server" Width="450px" Text='<%# Bind("Board") %>'
                                                MaxLength="255"></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Major/Group" SortExpression="Subject_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSubject" runat="server" Text='<%# Eval("Subject_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboSubject" runat="server" DataSourceID="SqlDataSourceSubject"
                                                AppendDataBoundItems="true" DataTextField="Emp_Subject" DataValueField="Emp_Subject"
                                                tag="EDIT">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceSubject" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT Emp_Subject FROM [Subject] ORDER BY OrderCol, Emp_Subject ASC"
                                                SelectCommandType="Text"></asp:SqlDataSource>

                                            <asp:TextBox ID="txtSubject" runat="server" Width="450px" Text='<%# Bind("Subject_Name") %>'
                                                MaxLength="255" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtSubject" runat="server"
                                                ValidationGroup="tabEducation" ErrorMessage="*" ControlToValidate="txtSubject"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboSubject" runat="server" DataSourceID="SqlDataSourceSubject"
                                                AppendDataBoundItems="true" DataTextField="Emp_Subject" DataValueField="Emp_Subject">
                                                <asp:ListItem Text=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceSubject" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT Emp_Subject FROM [Subject] ORDER BY OrderCol, Emp_Subject ASC"
                                                SelectCommandType="Text"></asp:SqlDataSource>

                                            <asp:TextBox ID="txtSubject" runat="server" Width="450px" Text='<%# Bind("Subject_Name") %>'
                                                MaxLength="255" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtSubject" runat="server"
                                                ValidationGroup="tabEducation" ErrorMessage="*" ControlToValidate="txtSubject"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle CssClass="tr-top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Institute Name" SortExpression="Institute_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInstitute" runat="server" Text='<%# Eval("Institute_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboInstitute" runat="server" DataSourceID="SqlDataSourceInstitute"
                                                AppendDataBoundItems="true" DataTextField="University_Name" DataValueField="University_Name"
                                                tag="EDIT">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceInstitute" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT University_Name FROM [BD_University] order by OrderCol,University_Name"
                                                SelectCommandType="Text"></asp:SqlDataSource>

                                            <asp:TextBox ID="txtInstitute" runat="server" Width="450px" Text='<%# Bind("Institute_Name") %>'
                                                MaxLength="255" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtInstitute" runat="server"
                                                ValidationGroup="tabEducation" ErrorMessage="*" ControlToValidate="txtInstitute"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboInstitute" runat="server" DataSourceID="SqlDataSourceInstitute"
                                                AppendDataBoundItems="true" DataTextField="University_Name" DataValueField="University_Name">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceInstitute" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT University_Name FROM [BD_University] order by OrderCol,University_Name"
                                                SelectCommandType="Text"></asp:SqlDataSource>

                                            <asp:TextBox ID="txtInstitute" runat="server" Width="450px" Text='<%# Bind("Institute_Name") %>'
                                                MaxLength="255" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtInstitute" runat="server"
                                                ValidationGroup="tabEducation" ErrorMessage="*" ControlToValidate="txtInstitute"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle CssClass="tr-top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Result" SortExpression="Result">
                                        <ItemTemplate>
                                            <asp:Label ID="lblResult" runat="server" Text='<%# Eval("Result") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboResult" runat="server" SelectedValue='<%# Bind("Result") %>'>
                                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                                <asp:ListItem Value="First Division/Class" Text="First Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Second  Division/Class" Text="Second  Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Third Division/Class" Text="Third Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Grade" Text="Grade"></asp:ListItem>
                                                <asp:ListItem Value="Appeared" Text="Appeared"></asp:ListItem>
                                                <asp:ListItem Value="Enrolled" Text="Enrolled"></asp:ListItem>
                                                <asp:ListItem Value="Awarded" Text="Awarded"></asp:ListItem>
                                            </asp:DropDownList>
                                            <span id="lblResult" class="hidden"></span>
                                            <asp:TextBox ID="txtResult" runat="server" Width="40px" Text='<%# Bind("Marks_CGPA") %>'
                                                MaxLength="100" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorResult" runat="server" ValidationGroup="tabEducation"
                                                ErrorMessage="*" ControlToValidate="txtResult"></asp:RequiredFieldValidator>
                                            <span id="lblTotalCGPA" class="hidden">Out of:
                                                <asp:TextBox ID="txtTotalCGPA" runat="server" Width="40px" Text='<%# Bind("Total_CGPA") %>'
                                                    MaxLength="100"></asp:TextBox>
                                            </span>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboResult" runat="server" SelectedValue='<%# Bind("Result") %>'>
                                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                                <asp:ListItem Value="First Division/Class" Text="First Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Second  Division/Class" Text="Second  Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Third Division/Class" Text="Third Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Grade" Text="Grade"></asp:ListItem>
                                                <asp:ListItem Value="Appeared" Text="Appeared"></asp:ListItem>
                                                <asp:ListItem Value="Enrolled" Text="Enrolled"></asp:ListItem>
                                                <asp:ListItem Value="Awarded" Text="Awarded"></asp:ListItem>
                                            </asp:DropDownList>
                                            <span id="lblResult" class="hidden"></span>
                                            <asp:TextBox ID="txtResult" runat="server" Width="40px" Text='<%# Bind("Marks_CGPA") %>'
                                                MaxLength="100" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorResult" runat="server" ValidationGroup="tabEducation"
                                                ErrorMessage="*" ControlToValidate="txtResult"></asp:RequiredFieldValidator>
                                            <span id="lblTotalCGPA" class="hidden">Out of:
                                                <asp:TextBox ID="txtTotalCGPA" runat="server" Width="40px" Text='<%# Bind("Total_CGPA") %>'
                                                    MaxLength="100"></asp:TextBox>
                                            </span>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Year of Passing" SortExpression="Passing_Year">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPassingYear" runat="server" Text='<%# Eval("Passing_Year") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboYearPassing" runat="server" DataSourceID="SqlDataSourceYear"
                                                DataTextField="YEAR" DataValueField="YEAR" SelectedValue='<%# Bind("Passing_Year") %>'>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ValidationGroup="tabEducation"
                                                ErrorMessage="*" ControlToValidate="cboYearPassing"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceYear" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_Years" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="1930" Name="Start" Type="Int32" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboYearPassing" runat="server" DataSourceID="SqlDataSourceYear"
                                                DataTextField="YEAR" DataValueField="YEAR" SelectedValue='<%# Bind("Passing_Year") %>'>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ValidationGroup="tabEducation"
                                                ErrorMessage="*" ControlToValidate="cboYearPassing"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceYear" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_Years" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="1930" Name="Start" Type="Int32" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditEdu" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="cmdNewEdu" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateEdu" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabEducation" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateEdu_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateEdu"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelEdu" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertEdu" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabEducation" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertEdu_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertEdu"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelEdu" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ControlStyle Width="80px" />
                                    </asp:TemplateField>
                                </Fields>

                            </asp:DetailsView>
                            <asp:DataList ID="DataListEducation" runat="server" DataSourceID="SqlDataSourceEducationGrid"
                                ShowFooter="False" ShowHeader="False" BorderStyle="None" Width="100%"
                                DataKeyField="ID" OnSelectedIndexChanged="DataListEducation_SelectedIndexChanged"
                                OnDeleteCommand="DataListEducation_DeleteCommand">

                                <ItemTemplate>
                                    <table class="table table-responsive table-condensed table-hover table-bordered">
                                        <tr>
                                            <th colspan="2" class="td-header">
                                                <%# Eval("Degree_Name")%>
                                                <div style="float: right">
                                                    <asp:LinkButton ID="cmdEduEdit" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Edit" CausesValidation="false">
                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cmdEduDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Delete" CausesValidation="false">
                                            <img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmEduDel" TargetControlID="cmdEduDel"
                                                        ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                                </div>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Exam/Degree
                                            </td>
                                            <td>
                                                <%# Eval("Exam_Degree_Title")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Institute
                                            </td>
                                            <td>
                                                <%# Eval("Institute_Name") %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Major/Group
                                            </td>
                                            <td>
                                                <%# Eval("Subject_Name") %>
                                            </td>
                                        </tr>
                                        <tr runat="server" visible='<%# (string.Format("{0}", Eval("Board")) == "" ? false : true) %>'>
                                            <td>Board
                                            </td>
                                            <td>
                                                <%# Eval("Board") %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Result
                                            </td>
                                            <td>
                                                <%# getResultText(Eval("Result"), Eval("Marks_CGPA"), Eval("Total_CGPA"))%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Passing Year
                                            </td>
                                            <td>
                                                <%# Eval("Passing_Year") %>
                                            </td>
                                        </tr>
                                        <tr class="silver">
                                            <td>Modify
                                            </td>
                                            <td>
                                                <%--<%# Eval("ModifiedBY") %>--%>
                                                on <span title='<%# Eval("DT","{0:dddd \ndd, MMMM yyyy \nh:mm:ss tt}")%>'>
                                                    <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                                                    <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:SqlDataSource ID="SqlDataSourceEducationGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Education_Browse" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Type" Type="String" DefaultValue="E" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceEducation" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM Education WHERE ID=@ID and type='E'" UpdateCommand="s_Education_Edit"
                                OnUpdated="SqlDataSourceEducation_Updated" UpdateCommandType="StoredProcedure"
                                InsertCommand="s_Education_Add" InsertCommandType="StoredProcedure"
                                OnInserted="SqlDataSourceEducation_Inserted" DeleteCommand="DELETE FROM Education WHERE USERID = @UserID AND ID = @ID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <InsertParameters>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID_Degree" Type="Int32" />
                                    <asp:Parameter Name="Exam_Degree_Title" Type="String" />
                                    <asp:Parameter Name="Subject_Name" Type="String" />
                                    <asp:Parameter Name="Institute_Name" Type="String" />
                                    <asp:Parameter Name="Board" Type="String" />
                                    <asp:Parameter Name="Result" Type="String" />
                                    <asp:Parameter Name="Marks_CGPA" Type="String" />
                                    <asp:Parameter Name="Total_CGPA" Type="String" />
                                    <asp:Parameter Name="Passing_Year" Type="String" />
                                    <asp:Parameter Name="Type" Type="String" DefaultValue="E" />

                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="DataListEducation" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID_Degree" Type="Int32" />
                                    <asp:Parameter Name="Exam_Degree_Title" Type="String" />
                                    <asp:Parameter Name="Subject_Name" Type="String" />
                                    <asp:Parameter Name="Institute_Name" Type="String" />
                                    <asp:Parameter Name="Board" Type="String" />
                                    <asp:Parameter Name="Result" Type="String" />
                                    <asp:Parameter Name="Marks_CGPA" Type="String" />
                                    <asp:Parameter Name="Total_CGPA" Type="String" />
                                    <asp:Parameter Name="Passing_Year" Type="String" />
                                    <asp:Parameter Name="Type" Type="String" DefaultValue="E" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>



                <asp:TabPanel runat="server" ID="tabProfessionalQualification">
                    <HeaderTemplate>
                        Professional Qualification
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Professional Qualification/Certification</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewProfessionalQualification" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceProfessionalQualification" CellPadding="4" DataKeyNames="ID"
                                GridLines="None" OnItemCommand="DetailsViewProfessionalQualification_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your professional qualification please click:
		<asp:LinkButton runat="server" ID="cmdAddProfessionalQualification" CommandName="New">
				<img src="Images/add.png" width="16" height="16" />
        </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Degree" SortExpression="Degree">
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboDegree" runat="server" DataSourceID="SqlDataSourceDegree"
                                                DataTextField="Degree_Name" DataValueField="ID_Degree" SelectedValue='<%# Bind("ID_Degree") %>'
                                                AppendDataBoundItems="true">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDegree" runat="server" ControlToValidate="cboDegree"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabProQ"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceDegree" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT [ID_Degree],[Degree_Name] FROM [Degree] where type='P' ORDER BY OrderCol ASC"></asp:SqlDataSource>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboDegree" runat="server" DataSourceID="SqlDataSourceDegree"
                                                DataTextField="Degree_Name" DataValueField="ID_Degree" SelectedValue='<%# Bind("ID_Degree") %>'
                                                AppendDataBoundItems="true">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDegree" runat="server" ControlToValidate="cboDegree"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabProQ"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceDegree" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT [ID_Degree],[Degree_Name] FROM [Degree] where type='P' ORDER BY OrderCol ASC"></asp:SqlDataSource>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Exam/Degree Title" SortExpression="Exam_Degree_Title">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Exam_Degree_Title") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtTitle" runat="server" Width="450px" Text='<%# Bind("Exam_Degree_Title") %>'
                                                MaxLength="255"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTitle" runat="server" ControlToValidate="txtTitle"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabProQ"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtTitle" runat="server" Width="450px" Text='<%# Bind("Exam_Degree_Title") %>'
                                                MaxLength="255"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTitle" runat="server" ControlToValidate="txtTitle"
                                                ErrorMessage="*" SetFocusOnError="True" ValidationGroup="tabProQ"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle Wrap="false" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Certification Body" SortExpression="Board">
                                        <ItemTemplate>
                                            <asp:Label ID="lblBoard" runat="server" Text='<%# Eval("Board") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtBoard" runat="server" Width="450px" Text='<%# Bind("Board") %>'
                                                MaxLength="255"></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtBoard" runat="server" Width="450px" Text='<%# Bind("Board") %>'
                                                MaxLength="255"></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Institute Name" SortExpression="Institute_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInstitute" runat="server" Text='<%# Eval("Institute_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboInstitute" runat="server" DataSourceID="SqlDataSourceInstitute"
                                                AppendDataBoundItems="true" DataTextField="University_Name" DataValueField="University_Name"
                                                tag="EDIT">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceInstitute" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT University_Name FROM [BD_University] order by OrderCol,University_Name"
                                                SelectCommandType="Text"></asp:SqlDataSource>

                                            <asp:TextBox ID="txtInstitute" runat="server" Width="450px" Text='<%# Bind("Institute_Name") %>'
                                                MaxLength="255" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtInstitute" runat="server"
                                                ValidationGroup="tabProQ" ErrorMessage="*" ControlToValidate="txtInstitute"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboInstitute" runat="server" DataSourceID="SqlDataSourceInstitute"
                                                AppendDataBoundItems="true" DataTextField="University_Name" DataValueField="University_Name">
                                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourceInstitute" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT University_Name FROM [BD_University] order by OrderCol,University_Name"
                                                SelectCommandType="Text"></asp:SqlDataSource>

                                            <asp:TextBox ID="txtInstitute" runat="server" Width="450px" Text='<%# Bind("Institute_Name") %>'
                                                MaxLength="255" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatortxtInstitute" runat="server"
                                                ValidationGroup="tabProQ" ErrorMessage="*" ControlToValidate="txtInstitute"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle CssClass="tr-top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Result" SortExpression="Result">
                                        <ItemTemplate>
                                            <asp:Label ID="lblResult" runat="server" Text='<%# Eval("Result") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboResult" runat="server" SelectedValue='<%# Bind("Result") %>'>
                                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                                <asp:ListItem Value="First Division/Class" Text="First Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Second  Division/Class" Text="Second  Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Third Division/Class" Text="Third Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Grade" Text="Grade"></asp:ListItem>
                                                <asp:ListItem Value="Appeared" Text="Appeared"></asp:ListItem>
                                                <asp:ListItem Value="Enrolled" Text="Enrolled"></asp:ListItem>
                                                <asp:ListItem Value="Awarded" Text="Awarded"></asp:ListItem>
                                            </asp:DropDownList>
                                            <span id="lblResult" class="hidden"></span>
                                            <asp:TextBox ID="txtResult" runat="server" Width="40px" Text='<%# Bind("Marks_CGPA") %>'
                                                MaxLength="100" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorResult" runat="server" ValidationGroup="tabProQ"
                                                ErrorMessage="*" ControlToValidate="txtResult"></asp:RequiredFieldValidator>
                                            <span id="lblTotalCGPA" class="hidden">Out of:
							<asp:TextBox ID="txtTotalCGPA" runat="server" Width="40px" Text='<%# Bind("Total_CGPA") %>'
                                MaxLength="100"></asp:TextBox>
                                            </span>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboResult" runat="server" SelectedValue='<%# Bind("Result") %>'>
                                                <asp:ListItem Value="" Text=""></asp:ListItem>
                                                <asp:ListItem Value="First Division/Class" Text="First Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Second  Division/Class" Text="Second  Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Third Division/Class" Text="Third Division/Class"></asp:ListItem>
                                                <asp:ListItem Value="Grade" Text="Grade"></asp:ListItem>
                                                <asp:ListItem Value="Appeared" Text="Appeared"></asp:ListItem>
                                                <asp:ListItem Value="Enrolled" Text="Enrolled"></asp:ListItem>
                                                <asp:ListItem Value="Awarded" Text="Awarded"></asp:ListItem>
                                            </asp:DropDownList>
                                            <span id="lblResult" class="hidden"></span>
                                            <asp:TextBox ID="txtResult" runat="server" Width="40px" Text='<%# Bind("Marks_CGPA") %>'
                                                MaxLength="100" CssClass="hidden"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorResult" runat="server" ValidationGroup="tabProQ"
                                                ErrorMessage="*" ControlToValidate="txtResult"></asp:RequiredFieldValidator>
                                            <span id="lblTotalCGPA" class="hidden">Out of:
							<asp:TextBox ID="txtTotalCGPA" runat="server" Width="40px" Text='<%# Bind("Total_CGPA") %>'
                                MaxLength="100"></asp:TextBox>
                                            </span>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Year of Passing" SortExpression="Passing_Year">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPassingYear" runat="server" Text='<%# Eval("Passing_Year") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboYearPassing" runat="server" DataSourceID="SqlDataSourceYear"
                                                DataTextField="YEAR" DataValueField="YEAR" SelectedValue='<%# Bind("Passing_Year") %>'>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ValidationGroup="tabProQ"
                                                ErrorMessage="*" ControlToValidate="cboYearPassing"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceYear" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_Years" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="1930" Name="Start" Type="Int32" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboYearPassing" runat="server" DataSourceID="SqlDataSourceYear"
                                                DataTextField="YEAR" DataValueField="YEAR" SelectedValue='<%# Bind("Passing_Year") %>'>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorYear" runat="server" ValidationGroup="tabProQ"
                                                ErrorMessage="*" ControlToValidate="cboYearPassing"></asp:RequiredFieldValidator>
                                            <asp:SqlDataSource ID="SqlDataSourceYear" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_Years" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:Parameter DefaultValue="1930" Name="Start" Type="Int32" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditEdu" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="cmdNewEdu" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateEdu" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabProQ" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateEdu_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateEdu"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelEdu" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertEdu" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabProQ" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertEdu_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertEdu"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelEdu" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ControlStyle Width="80px" />
                                    </asp:TemplateField>
                                </Fields>

                            </asp:DetailsView>
                            <asp:DataList ID="DataListProfessionalQualification" runat="server" DataSourceID="SqlDataSourceProfessionalQualificationGrid"
                                ShowFooter="False" ShowHeader="False" BorderStyle="None" Width="100%"
                                DataKeyField="ID" OnSelectedIndexChanged="DataListProfessionalQualification_SelectedIndexChanged"
                                OnDeleteCommand="DataListProfessionalQualification_DeleteCommand">

                                <ItemTemplate>
                                    <table class="table table-responsive table-condensed table-hover table-bordered">
                                        <tr>
                                            <th colspan="2" class="td-header">
                                                <%# Eval("Degree_Name")%>
                                                <div style="float: right">
                                                    <asp:LinkButton ID="cmdEduEdit" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Edit" CausesValidation="false">
						<img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cmdEduDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Delete" CausesValidation="false">
						<img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmEduDel" TargetControlID="cmdEduDel"
                                                        ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                                </div>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Exam/Degree
                                            </td>
                                            <td>
                                                <%# Eval("Exam_Degree_Title")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Institute
                                            </td>
                                            <td>
                                                <%# Eval("Institute_Name") %>
                                            </td>
                                        </tr>

                                        <tr runat="server" visible='<%# (string.Format("{0}", Eval("Board")) == "" ? false : true) %>'>
                                            <td>Certification Body
                                            </td>
                                            <td>
                                                <%# Eval("Board") %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Result
                                            </td>
                                            <td>
                                                <%# getResultText(Eval("Result"), Eval("Marks_CGPA"), Eval("Total_CGPA"))%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Passing Year
                                            </td>
                                            <td>
                                                <%# Eval("Passing_Year") %>
                                            </td>
                                        </tr>
                                        <tr class="silver">
                                            <td>Modify
                                            </td>
                                            <td>
                                                <%--<%# Eval("ModifiedBY") %>--%>
							on <span title='<%# Eval("DT","{0:dddd \ndd, MMMM yyyy \nh:mm:ss tt}")%>'>
                                <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                                <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                            </span>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:SqlDataSource ID="SqlDataSourceProfessionalQualificationGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Education_Browse" SelectCommandType="StoredProcedure" DeleteCommand="DELETE FROM Education WHERE USERID = @UserID AND ID = @ID and [type]='P'">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Type" Type="String" DefaultValue="P" />
                                </SelectParameters>
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceProfessionalQualification" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM Education WHERE ID=@ID and type='P'" UpdateCommand="s_Education_Edit"
                                OnUpdated="SqlDataSourceProfessionalQualification_Updated" UpdateCommandType="StoredProcedure"
                                InsertCommand="s_Education_Add" InsertCommandType="StoredProcedure"
                                OnInserted="SqlDataSourceProfessionalQualification_Inserted">

                                <InsertParameters>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID_Degree" Type="Int32" />
                                    <asp:Parameter Name="Exam_Degree_Title" Type="String" />
                                    <asp:Parameter Name="Institute_Name" Type="String" />
                                    <asp:Parameter Name="Board" Type="String" />
                                    <asp:Parameter Name="Result" Type="String" />
                                    <asp:Parameter Name="Marks_CGPA" Type="String" />
                                    <asp:Parameter Name="Total_CGPA" Type="String" />
                                    <asp:Parameter Name="Passing_Year" Type="String" />
                                    <asp:Parameter Name="Type" Type="String" DefaultValue="P" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="DataListProfessionalQualification" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID_Degree" Type="Int32" />
                                    <asp:Parameter Name="Exam_Degree_Title" Type="String" />
                                    <asp:Parameter Name="Institute_Name" Type="String" />
                                    <asp:Parameter Name="Board" Type="String" />
                                    <asp:Parameter Name="Result" Type="String" />
                                    <asp:Parameter Name="Marks_CGPA" Type="String" />
                                    <asp:Parameter Name="Total_CGPA" Type="String" />
                                    <asp:Parameter Name="Passing_Year" Type="String" />
                                    <asp:Parameter Name="Type" Type="String" DefaultValue="P" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>



                <asp:TabPanel runat="server" ID="tabExperience" HeaderText="Experiences">
                    <HeaderTemplate>
                        Experiences
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Professional Experiences</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewExperience" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceExperience" DataKeyNames="ID" DefaultMode="ReadOnly"
                                GridLines="None" OnItemCommand="DetailsViewExperience_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your professional experience please click:
                            <asp:LinkButton runat="server" ID="cmdNewExperience" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Organization" SortExpression="Organization">
                                        <ItemTemplate>
                                            <asp:Label ID="lblOrg" runat="server" Text='<%# Eval("Organization") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtOrg" runat="server" Text='<%# Bind("Organization") %>' Width="400px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorOrg" runat="server" ControlToValidate="txtOrg"
                                                ValidationGroup="tabExperience" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtOrg" runat="server" Text='<%# Bind("Organization") %>' Width="400px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorOrg" runat="server" ControlToValidate="txtOrg"
                                                ValidationGroup="tabExperience" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Designation" SortExpression="Designation">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDesignation" runat="server" Text='<%# Eval("Designation") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtDesignation" runat="server" Width="300px" Text='<%# Bind("Designation") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDesignation" runat="server"
                                                ValidationGroup="tabExperience" ControlToValidate="txtDesignation" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtDesignation" runat="server" Width="300px" Text='<%# Bind("Designation") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDesignation" runat="server"
                                                ValidationGroup="tabExperience" ControlToValidate="txtDesignation" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Department" SortExpression="Department">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDepartment" runat="server" Text='<%# Eval("Department") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtDepartment" runat="server" Width="300px" Text='<%# Bind("Department") %>'
                                                MaxLength="120"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDepartment" runat="server"
                                                ValidationGroup="tabExperience" ControlToValidate="txtDepartment" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtDepartment" runat="server" Width="300px" Text='<%# Bind("Department") %>'
                                                MaxLength="120"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDepartment" runat="server"
                                                ValidationGroup="tabExperience" ControlToValidate="txtDepartment" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Duration" SortExpression="FromDT">
                                        <ItemTemplate>
                                            From:
                                            <%# Eval("FromDT", "{0:dd/MM/yyyy}")%>
                                            To:
                                            <%# Eval("ToDT", "{0:dd/MM/yyyy}")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            From:
                                            <asp:TextBox CssClass="Date" ID="txtFDateExp" Width="80px" runat="server" Text='<%# Bind("FromDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFExp" runat="server" ControlToValidate="txtFDateExp"
                                                ValidationGroup="tabExperience" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            &nbsp;&nbsp;&nbsp;&nbsp; To:
                                            <asp:TextBox CssClass="Date" ID="txtToDateExp" Width="80px" runat="server" Text='<%# Bind("ToDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:CheckBox ID="chkTilNow" runat="server" Text="Till Now" />
                                            <%--<asp:RequiredFieldValidator ID="RequiredFieldValidatorToExp" runat="server" ControlToValidate="txtToDateExp"
                                        ValidationGroup="tabExperience" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>--%>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            From:
                                            <asp:TextBox CssClass="Date" ID="txtFDateExp" Width="80px" runat="server" Text='<%# Bind("FromDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorFExp" runat="server" ControlToValidate="txtFDateExp"
                                                ValidationGroup="tabExperience" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            &nbsp;&nbsp;&nbsp;&nbsp; To:
                                            <asp:TextBox CssClass="Date" ID="txtToDateExp" Width="80px" runat="server" Text='<%# Bind("ToDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:CheckBox ID="chkTilNow" runat="server" Text="Till Now" />
                                            <%-- <asp:RequiredFieldValidator ID="RequiredFieldValidatorToExp" runat="server" ControlToValidate="txtToDateExp"
                                        ValidationGroup="tabExperience" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>--%>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Job Description" SortExpression="JobDescription">
                                        <ItemTemplate>
                                            <%# Eval("JobDescription").ToString().Replace("\n", "<br>") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtJobDescription" runat="server" Width="400px" Text='<%# Bind("JobDescription") %>'
                                                TextMode="MultiLine" Height="70px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorJobDescription" runat="server"
                                                ValidationGroup="tabExperience" ControlToValidate="txtJobDescription" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtJobDescription" runat="server" Width="400px" Text='<%# Bind("JobDescription") %>'
                                                TextMode="MultiLine" Height="70px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorJobDescription" runat="server"
                                                ValidationGroup="tabExperience" ControlToValidate="txtJobDescription" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditExperience" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="ButtonExperience" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateExperience" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabExperience" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateExperience_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateExperience"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="ButtonExperience" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertExperience" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Save" ValidationGroup="tabExperience" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertExperience_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertExperience"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelExperience" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ItemStyle BackColor="White" />
                                    </asp:TemplateField>
                                </Fields>

                            </asp:DetailsView>


                            <asp:DataList ID="DataListExperience" runat="server" DataSourceID="SqlDataSourceExperienceGrid"
                                ShowFooter="False" ShowHeader="False" BorderStyle="None" Width="100%"
                                DataKeyField="ID" OnSelectedIndexChanged="DataListExperience_SelectedIndexChanged"
                                OnDeleteCommand="DataListExperience_DeleteCommand">

                                <ItemTemplate>
                                    <table class="table table-responsive table-condensed table-hover table-bordered">
                                        <tr>
                                            <th colspan="2" class="td-header">
                                                <%# Eval("Organization")%>
                                                <div style="float: right">
                                                    <asp:LinkButton ID="cmdExperienceEdit" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Edit" CausesValidation="false">
					<img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cmdExperienceDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Delete" CausesValidation="false">
					<img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmExperienceDel" TargetControlID="cmdExperienceDel"
                                                        ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                                </div>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Designation
                                            </td>
                                            <td>
                                                <%# Eval("Designation")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Department
                                            </td>
                                            <td>
                                                <%# Eval("Department") %>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Duration
                                            </td>
                                            <td>
                                                <%# Eval("FromDT","{0:dd-MMM-yyyy}")%> - 
                                        <%# string.Format("{0}", Eval("ToDT")) == "" ? "Till Now" : Eval("ToDT","{0:dd-MMM-yyyy}")%>
                                                <div class="silver">

                                                    <%# string.Format("{0}", Eval("ToDT")) == "" ? UserControl1.getAge(Eval("FromDT")) : UserControl1.getAge(Eval("FromDT"),Eval("ToDT"))%>
                                                </div>
                                            </td>
                                        </tr>
                                        <%-- <tr>
                                    <td>To Date
                                    </td>
                                    <td>                                        
                                        <%# string.Format("{0}", Eval("ToDT")) == "" ? "Till Now" : Eval("ToDT","{0:dd/MM/yyyy}")%>
                                    </td>
                                </tr>--%>

                                        <tr>
                                            <td class="nowrap">Job Description
                                            </td>
                                            <td>
                                                <%# Eval("JobDescription") %>
                                            </td>
                                        </tr>

                                        <tr class="silver">
                                            <td>Modify
                                            </td>
                                            <td>
                                                <%--<%# Eval("ModifiedBY") %>--%>
						on <span title='<%# Eval("DT","{0:dddd \ndd, MMMM yyyy \nh:mm:ss tt}")%>'>
                            <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                            <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                        </span>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:SqlDataSource ID="SqlDataSourceExperienceGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Professional_Experience"
                                SelectCommandType="StoredProcedure" DeleteCommand="DELETE FROM Professional_Experience WHERE UserID = @UserID AND ID = @ID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceExperience" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM Professional_Experience WHERE ID=@ID" SelectCommandType="Text"
                                UpdateCommand="s_Professional_Experience_Edit" OnUpdated="SqlDataSourceExperience_Updated"
                                UpdateCommandType="StoredProcedure" InsertCommand="s_Professional_Experience_Add"
                                InsertCommandType="StoredProcedure" OnInserted="SqlDataSourceExperience_Inserted">
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="DataListExperience" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Organization" Type="String" />
                                    <asp:Parameter Name="Designation" Type="String" />
                                    <asp:Parameter Name="FromDT" Type="DateTime" />
                                    <asp:Parameter Name="ToDT" Type="DateTime" />
                                    <asp:Parameter Name="Department" Type="String" />
                                    <asp:Parameter Name="JobDescription" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <%--<asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />--%>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Organization" Type="String" />
                                    <asp:Parameter Name="Designation" Type="String" />
                                    <asp:Parameter Name="FromDT" Type="DateTime" />
                                    <asp:Parameter Name="ToDT" Type="DateTime" />
                                    <asp:Parameter Name="Department" Type="String" />
                                    <asp:Parameter Name="JobDescription" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabMembership" HeaderText="Membership">
                    <HeaderTemplate>
                        Memberships
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Memberships</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewMembership" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceMembership" DataKeyNames="ID" DefaultMode="ReadOnly"
                                GridLines="None" OnItemCommand="DetailsViewMembership_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your memberships please click:
                            <asp:LinkButton runat="server" ID="cmdNewMembership" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Name of the Association" SortExpression="Name_Association">
                                        <ItemTemplate>
                                            <%# Eval("Name_Association") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtAssociation" runat="server" Text='<%# Bind("Name_Association") %>'
                                                Width="400px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAssociation" runat="server"
                                                ValidationGroup="tabMembership" ControlToValidate="txtAssociation" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtAssociation" runat="server" Text='<%# Bind("Name_Association") %>'
                                                Width="400px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAssociation" runat="server"
                                                ValidationGroup="tabMembership" ControlToValidate="txtAssociation" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Member Category" SortExpression="Member_Category">
                                        <ItemTemplate>
                                            <asp:Label ID="lblCategory" runat="server" Text='<%# Eval("Member_Category") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtCategory" runat="server" Width="400px" Text='<%# Bind("Member_Category") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCategory" runat="server" ControlToValidate="txtCategory"
                                                ValidationGroup="tabMembership" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtCategory" runat="server" Width="400px" Text='<%# Bind("Member_Category") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorCategory" runat="server" ControlToValidate="txtCategory"
                                                ValidationGroup="tabMembership" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditMember" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="ButtonMember" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateMember" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabMembership" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateMember_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateMember"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="ButtonMember" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertMember" runat="server" CausesValidation="false" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabMembership" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertMember_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertMember"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelMember" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ItemStyle BackColor="White" />
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                <AlternatingRowStyle BackColor="White" />
                            </asp:DetailsView>
                            <asp:GridView ID="GridViewMemberAssociation" runat="server" CssClass="table table-responsive table-condensed table-hover table-bordered"
                                AllowSorting="false"
                                AutoGenerateColumns="False"
                                DataSourceID="SqlDataSourceMemberGrid" DataKeyNames="ID"
                                GridLines="None" AllowPaging="false"
                                OnSelectedIndexChanging="GridViewMemberAssociation_SelectedIndexChanging">

                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                        SortExpression="ID" ItemStyle-HorizontalAlign="Center" Visible="false" />
                                    <asp:BoundField DataField="Name_Association" HeaderText="Name of the Association"
                                        SortExpression="Name_Association" HeaderStyle-CssClass="td-header" />
                                    <asp:BoundField DataField="Member_Category" HeaderText="Member Category" SortExpression="Member_Category"
                                        HeaderStyle-CssClass="td-header" />
                                    <asp:TemplateField Visible="True">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="cmdGridMember" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                Height="20px" ToolTip="Open" CausesValidation="false">
                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />                                            
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="cmdMemberDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                Height="20px" ToolTip="Delete" CausesValidation="false">
                                        <img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                            </asp:LinkButton>
                                            <asp:ConfirmButtonExtender runat="server" ID="ConfirmMemberDel" TargetControlID="cmdMemberDel"
                                                ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                        </ItemTemplate>
                                        <HeaderStyle Font-Bold="True" CssClass="td-header" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>

                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSourceMemberGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Member_Association"
                                SelectCommandType="StoredProcedure" DeleteCommand="DELETE FROM Member_Association WHERE UserID = @UserID AND ID = @ID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceMembership" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM Member_Association WHERE ID=@ID" SelectCommandType="Text"
                                UpdateCommand="s_Member_Association_Edit" OnUpdated="SqlDataSourceMembership_Updated"
                                UpdateCommandType="StoredProcedure" InsertCommand="s_Member_Association_Add"
                                InsertCommandType="StoredProcedure" OnInserted="SqlDataSourceMembership_Inserted">
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="GridViewMemberAssociation" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Name_Association" Type="String" />
                                    <asp:Parameter Name="Member_Category" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <%--<asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />--%>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Name_Association" Type="String" />
                                    <asp:Parameter Name="Member_Category" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabTraining" HeaderText="Trainings">
                    <HeaderTemplate>
                        Trainings
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Trainings & Workshops</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewTraining" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceTraining" DataKeyNames="ID" DefaultMode="ReadOnly"
                                GridLines="None" OnItemCommand="DetailsViewTraining_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your training and workshop info please click:
                            <asp:LinkButton runat="server" ID="cmdNewTraining" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Type">
                                        <ItemTemplate>
                                            <%# Eval("Type") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="dboType" runat="server" SelectedValue='<%# Bind("Type") %>'>
                                                <asp:ListItem></asp:ListItem>
                                                <asp:ListItem>Training</asp:ListItem>
                                                <asp:ListItem>Workshop</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorType" runat="server" ControlToValidate="dboType"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="dboType" runat="server" SelectedValue='<%# Bind("Type") %>'>
                                                <asp:ListItem></asp:ListItem>
                                                <asp:ListItem>Training</asp:ListItem>
                                                <asp:ListItem>Workshop</asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorType" runat="server" ControlToValidate="dboType"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Training/Workshop/Seminar Title" SortExpression="Title_Training">
                                        <ItemTemplate>
                                            <%# Eval("Title_Training") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title_Training") %>' Width="450px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTitle" runat="server" ControlToValidate="txtTitle"
                                                ValidationGroup="tabTraining" CssClass="required" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtTitle" runat="server" Text='<%# Bind("Title_Training") %>' Width="450px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTitle" runat="server" ControlToValidate="txtTitle"
                                                ValidationGroup="tabTraining" CssClass="required" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Institute Name" SortExpression="Institute">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInst" runat="server" Text='<%# Eval("Institute") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtInst" runat="server" Width="400px" Text='<%# Bind("Institute") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorInst" runat="server" ControlToValidate="txtInst"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtInst" runat="server" Width="400px" Text='<%# Bind("Institute") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorInst" runat="server" ControlToValidate="txtInst"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Organized By" SortExpression="OrganizedBy">
                                        <ItemTemplate>
                                            <asp:Label ID="lblOrganizedBy" runat="server" Text='<%# Eval("OrganizedBy") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtOrganizedBy" runat="server" Width="400px" Text='<%# Bind("OrganizedBy") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtOrganizedBy" runat="server" Width="400px" Text='<%# Bind("OrganizedBy") %>'></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Result" SortExpression="Result">
                                        <ItemTemplate>
                                            <asp:Label ID="lblResult" runat="server" Text='<%# Eval("Result") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtResult" runat="server" Width="150px" MaxLength="50" Text='<%# Bind("Result") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtResult" runat="server" Width="150px" Text='<%# Bind("Result") %>'></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Duration" SortExpression="FromDT">
                                        <ItemTemplate>
                                            From:
                                            <%# Eval("FromDT", "{0:dd/MM/yyyy}")%>
                                            To:
                                            <%# Eval("ToDT", "{0:dd/MM/yyyy}")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            From:
                                            <asp:TextBox CssClass="Date" ID="txtFDate" Width="80px" runat="server" Text='<%# Bind("FromDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorF" runat="server" ControlToValidate="txtFDate"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            &nbsp;&nbsp;&nbsp;&nbsp; To:
                                            <asp:TextBox CssClass="Date" ID="txtToDate" Width="80px" runat="server" Text='<%# Bind("ToDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTo" runat="server" ControlToValidate="txtToDate"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            From:
                                            <asp:TextBox CssClass="Date" ID="txtFDate" Width="80px" runat="server" Text='<%# Bind("FromDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorF" runat="server" ControlToValidate="txtFDate"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            &nbsp;&nbsp;&nbsp;&nbsp; To:
                                            <asp:TextBox CssClass="Date" ID="txtToDate" Width="80px" runat="server" Text='<%# Bind("ToDT","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorTo" runat="server" ControlToValidate="txtToDate"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="No. of Days" SortExpression="NoOfDays">
                                        <ItemTemplate>
                                            <asp:Label ID="lblNoOfDays" runat="server" Text='<%# Eval("NoOfDays") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtNoOfDays" runat="server" Width="40px" Text='<%# Bind("NoOfDays") %>'
                                                MaxLength="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNoOfDays" runat="server" ControlToValidate="txtNoOfDays"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtNoOfDays" runat="server" Width="40px" Text='<%# Bind("NoOfDays") %>'
                                                MaxLength="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorNoOfDays" runat="server" ControlToValidate="txtNoOfDays"
                                                ValidationGroup="tabTraining" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditTraining" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="ButtonTraining" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateTraining" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabTraining" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateTraining_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateTraining"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="ButtonTraining" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertTraining" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabTraining" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertTraining_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertTraining"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelTraining" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ItemStyle BackColor="White" />
                                    </asp:TemplateField>
                                </Fields>

                            </asp:DetailsView>
                            <asp:GridView ID="GridViewTraining" runat="server" CssClass="table table-responsive table-condensed table-hover table-bordered"
                                AllowSorting="false"
                                AutoGenerateColumns="False"
                                DataSourceID="SqlDataSourceTrainingGrid" DataKeyNames="ID"
                                GridLines="None" AllowPaging="false"
                                OnSelectedIndexChanging="GridViewTraining_SelectedIndexChanging">

                                <Columns>
                                    <asp:BoundField DataField="ID" HeaderText="ID" InsertVisible="False" ReadOnly="True"
                                        SortExpression="ID" ItemStyle-HorizontalAlign="Center" Visible="false" />
                                    <asp:TemplateField HeaderText="Training/Workshop/Seminar Info" SortExpression="Title_Training">
                                        <ItemTemplate>
                                            <b>
                                                <%# Eval("Title_Training")%></b>
                                            <%# Eval("Institute", "<br />Institute: {0}")%>
                                            <%# Eval("OrganizedBy", "<br />Organized By: {0}")%>
                                            <%# Eval("Result", "<br />Result: {0}")%>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Type" SortExpression="Type">
                                        <ItemTemplate>
                                            <%# Eval("Type")%>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                        <HeaderStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Date" SortExpression="FromDT">
                                        <ItemTemplate>
                                            <div title='<%# Eval("FromDT","{0:dddd, \ndd MMMM, yyyy }") %>'>
                                                <%# Eval("FromDT","{0:dd/MM/yyyy}")%>
                                                <%# (Eval("FromDT").ToString() == Eval("ToDT").ToString() ? "" : Eval("ToDT"," - {0:dd/MM/yyyy}"))%>
                                                <div>
                                                    <time class="timeago" datetime='<%# Eval("FromDT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                        <HeaderStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="NoOfDays" HeaderText="Days" SortExpression="NoOfDays"
                                        ItemStyle-HorizontalAlign="Center" HeaderStyle-CssClass="td-header" />
                                    <asp:TemplateField Visible="True">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="cmdGridtraining" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                Height="20px" ToolTip="Open" CausesValidation="false">                                            
                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="cmdTrainingDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                Height="20px" ToolTip="Delete" CausesValidation="false">
                                        <img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                            </asp:LinkButton>
                                            <asp:ConfirmButtonExtender runat="server" ID="ConfirmTrainingDel" TargetControlID="cmdTrainingDel"
                                                ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                        </ItemTemplate>
                                        <HeaderStyle CssClass="td-header" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSourceTrainingGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Training"
                                SelectCommandType="StoredProcedure" DeleteCommand="DELETE FROM Training WHERE UserID = @UserID AND ID = @ID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />

                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />

                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceTraining" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM Training WHERE ID=@ID" SelectCommandType="Text"
                                UpdateCommand="s_Training_Edit" OnUpdated="SqlDataSourceTraining_Updated"
                                UpdateCommandType="StoredProcedure" InsertCommand="s_Training_Add" InsertCommandType="StoredProcedure"
                                OnInserted="SqlDataSourceTraining_Inserted">
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="GridViewTraining" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Title_Training" Type="String" />
                                    <asp:Parameter Name="Institute" Type="String" />
                                    <asp:Parameter Name="NoOfDays" Type="String" />
                                    <asp:Parameter Name="FromDT" Type="DateTime" />
                                    <asp:Parameter Name="ToDT" Type="DateTime" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <%--<asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />--%>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Title_Training" Type="String" />
                                    <asp:Parameter Name="Institute" Type="String" />
                                    <asp:Parameter Name="NoOfDays" Type="String" />
                                    <asp:Parameter Name="FromDT" Type="DateTime" />
                                    <asp:Parameter Name="ToDT" Type="DateTime" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabLanguageProficiency" HeaderText="Languages">
                    <HeaderTemplate>
                        Languages
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Language Proficiency</h4>
                        <div class="tab-body">
                            <asp:SqlDataSource ID="SqlDataSource2" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_LanguageLevels_Browse" SelectCommandType="StoredProcedure"></asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSource3" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Language_Browse" SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>

                            <asp:DetailsView ID="DetailsViewLanguageProficiency" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceLanguageProficiency" DataKeyNames="SL" DefaultMode="ReadOnly" OnItemCommand="DetailsViewLanguageProficiency_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your language proficiency please click:
                            <asp:LinkButton runat="server" ID="cmdNewTraining" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Language">
                                        <ItemTemplate>
                                            <%# Eval("LangID") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="dboLanguage" runat="server" AppendDataBoundItems="true" Enabled="false" DataSourceID="SqlDataSource3" DataTextField="LanguageName" DataValueField="ID" SelectedValue='<%# Bind("LangID") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorType" runat="server" ControlToValidate="dboLanguage"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="dboLanguage" runat="server" AppendDataBoundItems="true" DataSourceID="SqlDataSource3" DataTextField="LanguageName" DataValueField="ID" SelectedValue='<%# Bind("LangID") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorType" runat="server" ControlToValidate="dboLanguage"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Reading" SortExpression="Reading">
                                        <ItemTemplate>
                                            <asp:Label ID="lblTitle" runat="server" Text='<%# Eval("Reading") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="dboReading" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Reading") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorReading" runat="server" ControlToValidate="dboReading"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="dboReading" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Reading") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorReading1" runat="server" ControlToValidate="dboReading"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Writing" SortExpression="Writing">
                                        <ItemTemplate>
                                            <asp:Label ID="lblInst" runat="server" Text='<%# Eval("Writing") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="dboWriting" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Writing") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorWriting" runat="server" ControlToValidate="dboWriting"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="dboWriting" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Writing") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorWriting1" runat="server" ControlToValidate="dboWriting"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Spoken" SortExpression="Speaking">
                                        <ItemTemplate>
                                            <asp:Label ID="lblSpoken" runat="server" Text='<%# Eval("Spoken") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="dboSpoken" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Spoken") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorSpoken" runat="server" ControlToValidate="dboSpoken"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="dboSpoken" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Spoken") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorSpoken1" runat="server" ControlToValidate="dboSpoken"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Listening" SortExpression="Listening">
                                        <ItemTemplate>
                                            <asp:Label ID="lblListening" runat="server" Text='<%# Eval("Listening") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="dboListening" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Listening") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorListening" runat="server" ControlToValidate="dboListening"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="dboListening" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Listening") %>' DataSourceID="SqlDataSource2" DataTextField="LangLevelsName" DataValueField="LangLevelsID">
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorListening" runat="server" ControlToValidate="dboListening"
                                                ValidationGroup="tabLanguageProficiency" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditLanguageProficiency" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="ButtonLanguageProficiency" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateLanguageProficiency" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabLanguageProficiency" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateLanguageProficiency_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateLanguageProficiency"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="ButtonLanguageProficiency" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertLanguageProficiency" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabLanguageProficiency" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertLanguageProficiency_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertLanguageProficiency"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelLanguageProficiency" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ItemStyle BackColor="White" />
                                    </asp:TemplateField>
                                </Fields>

                            </asp:DetailsView>
                            <asp:GridView ID="GridViewLanguageProficiency" runat="server" CssClass="table table-responsive table-condensed table-hover table-bordered"
                                AllowSorting="false"
                                AutoGenerateColumns="False" BorderStyle="None"
                                DataSourceID="SqlDataSourceLanguageProficiencyGrid" DataKeyNames="SL"
                                GridLines="None" AllowPaging="false"
                                OnSelectedIndexChanging="GridViewLanguageProficiency_SelectedIndexChanging">

                                <Columns>
                                    <asp:BoundField DataField="SL" HeaderText="SL" InsertVisible="False" ReadOnly="True"
                                        SortExpression="SL" Visible="false" />
                                    <asp:BoundField DataField="LanguageName" HeaderText="Language" SortExpression="LanguageName"
                                        HeaderStyle-CssClass="td-header" ItemStyle-CssClass="bold" />
                                    <asp:BoundField DataField="Reading" HeaderText="Reading" SortExpression="Reading"
                                        HeaderStyle-CssClass="td-header" />
                                    <asp:BoundField DataField="Writing" HeaderText="Writing" SortExpression="Writing"
                                        HeaderStyle-CssClass="td-header" />
                                    <asp:BoundField DataField="Spoken" HeaderText="Speaking" SortExpression="Spoken"
                                        HeaderStyle-CssClass="td-header" />
                                    <asp:BoundField DataField="Listening" HeaderText="Listening" SortExpression="Listening"
                                        HeaderStyle-CssClass="td-header" />
                                    <asp:TemplateField Visible="True">
                                        <ItemTemplate>
                                            <asp:LinkButton ID="cmdGridLanguage" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("SL") %>'
                                                Height="20px" ToolTip="Edit" CausesValidation="false">                                            
                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="cmdLanguageDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("SL") %>'
                                                Height="20px" ToolTip="Delete" CausesValidation="false">
                                        <img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                            </asp:LinkButton>
                                            <asp:ConfirmButtonExtender runat="server" ID="ConfirmLAnguageDel" TargetControlID="cmdLanguageDel"
                                                ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                        </ItemTemplate>
                                        <HeaderStyle Font-Bold="True" CssClass="td-header" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="false" />
                                    </asp:TemplateField>
                                </Columns>

                            </asp:GridView>
                            <asp:SqlDataSource ID="SqlDataSourceLanguageProficiencyGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_LanguageProficiency_browse"
                                SelectCommandType="StoredProcedure" DeleteCommand="DELETE FROM LanguageProficiency WHERE UserID = @UserID AND SL = @SL">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="SL" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceLanguageProficiency" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM LanguageProficiency WHERE SL=@SL" SelectCommandType="Text"
                                UpdateCommand="s_LanguageProficiency_Update" OnUpdated="SqlDataSourceLanguageProficiency_Updated"
                                UpdateCommandType="StoredProcedure" InsertCommand="s_LanguageProficiency_Insert" InsertCommandType="StoredProcedure"
                                OnInserted="SqlDataSourceLanguageProficiency_Inserted">
                                <SelectParameters>
                                    <asp:ControlParameter Name="SL" ControlID="GridViewLanguageProficiency" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="InputOutput" Name="SL" Type="Int32" DefaultValue="0" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="LangID" Type="Int32" />
                                    <asp:Parameter Name="Reading" Type="Int32" />
                                    <asp:Parameter Name="Writing" Type="Int32" />
                                    <asp:Parameter Name="Spoken" Type="Int32" />
                                    <asp:Parameter Name="Listening" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="LangID" Type="Int32" />
                                    <asp:Parameter Name="Reading" Type="Int32" />
                                    <asp:Parameter Name="Writing" Type="Int32" />
                                    <asp:Parameter Name="Spoken" Type="Int32" />
                                    <asp:Parameter Name="Listening" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabDependents" Visible="false">
                    <HeaderTemplate>
                        Dependents
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Dependents</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewDependents" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceDependents" DataKeyNames="ID"
                                GridLines="None" OnItemCommand="DetailsViewDependents_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your dependents please click:
                            <asp:LinkButton runat="server" ID="cmdAddDependents" CommandName="New" Visible='<%# getIsEditable() %>'>
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Name" SortExpression="Dependent_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblName" runat="server" Text='<%# Eval("Dependent_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtName" runat="server" Width="450px" Text='<%# Bind("Dependent_Name") %>'
                                                MaxLength="255"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorName" runat="server" ControlToValidate="txtName"
                                                ValidationGroup="tabDependents" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtName" runat="server" Width="450px" Text='<%# Bind("Dependent_Name") %>'
                                                MaxLength="255"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorName" runat="server" ControlToValidate="txtName"
                                                ValidationGroup="tabDependents" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Occupation" SortExpression="Dependent_Occupation">
                                        <ItemTemplate>
                                            <asp:Label ID="lblOccupation" runat="server" Text='<%# Eval("Dependent_Occupation") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtOccupation" runat="server" Width="250px" Text='<%# Bind("Dependent_Occupation") %>'
                                                MaxLength="100"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorOccupation" runat="server"
                                                ValidationGroup="tabDependents" ControlToValidate="txtOccupation" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtOccupation" runat="server" Width="250px" Text='<%# Bind("Dependent_Occupation") %>'
                                                MaxLength="100"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorOccupation" runat="server"
                                                ValidationGroup="tabDependents" ControlToValidate="txtOccupation" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField SortExpression="Dependent_DOB" HeaderText="Date of Birth">
                                        <ItemTemplate>
                                            Date of Birth:
                                            <%# Eval("Dependent_DOB","{0:dd/MM/yyyy}")%>
                                            &nbsp; Relationship:
                                            <%# Eval("RelationshipName")%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox CssClass="Date" ID="txtAge" runat="server" Text='<%# Bind("Dependent_DOB","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAge" runat="server" ControlToValidate="txtAge"
                                                ValidationGroup="tabDependents" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            &nbsp;&nbsp;&nbsp;&nbsp; Relationship:
                                            <asp:DropDownList ID="cboRelationshipD" runat="server" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourceDependentsRel" DataTextField="RelationshipName" DataValueField="ID"
                                                SelectedValue='<%# Bind("Dependent_RelationshipID") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorRelationship" runat="server"
                                                ValidationGroup="tabDependents" ControlToValidate="cboRelationshipD" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox CssClass="Date" ID="txtAge" runat="server" Text='<%# Bind("Dependent_DOB","{0:dd/MM/yyyy}") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAge" runat="server" ControlToValidate="txtAge"
                                                ValidationGroup="tabDependents" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                            &nbsp;&nbsp;&nbsp;&nbsp; Relationship:
                                            <asp:DropDownList ID="cboRelationshipD" runat="server" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourceDependentsRel" DataTextField="RelationshipName" DataValueField="ID"
                                                SelectedValue='<%# Bind("Dependent_RelationshipID") %>'>
                                                <asp:ListItem></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorRelationship" runat="server"
                                                ValidationGroup="tabDependents" ControlToValidate="cboRelationshipD" ErrorMessage="*"
                                                SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEditDependents" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="cmdNewDependents" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdateDependents" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabDependents" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdateDependents_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Update?" Enabled="True" TargetControlID="cmdUpdateDependents"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelDependents" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="cmdInsertDependents" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabDependents" />
                                            <asp:ConfirmButtonExtender ID="cmdInsertDependents_ConfirmButtonExtender" runat="server"
                                                ConfirmText="Do you want to Save?" Enabled="True" TargetControlID="cmdInsertDependents"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancelDependents" runat="server" CausesValidation="False"
                                                CommandName="Cancel" Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ControlStyle Width="80px" />
                                    </asp:TemplateField>
                                </Fields>
                            </asp:DetailsView>
                            <asp:DataList ID="DataListDependents" runat="server" DataSourceID="SqlDataSourceDependentsGrid"
                                ShowFooter="False" ShowHeader="False" Width="100%" BorderStyle="None"
                                DataKeyField="ID" OnSelectedIndexChanged="DataListDependents_SelectedIndexChanged"
                                OnDeleteCommand="DataListDependents_DeleteCommand">
                                <ItemStyle BackColor="White" />
                                <ItemTemplate>
                                    <table class="table table-responsive table-condensed table-hover table-bordered">
                                        <tr>
                                            <th colspan="2" class="td-header">
                                                <%# Eval("RelationshipName")%>
                                                <div style="float: right">
                                                    <asp:LinkButton ID="cmdEduEdit" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Edit" CausesValidation="false" Visible='<%# getIsEditable() %>'>
                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cmdEduDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Delete" CausesValidation="false" Visible='<%# getIsEditable() %>'>
                                            <img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmEduDel" TargetControlID="cmdEduDel"
                                                        ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                                </div>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Name
                                            </td>
                                            <td>
                                                <%# Eval("Dependent_Name")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 100px">Occupation
                                            </td>
                                            <td>
                                                <%# Eval("Dependent_Occupation")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Date of Birth
                                            </td>
                                            <td>
                                                <%# Eval("Dependent_DOB","{0:dd/MM/yyyy}")%>
                                        (Age: <%# UserControl1.getAge(Eval("Dependent_DOB"))%>)
                                            </td>
                                        </tr>

                                        <tr class="silver">
                                            <td>Modify
                                            </td>
                                            <td>
                                                <%-- <%# Eval("ModifiedBY") %>--%>
                                                on <span title='<%# Eval("DT","{0:dddd \ndd, MMMM yyyy \nh:mm:ss tt}")%>'>
                                                    <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                                                    <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:SqlDataSource ID="SqlDataSourceDependentsGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM v_Dependents WHERE UserID=@UserID" SelectCommandType="Text">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceDependents" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT   ID ,UserID ,Dependent_Name ,Dependent_Occupation ,Dependent_DOB ,Dependent_RelationshipID ,DT ,RelationshipName FROM    [JobPortal].[dbo].[v_Dependents] where id=@ID" UpdateCommand="s_Dependents_Edit"
                                SelectCommandType="Text"
                                OnUpdated="SqlDataSourceDependents_Updated" UpdateCommandType="StoredProcedure"
                                InsertCommand="s_Dependents_Add" InsertCommandType="StoredProcedure"
                                OnInserted="SqlDataSourceDependents_Inserted" DeleteCommand="DELETE FROM Dependents WHERE UserID = @UserID AND ID = @ID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <InsertParameters>
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Dependent_Name" Type="String" />
                                    <asp:Parameter Name="Dependent_Occupation" Type="String" />
                                    <asp:Parameter Name="Dependent_DOB" Type="DateTime" />
                                    <asp:Parameter Name="Dependent_RelationshipID" Type="Int32" />

                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                                <SelectParameters>
                                    <asp:ControlParameter Name="ID" ControlID="DataListDependents" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Dependent_Name" Type="String" />
                                    <asp:Parameter Name="Dependent_Occupation" Type="String" />
                                    <asp:Parameter Name="Dependent_DOB" Type="DateTime" />
                                    <asp:Parameter Name="Dependent_RelationshipID" Type="Int32" />

                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceDependentsRel" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT [ID], [RelationshipName] FROM [Relationship] ORDER BY [ID]"></asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

                <asp:TabPanel runat="server" ID="tabRef" HeaderText="References">
                    <HeaderTemplate>
                        References
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>References</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewRef" runat="server" AutoGenerateRows="False" CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceRef" DataKeyNames="ID" DefaultMode="ReadOnly"
                                GridLines="None" OnItemCommand="DetailsViewRef_ItemCommand">

                                <EmptyDataTemplate>
                                    To add your references please click:
                            <asp:LinkButton runat="server" ID="cmdNewRef" CommandName="New">
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>
                                <Fields>
                                    <asp:TemplateField HeaderText="Name" SortExpression="Ref_Name">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRef" runat="server" Text='<%# Eval("Ref_Name") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtRef" runat="server" MaxLength="255" Text='<%# Bind("Ref_Name") %>'
                                                Width="400px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRef"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtRef" runat="server" MaxLength="255" Text='<%# Bind("Ref_Name") %>'
                                                Width="400px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRef"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Organization" SortExpression="Ref_Organization">
                                        <ItemTemplate>
                                            <asp:Label ID="lblorg" runat="server" Text='<%# Eval("Ref_Organization") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtOrg" runat="server" MaxLength="255" Text='<%# Bind("Ref_Organization") %>'
                                                Width="300px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorOrg" runat="server" ControlToValidate="txtOrg"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtOrg" runat="server" MaxLength="255" Text='<%# Bind("Ref_Organization") %>'
                                                Width="300px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorOrg" runat="server" ControlToValidate="txtOrg"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Designation" SortExpression="Ref_Designation">
                                        <ItemTemplate>
                                            <asp:Label ID="lblDesig" runat="server" Text='<%# Eval("Ref_Designation") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtDesig" runat="server" MaxLength="255" Text='<%# Bind("Ref_Designation") %>'
                                                Width="300px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDesig" runat="server" ControlToValidate="txtDesig"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtDesig" runat="server" MaxLength="255" Text='<%# Bind("Ref_Designation") %>'
                                                Width="300px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDesig" runat="server" ControlToValidate="txtDesig"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Address" SortExpression="Ref_Address">
                                        <ItemTemplate>
                                            <asp:Label ID="lblAddress" runat="server" Text='<%# Eval("Ref_Address") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtAddress" TextMode="MultiLine" runat="server" Rows="3" Width="300px"
                                                Text='<%# Bind("Ref_Address") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAddress" runat="server" ControlToValidate="txtAddress"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtAddress" TextMode="MultiLine" runat="server" Rows="3" Width="300px"
                                                Text='<%# Bind("Ref_Address") %>'></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorAddress" runat="server" ControlToValidate="txtAddress"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                        <HeaderStyle VerticalAlign="Top" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Phone (Off)" SortExpression="Ref_Phone_Off">
                                        <ItemTemplate>
                                            <asp:Label ID="lblPhone" runat="server" Text='<%# Eval("Ref_Phone_Off") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtPhone" runat="server" MaxLength="255" Text='<%# Bind("Ref_Phone_Off") %>'
                                                Width="200px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPhone" runat="server" ControlToValidate="txtPhone"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtPhone" runat="server" MaxLength="255" Text='<%# Bind("Ref_Phone_Off") %>'
                                                Width="200px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorPhone" runat="server" ControlToValidate="txtPhone"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Phone (Res)" SortExpression="Ref_Phone_Res">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRes" runat="server" Text='<%# Eval("Ref_Phone_Res") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtRes" runat="server" MaxLength="255" Text='<%# Bind("Ref_Phone_Res") %>'
                                                Width="200px"></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtRes" runat="server" MaxLength="255" Text='<%# Bind("Ref_Phone_Res") %>'
                                                Width="200px"></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Mobile" SortExpression="Ref_Mobile">
                                        <ItemTemplate>
                                            <asp:Label ID="lblMobile" runat="server" Text='<%# Eval("Ref_Mobile") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtMobile" runat="server" MaxLength="255" Text='<%# Bind("Ref_Mobile") %>'
                                                Width="200px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorMobile" runat="server" ControlToValidate="txtMobile"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtMobile" runat="server" MaxLength="255" Text='<%# Bind("Ref_Mobile") %>'
                                                Width="200px"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorMobile" runat="server" ControlToValidate="txtMobile"
                                                ValidationGroup="tabRef" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Email" SortExpression="Ref_Email">
                                        <ItemTemplate>
                                            <asp:Label ID="lblEmail" runat="server" Text='<%# Eval("Ref_Email") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="255" Text='<%# Bind("Ref_Email") %>'
                                                Width="200px"></asp:TextBox>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtEmail" runat="server" MaxLength="255" Text='<%# Bind("Ref_Email") %>'
                                                Width="200px"></asp:TextBox>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Relation" SortExpression="Ref_Relation">
                                        <ItemTemplate>
                                            <asp:Label ID="lblRelation" runat="server" Text='<%# Bind("Ref_Relation") %>'></asp:Label>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboRelation" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Ref_Relation") %>'>
                                                <asp:ListItem Text="Relative" Value="Relative"></asp:ListItem>
                                                <asp:ListItem Text="Family Friend" Value="Family Friend"></asp:ListItem>
                                                <asp:ListItem Text="Academic" Value="Academic"></asp:ListItem>
                                                <asp:ListItem Text="Professional" Value="Professional"></asp:ListItem>
                                                <asp:ListItem Text="Others" Value="Others"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorRelation" runat="server" ControlToValidate="cboRelation"
                                                ValidationGroup="tabRef" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboRelation" runat="server" AppendDataBoundItems="true" SelectedValue='<%# Bind("Ref_Relation") %>'>
                                                <asp:ListItem Text="Relative" Value="Relative"></asp:ListItem>
                                                <asp:ListItem Text="Family Friend" Value="Family Friend"></asp:ListItem>
                                                <asp:ListItem Text="Academic" Value="Academic"></asp:ListItem>
                                                <asp:ListItem Text="Professional" Value="Professional"></asp:ListItem>
                                                <asp:ListItem Text="Others" Value="Others"></asp:ListItem>
                                            </asp:DropDownList>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorRelation" runat="server" ControlToValidate="cboRelation"
                                                ValidationGroup="tabRef" ErrorMessage="*"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False" ControlStyle-Width="80px">
                                        <ItemTemplate>
                                            <asp:Button ID="cmdEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabRef" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdate_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                                Enabled="True" TargetControlID="cmdUpdate"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="Button1" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabRef" />
                                            <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                                Enabled="True" TargetControlID="Button1"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancel2" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                </Fields>
                                <HeaderStyle BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                <AlternatingRowStyle BackColor="White" />
                            </asp:DetailsView>
                            <asp:DataList ID="DataListReferences" runat="server" DataSourceID="SqlDataSourceGrid"
                                ShowFooter="False" ShowHeader="False" BorderStyle="None" BorderWidth="0px"
                                DataKeyField="ID" OnSelectedIndexChanged="DataListReferences_SelectedIndexChanged"
                                OnDeleteCommand="DataListReferences_DeleteCommand" Width="100%">
                                <ItemStyle BackColor="White" />
                                <ItemTemplate>
                                    <table class="table table-responsive table-condensed table-hover table-bordered">
                                        <tr>
                                            <th colspan="2" class="td-header">
                                                <%# Eval("Ref_Relation")%>
                                                <div style="float: right">
                                                    <asp:LinkButton ID="cmdRefEdit" runat="server" CommandName="SELECT" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Edit" CausesValidation="false">
                                            <img alt="" height="16px" width="16px" src='Images/edit.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="cmdRefDel" runat="server" CommandName="Delete" CommandArgument='<%# Eval("ID") %>'
                                                        Height="20px" ToolTip="Delete" CausesValidation="false">
                                            <img alt="" height="16px" width="16px" src='Images/delete.png' border="0" />
                                                    </asp:LinkButton>
                                                    <asp:ConfirmButtonExtender runat="server" ID="ConfirmRefDel" TargetControlID="cmdrefDel"
                                                        ConfirmText="Do you want to Delete?"></asp:ConfirmButtonExtender>
                                                </div>
                                            </th>
                                        </tr>
                                        <tr>
                                            <td>Name
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Name")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Organization
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Organization")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Designation
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Designation")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Address
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Address")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Phone (Off)
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Phone_Off")%>
                                            </td>
                                        </tr>
                                        <tr class='<%# Eval("Ref_Phone_Res").ToString().Trim() == "" ? "hidden" : "" %>'>
                                            <td>Phone (Res)
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Phone_Res")%>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>Mobile
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Mobile")%>
                                            </td>
                                        </tr>
                                        <tr class='<%# Eval("Ref_Email").ToString().Trim() == "" ? "hidden" : "" %>'>
                                            <td>Email
                                            </td>
                                            <td>
                                                <%# Eval("Ref_Email")%>
                                            </td>
                                        </tr>
                                        <tr class="silver">
                                            <td>Modify
                                            </td>
                                            <td>
                                                <%-- <%# Eval("ModifiedBY") %>--%>
                                                on <span title='<%# Eval("DT","{0:dddd \ndd, MMMM yyyy \nh:mm:ss tt}")%>'>
                                                    <%# UserControl1.ToRecentDateTime(Eval("DT"))%>
                                                    <time class="timeago" datetime='<%# Eval("DT","{0:yyyy-MM-dd HH:mm:ss}") %>'></time>
                                                </span>
                                            </td>
                                        </tr>
                                    </table>
                                </ItemTemplate>
                            </asp:DataList>
                            <asp:SqlDataSource ID="SqlDataSourceGrid" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="s_Reference"
                                SelectCommandType="StoredProcedure">
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                            </asp:SqlDataSource>
                            <asp:SqlDataSource ID="SqlDataSourceRef" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM Reference WHERE ID=@ID" SelectCommandType="Text"
                                UpdateCommand="s_Ref_Edit" OnUpdated="SqlDataSourceRef_Updated" UpdateCommandType="StoredProcedure"
                                OnSelected="SqlDataSourceRef_Selected" InsertCommand="s_Ref_Add" InsertCommandType="StoredProcedure"
                                OnInserted="SqlDataSourceRef_Inserted" DeleteCommand="DELETE FROM Reference WHERE UserID = @UserID AND ID = @ID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <%--<asp:QueryStringParameter Name="EMPID" QueryStringField="ID" Type="String" />--%>
                                    <asp:ControlParameter Name="ID" ControlID="DataListReferences" PropertyName="SelectedValue" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />

                                    <asp:Parameter Name="Ref_Organization" Type="String" />
                                    <asp:Parameter Name="Ref_Designation" Type="String" />
                                    <asp:Parameter Name="Ref_Address" Type="String" />
                                    <asp:Parameter Name="Ref_Phone_Off" Type="String" />
                                    <asp:Parameter Name="Ref_Phone_Res" Type="String" />
                                    <asp:Parameter Name="Ref_Email" Type="String" />
                                    <asp:Parameter Name="Ref_Mobile" Type="String" />
                                    <asp:Parameter Name="Ref_Relation" Type="String" />

                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />

                                    <asp:Parameter Name="Ref_Designation" Type="String" />
                                    <asp:Parameter Name="Ref_Address" Type="String" />
                                    <asp:Parameter Name="Ref_Phone_Off" Type="String" />
                                    <asp:Parameter Name="Ref_Phone_Res" Type="String" />
                                    <asp:Parameter Name="Ref_Email" Type="String" />
                                    <asp:Parameter Name="Ref_Mobile" Type="String" />
                                    <asp:Parameter Name="Ref_Relation" Type="String" />

                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>




                <asp:TabPanel runat="server" ID="tabpanelOthers" HeaderText="Others">
                    <HeaderTemplate>
                        Others
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Other Information</h4>
                        <div class="tab-body">
                            <asp:DetailsView ID="DetailsViewOthers" runat="server" AutoGenerateRows="False"
                                CssClass="table table-responsive table-condensed table-hover table-bordered"
                                DataSourceID="SqlDataSourceOthers" DataKeyNames="ID" DefaultMode="ReadOnly"
                                OnItemCommand="DetailsViewOthers_ItemCommand" OnDataBinding="DetailsViewOthers_DataBound">

                                <Fields>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Prefered Job Location
                                             <div style="float: right">
                                                 <asp:LinkButton ID="cmdEditOthers" runat="server" CausesValidation="false"
                                                     CommandName="Edit" ToolTip="Edit">
                                                    <img alt="" height="16" width="16" src='Images/edit.png' border="0" />
                                                 </asp:LinkButton>
                                             </div>
                                        </ItemTemplate>
                                        <InsertItemTemplate>
                                            Prefered Job Location

                                        </InsertItemTemplate>
                                        <EditItemTemplate>Prefered Job Location</EditItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Prefered Location" ShowHeader="false">
                                        <ItemTemplate>
                                            <%--<asp:Label ID="lblPrefered_Location" runat="server" Text='<%# Eval("Prefered_Location") %>'></asp:Label>--%>
                                            <%# Eval("Prefered_Location") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:DropDownList ID="cboPreferedLocation" runat="server" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourcePreferedLocation" DataTextField="DIST_NAME" DataValueField="DIST_CODE"
                                                SelectedValue='<%# Bind("PreferedLocationID") %>'>
                                                <%-- <asp:ListItem></asp:ListItem>--%>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourcePreferedLocation" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT DIST_CODE, DIST_NAME FROM [BD_District] order by DIST_NAME"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="cboPreferedLocation"
                                                ValidationGroup="tabOhters" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:DropDownList ID="cboPreferedLocation" runat="server" AppendDataBoundItems="true"
                                                DataSourceID="SqlDataSourcePreferedLocation" DataTextField="DIST_NAME" DataValueField="DIST_CODE"
                                                SelectedValue='<%# Bind("PreferedLocationID") %>'>
                                                <%-- <asp:ListItem></asp:ListItem>--%>
                                            </asp:DropDownList>
                                            <asp:SqlDataSource ID="SqlDataSourcePreferedLocation" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="SELECT DIST_CODE, DIST_NAME FROM [BD_District] order by DIST_NAME"></asp:SqlDataSource>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorwsdas1" runat="server" ControlToValidate="cboPreferedLocation"
                                                ValidationGroup="tabOhters" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Prefered Job Category
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            <%-- <asp:HiddenField ID="hidJobCategoryIDs" runat="server" Value='<%# Eval("PreferedJobCategory") %>' />
                                            <asp:ListBox SelectionMode="Multiple" clientid="jobcategory" ID="lbPreferedJobCategory" runat="server" disabled="disabled"
                                                DataSourceID="SqlDataSourceJobCategory" DataTextField="CategoryName" DataValueField="ID" OnDataBound="lbPreferedJobCategory_DataBound"></asp:ListBox>

                                            <asp:SqlDataSource ID="SqlDataSourceJobCategory" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_PreferedJobCategory_Select" SelectCommandType="StoredProcedure"></asp:SqlDataSource>--%>

                                            <asp:DataList ID="DataList1" DataSourceID="SqlDataSourceJobCategory1" runat="server">
                                                <ItemTemplate>
                                                    <li><%# Eval("CategoryName") %></li>
                                                </ItemTemplate>
                                            </asp:DataList>

                                            <asp:SqlDataSource ID="SqlDataSourceJobCategory1" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_PreferedJobCategory" SelectCommandType="StoredProcedure">
                                                <SelectParameters>
                                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                                </SelectParameters>
                                            </asp:SqlDataSource>


                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:HiddenField ID="hidJobCategoryIDs" runat="server" Value='<%# Eval("PreferedJobCategory") %>' />
                                            <asp:ListBox SelectionMode="Multiple" clientid="jobcategory" ID="lbPreferedJobCategory" runat="server"
                                                DataSourceID="SqlDataSourceJobCategory" DataTextField="CategoryName" DataValueField="ID" OnDataBound="lbPreferedJobCategory_DataBound"></asp:ListBox>

                                            <asp:SqlDataSource ID="SqlDataSourceJobCategory" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_PreferedJobCategory_Select" SelectCommandType="StoredProcedure"></asp:SqlDataSource>


                                        </EditItemTemplate>
                                        <InsertItemTemplate>

                                            <asp:HiddenField ID="hidJobCategoryIDs" runat="server" Value='<%# Eval("PreferedJobCategory") %>' />
                                            <asp:ListBox SelectionMode="Multiple" clientid="jobcategory" ID="lbPreferedJobCategory" runat="server"
                                                DataSourceID="SqlDataSourceJobCategory" DataTextField="CategoryName" DataValueField="ID" OnDataBound="lbPreferedJobCategory_DataBound"></asp:ListBox>

                                            <asp:SqlDataSource ID="SqlDataSourceJobCategory" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                                SelectCommand="s_PreferedJobCategory_Select" SelectCommandType="StoredProcedure"></asp:SqlDataSource>

                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="" ShowHeader="false">
                                        <ItemTemplate>
                                            Discloser
                                        </ItemTemplate>
                                        <ItemStyle CssClass="td-header" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Discloser" ShowHeader="false">
                                        <ItemTemplate>
                                            <%# Eval("Discloser").ToString().Replace("\n", "<br />") %>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:TextBox ID="txtDiscloser" runat="server" MaxLength="255" Text='<%# Bind("Discloser") %>'
                                                Width="95%" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDiscloser" runat="server" ControlToValidate="txtDiscloser"
                                                ValidationGroup="tabOthers" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:TextBox ID="txtDiscloser" runat="server" MaxLength="255" Text='<%# Bind("Discloser") %>'
                                                Width="95%" TextMode="MultiLine" Rows="3"></asp:TextBox>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidatorDiscloser" runat="server" ControlToValidate="txtDiscloser"
                                                ValidationGroup="tabOthers" ErrorMessage="*" SetFocusOnError="True"></asp:RequiredFieldValidator>
                                        </InsertItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField ShowHeader="False">
                                        <ItemTemplate>
                                            <%-- <asp:Button ID="cmdEdit" runat="server" CausesValidation="False" CommandName="Edit"
                                                Text="Edit" />
                                            &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="New"
                                                Text="New" />--%>
                                        </ItemTemplate>
                                        <EditItemTemplate>
                                            <asp:Button ID="cmdUpdate" runat="server" CausesValidation="True" CommandName="Update"
                                                Text="Update" ValidationGroup="tabOthers" />
                                            <asp:ConfirmButtonExtender ID="cmdUpdate_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                                Enabled="True" TargetControlID="cmdUpdate"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="Button2" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </EditItemTemplate>
                                        <InsertItemTemplate>
                                            <asp:Button ID="Button1" runat="server" CausesValidation="true" CommandName="Insert"
                                                Text="Insert" ValidationGroup="tabOthers" />
                                            <asp:ConfirmButtonExtender ID="Button1_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Save?"
                                                Enabled="True" TargetControlID="Button1"></asp:ConfirmButtonExtender>
                                            &nbsp;<asp:Button ID="cmdCancel2" runat="server" CausesValidation="False" CommandName="Cancel"
                                                Text="Cancel" />
                                        </InsertItemTemplate>
                                        <ControlStyle Width="80px" />
                                        <ItemStyle BackColor="White" />
                                    </asp:TemplateField>
                                </Fields>
                                <EmptyDataTemplate>
                                    To add your other information please click:
                            <asp:LinkButton runat="server" ID="cmdNewOthers" CommandName="New"> 
                                    <img src="Images/add.png" width="16" height="16" />
                            </asp:LinkButton>
                                </EmptyDataTemplate>

                            </asp:DetailsView>


                            <asp:SqlDataSource ID="SqlDataSourceOthers" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                                SelectCommand="SELECT * FROM v_Others WHERE UserID=@UserID" SelectCommandType="Text"
                                UpdateCommand="s_Others_Edit" OnUpdated="SqlDataSourceOthers_Updated" UpdateCommandType="StoredProcedure"
                                InsertCommand="s_Others_Add" InsertCommandType="StoredProcedure" OnInserting="SqlDataSourceOthers_Inserting"
                                OnUpdating="SqlDataSourceOthers_Updating"
                                OnInserted="SqlDataSourceOthers_Inserted" DeleteCommand="DELETE FROM Others WHERE UserID = @UserID">
                                <DeleteParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="ID" />
                                </DeleteParameters>
                                <SelectParameters>
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                </SelectParameters>
                                <UpdateParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Discloser" Type="String" />
                                    <asp:Parameter Name="PreferedLocationID" Type="String" />
                                    <asp:Parameter Name="PreferedJobCategory" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </UpdateParameters>
                                <InsertParameters>
                                    <asp:Parameter Direction="ReturnValue" Name="RETURN_VALUE" Type="Int32" />
                                    <asp:Parameter DefaultValue="0" Direction="InputOutput" Name="ID" Type="Int32" />
                                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                                    <asp:Parameter Name="Discloser" Type="String" />
                                    <asp:Parameter Name="PreferedLocationID" Type="Int32" />
                                    <asp:Parameter Name="PreferedJobCategory" Type="String" />
                                    <asp:Parameter Direction="InputOutput" Name="Msg" Type="String" DefaultValue="" Size="255" />
                                    <asp:Parameter Direction="InputOutput" Name="Done" Type="Boolean" DefaultValue="false" />
                                </InsertParameters>
                            </asp:SqlDataSource>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>



                <asp:TabPanel runat="server" ID="tabpanelPic" HeaderText="Picture">
                    <HeaderTemplate>
                        Picture
                    </HeaderTemplate>
                    <ContentTemplate>
                        <h4>Profile Picture</h4>
                        <div class="tab-body">
                            <asp:Panel runat="server" ID="PanelProfileImage" Style="margin-bottom: 10px">
                                <img src="Images/loader.gif" loadimg='ProfileImage.ashx?id=<%= Session["USERID"].ToString() %>&keycode=<%= Session["KEYCODE"].ToString() %>' width="300" class="loadimg img-rounded img-responsive img-thumbnail" />
                            </asp:Panel>
                            <asp:HiddenField ID="hidTime" runat="server" />
                            <asp:Panel ID="Panel1" runat="server">

                                <table class="table table-responsive table-condensed table-bordered">
                                    <tr>
                                        <td class="td-header">
                                            <b>Select JPG File (max 2 MB):</b>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:AsyncFileUpload ID="FileUpload1" runat="server" UploadingBackColor="Yellow"
                                                CssClass="AsyncFileUploadField" ThrobberID="myThrobber"
                                                OnUploadedComplete="FileUpload1_UploadedComplete"
                                                OnClientUploadComplete="UploadComplete"
                                                OnClientUploadError="UploadError"
                                                OnUploadedFileError="FileUpload1_UploadedFileError"
                                                OnClientUploadStarted="AsyncFileUpload1_StartUpload"
                                                UploaderStyle="Traditional" />
                                            <asp:Image ImageUrl="Images/ajax-loader.gif" ID="myThrobber" runat="server" />

                                        </td>
                                    </tr>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlCrop" runat="server" Visible="false">
                                <div class="bold alert alert-success">
                                    Please select the area to crop the image.
                                </div>
                                <asp:Image ID="imgCrop" CssClass="loadimg" runat="server" />
                                <br />
                                <asp:HiddenField ID="X" runat="server" />
                                <asp:HiddenField ID="Y" runat="server" />
                                <asp:HiddenField ID="W" runat="server" />
                                <asp:HiddenField ID="H" runat="server" />
                                <asp:Button ID="btnCrop" Width="100px" Height="30px" runat="server" Text="Crop" Font-Bold="true"
                                    OnClick="btnCrop_Click" />
                            </asp:Panel>
                            <asp:Panel ID="pnlCropped" runat="server" Visible="false">
                                <asp:Image ID="imgCropped" runat="server" CssClass="img-responsive img-thumbnail img-rounded" Width="300px" />
                                <div style="margin-bottom: 10px; margin-top: 20px">
                                    <asp:CheckBox ID="ckhAgree" CssClass="bold" runat="server" Text=" I am ensuring that, this is my picture and this picture complies with the instructions." />
                                </div>
                                <asp:Button ID="cmdSave" Width="100px" Height="30px" runat="server" Font-Bold="true"
                                    Text="Save" OnClick="cmdSave_Click" />
                                <asp:ConfirmButtonExtender ID="cmdSave_ConfirmButtonExtender" runat="server" ConfirmText="Do you want to Update?"
                                    Enabled="True" TargetControlID="cmdSave"></asp:ConfirmButtonExtender>
                            </asp:Panel>
                            <asp:Label ID="lblUploadStatus" runat="server" Text="" Style="font-size: small;"></asp:Label>
                            <span style="display: none; padding-top: 10px" id="UploadBtn">
                                <br />
                                <asp:Button ID="cmdUpload" runat="server" CausesValidation="false" Font-Bold="true"
                                    Text="Show" Width="100px" OnClick="cmdUpload_Click" Height="30px" /></span>
                        </div>
                    </ContentTemplate>
                </asp:TabPanel>

            </asp:TabContainer>
            <asp:SqlDataSource ID="SqlDataSource_CV_Completion" runat="server" ConnectionString="<%$ ConnectionStrings:JobPortalConnectionString %>"
                SelectCommand="s_CV_Completion"
                SelectCommandType="StoredProcedure">
                <SelectParameters>
                    <asp:SessionParameter SessionField="USERID" Name="UserID" Type="Int32" />
                </SelectParameters>
            </asp:SqlDataSource>



            <div class="tab-footer">
                <div class="bold">
                    Completion of my CV:<div style="float: right">
                        <asp:Literal ID="litPrint" runat="server"></asp:Literal>
                    </div>
                </div>

                <asp:DataList ID="DataListCV_Completion" runat="server" DataSourceID="SqlDataSource_CV_Completion"
                    ShowFooter="False" ShowHeader="False" BorderStyle="None" BorderWidth="0px"
                    Width="100%">
                    <ItemStyle BackColor="White" />
                    <ItemTemplate>
                        <div class="progress" style="margin-bottom: 0">
                            <div class="progress-bar progress-bar-success progress-bar-striped" role="progressbar" aria-valuenow='<%# Eval("Completion") %>'
                                aria-valuemin="0" aria-valuemax="100" style="width: <%# Eval("Completion") %>%;">
                                <a href="https://www.google.com" style="color: white; text-shadow: -1px -1px 1px rgba(0,0,0,.5)"><%# Eval("Completion") %>%</a>
                            </div>
                        </div>
                        <%# Eval("Msg") %>
                    </ItemTemplate>
                </asp:DataList>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server" DynamicLayout="false" AssociatedUpdatePanelID="UpdatePanel1"
        DisplayAfter="10">
        <ProgressTemplate>
            <div class="TransparentGrayBackground">
            </div>
            <asp:Image ID="Image1" runat="server" alt="" ImageUrl="~/Images/processing.gif" CssClass="LoadingImage"
                Width="214" Height="138" />
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:AlwaysVisibleControlExtender ID="UpdateProgress1_AlwaysVisibleControlExtender"
        runat="server" Enabled="True" HorizontalSide="Center" TargetControlID="Image1"
        UseAnimation="false" VerticalSide="Middle"></asp:AlwaysVisibleControlExtender>
</asp:Content>
