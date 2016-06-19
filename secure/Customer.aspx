<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="Customer.aspx.cs" Inherits="secure_Customer" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function hide() {
            $('#myModal').modal('hide');
        }
    </script>
    <div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server">
            <ContentTemplate>
                <div class="col-lg-12">
                    <h3 class="page-header">Customers / Client</h3>
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="100%"
                        CssClass="table table-bordered" AutoGenerateColumns="false" ShowHeader="true"
                        EmptyDataText="No record found" ShowHeaderWhenEmpty="true"
                        OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:BoundField HeaderText="Customer Id" DataField="CustomerId" />
                            <asp:BoundField HeaderText="Name" DataField="CustomerName" />
                             <asp:BoundField HeaderText="Contact Person" DataField="ContactPerson" />
                            <asp:BoundField HeaderText="Email Id" DataField="CustomerEmail" />
                            <asp:BoundField HeaderText="Address" DataField="customerAddress" />
                            <asp:BoundField HeaderText="Mobile No" DataField="MobileNo" />
                             <asp:BoundField HeaderText="Tin No" DataField="TINNo" />
                            <asp:TemplateField ItemStyle-Width="60px">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnEdit" Text="Edit" CssClass="btn btn-xs btn-success" runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <%--<asp:LinkButton ID="LinkButton1" Text="Delete" CssClass="btn btn-xs btn-danger" runat="server" OnClientClick="return confirm('Are you sure you want to delete?')" CommandArgument='<%# Eval("Id") %>' CommandName="delete"></asp:LinkButton>--%>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

                <div class="col-lg-12">
                    <asp:LinkButton ID="lbtnAdd" Text="Add New" runat="server" CssClass="btn btn-success" data-toggle="modal" data-target="#myModal"></asp:LinkButton>

                </div>

                <div class="col-lg-12">
                    <!-- Modal -->
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="false">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="myModalLabel">Customer detail</h4>
                                </div>
                                <div class="modal-body clearfix">
                                    <div class="col-md-12">
                                        <table width="100%" class="col-md-12">
                                            <tr>
                                                <td>Name</td>
                                                <td>
                                                    <asp:TextBox ID="txtName" CssClass="form-control" placeholder="Full name" runat="server" required></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Contact Person</td>
                                                <td>
                                                    <asp:TextBox ID="txtContactPerson" CssClass="form-control" placeholder="Contact person name" runat="server" required></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Email-Id</td>
                                                <td>
                                                    <asp:TextBox ID="txtEmail" CssClass="form-control" placeholder="Email id" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Address</td>
                                                <td>
                                                    <asp:TextBox ID="txtAddress" CssClass="form-control" TextMode="MultiLine" Style="height: 50px; resize: none" placeholder="Address" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Mobile No.</td>
                                                <td>
                                                    <asp:TextBox ID="txtMobileNo" MaxLength="49" CssClass="form-control" placeholder="Mobile no." runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>TIN No.</td>
                                                <td>
                                                    <asp:TextBox ID="txtTin" MaxLength="49" CssClass="form-control" placeholder="Tin no." runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                        </table>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="btnClose" class="btn btn-default" runat="server" Text="Close" data-dismiss="modal" />
                                    <asp:Button ID="btnSubmit" class="btn btn-default" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
                                    <asp:HiddenField ID="hdnId" Value="0" runat="server" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

