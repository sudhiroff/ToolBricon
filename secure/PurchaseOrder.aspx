<%@ Page Title="Purchase Order" Language="C#" MasterPageFile="~/secure/Site.master"
    AutoEventWireup="true" CodeFile="PurchaseOrder.aspx.cs" Inherits="secure_PurchaseOrder" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="row">
        <asp:UpdatePanel ID="uppanel" runat="server" ChildrenAsTriggers="true">
            <ContentTemplate>
                <div class="col-lg-12">
                    <div class="col-md-11" style="padding-left: 0px">
                        <h3 class="page-header">Purchase order</h3>
                    </div>
                    <div class="col-md-1">
                        <asp:LinkButton ID="lbtnAdd" Text="Add New" runat="server" CssClass="btn btn-success page-header" PostBackUrl="~/secure/CreateOrder.aspx"></asp:LinkButton>
                    </div>
                </div>
                <!-- /.col-lg-12 -->
                <div class="col-lg-12">
                    <asp:GridView ID="grid" runat="server" Width="100%" CssClass="table table-bordered"
                        AutoGenerateColumns="false" ShowHeader="true" EmptyDataText="No record found"
                        ShowHeaderWhenEmpty="true" OnRowCommand="grid_RowCommand" OnRowDeleting="grid_RowDeleting"
                        OnRowEditing="grid_RowEditing">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton2" Text="" ToolTip="view item" runat="server" CssClass="fa fa-reorder" CommandName="view" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="lbtnEdit" Text="" ToolTip="Edit" runat="server" CssClass="fa fa-edit" CommandName="edit" CommandArgument='<%# Eval("Id") %>'></asp:LinkButton>
                                    <asp:LinkButton ID="LinkButton1" Text="" ToolTip="Remove" runat="server" CssClass="fa fa-close" CommandArgument='<%# Eval("Id") %>'
                                        OnClientClick="return confirm('Are you sure want to delete?')" CommandName="delete"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Order No. / Client">
                                <ItemTemplate>
                                    <asp:Label ID="lbl" runat="server" style="font-size:12px" Text='<%#Eval("OrderId") %>'></asp:Label>&nbsp;/&nbsp;
                                    <asp:Label ID="Label1" runat="server" style="font-size:12px"  Text='<%#Eval("CustomerId") %>'></asp:Label>                                    
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField HeaderText="P.O. Date" DataField="PODate" DataFormatString="{0:dd/MM/yyyy}" />
                            <asp:BoundField HeaderText="Start date" DataField="StartDate" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="End date" DataField="EndDate" DataFormatString="{0:dd/MM/yyyy}" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Order description" DataField="OrderDescription" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            <asp:BoundField HeaderText="Shipping Add." DataField="ShippingAddress" ItemStyle-CssClass="hidden-xs hidden-sm" HeaderStyle-CssClass="hidden-xs hidden-sm" />
                            
                        </Columns>
                    </asp:GridView>
                </div>
                <div class="col-lg-12">
                    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" data-backdrop="false">
                        <div class="modal-dialog" role="document" style="width:960px">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title" id="myModalLabel">P.O. Items</h4>
                                </div>
                                <div class="modal-body">
                                    <asp:GridView Width="100%" ID="grdItem" runat="server" CssClass="table table-bordered" AutoGenerateColumns="false">
                                        <Columns>
                                            <asp:BoundField HeaderText="Item Code" DataField="ItemCode" />
                                            <asp:BoundField HeaderText="Description" DataField="ItemDes" />
                                            <asp:BoundField HeaderText="Quantity" DataField="Quantity" />
                                            <asp:BoundField HeaderText="Buy Rate" DataField="BuyRate" />
                                            <asp:BoundField HeaderText="Sell Rate" DataField="SellRate" />
                                            <asp:BoundField HeaderText="Suplier No." DataField="SuplierId" />
                                            <asp:BoundField HeaderText="Rate From" DataFormatString="{0:dd/MM/yyyy}" DataField="RateFrom" />
                                            <asp:BoundField HeaderText="Rate To" DataFormatString="{0:dd/MM/yyyy}" DataField="RateTo" />
                                        </Columns>
                                    </asp:GridView>
                                </div>
                                <div class="modal-footer">
                                    <asp:Button ID="btnClose" class="btn btn-default" runat="server" Text="Close" data-dismiss="modal" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
</asp:Content>
