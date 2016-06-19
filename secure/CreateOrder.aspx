<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true"
    CodeFile="CreateOrder.aspx.cs" Inherits="secure_CreateOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
    function hide() {
        $('#myModal').modal('hide');
    }

    $(document).ready(function () {
        $('#<%=btnAddItem.ClientID %>').on('click', function () {
            var a = $('#<%=ddlItemCode.ClientID %>').val();
            var b = $('#<%=txtItem.ClientID %>').val();
            var c = $('#<%=txtQuantity.ClientID %>').val();
            var d = $('#<%=txtSellRate.ClientID %>').val();
            var e = $('#<%=txtBuyRate.ClientID %>').val();
            if (a == "0") {
                return false;
            }
            if (b == "" && c == "" && d == "" && e == "") {
                return false;
            }
        });
    });
    function ajaxreq() {
        var url = '<%= ResolveClientUrl("~/secure/CreateOrder.aspx/GetItemName") %>'
        var selectedId = $('#<%=ddlItemCode.ClientID %>').val();
        $.ajax({
            type: "POST",
            url: url,
            data: '{"Id":"' + selectedId + '"}',
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            success: function (data) {
                $('#<%=txtItem.ClientID%>').val(data.d.split(';')[0]);
                $('#<%=txtItemTax.ClientID%>').val(data.d.split(';')[1]);

                $('#<%=txtItem.ClientID%>').attr('readonly', 'true');
                $('#<%=txtItemTax.ClientID%>').attr('readonly', 'true');
            },
            error: function (err) {
                alert(err);
            }
        });
    }           
    </script>
    <asp:UpdatePanel ID="uppanel" runat="server"><ContentTemplate>
    <div>
        <div class="modal-header">            
            <h4 class="modal-title" id="myModalLabel">
                Purchase order</h4>
        </div>
        <div class="modal-body create-order">
               <div class="col-md-12 clearfix">
                    <div class="col-md-4 col-sm-6">
                        P.O. Date
                        <asp:TextBox ID="txtPODate" CssClass="form-control datepckr" placeholder="Purchase order date"
                            runat="server" required></asp:TextBox>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        Start Date
                        <asp:TextBox ID="txtStartDate" CssClass="form-control datepckr" placeholder="Start date"
                            runat="server" required></asp:TextBox>
                    </div>
                    <div class="col-md-4">
                        End Date
                        <asp:TextBox ID="txtEndDate" CssClass="form-control datepckr" placeholder="End date"
                            runat="server" required></asp:TextBox>
                    </div>
                </div>
            <div class="col-md-12" style="height:10px"></div>
                <div class="col-md-12 clearfix">
                    <div class="col-md-4 col-sm-6">
                       Client
                        <asp:DropDownList ID="ddlClient" CssClass="form-control" runat="server" OnSelectedIndexChanged="ddlClient_SelectedIndexChanged" AutoPostBack="true">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 col-sm-6">
                        Shipping Address
                        <asp:DropDownList ID="ddlShippngAddress" CssClass="form-control"
                            runat="server" required>
                            <asp:ListItem Text="--Select--" Value="0"></asp:ListItem>
                        </asp:DropDownList>
                    </div>                    
                    <div class="col-md-4 col-sm-6">
                        Order Description
                        <asp:TextBox ID="txtOrderDes" CssClass="form-control" placeholder="Order description"
                            runat="server" required></asp:TextBox>
                    </div>
                </div> 
            <div class="col-md-12" style="height:10px"></div>    
            <div class="col-md-12 clearfix">
                <div class="col-md-5" style="padding-left: 0px">
                    <div class="col-md-4 col-sm-4 col-xs-6">
                        Item Code
                        <asp:DropDownList ID="ddlItemCode" CssClass="form-control ddlItemCode input-sm" onchange="ajaxreq();"
                            runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 col-sm-4 col-xs-6">
                        Item
                        <asp:TextBox ID="txtItem" CssClass="form-control input-sm" placeholder="Item description"
                            runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md4 col-sm-4 col-xs-6">
                        Tax
                        <asp:TextBox ID="txtItemTax" CssClass="form-control input-sm" placeholder="Item tax %"
                            runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-7" style="padding-left: 0px">
                    <div class="col-md-3 col-sm-4 col-xs-6">
                        Quantity
                        <asp:TextBox ID="txtQuantity" CssClass="form-control input-sm" placeholder="Quantity" ValidationGroup="item"
                            runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 col-sm-4 col-xs-6">
                        Sell Rate
                        <asp:TextBox ID="txtSellRate" CssClass="form-control input-sm" placeholder="Sell rate"
                            runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md-3 col-sm-4 col-xs-6">
                        Buy Rate
                        <asp:TextBox ID="txtBuyRate" CssClass="form-control input-sm" placeholder="Buy rate"
                            runat="server"></asp:TextBox>
                    </div>
                    
                </div>
            </div>
            <div class="col-md-12 clearfix">
                <div class="col-md-5" style="padding-left: 0px">
                    <div class="col-md-4 col-sm-4 col-xs-6">
                        Suplier No.
                        <asp:DropDownList ID="ddlSuplierNo" CssClass="form-control ddlItemCode input-sm"
                            runat="server">
                        </asp:DropDownList>
                    </div>
                    <div class="col-md-4 col-sm-4 col-xs-6">
                        Rate From
                        <asp:TextBox ID="txtRateFrom" CssClass="form-control input-sm datepckr" placeholder="Rate apply from date"
                            runat="server"></asp:TextBox>
                    </div>
                    <div class="col-md4 col-sm-4 col-xs-6">
                        Rate To
                        <asp:TextBox ID="txtRateTo" CssClass="form-control input-sm datepckr" placeholder="Rate apply to date"
                            runat="server"></asp:TextBox>
                    </div>
                </div>
                <div class="col-md-7" style="padding-left: 0px">                    
                    <div class="col-md-6 col-sm-4 col-xs-6">
                        <br />
                        <asp:Button ID="btnAddItem" runat="server" Text="Add" ValidationGroup="item"
                            CssClass="btn btn-sm btn-success" OnClick="btnAddItem_Click" formnovalidate />
                        <asp:Button ID="btnAddCancel" runat="server" Visible="false" Text="Cancel" CausesValidation="false"
                            CssClass="btn btn-sm btn-success" OnClientClick="location.reload();" formnovalidate />
                        <asp:HiddenField ID="hdnItemIndex" runat="server" Value="-1" />
                    </div>
                </div>
            </div>
            <div class="col-md-12" style="height:10px"></div>
                <div class="col-md-12 clearfix">
                    <asp:GridView ID="grid" runat="server" Width="100%" CssClass="table table-bordered" style="margin-top:5px;margin-left: 15px;"
                        AutoGenerateColumns="false" ShowHeader="true" EmptyDataText="No record found"
                        ShowHeaderWhenEmpty="true" OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:BoundField HeaderText="Item Code" DataField="ItemCode"  />                            
                            <asp:BoundField HeaderText="Item Des." DataField="ItemDes" />
                            <asp:BoundField HeaderText="Tax." DataField="Tax" />
                            <asp:BoundField HeaderText="Quntity" DataField="Quantity" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Sell rate" DataField="SellRate" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm"/>
                            <asp:BoundField HeaderText="Buy rate" DataField="BuyRate" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm"/>
                            <asp:BoundField HeaderText="Suplier No." DataField="SuplierId" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm"/>
                            <asp:BoundField HeaderText="Rate From" DataField="RateFrom" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm"/>
                            <asp:BoundField HeaderText="Rate To" DataField="RateTo" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm"/>
                            <asp:TemplateField>
                                <ItemTemplate>
                                   <asp:LinkButton ID="LinkButton2" Text="Edit" runat="server" CommandArgument='<%# Container.DataItemIndex %>' CommandName="edit"></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="Delete" runat="server" CommandArgument='<%# Container.DataItemIndex %>'
                                        OnClientClick="return confirm('Are you sure want to delete?')" CommandName="delete"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>

            <table width="100%" class="row">                                          
                <tr class="col-md-12 clearfix">
                    <td colspan="3">
                        <div class="clearfix col-md-12">                            
                       
                        </div>
                    </td>
                </tr>
            </table>
        </div>
        <div class="modal-footer">
            <asp:Button ID="btnClose" class="btn btn-default" runat="server" Text="Cancel" PostBackUrl="~/secure/PurchaseOrder.aspx" formnovalidate />
            <asp:Button ID="btnSubmit" class="btn btn-default" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
            <asp:HiddenField ID="hdnId" Value="0" runat="server" />
        </div>
    </div>
    </ContentTemplate></asp:UpdatePanel>
</asp:Content>
