<%@ Page Title="Cash book" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="Cashbook.aspx.cs" Inherits="secure_Cashbook" EnableEventValidation="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <script type="text/javascript">
        function getRef()
        {
            <%--var cat = $('#<%=ddlCategory.ClientID%>').val();
            $.ajax({
                    type: "POST",
                    contentType: "application/json; charset=utf-8",
                    url: '<%= ResolveClientUrl("~/secure/Cashbook.aspx/GetReference") %>',
                    data: "{'strCat':'" + cat + "'}",
                    dataType: "json",
                    async: true,
                    success: function (data) {
                        if (data.d != "") {
                            var select = $('#<%=ddlRef.ClientID%>');
                            select.find('option').remove();
                            for (var i = 0; i < data.d.length; i++) {
                                select.append($(document.createElement("option")).attr("value", data.d[i].Id).text(data.d[i].TransactionRef));
                            }
                        }
                    },
                    error: function (result) {
                        //showError(result);
                        alert(result);
                    }
                });--%>
            javascript: setTimeout('__doPostBack(\'ctl00$ContentPlaceHolder1$ddlCategory\',\'LoadRef\')', 0);            
        }
        function openModal() {
            $('#myModal').modal('show');
        }
    </script>
    <div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server">
            <ContentTemplate>
                <div class="col-lg-12">
                    <h3 class="page-header">Daily cash book</h3>
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="100%"
                        CssClass="table table-bordered" AutoGenerateColumns="false" ShowHeader="true"
                        EmptyDataText="No record found" ShowHeaderWhenEmpty="true"
                        OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:TemplateField HeaderText="S.No.">
                                <ItemTemplate><%#Container.DataItemIndex + 1 %></ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="Narration" DataField="Narration" />
                             <asp:BoundField HeaderText="Category" DataField="TransactionCategory" />
                            <asp:BoundField HeaderText="Reference" DataField="TransactionRef" />
                            <asp:BoundField HeaderText="Date" DataField="StartDate" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField HeaderText="Type" DataField="TransactionType" />
                             <asp:BoundField HeaderText="Amount" DataField="Amount" />
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
                                                <td>Narration</td>
                                                <td>
                                                    <asp:TextBox ID="txtNarration" CssClass="form-control" placeholder="Narration" runat="server" required></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Transaction Category</td>
                                                <td>
                                                   <asp:DropDownList ID="ddlCategory" runat="server" onchange="getRef();" CssClass="form-control"></asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Transaction Reference</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlRef" runat="server" CssClass="form-control">
                                                        <asp:ListItem Text="--Select Referance--"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Date</td>
                                                <td>
                                                    <asp:TextBox ID="txtDate" CssClass="form-control datepckr" placeholder="Date" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Transaction Type</td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTransactionType" runat="server" CssClass="form-control">
                                                        <asp:ListItem Text="Withdrawal (debit)" Value="Withdrawal(debit)"></asp:ListItem>
                                                         <asp:ListItem Text="Deposit (credit)" Value="Deposit(credit)"></asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                             <tr>
                                                <td style="height: 5px">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td>Amount</td>
                                                <td>
                                                    <asp:TextBox ID="txtAmount" MaxLength="49" CssClass="form-control" placeholder="Amount" runat="server"></asp:TextBox>
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

