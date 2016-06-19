<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="CustomerSiteAddress.aspx.cs" Inherits="secure_CustomerSiteAddress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server">
            <ContentTemplate>
                <div class="col-lg-12">
                    <h3 class="page-header">Customers site address</h3>
                </div>
                <div class="col-lg-12">
                    <table>
                        <tr class="">
                            <td><asp:DropDownList ID="ddlClient" CssClass="form-control" runat="server"></asp:DropDownList>  </td>
                            <td style="padding-left:10px"><asp:LinkButton ID="lbtnSearch" runat="server" Text="Search" CssClass="btn btn-success btn-sm" OnClick="lbtnSearch_Click"></asp:LinkButton>  </td>
                            <td></td>
                        </tr>
                    </table>
                    <hr />
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="100%"
                        CssClass="table table-bordered" AutoGenerateColumns="false" ShowHeader="true"
                        EmptyDataText="No record found" ShowHeaderWhenEmpty="true"
                        OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:BoundField HeaderText="Customer" DataField="CustomerName" /> 
                            <asp:BoundField HeaderText="Contact Person" DataField="ContactPerson" /> 
                            <asp:BoundField HeaderText="Email" DataField="EmailId" /> 
                            <asp:BoundField HeaderText="Mobile" DataField="MobileNo" /> 
                            <asp:BoundField HeaderText="Site Address" DataField="SiteAddress" />                            
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnEdit" Text="Edit" CssClass="btn btn-xs btn-success" runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="Delete" CssClass="btn btn-xs btn-danger" runat="server" OnClientClick="return confirm('Are you sure you want to delete?')" CommandArgument='<%# Eval("Id") %>' CommandName="delete"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                    <div class="col-lg-12" style="padding-left:0px">
                    <asp:LinkButton ID="lbtnAdd" Text="Add New" runat="server" CssClass="btn btn-success" data-toggle="modal" data-target="#myModal"></asp:LinkButton>

                </div>
                    <div class="col-lg-12">
                        <!-- Modal -->
                        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="false">
                            <div class="modal-dialog" role="document">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                        <h4 class="modal-title" id="myModalLabel">Customer Site Address</h4>
                                    </div>
                                    <div class="modal-body clearfix">
                                        <div class="col-md-12">
                                            <table width="100%" class="col-md-12">
                                                 <tr>
                                                    <td>Contact Person</td>
                                                    <td>
                                                        <asp:TextBox ID="txtContactPerson" CssClass="form-control" placeholder="Contact person" runat="server" required></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 5px">&nbsp;</td>
                                                </tr>
                                                 <tr>
                                                    <td>Email Id</td>
                                                    <td>
                                                        <asp:TextBox ID="txtEmail" CssClass="form-control" placeholder="Email id" runat="server" required></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 5px">&nbsp;</td>
                                                </tr>
                                                 <tr>
                                                    <td>Mobile No.</td>
                                                    <td>
                                                        <asp:TextBox ID="txtMobile" CssClass="form-control" placeholder="Mobile number" runat="server" required></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 5px">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td>Address</td>
                                                    <td>
                                                        <asp:TextBox ID="txtCSiteAddress" CssClass="form-control" placeholder="Site address" runat="server" required></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td style="height: 5px">&nbsp;</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                    <div class="modal-footer">
                                        <asp:Button ID="Button1" class="btn btn-default" runat="server" Text="Close" data-dismiss="modal" />
                                        <asp:LinkButton ID="lbtnAddSiteAddress" Text="Add" CssClass="btn btn-default" runat="server" OnClick="lbtnAddSiteAddress_Click"></asp:LinkButton>
                                        <asp:HiddenField ID="hdnSiteAddressId" runat="server" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

