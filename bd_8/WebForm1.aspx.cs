using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Npgsql;
using System.Data;
using System.Data.Odbc;
using System.IO;

namespace bd_8
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        //public static NpgsqlConnection connection;
        public static OdbcConnection connection;
        protected void Page_Load(object sender, EventArgs e)
        {
            
        }

        protected void ConnectionButton(object sender, EventArgs e)
        {
            connection = new OdbcConnection();
            connection.ConnectionString = "Dsn=PostgseSQL16;data source=postgresql.students.ami.nstu.ru;database=students;user id=pmi-b8112;password=eefItUd8;schema=pmib8112";
            try
            {
                connection.Open();
                TextBox.Text = "Connectoin success\n";
                panel.Visible = true;

                //string request = "SELECT distinct(town) from pmib8112.p";
                //OdbcCommand command = new OdbcCommand(request, connection);
                //List<string> town = new List<string>();
                //OdbcTransaction transaction = null;
                //try
                //{
                //    transaction = connection.BeginTransaction();
                //    command.Transaction = transaction;
                //    OdbcDataReader dataReader = command.ExecuteReader();
                //    while (dataReader.Read())
                //        town.Add(dataReader[0].ToString().Trim()); 
                                                                   
                //    Town.DataSource = town;
                //    Town.DataBind();

                //    dataReader.Close();
                //    transaction.Commit();

                //    panel.Visible = true;
                //}
                //catch (Exception ex) // Обработка ошибок
                //{
                //    TextBox1.Text = ex.Message;
                //    transaction.Rollback();
                //}
            }
            catch
            {
                TextBox.Text = "Connection failed\n";
            }
        }

        private DataTable GetTable()
        {
            DataTable dataTable = new DataTable();
            dataTable.Columns.Add(new DataColumn("n_post", typeof(string)));
            dataTable.Columns.Add(new DataColumn("name", typeof(string)));
            dataTable.Columns.Add(new DataColumn("reiting", typeof(int)));
            dataTable.Columns.Add(new DataColumn("town", typeof(string)));

            string request = "SELECT * from pmib8112.s";
            var command = new OdbcCommand(request, connection);
            OdbcTransaction transaction = null;
            try
            {
                transaction = connection.BeginTransaction();
                command.Transaction = transaction;
                OdbcDataReader dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    DataRow dataRow = dataTable.NewRow();
                    dataRow["n_post"] = dataReader[0].ToString().Trim();
                    dataRow["name"] = dataReader[1].ToString().Trim();
                    dataRow["reiting"] = dataReader[2].ToString().Trim();
                    dataRow["town"] = dataReader[3].ToString().Trim();
                    dataTable.Rows.Add(dataRow);
                }
                dataReader.Close();
                transaction.Commit();
            }
            catch (Exception ex)
            {
                TextBox1.Text = ex.Message;
                transaction.Rollback();
            }
            return dataTable;
        }

        protected void Request1(object sender, EventArgs e)
        {
            TextBox1.Text = null;
            string town = Town.SelectedValue;
            DateTime dateTime1, dateTime2;

            OdbcTransaction transaction = null;
            try
            {
                dateTime1 = DateTime.Parse(DateTextBox1.Text);
                dateTime2 = DateTime.Parse(DateTextBox2.Text);
                if (dateTime2 > DateTime.Now)
                {
                    TextBox1.Text = "Выбрана неверная дата!";
                    return;
                }
                else if (dateTime1 > dateTime2)
                {
                    TextBox1.Text = "Выбран неправильный промежуток";
                    return;
                }
            }
            catch
            {
                TextBox1.Text = "Не выбрана дата для формирования запроса №1!";
                return;
            }
            string request = "SELECT * FROM pmib8112.s " +
            "WHERE n_post IN ( select distinct(n_post) from pmib8112.spj " +
            "where n_det in( select n_det from pmib8112.p where town = :town_param)" +
            "and spj.date_post between to_date(:date_param1, 'yyyy-mm-dd') and to_date(:date_param2, 'yyyy-mm-dd'))" +
            "Order by n_post";

            var command = new OdbcCommand(request, connection);

            command.Parameters.AddWithValue("town_param", town);
            command.Parameters.AddWithValue("date_param1", dateTime1.ToString("yyyy-MM-dd"));
            command.Parameters.AddWithValue("date_param2", dateTime2.ToString("yyyy-MM-dd"));
            try
            {
                transaction = connection.BeginTransaction();
                command.Transaction = transaction;
                DataTable dataTable = new DataTable();
                dataTable.Columns.Add(new DataColumn("n_post", typeof(string)));
                dataTable.Columns.Add(new DataColumn("name", typeof(string)));
                dataTable.Columns.Add(new DataColumn("reiting", typeof(int)));
                dataTable.Columns.Add(new DataColumn("town", typeof(string)));

                OdbcDataReader dataReader = command.ExecuteReader();
                while (dataReader.Read())
                {
                    DataRow dataRow = dataTable.NewRow();
                    dataRow["n_post"] = dataReader[0].ToString().Trim();
                    dataRow["name"] = dataReader[1].ToString().Trim();
                    dataRow["reiting"] = dataReader[2].ToString().Trim();
                    dataRow["town"] = dataReader[3].ToString().Trim();
                    dataTable.Rows.Add(dataRow);
                }
                dataReader.Close();

                GridView1.DataSource = dataTable;
                GridView1.DataBind();
                transaction.Commit();
            }
            catch (Exception ex)
            {
                TextBox1.Text = ex.Message;
                transaction.Rollback();
            }
        }

        protected void Request2(object sender, EventArgs e)
        {
            TextBox1.Text = null;
            DataTable dataTableBefore = GetTable();
            ViewState["Current table"] = dataTableBefore;
            GridView2.DataSource = dataTableBefore;
            GridView2.DataBind();

            string name = TextBoxName.Text;
            int reiting;
            string town = TextBoxTown.Text;

            if (name.Equals(""))
            {
                TextBox1.Text = "Имя не введено!";
                return;
            }
            else if (town == "")
            {
                TextBox1.Text = "Нет города!";
                return;
            }

            try
            {
                reiting = Int32.Parse(TextBoxReiting.Text);
                if(reiting < 0)
                {
                    TextBox1.Text = "Рейтинг не моет быть меньше нуля!";
                    return;
                }
            }
            catch
            {
                TextBox1.Text = "Нет рейтинга!";
                return;
            }
            string request = "insert into pmib8112.s values(concat('S', NEXTVAL('n_post')),:param_name,:param_reiting,:param_town);"; //последовательность уже создана

            var command = new OdbcCommand(request, connection);
            command.Parameters.AddWithValue("param_name", name);
            command.Parameters.AddWithValue("param_reiting", reiting);
            command.Parameters.AddWithValue("param_town", town);

            OdbcTransaction transaction = null;
            try
            {
                transaction = connection.BeginTransaction();
                command.Transaction = transaction;
                OdbcDataReader dataReader = command.ExecuteReader();               
                dataReader.Close();
                transaction.Commit();

                DataTable dataTable = GetTable();
                ViewState["New table"] = dataTable;
                GridView3.DataSource = dataTable;
                GridView3.DataBind();
            }
            catch (Exception ex) 
            {
                TextBox1.Text = ex.Message;
                transaction.Rollback();
            }
        }
    }
}