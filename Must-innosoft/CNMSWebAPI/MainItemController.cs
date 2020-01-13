using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;
using System.Data.Entity;
using System.IdentityModel.Tokens.Jwt;
using JWT;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using CNMSWebAPI.Models;

namespace CNMSWebAPI.Controllers.Process
{    
    public class MainItemController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        public HttpResponseMessage Get()
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                    {
                        connection.Open();
                        DataTable dt1 = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter("select * from MainItemMaster", connection);
                        da.Fill(dt1);
                        connection.Close();
                        return Request.CreateResponse(HttpStatusCode.OK, dt1);

                    }
                }
                else
                {
                    message = "MainItem Details not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        public HttpResponseMessage Get(int id)
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                    {
                        DataTable dt1 = new DataTable();
                        connection.Open();
                        if (id != 0)
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from MainItemMaster where MainItemId=" + id, connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        }
                        else
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from MainItemMaster where Status=1", connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);


                        }
                    }
                }
                else
                {
                    message = "MainItem Details not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        public HttpResponseMessage Post([FromBody] MainItemModel locat)
        {
            try
            {
                string authHeader = this.httpContext.Request.Headers["Authorization"];
                clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                int userid = Convert.ToInt32(Models.JwtAuthentication.GetTokenUserId(authHeader));

                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                    if (dbt != null)
                    {

                        using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                        {
                            DataTable dt1 = new DataTable();
                            connection.Open();
                            SqlDataAdapter da = new SqlDataAdapter("select * from MainItemMaster where MainItemId=" + locat.MainItemId, connection);
                            da.Fill(dt1);

                            if (dt1.Rows.Count > 0)
                            {
                                
                                if (dt1.Rows.Count == 0)
                                {
                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                    string sql = "Update MainItemMaster set MainItemName='" + locat.MainItemName + "',MainItemDescription='" + locat.MainItemDescription + ",Status=" + locat.Status + " where MainItemId=" + locat.MainItemId;
                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                    adapter.UpdateCommand.ExecuteNonQuery();
                                    connection.Close();
                                    message = "Update Successfully";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });


                                }
                                else
                                {
                                    long MainItemId = Convert.ToInt64(dt1.Rows[0]["MainItemId"].ToString());
                                    if (locat.MainItemId != MainItemId)
                                    {
                                        status = false;
                                        message = "MainItem Name already exists";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else
                                    {
                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        string sql = "Update MainItemMaster set MainItemName='" + locat.MainItemName + "',MainItemDescription='" + locat.MainItemDescription + ",Status=" + locat.Status + " where MainItemId=" + locat.MainItemId;
                                        adapter.UpdateCommand = new SqlCommand(sql, connection);
                                        adapter.UpdateCommand.ExecuteNonQuery();
                                        connection.Close();
                                        message = "Update Successfully";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                            }
                            else
                            {
                                da = new SqlDataAdapter("select * from MainItemMaster where MainItemName='" + locat.MainItemName + "'", connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    status = false;
                                    message = "MainItem Name already exists";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                else
                                {
                                    

                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        string sql = "insert into MainItemMaster values(" + locat.MainItemName + "','" + locat.MainItemDescription + "',"  + locat.Status + ")";
                                        adapter.InsertCommand = new SqlCommand(sql, connection);
                                        adapter.InsertCommand.ExecuteNonQuery();
                                        connection.Close();
                                        message = "Saved Successfully";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    
                                }
                            }
                        }
                    }
                    else
                    {
                        message = "MainItemDetails not found";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                }
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
    }
}
