<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="Create-Invoice.aspx.cs" Inherits="secure_Create_Invoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        function CheckItemIsSelected() {
            var isChecked = false;
            $(".chkSelected input[type=checkbox]").each(function () {
                if ($(this).prop('checked') == true) {
                    isChecked = true;
                }
            });
            if (isChecked == false) {
                alert('Please select al least one item for invoice.');
                return false;
            }
        }

        function SelectAll() {
            if ($(".chkAllSelected").prop('checked') == true)
            {
                $(".chkSelected input[type=checkbox]").each(function () {
                    $(this).prop('checked',true);
                });
            }
            else {
                $(".chkSelected input[type=checkbox]").each(function () {
                    $(this).prop('checked', false);
                });
            }
        }
        function CheckDate() {
            var from=$('#<%=txtFromDate.ClientID%>').val();
            var to=$('#<%=txtToDate.ClientID%>').val();
            if (from != '' && to == '') {
                alert('Please also select To Date.');
                return false;
            }
            if (from == '' && to != '') {
                alert('Please also select From Date.');
                return false;
            }
        }
        function filter() {
            var selected = $('#<%=ddlPercent.ClientID %>').val();
            $('#<%=grid.ClientID%> tr').each(function (e) {
                if (e > 0) {
                    var cls = $(this).find('label').hasClass(selected);
                    if (selected == "0") {
                        $(this).show();
                    }
                    else {
                        if (cls == true)
                            $(this).show();
                        else
                            $(this).hide();
                    }
                }
            });
        }
    </script>
    <div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server" ChildrenAsTriggers="true">
            <ContentTemplate>
                <div class="col-lg-12">
                    <div class="col-md-12" style="padding-left: 0px">
                        <h3 class="page-header">Create Invoice</h3>
                    </div>                    
                </div>
                <div class="col-lg-12">
                    <table>
                        <tr class="">
                            <td><asp:DropDownList ID="ddlClient" CssClass="form-control" OnSelectedIndexChanged="ddlClient_SelectedIndexChanged" AutoPostBack="true" runat="server"></asp:DropDownList> 
                                <asp:RequiredFieldValidator ID="rfvClient" runat="server" ControlToValidate="ddlClient" Text="Please select client." ForeColor="Red" InitialValue="0" ValidationGroup="search"></asp:RequiredFieldValidator>
                            </td>
                            <td style="padding-left:10px"><asp:DropDownList ID="ddlSiteAddress" CssClass="form-control" runat="server">
                                  <asp:ListItem Text="--Select Address--" Value="0"></asp:ListItem>
                                </asp:DropDownList> 
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlSiteAddress" Text="Please select address." ForeColor="Red" InitialValue="0" ValidationGroup="search"></asp:RequiredFieldValidator>
                            </td>
                            <td style="padding-left:10px"><asp:TextBox ID="txtFromDate" CssClass="form-control datepckr" runat="server" placeholder="From Date"></asp:TextBox><br /> </td>
                            <td style="padding-left:10px"><asp:TextBox ID="txtToDate" CssClass="form-control datepckr" runat="server" placeholder="To Date"></asp:TextBox><br /> </td>
                            <td style="padding-left:10px"><asp:LinkButton ID="lbtnSearch" runat="server" Text="Search" CssClass="btn btn-success btn-sm" ValidationGroup="search" OnClientClick="return CheckDate();" OnClick="lbtnSearch_Click"></asp:LinkButton><br /><strong>&nbsp;</strong></td>
                            <td></td>
                        </tr>
                    </table>
                    <hr />
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <div class="row" style="padding-bottom:0px">
                        <div class="col-md-9" style="padding-left: 15px">
                            <asp:TextBox ID="txtRemark" CssClass="form-control" Visible="false" Style="width: 767px; height:70px; resize: none;" TextMode="MultiLine" runat="server" Text="" placeholder="Write some word about tax invoice" />
                        </div>
                        <div class="col-md-2" style="padding-left: 0px; padding-bottom: 15px">
                            <asp:DropDownList ID="ddlInvOption" CssClass="form-control" Visible="false" runat="server">
                                <asp:ListItem Text="Cheque" Value="false"></asp:ListItem>
                                <asp:ListItem Text="Cash" Value="true"></asp:ListItem>
                            </asp:DropDownList>
                             <asp:TextBox ID="txtSalesPerson" Visible="false" style="margin-top:5px;" runat="server" CssClass="form-control" placeholder="Sales person name"></asp:TextBox>
                        </div>
                    </div>
                    <div class="nice-scroll" style="height:290px;overflow-y:auto;margin-bottom:10px">
                        <asp:GridView ID="grid" runat="server" Width="100%" CssClass="table table-bordered"
                            AutoGenerateColumns="false" ShowHeader="true" EmptyDataText="No record found" ShowHeaderWhenEmpty="false">
                            <Columns>
                                <asp:TemplateField>
                                    <HeaderTemplate>
                                        <input type="checkbox" onchange="SelectAll();" class="chkAllSelected" />

                                    </HeaderTemplate>
                                    <ItemTemplate>
                                        <asp:CheckBox ID="chkItem" CssClass="chkSelected" runat="server" />
                                        <asp:HiddenField ID="hdnTradeId" Value='<%# Eval("Id") %>' runat="server" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField HeaderText="Order No." DataField="POrderId" />
                                <asp:BoundField HeaderText="Item Code" DataField="ItemCode" />
                                <asp:BoundField HeaderText="Item Des." DataField="ItemDescription" ItemStyle-CssClass="hidden-xs" HeaderStyle-CssClass="hidden-xs" />
                                <asp:BoundField HeaderText="Vehicle No" DataField="VehicleNo" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                                <asp:BoundField HeaderText="Quantity" DataField="Quantity" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                                <asp:BoundField HeaderText="Unit Price" DataField="UnitPrice" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                                <asp:BoundField HeaderText="Sub Total" DataField="SubTotal" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                                <asp:BoundField HeaderText="Buy rate" DataField="BuyRate" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                                <asp:BoundField HeaderText="Buy cost" DataField="BuyCost" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                                <asp:TemplateField HeaderText="Tax" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" >
                                    <ItemTemplate>
                                        <label style="font-weight:normal" class='<%# Eval("TaxPercentage") %>'><%# Eval("TaxPercentage") %></label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                </div>
                <div class="col-lg-12">
                    <div class="col-md-2" style="padding-left:0px;">
                        <asp:LinkButton ID="lbtnCreateInvoice" Visible="false" Text="Create Invoice" runat="server" OnClientClick="return CheckItemIsSelected();" CssClass="btn btn-success" OnClick="lbtnCreateInvoice_Click"></asp:LinkButton></div>
                    <div class="col-md-3">
                       <asp:DropDownList ID="ddlPercent" Visible="false" runat="server" CssClass="form-control input-sm"  onchange="filter();">
                        </asp:DropDownList>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

