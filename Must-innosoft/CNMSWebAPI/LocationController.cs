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
    public class LocationController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        string Server_Name = "";
        string DB_Name = "";
        public HttpResponseMessage Get()
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                if (clientid == 0)
                {
                    status = false;
                    message = "Login Using Client Id";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
                else
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                    if (dbt != null)
                    {
                        Server_Name = dbt.Server_Name;
                        DB_Name = dbt.DB_Name;

                        using (SqlConnection connection = new SqlConnection("Data Source=" + Server_Name + ";Initial Catalog=" + DB_Name + ";Integrated Security = True;"))
                        {
                            connection.Open();
                            DataTable dt1 = new DataTable();
                            SqlDataAdapter da = new SqlDataAdapter("select * from LocationMaster", connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        }
                    }
                    else
                    {
                        status = false;
                        message = "DatabaseDetails not found";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
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
                    Server_Name = dbt.Server_Name;
                    DB_Name = dbt.DB_Name;
                    using (SqlConnection connection = new SqlConnection("Data Source=" + Server_Name + ";Initial Catalog=" + DB_Name + ";Integrated Security = True;"))
                    {
                        DataTable dt1 = new DataTable();
                        connection.Open();
                        if (id != 0)
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from LocationMaster where LocationId=" + id, connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        }
                        else
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from LocationMaster where Status=1", connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);


                        }
                    }
                }
                else
                {
                    message = "DatabaseDetails not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        public HttpResponseMessage Post([FromBody] LocationModel locat)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection("Data Source=" + Server_Name + ";Initial Catalog=" + DB_Name + ";Integrated Security = True;"))
                {
                    DataTable dt1 = new DataTable();
                    connection.Open();
                    SqlDataAdapter da = new SqlDataAdapter("select * from LocationMaster where LocationId=" + locat.LocationId, connection);
                    da.Fill(dt1);

                    if (dt1.Rows.Count > 0)
                    {
                        da = new SqlDataAdapter("select * from LocationMaster where LocationName=" + locat.LocationName, connection);
                        da.Fill(dt1);
                        if (dt1.Rows.Count == 0)
                        {
                            SqlDataAdapter adapter = new SqlDataAdapter();
                            string sql = "Update LocationMaster set LocationName='" + locat.LocationName + "',Status=" + locat.Status + " where LocationId=" + locat.LocationId + ")";
                            adapter.UpdateCommand = new SqlCommand(sql, connection);
                            adapter.UpdateCommand.ExecuteNonQuery();
                            connection.Open();
                            message = "Update Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });


                        }
                        else
                        {
                            long LocationId = Convert.ToInt64(dt1.Rows[0]["LocationId"].ToString());
                            if (locat.LocationId != LocationId)
                            {
                                status = false;
                                message = "Location Name already exists";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                SqlDataAdapter adapter = new SqlDataAdapter();
                                string sql = "Update LocationMaster set LocationName='" + locat.LocationName + "',Status=" + locat.Status + " where LocationId=" + locat.LocationId + ")";
                                adapter.UpdateCommand = new SqlCommand(sql, connection);
                                adapter.UpdateCommand.ExecuteNonQuery();
                                connection.Open();
                                message = "Update Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                        }
                    }
                    else
                    {
                        da = new SqlDataAdapter("select * from LocationMaster where LocationName=" + locat.LocationName, connection);
                        da.Fill(dt1);
                        if(dt1.Rows.Count>0)
                        {
                            status = false;
                            message = "Location Name already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            SqlDataAdapter adapter = new SqlDataAdapter();
                            string sql = "insert into LocationMaster values('" + locat.LocationName + "'," + locat.Status + ")";
                            adapter.InsertCommand = new SqlCommand(sql, connection);
                            adapter.InsertCommand.ExecuteNonQuery();
                            connection.Open();
                            message = "Saved Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
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
