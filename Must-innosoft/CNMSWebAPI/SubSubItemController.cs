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
    public class SubSubItemController : ApiController
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

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                    {
                        connection.Open();
                        DataTable dt1 = new DataTable();
                        SqlDataAdapter da = new SqlDataAdapter("select *,ISNULL((select MainItemName from MainItemMaster c join SubItemMaster c1  on c1.MainItemId=c.MainItemId where p.SubItemId=c1.SubItemId),'') as MainItemName,ISNULL((select SubItemName from SubItemMaster c where p.SubItemId=c.SubItemId),'') as SubItemName from SubSubItemMaster  p", connection);
                        da.Fill(dt1);
                        connection.Close();
                        return Request.CreateResponse(HttpStatusCode.OK, dt1);

                    }
                }
                else
                {
                    message = "SubSubItem Details not found";
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

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                    {
                        DataTable dt1 = new DataTable();
                        connection.Open();
                        if (id != 0)
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from SubSubItemMaster where Status=1 and SubItemId=" + id, connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        }
                        else
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from SubSubItemMaster where Status=1", connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);


                        }
                    }
                }
                else
                {
                    message = "SubSubItem Details not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        public HttpResponseMessage Post([FromBody] SubSubItemModel locat)
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

                        using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                        {
                            DataTable dt1 = new DataTable();
                            connection.Open();
                            SqlDataAdapter da = new SqlDataAdapter("select * from SubSubItemMaster where SubSubItemId=" + locat.SubSubItemId, connection);
                            da.Fill(dt1);

                            if (dt1.Rows.Count > 0)
                            {

                                if (dt1.Rows.Count == 0)
                                {
                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                    string sql = "Update SubSubItemMaster set SubItemName='" + locat.SubSubItemName + "',SubSubItemDescription='" + locat.SubSubItemDescription + ",SubItemId=" + locat.SubItemId + ",Status=" + locat.Status + " where SubSubItemId=" + locat.SubSubItemId;
                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                    adapter.UpdateCommand.ExecuteNonQuery();
                                    connection.Close();
                                    message = "Update Successfully";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });


                                }
                                else
                                {
                                    long SubSubItemId = Convert.ToInt64(dt1.Rows[0]["SubSubItemId"].ToString());
                                    if (locat.SubSubItemId != SubSubItemId)
                                    {
                                        status = false;
                                        message = "SubSubItem Name already exists";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else
                                    {
                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        string sql = "Update SubSubItemMaster set SubItemName='" + locat.SubSubItemName + "',SubSubItemDescription='" + locat.SubSubItemDescription + ",SubItemId=" + locat.SubItemId + ",Status=" + locat.Status + " where SubSubItemId=" + locat.SubSubItemId;
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
                                da = new SqlDataAdapter("select * from SubItemMaster where SubSubItemName='" + locat.SubSubItemName + "'", connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    status = false;
                                    message = "SubSubItem Name already exists";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                else
                                {


                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                    string sql = "insert into SubSubItemMaster values(" + locat.SubItemId + ",'" + locat.SubSubItemName + "','" + locat.SubSubItemDescription + "'," + locat.Status + ")";
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
                        message = "SubSubItemDetails not found";
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
