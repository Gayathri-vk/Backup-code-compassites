using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;
using System.Data.Entity;
using System.Net.Http.Headers;
using System.Threading;
using CNMSWebAPI.Models;
using System.Web;
using JWT;
using JWT.Serializers;
using System.IdentityModel.Tokens.Jwt;
using Newtonsoft.Json.Linq;
using System.Xml;
using System.IdentityModel.Claims;
using System.Text;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using CNMSWebAPI.Filters;

namespace CNMSWebAPI.Controllers
{
    public class ClientController : ApiController
    {
        
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        int userole = 0;
        Boolean status = true;
        
        public HttpResponseMessage Get()
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {



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



           

            ent.Configuration.ProxyCreationEnabled = false;
                //return ent.Clients.ToList();
                //return ent.Clients.Select(c => new NamePriceModel
                //{
                //    ClientId=c.ClientId,
                //    CompanyId=c.CompanyId
                //}).ToList();
                string ClientCode = ""; 
                var session = System.Web.HttpContext.Current.Session;
                if(session != null)
                {
                    if (session["ClientCode"] != null)
                        ClientCode = session["ClientCode"].ToString();
                }
                if (clientid == 0)
                {
                    if(userole==1)
                    { 
                    var dat = (from c in ent.Clients
                               select new
                               {
                                   c.Company.CompanyName,
                                   c.Country.Country_Name,
                                   c.ClientId,
                                   c.CompanyId,
                                   c.ClientCode,
                                   c.ClientName,
                                   c.TaxNo,
                                   c.GSTNo,
                                   c.ContactPerson,
                                   c.Designation,
                                   c.HandPhoneNo,
                                   c.TelePhoneNo,
                                   c.EmailId,
                                   c.Website,
                                   c.UintNo,
                                   c.Building,
                                   c.Street,
                                   c.City,
                                   c.State,
                                   c.StateCode,
                                   c.Pincode,
                                   c.CountryId,
                                   c.NoofUser,
                                   c.Remark,
                                   c.ExprieDate,
                                   c.Status,
                                   CreatedUser = (from a in ent.UserDetails where a.ClientId == c.ClientId select a.UserId).DefaultIfEmpty(0).Count()
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                        //return dat;
                    }
                    else
                        return Request.CreateResponse(HttpStatusCode.OK, status);
                }
                else
                {
                    var dat = (from c in ent.Clients
                               where c.ClientId == clientid
                               select new
                               {
                                   c.Company.CompanyName,
                                   c.Country.Country_Name,
                                   c.ClientId,
                                   c.CompanyId,
                                   c.ClientCode,
                                   c.ClientName,
                                   c.TaxNo,
                                   c.GSTNo,
                                   c.ContactPerson,
                                   c.Designation,
                                   c.HandPhoneNo,
                                   c.TelePhoneNo,
                                   c.EmailId,
                                   c.Website,
                                   c.UintNo,
                                   c.Building,
                                   c.Street,
                                   c.City,
                                   c.State,
                                   c.StateCode,
                                   c.Pincode,
                                   c.CountryId,
                                   c.NoofUser,
                                   c.Remark,
                                   c.ExprieDate,
                                   c.Status,
                                   CreatedUser = (from a in ent.UserDetails where a.ClientId == c.ClientId select a.UserId).DefaultIfEmpty(0).Count()
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
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
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
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
                if (clientid != 0)
                {
                    var dat = ent.Clients.Where(a => a.CompanyId == id && a.ClientId == clientid).ToList();
                    if (dat != null)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, dat);

                    }
                    else
                        return Request.CreateResponse(HttpStatusCode.OK, status);
                }
                else
                {
                    var dat = ent.Clients.Where(a => a.CompanyId == id).ToList();
                    if (dat != null)
                    {
                        return Request.CreateResponse(HttpStatusCode.OK, dat);

                    }
                    else
                        return Request.CreateResponse(HttpStatusCode.OK, status);
                }
            }
        }
                    //public HttpResponseMessage GetClientCode()
                    //{
                    //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
                    //    {
                    //        long CCode;
                    //        try
                    //        {
                    //            ent.Configuration.ProxyCreationEnabled = false;
                    //            var dat = ent.Clients.Select(c => c.ClientCode).Max();
                    //            if (dat != null)
                    //            {
                    //                CCode = Convert.ToInt64(dat) + 1;
                    //            }
                    //            else
                    //                CCode = 1001;

                    //            return Request.CreateResponse(HttpStatusCode.OK, new { CCode, status });
                    //        }
                    //        catch
                    //        {
                    //            CCode = 1001;
                    //            return Request.CreateResponse(HttpStatusCode.OK, new { CCode, status });
                    //        }
                    //    }

                    //}

        //            public HttpResponseMessage Get(int id)
        //{
        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //        ent.Configuration.ProxyCreationEnabled = false;

        //        var dat = ent.Clients.FirstOrDefault(c => c.CompanyId == id);
        //        if (dat != null)
        //        {
        //            return Request.CreateResponse(HttpStatusCode.OK, dat);

        //        }
        //        else
        //        {
        //            message = "Client with id = " + id.ToString() + " not found";
        //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    
        //        }
        //    }
        //}
        public HttpResponseMessage Post([FromBody] Client clients)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    //var dat = ent.Clients.FirstOrDefault(c => c.ClientCode == clients.ClientCode);
                    //if (dat != null)
                    //{
                    long NClientId = 0;
                        ent.Configuration.ProxyCreationEnabled = false;
                    var dat = ent.Clients.FirstOrDefault(c => c.ClientId == clients.ClientId);
                    if (dat == null)
                    {

                        long CCode;
                        try
                        {
                            ent.Configuration.ProxyCreationEnabled = false;
                            var dat2 = ent.Clients.Select(c => c.ClientCode).Max();
                            if (dat2 != null)
                            {
                                CCode = Convert.ToInt64(dat2) + 1;
                            }
                            else
                                CCode = 1001;

                            //return Request.CreateResponse(HttpStatusCode.OK, new { CCode, status });
                        }
                        catch
                        {
                            CCode = 1001;
                            //return Request.CreateResponse(HttpStatusCode.OK, new { CCode, status });
                        }

                        clients.Modfied_Date = DateTime.Now;
                        clients.ClientCode = CCode.ToString();
                        ent.Clients.Add(clients);
                        string DB_Name = "";

                        string clientname = clients.ClientName.Trim().ToUpper().Replace(" ", "_");
                        var dbt = (from a in ent.DatabaseDetails where a.DB_Name == clientname select a).FirstOrDefault();
                        if (dbt == null)
                        {
                            ent.SaveChanges();
                    
                            var cmax = ent.Clients.Select(c => c.ClientId).Max();
                            if(cmax!=0)
                            {
                                NClientId = cmax;
                                DatabaseDetail st = new DatabaseDetail();
                                st.ClientId = cmax;
                                st.CompanyId = clients.CompanyId;
                                //st.DB_Name = "prase_mobiledb";
                                st.DB_Name = "ConstructionPro";
                                st.DB_Password = "condb@123";
                                st.DB_Username = "condb";
                                //st.Server_Name = "DESKTOP-QPBLTS2";
                                //st.Server_Name = "182.50.133.109";

                                st.Server_Name = "AZEES-PC";
                                //st.DB_Name = "Test";
                                //st.DB_Password = "P@ssword";
                                //st.DB_Username = "sa";
                                //st.Server_Name = "EC2AMAZ-USPU7JQ\\SQLEXPRESS";
                                DB_Name = st.DB_Name;
                                st.Status = 1;
                                ent.DatabaseDetails.Add(st);
                                ent.SaveChanges();


                                //To Create Database
                                //DataTable dt1 = new DataTable();
                                //string connectionString = ConfigurationManager.ConnectionStrings["ConstructionProcess"].ConnectionString;

                                //SqlDataAdapter da = new SqlDataAdapter("CreateCopyDatabaseTable", connectionString);
                                //da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                //da.SelectCommand.Parameters.AddWithValue("@toDatabase", st.DB_Name);
                                //da.Fill(dt1);

                                //da = new SqlDataAdapter("CreateCopyDatabaseprocedures", connectionString);
                                //da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                //da.SelectCommand.Parameters.AddWithValue("@Name", st.DB_Name);
                                //da.Fill(dt1);

                                //da = new SqlDataAdapter("CreateCopyDatabaseView", connectionString);
                                //da.SelectCommand.CommandType = CommandType.StoredProcedure;
                                //da.SelectCommand.Parameters.AddWithValue("@Name", st.DB_Name);
                                //da.Fill(dt1);

                                }
                            //var dbt1 = (from a in ent.DatabaseDetails where a.DB_Name == clientname select a).FirstOrDefault(); 
                            var dbt1 = (from a in ent.DatabaseDetails where a.DB_Name == DB_Name select a).FirstOrDefault();
                            if (dbt1 != null)
                            {
                                using (SqlConnection connection = new SqlConnection("Data Source=" + dbt1.Server_Name + ";Initial Catalog=" + dbt1.DB_Name + ";User Id=" + dbt1.DB_Username + ";Password=" + dbt1.DB_Password + ";"))
                                {
                                    connection.Open();

                                    //    SqlDataAdapter da1 = new SqlDataAdapter("CreateCopyDatabaseuser", connection);
                                    //    da1.SelectCommand.CommandType = CommandType.StoredProcedure;                  
                                    //    da1.SelectCommand.Parameters.AddWithValue("@toDatabase", st.DB_Name);

                                    //    da1.Fill(dt1);

                                    string TaxNo = Convert.ToString(clients.TaxNo);
                                    string GSTNo = Convert.ToString(clients.GSTNo);
                                    string ContactPerson = Convert.ToString(clients.ContactPerson);
                                    string Designation = Convert.ToString(clients.Designation);
                                    string HandPhoneNo = Convert.ToString(clients.HandPhoneNo);
                                    string TelePhoneNo = Convert.ToString(clients.TelePhoneNo);
                                    string EmailId = Convert.ToString(clients.EmailId);
                                    string Website = Convert.ToString(clients.Website);
                                    string UintNo = Convert.ToString(clients.UintNo);

                                    string Building = Convert.ToString(clients.Building);
                                    string Street = Convert.ToString(clients.Street);
                                    string City = Convert.ToString(clients.City);
                                    string State = Convert.ToString(clients.State);
                                    string StateCode = Convert.ToString(clients.StateCode);
                                    string Pincode = Convert.ToString(clients.Pincode);

                                    

                                    SqlDataAdapter da1 = new SqlDataAdapter();
                                    string sql = "insert into ClientMaster values(" + NClientId + ",'" + clients.ClientCode + "','" + clients.ClientName + "','" + TaxNo + "','" + GSTNo + "','" + ContactPerson + "','" + Designation + "','" + HandPhoneNo + "','" + TelePhoneNo + "','" + EmailId + "','" + Website + "','" + UintNo + "','" + Building + "','" + Street + "','" + City + "','" + State + "','" + StateCode + "','" + Pincode + "'," + clients.Status + ")";
                                    da1.InsertCommand = new SqlCommand(sql, connection);
                                    da1.InsertCommand.ExecuteNonQuery();
                                    connection.Close();
                                }
                            }

                        }
                        else
                        {
                            status = false;
                            message = "Client Name DB Already Exists, Use Other Name";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }

                        var upp = (from a in ent.UserDetails where a.ClientId == NClientId select a).ToList();
                        foreach (var item in upp)
                        {
                            var sas = (from a in ent.UserDetails where a.UserId == item.UserId select a).FirstOrDefault();
                            if (sas != null)
                            {
                                sas.Status = 1;
                                sas.ExprieDate = dat.ExprieDate;
                                sas.Modfied_Date = DateTime.Now;

                                UserValidity s = new UserValidity();
                                s.ClientId = (long)dat.ClientId;
                                s.ExprieDate = dat.ExprieDate;
                                s.UserId = item.UserId;
                                ent.UserValidities.Add(s);

                                ent.SaveChanges();

                            }
                        }


                        message = "Saved Successfully. Your Client Code is : " + CCode.ToString();
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                    else
                    {
                        dat.CompanyId = clients.CompanyId;
                        dat.ClientName = clients.ClientName;
                        //dat.ClientCode = clients.ClientCode;
                        dat.ContactPerson = clients.ContactPerson;
                        dat.Designation = clients.Designation;
                        dat.Building = clients.Building;
                        dat.City = clients.City;
                        dat.Country = clients.Country;
                        dat.EmailId = clients.EmailId;
                        dat.GSTNo = clients.GSTNo;
                        dat.HandPhoneNo = clients.HandPhoneNo;
                        dat.Pincode = clients.Pincode;
                        dat.StateCode = clients.StateCode;
                        dat.Street = clients.Street;
                        dat.State = clients.State;
                        dat.TaxNo = clients.TaxNo;
                        dat.TelePhoneNo = clients.TelePhoneNo;
                        dat.UintNo = clients.UintNo;
                        dat.Website = clients.Website;
                        dat.CountryId = clients.CountryId;
                        dat.NoofUser = clients.NoofUser;
                        dat.Remark = clients.Remark;
                        dat.ExprieDate = clients.ExprieDate;
                        dat.Status = clients.Status;
                        dat.Modfied_Date = DateTime.Now;
                        ent.SaveChanges();


                        var chk = ent.UserDetails.FirstOrDefault(c => c.ClientId == dat.ClientId && c.ExprieDate == dat.ExprieDate);
                        if (chk == null)
                        {
                            var upp = (from a in ent.UserDetails where a.ClientId == dat.ClientId select a).ToList();
                            foreach (var item in upp)
                            {
                                var sas = (from a in ent.UserDetails where a.UserId == item.UserId select a).FirstOrDefault();
                                if (sas != null)
                                {
                                    sas.Status = 1;
                                    sas.ExprieDate = dat.ExprieDate;
                                    sas.Modfied_Date = DateTime.Now;

                                        UserValidity s = new UserValidity();
                                        s.ClientId = (long)dat.ClientId;
                                        s.ExprieDate = dat.ExprieDate;
                                        s.UserId = item.UserId;
                                        ent.UserValidities.Add(s);
                                    
                                    ent.SaveChanges();

                                }
                            }
                        }


                        message = "Updated Successfully";




                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                        //var message = Request.CreateResponse(HttpStatusCode.Created, clients);
                        //message.Headers.Location = new Uri(Request.RequestUri + "/" + clients.ClientId.ToString());
                        //return message;
                    //}
                    //else
                    //{
                    //    message = "Client " + clients.ClientCode.ToString() + " already exists";
                    //    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    //}
                }
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }

        public HttpResponseMessage Put(int id, [FromBody] Client clients)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat = ent.Clients.FirstOrDefault(c => c.ClientId == id);
                    var dat1 = ent.Clients.FirstOrDefault(c => c.ClientCode == clients.ClientCode);
                    if (dat1 == null)
                    {
                        if (dat != null)
                        {
                            dat.CompanyId = clients.CompanyId;
                            dat.ClientName = clients.ClientName;
                            //dat.ClientCode = clients.ClientCode;
                            dat.ContactPerson = clients.ContactPerson;
                            dat.Designation = clients.Designation;
                            dat.Building = clients.Building;
                            dat.City = clients.City;
                            dat.Country = clients.Country;
                            dat.EmailId = clients.EmailId;
                            dat.GSTNo = clients.GSTNo;
                            dat.HandPhoneNo = clients.HandPhoneNo;
                            dat.Pincode = clients.Pincode;
                            dat.StateCode = clients.StateCode;
                            dat.Street = clients.Street;
                            dat.State = clients.State;
                            dat.TaxNo = clients.TaxNo;
                            dat.TelePhoneNo = clients.TelePhoneNo;
                            dat.UintNo = clients.UintNo;
                            dat.Website = clients.Website;
                            dat.CountryId = clients.CountryId;
                            dat.NoofUser = clients.NoofUser;
                            dat.Remark = clients.Remark;
                            dat.ExprieDate = clients.ExprieDate;

                            dat.Status = clients.Status;
                            ent.SaveChanges();
                            message = "Updated Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            message = "Client with id = " + id.ToString() + " not found";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                    }
                    else
                    {
                        if (dat.ClientId != dat.ClientId)
                        {
                            message = "Client " + dat1.ClientCode.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            dat.CompanyId = clients.CompanyId;
                            dat.ClientName = clients.ClientName;
                            //dat.ClientCode = clients.ClientCode;
                            dat.ContactPerson = clients.ContactPerson;
                            dat.Designation = clients.Designation;
                            dat.Building = clients.Building;
                            dat.City = clients.City;
                            dat.Country = clients.Country;
                            dat.EmailId = clients.EmailId;
                            dat.GSTNo = clients.GSTNo;
                            dat.HandPhoneNo = clients.HandPhoneNo;
                            dat.Pincode = clients.Pincode;
                            dat.StateCode = clients.StateCode;
                            dat.Street = clients.Street;
                            dat.State = clients.State;
                            dat.TaxNo = clients.TaxNo;
                            dat.TelePhoneNo = clients.TelePhoneNo;
                            dat.UintNo = clients.UintNo;
                            dat.Website = clients.Website;
                            dat.CountryId = clients.CountryId;
                            dat.NoofUser = clients.NoofUser;
                            dat.Remark = clients.Remark;
                            dat.ExprieDate = clients.ExprieDate;

                            dat.Status = clients.Status;
                            ent.SaveChanges();
                            message = "Updated Successfully";
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
