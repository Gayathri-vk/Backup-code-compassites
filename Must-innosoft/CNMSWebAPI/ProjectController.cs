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

    public class ProjectController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        string Server_Name = "";
        string DB_Name = "";
        int userole = 0;
        public HttpResponseMessage Get()
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            try
            {

                GetTokenClientId();

            }
            catch (TokenExpiredException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
            catch (SignatureVerificationException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);

            }
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
                        SqlDataAdapter da = new SqlDataAdapter("select *,ISNULL((select ClientName from ClientMaster c where p.ClientId=c.ClientId),'') as ClientName from ProjectMaster p where p.ClientId="+clientid, connection);
                        da.Fill(dt1);
                        connection.Close();
                        return Request.CreateResponse(HttpStatusCode.OK, dt1);

                    }
                }
                else
                {
                    message = "DatabaseDetails not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        private void GetTokenClientId()
        {

            string authHeader = this.httpContext.Request.Headers["Authorization"];

            var authBits = authHeader.Split(' ');
            var tokenHandler = new JwtSecurityTokenHandler();

            var readableToken = tokenHandler.CanReadToken(authBits[1].ToString());
            if (readableToken == true)
            {
                var jwtToken = tokenHandler.ReadToken(authBits[1]) as JwtSecurityToken;

                var cli = jwtToken.Payload.ToList();
                if (cli.Count > 0)
                {
                    string val = cli[2].ToString().Replace("[", "").Replace("]", "");
                    string spli = val.Split(',')[1];
                    clientid = Convert.ToInt32(spli);

                    val = cli[1].ToString().Replace("[", "").Replace("]", "");
                    spli = val.Split(',')[1];

                    userole = Convert.ToInt32(spli);
                }


            }

        }
        public HttpResponseMessage Get(int id)
        {
            //string authHeader = this.httpContext.Request.Headers["Authorization"];
            //clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            try
            {

                GetTokenClientId();

            }
            catch (TokenExpiredException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
            catch (SignatureVerificationException ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);

            }
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {
                    var session = HttpContext.Current.Session;
                    if (session != null)
                    {
                        if (session["Server_Name"] == null)
                            session["Server_Name"] = dbt.Server_Name;

                        if (session["DB_Name"] == null)
                            session["DB_Name"] = dbt.DB_Name;
                    }
                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id="+dbt.DB_Username+";Password="+dbt.DB_Password+";"))
                    {
                        DataTable dt1 = new DataTable();
                        connection.Open();
                        if (id != 0)
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from ClientMaster where ClientId=" + clientid, connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);

                        }
                        else
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from ProjectMaster where ClientId="+clientid+" and Status=1", connection);
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
        public SqlCommand cmd;
        public HttpResponseMessage Post([FromBody] ProjectModel locat)
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
                            SqlDataAdapter da = new SqlDataAdapter("select * from ProjectMaster where ClientId=" + locat.ClientId, connection);
                            da.Fill(dt1);

                            if (dt1.Rows.Count > 0)
                            {
                                DateTime zeroTime = new DateTime(1, 1, 1);
                                TimeSpan span = Convert.ToDateTime(locat.End_Date) - Convert.ToDateTime(locat.Start_Date);


                                decimal years = Math.Round(Convert.ToDecimal(span.TotalDays / 365), 1);
                                //int months = Convert.ToInt32(span.TotalDays) / 12;
                                int days = Convert.ToInt32(span.TotalDays);
                                //int years = (zeroTime + span).Year - 1;
                                //int months = (zeroTime + span).Month - 1;
                                //int days = (zeroTime + span).Day;
                                int weeks = Convert.ToInt32(span.TotalDays) / 7;


                                //DateTime past = Convert.ToDateTime(locat.Start_Date).AddMonths(-13);
                                //int months = 12 * (Convert.ToDateTime(locat.Start_Date).Year - past.Year) + Convert.ToDateTime(locat.Start_Date).Month - past.Month;
                                // ((Convert.ToDateTime(locat.Start_Date).Year - Convert.ToDateTime(locat.End_Date).Year) * 12) + Convert.ToDateTime(locat.Start_Date).Month - Convert.ToDateTime(locat.End_Date).Month;
                                double months = (Convert.ToDateTime(locat.End_Date).Subtract(Convert.ToDateTime(locat.Start_Date)).Days) / (365.25 / 12);
                                decimal twoDec = Math.Round((decimal)months, 0);

                                string duration = Convert.ToString(years) + " Years & " + Convert.ToString(twoDec) + " Months & " + Convert.ToString(weeks) + " Weeks & " + Convert.ToString(days) +" Days";
                                if (dt1.Rows.Count == 0)
                                {
                                    SqlDataAdapter adapter = new SqlDataAdapter();
                                    string sql = "Update ProjectMaster set Fromday='" + locat.Fromday + "',Today='" + locat.Today + "',Fromtime='" + locat.Fromtime + "',Totime='" + locat.Totime + "',ProjectName='" + locat.ProjectName + "',ProjectLocation='" + locat.ProjectLocation + "',ContactNo='" + locat.ContactNo + "',EmailId='" + locat.EmailId + "',End_Date='" + locat.End_Date + "',ProjectIncharge='" + locat.ProjectIncharge + "',Start_Date='" + locat.Start_Date + "',ProjectDuration='" + duration + "',UserId=" + userid + ",Status=" + locat.Status + " where ProjectId=" + locat.ProjectId;
                                    adapter.UpdateCommand = new SqlCommand(sql, connection);
                                    adapter.UpdateCommand.ExecuteNonQuery();
                                    connection.Close();
                                    message = "Update Successfully";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });


                                }
                                else
                                {
                                    long LocationId = Convert.ToInt64(dt1.Rows[0]["ProjectId"].ToString());
                                    if (locat.ProjectId != LocationId)
                                    {
                                        status = false;
                                        message = "Project Name already exists";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else
                                    {
                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        string sql = "Update ProjectMaster set Fromday='" + locat.Fromday + "',Today='" + locat.Today + "',Fromtime='" + locat.Fromtime + "',Totime='" + locat.Totime + "',ProjectName='" + locat.ProjectName + "',ProjectLocation='" + locat.ProjectLocation + "',ContactNo='" + locat.ContactNo + "',EmailId='" + locat.EmailId + "',End_Date='" + locat.End_Date + "',ProjectIncharge='" + locat.ProjectIncharge + "',Start_Date='" + locat.Start_Date + "',ProjectDuration='" + duration + "',UserId=" + userid + ",Status=" + locat.Status + " where ProjectId=" + locat.ProjectId;
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
                               
                                da = new SqlDataAdapter("select * from ProjectMaster where ProjectName='" + locat.ProjectName+"'", connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    status = false;
                                    message = "Use other any other name";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                else
                                {
                                    da = new SqlDataAdapter("select * from ProjectMaster where ClientId="+clientid, connection);
                                    da.Fill(dt1);
                                    if (dt1.Rows.Count > 0)
                                    {
                                        status = false;
                                        message = "User not valid to create more then one projects";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else
                                    {
                                        DateTime zeroTime = new DateTime(1, 1, 1);
                                        TimeSpan span =Convert.ToDateTime(locat.End_Date) - Convert.ToDateTime(locat.Start_Date);



                                        decimal years = Math.Round(Convert.ToDecimal(span.TotalDays / 365), 1);

                                        //int months = Convert.ToInt32(span.TotalDays) / 12;
                                        int days = Convert.ToInt32(span.TotalDays);
                                        //int years = (zeroTime + span).Year - 1;
                                        //int months = (zeroTime + span).Month - 1;
                                        //int days = (zeroTime + span).Day;
                                        int weeks = Convert.ToInt32(span.TotalDays) / 7;
                                        // DateTime past = Convert.ToDateTime(locat.Start_Date).AddMonths(-13);
                                        //int months = 12 * (Convert.ToDateTime(locat.Start_Date).Year - past.Year) + (Convert.ToDateTime(locat.Start_Date).Month - past.Month);
                                        double months = (Convert.ToDateTime(locat.End_Date).Subtract(Convert.ToDateTime(locat.Start_Date)).Days) / (365.25 / 12);
                                        decimal twoDec = Math.Round((decimal)months, 0);
                                        string duration = Convert.ToString(years) + " Years & " + Convert.ToString(twoDec) + " Months & " + Convert.ToString(weeks) + " Weeks & " + Convert.ToString(days) + " Days";


                                        //SqlDataAdapter adapter = new SqlDataAdapter();
                                        //string sql = "insert into ProjectMaster values('" + locat.ClientId + "','" + locat.ProjectName + "','" + locat.ProjectLocation + "','" + locat.ProjectIncharge + "','" + locat.ContactNo + "','" + locat.EmailId + "','" + Convert.ToDateTime(locat.Start_Date)  + "','" + Convert.ToDateTime(locat.End_Date) + "','"  + duration + "','" + userid + "'," + locat.Status + ")";
                                        //adapter.InsertCommand = new SqlCommand(sql, connection);
                                        //adapter.InsertCommand.ExecuteNonQuery();
                                        //connection.Close();

                                        string ProjectLocation1 = Convert.ToString(locat.ProjectLocation as object);
                                        
                                        string ProjectIncharge = Convert.ToString(locat.ProjectIncharge as object);
                                        
                                        string ContactNo1 = Convert.ToString(locat.ContactNo as object);
                                        
                                        string EmailId = Convert.ToString(locat.EmailId as object);
                                        
                                        string sql = "Save_Project";
                                        cmd = new SqlCommand(sql, connection);
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.Parameters.Add("@ClientId", SqlDbType.BigInt).Value = locat.ClientId;
                                        cmd.Parameters.Add("@ProjectName", SqlDbType.VarChar).Value = locat.ProjectName;
                                        cmd.Parameters.Add("@ProjectLocation", SqlDbType.VarChar).Value = ProjectLocation1;
                                        cmd.Parameters.Add("@ProjectIncharge", SqlDbType.VarChar).Value = ProjectIncharge;
                                        cmd.Parameters.Add("@ContactNo", SqlDbType.VarChar).Value = ContactNo1;
                                        cmd.Parameters.Add("@EmailId", SqlDbType.VarChar).Value = EmailId;
                                        cmd.Parameters.Add("@Start_Date", SqlDbType.DateTime).Value = locat.Start_Date;
                                        cmd.Parameters.Add("@End_Date", SqlDbType.DateTime).Value = locat.End_Date;
                                        cmd.Parameters.Add("@duration", SqlDbType.VarChar).Value = duration;
                                        cmd.Parameters.Add("@userid", SqlDbType.Int).Value = userid;
                                        cmd.Parameters.Add("@Status", SqlDbType.Int).Value = locat.Status;
                                        cmd.Parameters.Add("@Fromday", SqlDbType.VarChar).Value = locat.Fromday;
                                        cmd.Parameters.Add("@Today", SqlDbType.VarChar).Value = locat.Today;
                                        cmd.Parameters.Add("@Fromtime", SqlDbType.VarChar).Value = locat.Fromtime;
                                        cmd.Parameters.Add("@Totime", SqlDbType.VarChar).Value = locat.Totime;
                                        cmd.CommandTimeout = 0;
                                        cmd.ExecuteNonQuery();
                                        message = "Saved Successfully";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
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
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
    }

}
