<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="WebForm1.aspx.cs" Inherits="bd_8.WebForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:SqlDataSource ID="townDataSource" runat="server" ConnectionString="<%$ ConnectionStrings:studentsConnectionString %>" ProviderName="<%$ ConnectionStrings:studentsConnectionString.ProviderName %>" SelectCommand="SELECT pmib8112.p.town AS towns FROM students.pmib8112.p"></asp:SqlDataSource>
        <div>
            <div style="float: right;">
                <asp:TextBox ID="TextBox" runat="server" Width="120px" Enabled="false" />
                <asp:Button ID="ButtonConnect" runat="server" Text="Connection" Width="90px" OnClick="ConnectionButton" />
            </div>
            <div style="float: left;">Лабораторная работа №8. ASP.NET + ADO.NET</div>
        </div>
        <asp:Panel ID="panel" runat="server" Visible="false">
            <div>
                <asp:TextBox Style="margin-top: 7px" ID="TextBox1" runat="server" Width="797px"></asp:TextBox>
                Errors
            </div>
            <div>
                <br />
                ЗАПРОС 1
            <br />
                <div>
                    Получить информацию о поставщиках, которые осуществляли поставки деталей из заданного города в указанный период.
                </div>
                Выберите город:
            <asp:DropDownList ID="Town" runat="server" Width="100px" AutoPostBack="True" DataSourceID="townDataSource" DataTextField="towns" DataValueField="towns" />
                <br />
                Выберете период: с
            <asp:TextBox ID="DateTextBox1" runat="server" TextMode="Date"></asp:TextBox>
                по
        <asp:TextBox ID="DateTextBox2" runat="server" TextMode="Date"></asp:TextBox>
                <br />
                <asp:Button ID="Button1" runat="server" Text="Exe" Width="90px" OnClick="Request1" />
                <br />
                <br />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="n_post" HeaderText="n_post" />
                        <asp:BoundField DataField="name" HeaderText="name" />
                        <asp:BoundField DataField="reiting" HeaderText="reiting" />
                        <asp:BoundField DataField="town" HeaderText="town" />
                    </Columns>
                </asp:GridView>
            </div>
            <div>
                <br />
                <br />
                ЗАПРОС 2
            <br />
                <div>Вставить поставщика с заданными параметрами</div>
                имя 
        <br />
                <asp:TextBox ID="TextBoxName" runat="server" ToolTip="name" Width="200px" />
                <br />
                рейтинг 
        <br />
                <asp:TextBox ID="TextBoxReiting" runat="server" ToolTip="reiting" TextMode="Number" Width="50px" />
                <br />
                город 
        <br />
                <asp:TextBox ID="TextBoxTown" runat="server" ToolTip="town" Width="150px" />
                <br />
                <br />
                <asp:Button ID="Button2" runat="server" Text="Exe" Width="90px" OnClick="Request2" />
            </div>
            <div>
                <div style="float: left;">
                    Таблица S до запроса
                <br />
                    <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="n_post" HeaderText="n_post" />
                            <asp:BoundField DataField="name" HeaderText="name" />
                            <asp:BoundField DataField="reiting" HeaderText="reiting" />
                            <asp:BoundField DataField="town" HeaderText="town" />
                        </Columns>
                    </asp:GridView>
                </div>
                <div style="float: right;">
                    Таблица S после запроса
                <br />
                    <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False">
                        <Columns>
                            <asp:BoundField DataField="n_post" HeaderText="n_post" />
                            <asp:BoundField DataField="name" HeaderText="name" />
                            <asp:BoundField DataField="reiting" HeaderText="reiting" />
                            <asp:BoundField DataField="town" HeaderText="town" />
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
        </asp:Panel>
    </form>
    <div runat="server">
        &nbsp;
    </div>
</body>
</html>
