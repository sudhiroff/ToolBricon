<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true"
    CodeFile="LoanAccount.aspx.cs" Inherits="secure_LoanAccount" %>

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
                    <h3 class="page-header">Loan Account</h3>
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="50%" CssClass="table table-bordered"
                        AutoGenerateColumns="false" ShowHeader="true" EmptyDataText="No record found"
                        ShowHeaderWhenEmpty="true" OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:BoundField HeaderText="Currency" DataField="Currency" />
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnEdit" Text="Edit" runat="server" CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="Delete" runat="server" CommandArgument='<%# Eval("Id") %>'
                                        CommandName="delete"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="col-lg-12">
                    <asp:LinkButton ID="lbtnAdd" Text="Add New" runat="server" CssClass="btn btn-success"
                        data-toggle="modal" data-target="#myModal"></asp:LinkButton>
                </div>
                <div class="col-lg-12">
                    <!-- Modal -->
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
                        data-backdrop="false">
                        <div class="modal-dialog modal-lg" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                        <span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="myModalLabel">
                                        Loan Detail</h4>
                                </div>
                                <div class="modal-body">                                  
                                    <table width="100%">
                                        <tr>
                                            <td>
                                                Borrower/Lander Name
                                                <asp:TextBox ID="txtEndDate" CssClass="form-control" placeholder="Borrower/Lander Name" runat="server"
                                                    required></asp:TextBox>
                                            </td>
                                            <td>
                                                Loan Type
                                                <asp:DropDownList ID="ddlAccountType" runat="server" CssClass="form-control">
                                                <asp:ListItem Text="Loan" Value="Loan"></asp:ListItem>
                                                 <asp:ListItem Text="Borrow" Value="Borrow"></asp:ListItem>
                                                </asp:DropDownList>
                                            </td>
                                            <td>
                                                Principal Amt.
                                                <asp:TextBox ID="txtStartDate" CssClass="form-control" placeholder="Principal amount" runat="server"
                                                    required></asp:TextBox>
                                            </td>                                            
                                        </tr>
                                        <tr>
                                            <td style="height:2px">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Start date
                                                <asp:TextBox ID="txtOrderDes" CssClass="form-control datepckr" placeholder="Start date" runat="server"
                                                    required></asp:TextBox>
                                            </td>
                                            <td>
                                                Intrest Rate
                                                <asp:TextBox ID="txtShippngAddress" CssClass="form-control" placeholder="%" runat="server"
                                                    required></asp:TextBox>
                                            </td>
                                            <%--<td>
                                               Interest Now
                                                <asp:TextBox ID="txtQuantity" CssClass="form-control" placeholder="Interest till date" runat="server"
                                                    required></asp:TextBox>
                                            </td>--%>
                                        </tr>
                                        <%-- <tr>
                                            <td style="height:2px">
                                                &nbsp;
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Principal outstanding
                                                <asp:TextBox ID="TextBox1" CssClass="form-control" placeholder="Principal outstanding" runat="server"
                                                    required></asp:TextBox>
                                            </td>
                                            <td>
                                                Interest outstanding
                                                <asp:TextBox ID="TextBox2" CssClass="form-control" placeholder="Interest outstanding" runat="server"
                                                    required></asp:TextBox>
                                            </td>
                                            <td>
                                               Total outstanding
                                                <asp:TextBox ID="TextBox3" CssClass="form-control" placeholder="Total outstanding" runat="server"
                                                    required></asp:TextBox>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height: 2px">
                                                &nbsp;
                                            </td>
                                        </tr> --%>                                       
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
