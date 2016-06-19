<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="TransactionRef.aspx.cs" Inherits="secure_TransactionRef" %>

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
                    <h3 class="page-header">Transaction reference</h3>
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="100%"
                        CssClass="table table-bordered" AutoGenerateColumns="false" ShowHeader="true"
                        EmptyDataText="No record found" ShowHeaderWhenEmpty="true"
                        OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:BoundField HeaderText="Transaction category" DataField="TransactionCategory" />
                            <asp:BoundField HeaderText="Transaction reference" DataField="TransactionRef" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnEdit" Text="Edit" CssClass="btn btn-info btn-xs" runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="Delete" CssClass="btn btn-danger btn-xs" runat="server" CommandArgument='<%# Eval("Id") %>' CommandName="delete"></asp:LinkButton>
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
                                    <h4 class="modal-title" id="myModalLabel">Category</h4>
                                </div>
                                <div class="modal-body">
                                    <table width="100%">
                                        <tr>
                                            <td>Transaction Category</td>
                                            <td>
                                                <asp:DropDownList ID="ddlCat" runat="server" CssClass="form-control"></asp:DropDownList>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 10px">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>Transaction Reference</td>
                                            <td>
                                                <asp:TextBox ID="txtRef" CssClass="form-control" placeholder="Item name" runat="server" required></asp:TextBox>
                                            </td>
                                        </tr>
                                    </table>
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

