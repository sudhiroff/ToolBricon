<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="Settings.aspx.cs" ValidateRequest="false" Inherits="secure_Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function editMode() {
            $('.editmode').removeClass('hidden');
            $('.defaultmode').addClass('hidden');
            return false;
        }

        function defaultMode() {
            $('.editmode').addClass('hidden');
            $('.defaultmode').removeClass('hidden');
            return false;
        }

    </script>
   <%-- <asp:UpdatePanel ID="uppanel" runat="server">
        <ContentTemplate>--%>
            <div>
                <div class="modal-header">
                    <h4 class="modal-title" id="myModalLabel">Settings</h4>
                </div>
                <div class="modal-body clearfix" style="height:250px">
                    <div class="col-md-12 clearfix">
                        <div class="col-md-4 col-sm-6">
                            <strong>Name</strong><br />
                        <asp:TextBox ID="txtName" CssClass="form-control editmode hidden" placeholder="Name"
                            runat="server" required></asp:TextBox>
                            <asp:Label ID="lblName" runat="server" CssClass="defaultmode"></asp:Label>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <strong>Reg. Address</strong><br />
                        <asp:TextBox ID="txtAddressLine1" CssClass="form-control editmode hidden"  placeholder="Address line 1"
                            runat="server" required></asp:TextBox>
                         <asp:TextBox ID="txtAddressLine2" CssClass="form-control editmode hidden"  placeholder="Address line 2"
                            runat="server" required></asp:TextBox>
                            <asp:Label ID="lblAddress" runat="server" CssClass=" defaultmode"></asp:Label>
                        </div>
                        <div class="col-md-4">
                            <strong>Contact Person</strong><br />
                        <asp:TextBox ID="txtContactPerson" CssClass="form-control editmode hidden" placeholder="Contact person"
                            runat="server" required></asp:TextBox>
                            <asp:Label ID="lblContactPerson" runat="server" CssClass=" defaultmode"></asp:Label>
                        </div>
                    </div>
                    
                    <div class="col-md-12 clearfix" style="padding-top:20px">
                        <div class="col-md-4 col-sm-6">
                            <strong>Phone Number</strong><br />
                        <asp:TextBox ID="txtPhnNumber" CssClass="form-control editmode hidden" placeholder="Phone Number"
                            runat="server" required></asp:TextBox>
                            <asp:Label ID="lblPhnNumber" runat="server" CssClass=" defaultmode"></asp:Label>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <strong>Branch Address</strong><br />
                        <asp:TextBox ID="txtBranchAddress" CssClass="form-control editmode hidden" placeholder="Branch address"
                            runat="server" required></asp:TextBox>
                            <asp:Label ID="lblBranchAddress" runat="server" CssClass=" defaultmode"></asp:Label>
                        </div>
                        <div class="col-md-4 col-sm-6">
                            <strong>TIN\CST No.</strong><br />
                        <asp:TextBox ID="txtTinNumber" CssClass="form-control editmode hidden" placeholder="TIN\CST No."
                            runat="server" required></asp:TextBox>
                            <asp:Label ID="lblTinNumber" runat="server" CssClass=" defaultmode"></asp:Label>
                        </div>
                    </div>

                    <div class="col-md-12 clearfix" style="padding-top:20px">
                        <div class="col-md-4 col-sm-6">
                            <strong>Company Logo</strong><br />
                            <img src="" runat="server" id="imgLogo" alt="" class="defaultmode" />
                            <asp:FileUpload ID="uploadImage" CssClass="form-control editmode hidden" runat="server" />
                        </div>
                        <div class="col-md-4 col-sm-6">
                          
                        </div>
                        <div class="col-md-4 col-sm-6">
                         
                        </div>
                    </div>

                </div>
                <div class="modal-footer clearfix">
                    <asp:Button ID="btnEdit" class="btn btn-default defaultmode" OnClientClick="return editMode();" runat="server" Text="Edit" formnovalidate />
                    <asp:Button ID="btnCancel" class="btn btn-default editmode hidden" runat="server" OnClientClick="return defaultMode();" Text="Cancel" formnovalidate />
                    <asp:Button ID="btnSubmit" class="btn btn-default editmode hidden" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
                </div>
            </div>
       <%-- </ContentTemplate>
    </asp:UpdatePanel>--%>
</asp:Content>

