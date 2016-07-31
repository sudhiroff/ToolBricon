<%@ Page Title="" Language="C#" MasterPageFile="~/secure/Site.master" AutoEventWireup="true" CodeFile="TradeMaster.aspx.cs" Inherits="secure_TradeMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
 <script type="text/javascript">
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
    </script>
    <div class="row">
       
                <div class="col-lg-12">
                    <div class="col-md-12 clearfix" style="padding-left: 0px;">
                        <table>
                            <tr>
                                <td> <h3 class="page-header" style="float: left">Trade master</h3></td>
                                <td><asp:LinkButton Style="float: left; margin-left: 20px" ID="lbtnAdd" Text="Add New" runat="server" CssClass="btn btn-success page-header" PostBackUrl="~/secure/AddTrade.aspx"></asp:LinkButton></td>
                                <td style="padding-left:20px"> <asp:TextBox ID="txtdFromDate" style="width:120px" runat="server" placeholder="from date" CssClass="form-control datepckr"></asp:TextBox>
                                </td>
                                <td style="padding-left:5px"><asp:TextBox ID="txtdToDate" runat="server" placeholder="To date" style="width:120px" CssClass="form-control datepckr"></asp:TextBox></td>

                                <td><asp:LinkButton ID="lbtnDownload" runat="server" Text="Download" CssClass="btn btn-info btn-sm" Style="float: left; margin-left: 20px;" OnClick="lbtnDownload_Click"></asp:LinkButton></td>
                                
                            </tr>
                        </table>                 
                     </div>
                </div>
         <asp:UpdatePanel ID="uppanel" runat="server" ChildrenAsTriggers="true">
            <ContentTemplate>
                 <div class="col-lg-12">
                    <table>
                        <tr class="">
                            <td><asp:DropDownList ID="ddlSuplierNo" CssClass="form-control" style="width:180px" runat="server"></asp:DropDownList> 
                                <%--<asp:RequiredFieldValidator ID="rfvClient" runat="server" ControlToValidate="ddlClient" Text="Please select client." ForeColor="Red" InitialValue="0" ValidationGroup="search"></asp:RequiredFieldValidator>--%>
                            </td>
                            <td style="padding-left:10px"><asp:DropDownList ID="ddlClient" CssClass="form-control" style="width:180px" OnSelectedIndexChanged="ddlClient_SelectedIndexChanged" AutoPostBack="true" runat="server"></asp:DropDownList> 
                                <%--<asp:RequiredFieldValidator ID="rfvClient" runat="server" ControlToValidate="ddlClient" Text="Please select client." ForeColor="Red" InitialValue="0" ValidationGroup="search"></asp:RequiredFieldValidator>--%>
                            </td>
                            <td style="padding-left:10px"><asp:DropDownList ID="ddlSiteAddress" style="width:180px" CssClass="form-control" runat="server">
                                  <asp:ListItem Text="--Select Address--" Value="0"></asp:ListItem>
                                </asp:DropDownList> 
                                <%--<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlSiteAddress" Text="Please select address." ForeColor="Red" InitialValue="0" ValidationGroup="search"></asp:RequiredFieldValidator>--%>
                            </td>
                            <td style="padding-left:10px"><asp:TextBox ID="txtFromDate" CssClass="form-control datepckr" runat="server" placeholder="From Date" style="width:120px"></asp:TextBox></td>
                            <td style="padding-left:10px"><asp:TextBox ID="txtToDate" CssClass="form-control datepckr" runat="server" placeholder="To Date" style="width:120px"></asp:TextBox> </td>
                            <td style="padding-left:10px"><asp:LinkButton ID="lbtnSearch" runat="server" Text="Search" CssClass="btn btn-success btn-sm" ValidationGroup="search" OnClientClick="return CheckDate();"  OnClick="lbtnSearch_Click"></asp:LinkButton></td>
                            <td style="padding-left:10px;font-weight:bold">Total <span id="lblCount" runat="server"></span> results.</td>
                        </tr>
                    </table>
                    <hr style="margin:10px 0px 5px 0px" />
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12 nice-scroll" id="gridData" style="width:1160px;overflow-x:auto;height:475px">
                    <div style="width:1138px;font-size:12px;position:relative">
                    <asp:GridView ID="grid" runat="server" Width="100%" CssClass="table table-bordered"
                        AutoGenerateColumns="false" ShowHeader="true" EmptyDataText="No record found"
                        ShowHeaderWhenEmpty="true" OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing" PageSize="12" AllowPaging="false" PagerStyle-CssClass="pagination-sm pagination" OnPageIndexChanging="grid_PageIndexChanging">
                        <Columns>
                            <asp:TemplateField ItemStyle-Width="100px" HeaderText="">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lbtnEdit" Text="Edit" runat="server" CssClass="btn btn-xs btn-info" Visible='<%# Eval("IsInvoiceGenerate").ToString()=="True"? Convert.ToBoolean("False"):Convert.ToBoolean("True") %>' CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="Delete" runat="server" CssClass="btn btn-xs btn-danger" Visible='<%# Eval("IsInvoiceGenerate").ToString()=="True"? Convert.ToBoolean("False"):Convert.ToBoolean("True") %>' CommandArgument='<%# Eval("Id") %>' OnClientClick="return confirm('Are you sure you want to delete it?');"
                                        CommandName="delete"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Order No." ItemStyle-Width="110px">
                                <ItemTemplate>
                                    <%# Eval("POrderId") %>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <%--<asp:BoundField HeaderText="Item Code" DataField="ItemCode" />--%>
                            <asp:BoundField HeaderText="Item Description." DataField="ItemDescription" ItemStyle-CssClass="hidden-xs" HeaderStyle-CssClass="hidden-xs" />
                            <asp:BoundField HeaderText="Vehicle No" DataField="VehicleNo" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Challan No." DataField="ChallanNo" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Ship date" DataField="Shipdate" ItemStyle-Width="90px" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Quantity" DataField="Quantity" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Sell Rate" DataField="UnitPrice" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Sell Cost" DataField="SubTotal" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Buy rate" DataField="BuyRate" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Buy cost" DataField="BuyCost" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Suplier No" DataField="SuplierId" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                        </Columns>
                    </asp:GridView>
                         <asp:UpdateProgress ID="upprogres" runat="server">
                    <ProgressTemplate>
                        <img runat="server" alt="" src="~/Images/progress.gif" style="position:absolute;top:200px;left:40%" />
                    </ProgressTemplate>
                </asp:UpdateProgress>
                    </div>
                </div>           
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>

